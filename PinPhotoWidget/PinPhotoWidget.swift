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
    let itemViewModel: ItemViewModel = ItemViewModel()
    let groupViewModel: GroupViewModel = GroupViewModel()
    let widgetViewModel: WidgetViewModel = WidgetViewModel()
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(),
                    item: getItem(),
                    configuration: ConfigurationIntent())
    }
    
    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(),
                                item: getItem(),
                                configuration: configuration)
        completion(entry)
    }
    
    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let entry: SimpleEntry = SimpleEntry(date: Date(), item: getItem(), configuration: configuration)

        let timeline = Timeline(entries: [entry], policy: .never)
        completion(timeline)
    }
    
    func getItem() -> Item? {
        groupViewModel.load()
        guard let widgetGroup = groupViewModel.groups.first else { return nil }
        guard let current = widgetViewModel.currentIndex else { return nil }

        itemViewModel.loadFromIds(ids: widgetGroup.ids)
        let index: Int = min(current, itemViewModel.items.count)
        
        return itemViewModel.item(at: index)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let item: Item?
    let configuration: ConfigurationIntent
}

struct exampleEntryView : View {
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
                    Text("아이템을 추가해주세요.")
                }

            } else {
                Text("아이템을 추가해주세요.")
            }
        }
    }
}

@main
struct example: Widget {
    let kind: String = "group.com.wonheo.PinPhoto"
    
    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            exampleEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct example_Previews: PreviewProvider {
    static var previews: some View {
        exampleEntryView(entry: SimpleEntry(date: Date(),                                item: nil, configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
