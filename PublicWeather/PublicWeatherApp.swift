//
//  PublicWeatherApp.swift
//  PublicWeather
//
//  Created by 여나경 on 10/30/24.
//

import SwiftUI

@main
struct PublicWeatherApp: App {
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            WeatherView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
