//
//  ResponseModel.swift
//  PublicWeather
//
//  Created by 여나경 on 10/30/24.
//

import Foundation

struct ResponseModel: Codable {
    let response: Response?
}

struct Response: Codable {
    let header: Header?
    let body: Body?
}

struct Body: Codable {
    let dataType: String?
    let items: Items?
    let pageNo, numOfRows, totalCount: Int?
}

struct Items: Codable {
    let item: [ShortTermWeather]?
}

struct ShortTermWeather: Codable {
    let baseDate, baseTime, fcstDate, fcstTime: String?
    let category: Category?
    let fcstValue: String?
    let nx, ny: Int?
}

struct Header: Codable {
    let resultCode, resultMsg: String?
}
