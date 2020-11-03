//
//  example.swift
//  example
//
//  Created by won heo on 2020/09/21.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {
    private let itemViewModel: ItemViewModel = ItemViewModel()
    private let groupViewModel: GroupViewModel = GroupViewModel()
    private let widgetViewModel: WidgetViewModel = WidgetViewModel()
    
    private func getItem() -> Item? {
        groupViewModel.load()
        guard let widgetGroup = groupViewModel.groups.first, let current = widgetViewModel.displayItemIndex else { return nil }
        
        let index: Int = min(current, widgetGroup.ids.count - 1)
        
        itemViewModel.loadFromIds(ids: [widgetGroup.ids[index]])
        return itemViewModel.items.first
    }
    
    func placeholder(in context: Context) -> TimeEntry {
        TimeEntry(date: Date(),
                    item: getItem(),
                    configuration: ConfigurationIntent())
    }
    
    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (TimeEntry) -> ()) {
        let entry = TimeEntry(date: Date(),
                                item: getItem(),
                                configuration: configuration)
        completion(entry)
    }
    
    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let entry: TimeEntry = TimeEntry(date: Date(), item: getItem(), configuration: configuration)

        let timeline = Timeline(entries: [entry], policy: .never)
        completion(timeline)
    }
}

struct TimeEntry: TimelineEntry {
    let date: Date
    let item: Item?
    let configuration: ConfigurationIntent
}

struct EntryView : View {
    var entry: Provider.Entry

    var body: some View {
        ZStack {
            if let item = entry.item {
                switch item.contentType {
                case ItemType.image.value:
                    Image(uiImage: item.contentImage?.image ?? UIImage())
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                case ItemType.text.value:
                    Text(item.contentText ?? "")
                default:
                    Text("Please select an item".localized)
                }
            } else {
                Text("Please select an item".localized)
            }
        }
    }
}

@main
struct main: Widget {
    let kind: String = "group.com.wonheo.PinPhoto"
    
    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            EntryView(entry: entry)
        }
        .configurationDisplayName("PinPhoto".localized)
        .description("A widget showing pictures and notes".localized)
    }
}

struct example_Previews: PreviewProvider {
    static var previews: some View {
        EntryView(entry: TimeEntry(date: Date(), item: nil, configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
