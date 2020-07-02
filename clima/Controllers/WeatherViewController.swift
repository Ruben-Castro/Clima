//
//  ViewController.swift
//  Clima
//  Created by Ruben Castro  on 01/09/2019.
//  .
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    
    
    
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()

   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchTextField.delegate = self
        weatherManager.delegate = self
        locationManager.delegate = self
        
        //ask user for location
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        // set the delegate to the current class aka the text field will notify our view controller that the
        // user interacted with the text field. Communication between text field and view controller.
        
    }

}

//MARK: - UITextFieldDelegate



extension WeatherViewController: UITextFieldDelegate {
   
    @IBAction func searchPressed(_ sender: UIButton) {
           print(searchTextField.text!)
           searchTextField.endEditing(true)
       }
       
       // all of the should are asking the view controller what to do ?
       func textFieldShouldReturn(_ textField: UITextField) -> Bool {
           searchTextField.endEditing(true)
           print(searchTextField.text!)
           return true
       }
       
       // useful for doing validation on what the user typed
       func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
           if textField.text != "" {
               return true
           }else{
               textField.placeholder = "Type a city name"
               return false
           }
       }
       
       //basically says hey view controller the text field has stopped editing ie the user has stoped typing, now we can do something if this is the case
       func textFieldDidEndEditing(_ textField: UITextField) {
           //Use the search TextField.text to get the weather from the city after this we can reset the searchTextfield
           if var city = searchTextField.text {
            // trim leading and trailing white spaces
            city = city.trimmingCharacters(in: .whitespaces)
            
            //remove excess whitespace for example "  " -> " "
            city = city.replacingOccurrences(of: "[\\s\n]+", with: " ", options: .regularExpression, range: nil)
            
            // fixes issues with cities that contain spaces ex Los Angeles 
            if city.contains(" "){
                let parts = city.split(separator: " ")
                city = parts[0] + "%20" + parts[1]
            }
           
               weatherManager.fetchWeather(cityName: city)
           }
           
           searchTextField.text =  ""
       }
}

//MARK: - WeatherManagerDelegate

extension WeatherViewController: WeatherManagerDelegate {
    
    func didUpdateWeather(_ weatherManager:WeatherManager, weather: WeatherModel) {
        DispatchQueue.main.async {
            self.temperatureLabel.text = weather.temperatureString
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
            self.cityLabel.text = weather.cityName
        }
        
        
        
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}


//MARK: - CLLocationManagerDelegate

extension WeatherViewController:CLLocationManagerDelegate {
    
    @IBAction func locationButtonPressed(_ sender: UIButton) {
       print("location Button Pressed")
       locationManager.requestLocation()
      
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    if let location = locations.last {
        locationManager.stopUpdatingLocation()
        let lat = location.coordinate.latitude
        let lon = location.coordinate.longitude
      weatherManager.fetchWeather(latitude: lat, longitute: lon)
        
    }
        
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
