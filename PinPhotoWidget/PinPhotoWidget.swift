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
    
    func getItem() -> Item? {
        groupViewModel.load()
        guard let widgetGroup = groupViewModel.groups.first, let current = widgetViewModel.isDisplayItem else { return nil }
        
        let index: Int = min(current, widgetGroup.ids.count - 1)
        
        itemViewModel.loadFromIds(ids: [widgetGroup.ids[index]])
        return itemViewModel.items.first
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
                    Text("항목을 선택해주세요.")
                }

            } else {
                Text("항목을 선택해주세요.")
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
        .configurationDisplayName("사진 콕")
        .description("사진을 보여주는 위젯입니다.")
    }
}

struct example_Previews: PreviewProvider {
    static var previews: some View {
        EntryView(entry: TimeEntry(date: Date(), item: nil, configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
