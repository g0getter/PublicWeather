//
//  WeatherViewModel.swift
//  PublicWeather
//
//  Created by 여나경 on 10/30/24.
//

import Foundation
//TODO: import Combine

class WeatherViewModel: ObservableObject {
    @Published var weather: WeatherPresentationModel?
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false

    private let apiService = APIService()

    func fetchWeather() {
        isLoading = true
        errorMessage = nil

        Task {
            do {
                let weather = try await apiService.fetchWeather()
                DispatchQueue.main.async {
                    self.weather = weather
                    self.isLoading = false
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = "Error: \(error.localizedDescription)"
                    self.isLoading = false
                }
            }
        }
    }
}
