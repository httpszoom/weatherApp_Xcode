import Foundation
 
let apiKey = "9d5002b55b3fdc06be8976d89577e02c"
let city = "Paris"
 
let data: Data? = """
{"coord":{"lon":-80,"lat":40.44},"weather":[{"id":804,"main":"Clouds","description":"overcast clouds","icon":"04d"}],"base":"stations","main":{"temp":41.5,"feels_like":36.81,"temp_min":37.4,"temp_max":45,"pressure":1021,"humidity":80},"visibility":16093,"wind":{"speed":3.04,"deg":79},"clouds":{"all":90},"dt":1585068301,"sys":{"type":1,"id":3510,"country":"US","sunrise":1585048554,"sunset":1585092969},"timezone":-14400,"id":5206379,"name":"Pittsburgh","cod":200}
""".data(using: .utf8)
 
struct Weather: Codable {
    var temp: Double?
    var humidity: Double?
}
 
struct WeatherMain: Codable{
    let main: Weather
}
 
func decodeJSONData(JSONData: Data){
    do{
        let weatherData = try? JSONDecoder().decode(WeatherMain.self, from: JSONData)
        if let weatherData = weatherData{
            let weather = weatherData.main
            print(weather.temp!)
            print(weather.humidity!)
        }
    }
}
 
struct WeatherData: Decodable {
    let list: [List]
}
 
struct Main: Decodable {
    let temp: Float
}
 
struct Weather2: Decodable {
    let description: String
    let icon: String
}
 
struct List: Decodable {
    let main: Main
    let weather: [Weather2]
}
 
func decodeJSONForecast(JSONData: Data){
    let response = try! JSONDecoder().decode(WeatherData.self, from: JSONData)
    
    for i in response.list {
        print("Temp : \(i.main.temp)")
        for j in i.weather {
            print("Description : \(j.description)")
            print("Icon : \(j.icon)")
        }
    }
}
 
func pullJSONData(url: URL?){
    let task = URLSession.shared.dataTask(with: url!) { data, response, error in
        if let error = error {
            print("Error : \(error.localizedDescription)")
        }
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            print("Error : HTTP Response Code Error")
            return
        }
        
        guard let data = data else {
            print("Error : No Response")
            return
        }
        
        decodeJSONForecast(JSONData: data)
        
    }
    task.resume()
}
 
let url = URL(string: "http://api.openweathermap.org/data/2.5/forecast?q=\(city)&appid=\(apiKey)&units=imperial")
 
pullJSONData(url: url)

