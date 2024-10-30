//
//  WeatherPresentationModel.swift
//  PublicWeather
//
//  Created by 여나경 on 10/30/24.
//

import Foundation

// TODO: 화면에 맞게 수정
struct WeatherPresentationModel: Codable {
    let baseDate: String
    let baseTime: String
    let category: Category
    let fcstDate: String
    let fcstTime: String
    let fcstValue: String
    let nx: Int
    let ny: Int
}

enum Category: String, Codable {
    case t1h = "T1H" // 기온 (℃)
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
