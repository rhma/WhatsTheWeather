//
//  Weather.swift
//  JSON
//
//  Created by Brian Advent on 11.05.17.
//  Copyright © 2017 Brian Advent. All rights reserved.
//
import Foundation
import CoreLocation

struct Weather {
    let summary:String
    let icon:String
    let temperaturemax:Double
    let celsiusmax:Double
    let temperaturemin:Double
    let celsiusmin:Double
    
    enum SerializationError:Error {
        case missing(String)
        case invalid(String, Any)
    }
    
    
    init(json:[String:Any]) throws {
        guard let summary = json["summary"] as? String else {throw SerializationError.missing("summary is missing")}
        
        guard let icon = json["icon"] as? String else {throw SerializationError.missing("icon is missing")}
        
        guard let temperaturemax = json["temperatureMax"] as? Double else {throw SerializationError.missing("temp is missing")}
        
        guard let celsiusmax = json["temperatureMax"] as? Double else {throw SerializationError.missing("temp is missing")}
        
        guard let temperaturemin = json["temperatureMin"] as? Double else {throw SerializationError.missing("temp is missing")}
        
        guard let celsiusmin = json["temperatureMin"] as? Double else {throw SerializationError.missing("temp is missing")}
        
        self.summary = summary
        self.icon = icon
        self.temperaturemax = temperaturemax
        self.celsiusmax = celsiusmax
        self.temperaturemin = temperaturemin
        self.celsiusmin = celsiusmin
        
    }
    
    
    static let basePath = "https://api.darksky.net/forecast/c1c6f4de97eef5fa018a527125cbb8e4/"
    
    static func forecast (withLocation location:CLLocationCoordinate2D, completion: @escaping ([Weather]?) -> ()) {
        
        let url = basePath + "\(location.latitude),\(location.longitude)"
        let request = URLRequest(url: URL(string: url)!)
        
        let task = URLSession.shared.dataTask(with: request) { (data:Data?, response:URLResponse?, error:Error?) in
            
            var forecastArray:[Weather] = []
            
            if let data = data {
                
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] {
                        if let dailyForecasts = json["daily"] as? [String:Any] {
                            if let dailyData = dailyForecasts["data"] as? [[String:Any]] {
                                for dataPoint in dailyData {
                                    if let weatherObject = try? Weather(json: dataPoint) {
                                        forecastArray.append(weatherObject)
                                    }
                                }
                            }
                        }
                    
                    }
                }catch {
                    print(error.localizedDescription)
                }
                
                completion(forecastArray)
                
            }
            
            
        }
        
        task.resume()
        
        
        
        
        
        
        
        
    
    }
    

}
