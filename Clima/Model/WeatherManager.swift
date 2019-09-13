//
//  WeatherManager.swift
//  Clima
//
//  Created by Vinicius Santana on 11/06/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager {
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=19f4b58f856b04ad7f7fe1a886eca603&units=metric"
    
    var delegate : WeatherManagerDelegate?
    
    func fetchWeather(cityName : String)  {
        let urlString = "\(weatherURL)&q=\(cityName)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        performRequest(with: urlString)
    }
    
    func fetchWeather(latitude: Double, longitude: Double){
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString : String){
        //1. Create a URL
        
        if let url = URL(string: urlString) {
            //2. Create URLSession
            let session = URLSession(configuration: .default)
            
            //3. Give the session a task
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data {
                    if let weather = self.parseJson(safeData) {
                        self.delegate?.didUpdateWeather(self, weather : weather)
                    }
                }
            }
            
            //4. Start task
            task.resume()
        }
        
    }
    
    func parseJson(_ weatherData : Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
           
            let id = decodedData.weather[0].id
            let temperature = decodedData.main.temp
            let cityName = decodedData.name
            let timezone = TimeZone(secondsFromGMT: decodedData.timezone)!
            
            let weather = WeatherModel(conditionId: id, cityName: cityName, temperature: temperature, timeZone: timezone)
            
            return weather
            
        } catch {
            self.delegate?.didFailWithError(error: error)
            return nil
        }
        
    }
    

}
