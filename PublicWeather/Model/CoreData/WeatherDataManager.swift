//
//  WeatherDataManager.swift
//  PublicWeather
//
//  Created by 여나경 on 10/31/24.
//

import CoreData

class WeatherDataManager {
    static let shared = WeatherDataManager()
    private let context = PersistenceController.shared.container.viewContext

    func saveWeather(_ weather: WeatherPresentationModel) {
        deleteAllWeatherData()

        // 기본 정보 저장
        let weatherEntity = WeatherEntity(context: context)
        weatherEntity.nx = Int64(weather.nx)
        weatherEntity.ny = Int64(weather.ny)
        weatherEntity.baseDate = weather.baseDate
        weatherEntity.baseTime = weather.baseTime

        // 시간별 날씨 데이터 저장
        for item in weather.weatherSixHours {
            let weatherHourEntity = WeatherHourEntity(context: context)
            weatherHourEntity.fcstDate = item.fcstDate
            weatherHourEntity.fcstTime = item.fcstTime
            weatherHourEntity.temperature = item.temperature
            weatherHourEntity.sky = item.sky
            weatherHourEntity.weatherEntity = weatherEntity // 관계 설정
        }
        try? context.save()
    }

    func fetchWeather() -> WeatherPresentationModel? {
        let request: NSFetchRequest<WeatherEntity> = WeatherEntity.fetchRequest()
        guard let weatherEntity = (try? context.fetch(request))?.first,
              let weatherHourEntity = weatherEntity.weatherHours else { return nil }

        // FIXME: 길이 6인 weatherHours 반환하도록 수정 - CoreData
        let weatherHours: [Weather] = Set(arrayLiteral: weatherHourEntity).compactMap { weatherHour in
            Weather(
                fcstDate: weatherHour.fcstDate ?? "",
                fcstTime: weatherHour.fcstTime ?? "",
                temperature: weatherHour.temperature ?? "",
                sky: weatherHour.sky ?? ""
            )
        }

        return WeatherPresentationModel(
            nx: Int(weatherEntity.nx),
            ny: Int(weatherEntity.ny),
            baseDate: weatherEntity.baseDate ?? "",
            baseTime: weatherEntity.baseTime ?? "",
            weatherSixHours: weatherHours
        )
    }

    private func deleteAllWeatherData() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = WeatherEntity.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        _ = try? context.execute(deleteRequest)
    }
}
