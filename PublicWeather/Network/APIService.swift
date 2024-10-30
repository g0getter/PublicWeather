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
        print(result.response?.body?.items?.item)

        guard let item = result.response?.body?.items?.item?.first(where: { $0.category == .t1h }) else {
            throw URLError(.badServerResponse)
        }
        
        // TODO: 옵셔널 값 적절하게 처리
        return WeatherPresentationModel(
            baseDate: item.baseDate ?? "N/A",
            baseTime: item.baseTime ?? "N/A",
            category: item.category ?? .t1h,
            fcstDate: item.fcstDate ?? "N/A",
            fcstTime: item.fcstTime ?? "N/A",
            fcstValue: item.fcstValue ?? "0",
            nx: item.nx ?? 0,
            ny: item.ny ?? 0
        )
    }
}

