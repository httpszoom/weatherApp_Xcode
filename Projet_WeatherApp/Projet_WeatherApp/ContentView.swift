//
//  ContentView.swift
//  Projet_WeatherApp
//
//  Created by Hubert Page on 28/03/2021.
//

import SwiftUI

struct ContentView: View {
    
    @State var forecast: Forecast? = nil

        
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    //TextField("Enter Location", text: $location).textFieldStyle(RoundedBorderTextFieldStyle())
                    Button {
                       getWeatherForecast()
                    } label: {
                        Text("Actualiser").font(.title3)
                    }
                }
                
                if let forecast = forecast {
                    List(forecast.list, id: \.dt) { day in
                        Text("\(day.dt)")
                    }
                } else {
                    Spacer()
                }
            }
            .padding(.horizontal)
            .navigationTitle("Météo de Paris")
        }
        
        
    }
    
    func getWeatherForecast() {
        let apiService = APIService.shared
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E, MM, d"

        apiService.getJSON(urlString: "https://api.openweathermap.org/data/2.5/forecast?q=Paris&appid=\(apiKey)",
                           dateDecodingStrategy: .secondsSince1970) { (result: Result<Forecast,APIService.APIError>) in
            switch result {
            case .success(let forecast):
                self.forecast = forecast
//                for list in forecast.list {
//                    print(dateFormatter.string(from: list.dt))
//                    print("   Température:", list.main.temp)
//                    print("   Description:", list.weather[0].description)
//                    print("   Icone:", list.weather[0].icon)
//                    print("   URL de l'icone:", list.weather[0].weatherIconURL)
//
//                }
            case .failure(let apiError):
                switch apiError {
                case .error(let errorString):
                    print(errorString)
                }
            }
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
