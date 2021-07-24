//
//  TimeSeriesManager.swift
//  Covid19
//
//  Created by curry敏 on 2021/7/23.
//

import Foundation

protocol TimeSeriesManagerDelegate {
    func updateGraph(time: TimeSeriesModel)
}

struct TimeSeriesManager {
    
    private let baseURL = "https://corona.lmao.ninja/v3/covid-19/historical"
    
    var delegate: TimeSeriesManagerDelegate?
    
    func fetchTimeSeriesData(_ country: String) {
        let timeURLString = "\(baseURL)/\(country)?lastdays=8"
        print(timeURLString)
        performTimeSeriesRequest(with: timeURLString)
    }
    
    func performTimeSeriesRequest(with urlString: String) {
        
        //1.create a URL
        if let timeurl = URL(string: urlString) {
            //2.create a URL session
            let timeSession = URLSession(configuration: .default)
            //3.give session a task
            let timeTask = timeSession.dataTask(with: timeurl) { data, response, error in
                if error != nil {
                    print(error!)
                    return
                }
                if let safeData = data {
                    if let time = self.parseTimeJSON(safeData) {
                        delegate?.updateGraph(time: time)
                        print("Should update Graph now")
                    }
                }
            }
            timeTask.resume()
        }
    }
    
    func parseTimeJSON(_ covidData: Data) -> TimeSeriesModel? {
        
        let decoder = JSONDecoder()
        do {
        let decodedData = try decoder.decode(TimeSeriesData.self, from: covidData)
            let dataDict: [String : Int] = decodedData.timeline.cases
            var dataArray = Array(dataDict.values)
            var dayArray = Array(dataDict.keys)
            dayArray.sort()
            dayArray.removeFirst()
            dataArray.sort()
            var afterArray: [Int] = []
            for i in 0..<dataArray.count {
                if i != 0 {
                let result = dataArray[i] - dataArray[i-1]
                afterArray.append(result)
                }
            }
            print(dataDict)
            print(dataArray)
            print(dayArray)
            print(afterArray)
            let timeData = TimeSeriesModel(cases: afterArray)
            return timeData
        } catch {
            print(error)
            return nil
        }
    }
    
    
    
    
}
