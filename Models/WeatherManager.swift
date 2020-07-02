//
//  WeatherManager.swift
//
//  Created by Ruben Castro Espinoza on 6/23/20.
//sfasdf
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager:WeatherManager, weather: WeatherModel)
    func didFailWithError(error:Error)
}

struct WeatherManager {
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=\(appId)&units=metric"
    
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(latitude: CLLocationDegrees, longitute: CLLocationDegrees) {
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitute)"
        performRequest(with: urlString)
    }
    
    func fetchWeather(cityName:String) {
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(with:urlString)
    }
    
    func performRequest(with urlString:String) {
        /*
         4 steps of networking
         1. create an actual URL not a string
         2. ceate a URL Session
         3. give the session a task
         4. start the task
         */
        
        
        // note this method creates an optional url since creating urls from strings can be bad example typos
        // the if let prevents any errors from happening
        if let url = URL(string: urlString) {
            // do something with the url
            
            //step 2 create session
            let session = URLSession(configuration: .default)
            
            //step 3 give the session a task
            //what is the completion handler well this task will take a long time since it is a network request
            //thus this is done asynchronously the handler will notify us when the task is complete
            let task  = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    // now we are going to parse the JSON Data and store it in a swift object
                    if let weather = self.parseJSON(safeData){
                        self.delegate?.didUpdateWeather(self, weather:weather)
                    }
                }
            }
            
            
            //step 4 start the task
            task.resume()
            
            
        }
        
        
    }
    
    func parseJSON(_ weatherData:Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
        
            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp)
            return weather
            
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
        
        
    }
    
    
    
    
}
