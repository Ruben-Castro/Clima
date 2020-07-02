//
//  WeatherData.swift
//  Clima
//
//  Created by Ruben Castro Espinoza on 6/23/20.
//  
//

import Foundation


struct WeatherData: Decodable {
    let name: String
    let main: Main
    let weather : [Weather]
}

struct Main: Decodable {
    let temp: Double
    let pressure: Double
}

struct Weather: Decodable {
    let description:String
    let id:Int
    
}
