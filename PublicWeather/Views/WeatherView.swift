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
                VStack(alignment: .center, spacing: 20) {
                    HStack {
                        Text("위치 (\(weather.nx), \(weather.ny))")
                        Text("\(weather.baseDate) \(weather.baseTime) 발표")
                            .font(.system(size: 15))
                    }
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(spacing: 20) {
                            ForEach(weather.weatherSixHours, id: \.fcstTime) { weather in
                                HStack {
                                    Text(weather.fcstTime)
                                        .font(.headline)
                                    Text(weather.temperature)
                                    Text(weather.sky)
                                        .foregroundColor(.blue)
                                }
                                .padding()
                                .background(RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.gray.opacity(0.2)))
                            }
                        }
                        .padding()
                    }
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
