//
//  Date+Format.swift
//  PublicWeather
//
//  Created by 여나경 on 10/31/24.
//

import Foundation

extension Date {
    /// e.g. "20241031"
    var yyyyMMdd: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        return formatter.string(from: self)
    }
    
    var HHmm: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HHmm"
        return formatter.string(from: self)
    }
    
    // 1시간 뺀 HHmm 형식
    var HHmmOneHourAgo: String {
        let calendar = Calendar.current
        let oneHourAgo = calendar.date(byAdding: .hour, value: -1, to: self) ?? self
        let formatter = DateFormatter()
        formatter.dateFormat = "HHmm"
        return formatter.string(from: oneHourAgo)
    }
}
