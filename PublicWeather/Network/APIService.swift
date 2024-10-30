//
//  APIService.swift
//  PublicWeather
//
//  Created by 여나경 on 10/30/24.
//

import Foundation

class APIService {
    func fetchWeather() async throws -> WeatherPresentationModel {
        // TODO: baseDate, baseTime 현재 시간으로 변경, nx, ny 현재 위치 기반 or 입력하도록 변경
        let apiKey = "5ujyxrqUwgiHVUgpCydwjUcl3hkyH%2FiPDyjRCd9nizgwI72jpUtli00JbQZTV4N78CNEwoR0ebFsJ2SP8%2BiI6w%3D%3D" // FIXME: 안전 확인
        let baseDate = "20241030"
        let baseTime = "0630"
        let nx = "58"
        let ny = "26"
        let urlString = """
        https://apis.data.go.kr/1360000/VilageFcstInfoService_2.0/getUltraSrtFcst?\
        serviceKey=\(apiKey)&pageNo=1&numOfRows=100&dataType=JSON&base_date=\(baseDate)\
        &base_time=\(baseTime)&nx=\(nx)&ny=\(ny)
        """
        
        // TODO: 에러 처리
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }

        switch httpResponse.statusCode {
        case 200...299:
            return try parseWeatherData(data)  // 파싱 함수 호출
        // TODO: 에러 세분화 처리
//        case 400:
//            // bad request
//        case 401:
//            // auth
//        case 404:
//            // not found
//        case 500...599:
//            // server error
        default:
            throw URLError(.unknown)
        }
    }
    
    private func parseWeatherData(_ data: Data) throws -> WeatherPresentationModel {
        let decoder = JSONDecoder()
        let result = try decoder.decode(ResponseModel.self, from: data)
//        print(result.response?.body?.items?.item)

        guard let weatherList = result.response?.body?.items?.item else {
            throw URLError(.badServerResponse)
        }
  
        let groupedWeather = Dictionary(grouping: weatherList) { item in
            // Dictionary의 키로 Hashable 타입만 가능 // TODO: 필요성 재고
            WeatherDateTime(date: item.fcstDate ?? "", time: item.fcstTime ?? "")
        }
        let unsortedWeatherSixHours: [Weather] = groupedWeather
            .compactMap { (_, items) -> Weather? in
                let temperature = items.first(where: { $0.category == .t1h })?.fcstValue ?? ""
                let skyValue = items.first(where: { $0.category == .sky })?.fcstValue ?? ""
                let skyDescription = Sky.getType(forecastValue: skyValue)?.description ?? ""
                guard !temperature.isEmpty || !skyDescription.isEmpty else { return nil }
                return Weather(
                    fcstDate: items.first?.fcstDate ?? "",
                    fcstTime: items.first?.fcstTime ?? "",
                    temperature: "\(temperature)°C",
                    sky: skyDescription
                )
            }
        let weatherSixHours = unsortedWeatherSixHours.sorted { $0.fcstTime < $1.fcstTime }
        
        return WeatherPresentationModel(
            nx: weatherList.first?.nx ?? 0,
            ny: weatherList.first?.ny ?? 0,
            baseDate: weatherList.first?.baseDate ?? "N/A",
            baseTime: weatherList.first?.baseTime ?? "N/A",
            weatherSixHours: weatherSixHours
        )
    }
}

