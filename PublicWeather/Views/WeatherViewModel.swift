//
//  WeatherViewModel.swift
//  PublicWeather
//
//  Created by 여나경 on 10/30/24.
//

import Foundation
import Combine

class WeatherViewModel: ObservableObject { // 뷰 모델에 상태 변화가 있음을 알림
    @Published var weather: WeatherPresentationModel? // 뷰와 바인딩
    @Published var errorMessage: String? // 에러 메시지 상태 관리
    @Published var isLoading: Bool = false // 로딩 상태 관리

    private var networkMonitor = NetworkMonitor()
    private let apiService = APIService()
    private let weatherDataManager = WeatherDataManager.shared
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        startSyncTimer()
        
        loadDataBasedOnNetworkStatus()
        
        // 네트워크 상태 변화 감지하여 데이터 로드
        networkMonitor.$isConnected // isConnected 업데이트 될 때마다 sink 클로저 호출
            .sink { [weak self] isConnected in
                self?.loadDataBasedOnNetworkStatus()
            }
            .store(in: &cancellables)
    }
    
    private func loadDataBasedOnNetworkStatus() {
        if networkMonitor.isConnected {
            fetchWeather()
        } else {
            loadLocalWeatherData()
        }
    }
    
    // 실제 API 호출
    func fetchWeather() {
        isLoading = true
        errorMessage = nil

        Task {
            do {
                let weather = try await apiService.fetchWeather()
                DispatchQueue.main.async {
                    self.weather = weather
                    self.weatherDataManager.saveWeather(weather) // 로컬 DB에 저장
                    self.isLoading = false
                }
            } catch { // 와이파이 미연결 시 여기 실행
                DispatchQueue.main.async {
                    self.errorMessage = "Error: \(error.localizedDescription)"
                    self.isLoading = false
                }
            }
        }
    }
    
    // 로컬 데이터베이스에서 가져옴
    private func loadLocalWeatherData() {
        if let localWeatherData = weatherDataManager.fetchWeather() {
            self.weather = localWeatherData
        }
    }
    
    private func startSyncTimer() {
//        Timer.publish(every: 18, on: .main, in: .common) // 시간 단축 시 사용
        Timer.publish(every: 1800, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                if self?.networkMonitor.isConnected == true {
                    self?.fetchWeather()
                }
            }
            .store(in: &cancellables)
    }
}
