//
//  WeatherView.swift
//  PublicWeather
//
//  Created by 여나경 on 10/30/24.
//

import SwiftUI

struct WeatherView: View {
    @ObservedObject private var viewModel = WeatherViewModel()

    var body: some View {
        VStack(spacing: 20) {
            Button("Fetch Weather") {
                viewModel.fetchWeather()
            }
            .padding()

            if viewModel.isLoading {
                ProgressView()
            } else if let weather = viewModel.weather {
                VStack {
                    Text("Temperature: \(weather.fcstValue)°C")
                    Text("Forecast Time: \(weather.fcstTime)")
                }
                .font(.title)
            } else if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
            }

            Spacer()
        }
        .padding()
    }
}


#Preview {
    WeatherView()
}
