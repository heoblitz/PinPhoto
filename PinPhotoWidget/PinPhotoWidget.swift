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
    private let itemService = ItemService()
    private let groupViewModel: GroupViewModel = GroupViewModel()
    private let widgetViewModel: WidgetViewModel = WidgetViewModel()

    private func loadItems() {
        groupViewModel.load()
        guard let widgetGroup = groupViewModel.groups.first else { return }
        itemService.fetch(by: widgetGroup.ids)
    }
        
    private func placeItem() -> Item? {
        groupViewModel.load()
        guard let widgetGroup = groupViewModel.groups.first, let current = widgetViewModel.displayItemIndex else { return nil }

        let index: Int = min(current, widgetGroup.ids.count - 1)

        itemService.fetch(by: widgetGroup.ids)
        return itemService.items.first
    }
        
    func placeholder(in context: Context) -> TimeEntry {
        TimeEntry(date: Date(),
                    item: placeItem(),
                    configuration: ConfigurationIntent())
    }
    
    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (TimeEntry) -> ()) {
        let entry = TimeEntry(date: Date(),
                                item: placeItem(),
                                configuration: configuration)
        completion(entry)
    }
    
    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [Entry] = []
        var policy: TimelineReloadPolicy
        let currentDate = Date()
        
        loadItems()
        
        if widgetViewModel.isShowAllItems {
            policy = .atEnd
            
            let second = widgetViewModel.changeTimeSecond
            var count: TimeInterval = 0
            
            itemService.items.forEach {
                let sec = second * count
                let date = Calendar.current.date(byAdding: .second, value: Int(sec), to: currentDate)!
                let entry = TimeEntry(date: date, item: $0, configuration: configuration)
                entries.append(entry)
                count += 1
            }
        } else {
            policy = .never
            
            if let index = widgetViewModel.displayItemIndex {
                let entry: TimeEntry = TimeEntry(date: Date(), item: itemService.items[index], configuration: configuration)
                entries.append(entry)
            }
        }

        let timeline = Timeline(entries: entries, policy: policy)
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
