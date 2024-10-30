//
//  WeatherPresentationModel.swift
//  PublicWeather
//
//  Created by 여나경 on 10/30/24.
//

import Foundation

// TODO: 화면에 맞게 수정

struct WeatherDateTime: Hashable {
    let date: String
    let time: String
}

/// VStack의 row에 들어갈 1시간 분의 날씨
struct Weather: Codable {
    let fcstDate: String
    let fcstTime: String
    let temperature: String // e.g. 21°C
    let sky: String // Sky.description, e.g. 맑음
}

struct WeatherPresentationModel: Codable {
    // 장소
    let nx: Int
    let ny: Int
    /// 기준시간(발표일자)
    let baseDate: String
    /// 기준시간(발표시각)
    let baseTime: String
    let weatherSixHours: [Weather]
}

enum Category: String, Codable {
    case t1h = "T1H" // 기온 (°C)
    case rn1 = "RN1" // 1시간 강수량 (mm)
    case sky = "SKY" // 하늘 상태 (코드값)
    case uuu = "UUU" // 동서바람성분 (m/s)
    case vvv = "VVV" // 남북바람성분 (m/s)
    case reh = "REH" // 습도 (%)
    case pty = "PTY" // 강수 형태 (코드값)
    case lgt = "LGT" // 낙뢰 (kA)
    case vec = "VEC" // 풍향 (deg)
    case wsd = "WSD" // 풍속 (m/s)
}

/// 하늘상태
enum Sky: CaseIterable {
    /// 맑음
    case sunny
    /// 구름 많음
    case cloudy
    /// 흐림
    case overcast
    
    var forecastValue: String {
        switch self {
        case .sunny: "1"
        case .cloudy: "3"
        case .overcast: "4"
        }
    }
    
    var description: String {
        switch self {
        case .sunny: "맑음"
        case .cloudy: "구름 많음"
        case .overcast: "흐림"
        }
    }
    
    static func getType(forecastValue: String) -> Sky? {
        Sky.allCases.first { $0.forecastValue == forecastValue }
    }
}
