//
//  ResponseView.swift
//  WeatherWidgetAPIExtension
//
//  Created by AzizOfficial on 7/24/21.
//

import SwiftUI
import WidgetKit

struct ResponseView: View {
    
    let response: WeatherCondition
    let weatherModel = WeatherModel.shared
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Text(Int.init(response.main.temp).description + "" + "º").font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(Color(UIColor.label))
                        .multilineTextAlignment(.leading)
                    Spacer()
                    if let icon = response.weather.last?.icon {
                        Image(uiImage: weatherModel.getSystemIcon(from: icon)!)
                    }
                }
                .padding()
                Spacer()
                VStack(alignment: .center) {
                    if let text = response.weather.last?.description {
                        Text(text)
                            .font(.caption)
                            .foregroundColor(Color(UIColor.systemGray))
                            .multilineTextAlignment(.center)
                            
                    }
                    Text(response.name)
                        .foregroundColor(Color(UIColor.systemTeal))
                        .font(.footnote)
                        .multilineTextAlignment(.center)
                }
                .padding()
            }
        }
//        .background(Image("rain")
//                        .resizable()
//                        .blur(radius: 15)
//                        .scaledToFill()
//                        .edgesIgnoringSafeArea(.all))
    }
}


struct ResponseView_Previews: PreviewProvider {
    static var previews: some View {
        ResponseView(response: WeatherModel.shared.snapshot())
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
