//
//  Forecast.swift
//  Projet_WeatherApp
//
//  Created by Hubert Page on 28/03/2021.
//

import Foundation

let apiKey = "9d5002b55b3fdc06be8976d89577e02c"

struct Forecast : Codable {
    struct List: Codable {
        let dt: Date
        struct Main: Codable {
            let temp: Double
        }
        let main: Main
        
        struct Weather: Codable {
            let description: String
            let icon: String
            var weatherIconURL: URL {
                let urlString = "http://openweathermap.org/img/wn/\(icon)@2x.png"
                return URL(string: urlString)!
            }
        }
        let weather: [Weather]
    }
    let list: [List]
}

let apiService = APIService.shared
let dateFormatter = DateFormatter()

func apiServiceJson() {
    
    dateFormatter.dateFormat = "E, MM, d"

    apiService.getJSON(urlString: "http://api.openweathermap.org/data/2.5/forecast?q=Paris&appid=\(apiKey)",
                       dateDecodingStrategy: .secondsSince1970) { (result: Result<Forecast,APIService.APIError>) in
        switch result {
        case .success(let forecast):
            for list in forecast.list {
                print(dateFormatter.string(from: list.dt))
                print("   Température:", list.main.temp)
                print("   Description:", list.weather[0].description)
                print("   Icone:", list.weather[0].icon)
                print("   URL de l'icone:", list.weather[0].weatherIconURL)
        
            }
        case .failure(let apiError):
            switch apiError {
            case .error(let errorString):
                print(errorString)
            }
        }
    }

}
