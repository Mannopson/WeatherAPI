//
//  ErrorView.swift
//  WeatherWidgetAPIExtension
//
//  Created by AzizOfficial on 7/24/21.
//

import SwiftUI

struct ErrorView: View {
    let responseError: Error
    var body: some View {
        Text(responseError.localizedDescription)
            .font(.footnote)
            .multilineTextAlignment(.center)
            .padding()
    }
}

