//
//  WeatherModel.swift
//  Clima
//
//  Created by Vinicius Santana on 12/06/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation

struct WeatherModel{
    let conditionId : Int
    let cityName : String
    let temperature : Double
    let timeZone : TimeZone
    
    var stringTemp : String {
        return String(format: "%.1f", temperature)
    }
    
    
    var conditionName : String  {
        
        switch conditionId {
        case 200...232:
            return isEvening() ? "cloud.moon.bolt" : "cloud.bolt"
        case 300...321:
            return "cloud.drizzle"
        case 500...531:
            return isEvening() ? "cloud.moon.rain" :"cloud.rain"
        case 600...622:
            return "cloud.snow"
        case 701...781:
            return "cloud.fog"
        case 800:
            return isEvening() ? "moon.stars" :  "sun.max"
        case 801...804:
            return isEvening() ? "cloud.moon" : "cloud"
        default:
            return isEvening() ? "cloud.moon" : "cloud"
        }
    }
    
    func isEvening() -> Bool {
        var calendar = Calendar.current
        calendar.timeZone = timeZone
        let hour = calendar.component(.hour, from: Date())
        return hour > 18
    }
}
