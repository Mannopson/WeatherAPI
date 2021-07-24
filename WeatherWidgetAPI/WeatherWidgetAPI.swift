//
//  WeatherWidgetAPI.swift
//  WeatherWidgetAPI
//
//  Created by AzizOfficial on 7/24/21.
//

import WidgetKit
import SwiftUI
import CoreLocation

struct Provider: TimelineProvider {
    
    var locationServices = LocationServices()
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date.init(), response: .success(WeatherModel.shared.snapshot()))
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date.init(), response: .success(WeatherModel.shared.snapshot()))
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        let weatherModel = WeatherModel.shared
        
        locationServices.fetchLocation { (result) in
            switch result {
            case .success(let location):
                print(location)
                weatherModel.getConditionInfoByLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude, units: weatherModel.preferredUnits(), language: "en") { (result) in
                    
                    // Generate a timeline consisting of five entries an hour apart, starting from the current date.
                    let currentDate = Date()
                    for hourOffset in 0 ..< 5 {
                        let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
                        let entry = SimpleEntry(date: entryDate, response: result)
                        entries.append(entry)
                    }

                    let timeline = Timeline(entries: entries, policy: .atEnd)
                    completion(timeline)
                }
            case .failure(let error):
                print(error.localizedDescription)
                let entry = SimpleEntry(date: Date.init(), response: .failure(error))
                entries.append(entry)
                
                let timeline = Timeline(entries: entries, policy: .atEnd)
                completion(timeline)
            }
        }
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let response: Result<WeatherCondition, Error>
}

struct WeatherWidgetEntryView : View {
    var entry: Provider.Entry

    func viewProvider() -> AnyView {
        switch entry.response {
        case .success(let weather):
            return AnyView(ResponseView(response: weather))
        case .failure(let error):
            return AnyView(ErrorView(responseError: error))
        }
    }
    
    var body: some View {
       viewProvider()
    }
}

@main
struct WeatherWidget: Widget {
    let kind: String = "WeatherWidgetAPI"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            WeatherWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct WeatherWidget_Previews: PreviewProvider {
    static var previews: some View {
        WeatherWidgetEntryView(entry: SimpleEntry(date: Date(), response: .success(WeatherModel.shared.snapshot())))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
