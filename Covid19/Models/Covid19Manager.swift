//
//  Covid19Manager.swift
//  Covid19
//
//  Created by curry敏 on 2021/7/20.
//

import Foundation

protocol Covid19ManagerDelegate {
    
    func updateData(covid: Covid19Model)
}

struct Covid19Manager {
    
    private let baseURL = "https://corona.lmao.ninja/v3/covid-19/countries"
    
    var delegate: Covid19ManagerDelegate?
    
    func fetchData(_ country: String) {
        let urlString = "\(baseURL)/\(country)"
        print(urlString)
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String) {
        
        //1.create a URL
        if let url = URL(string: urlString) {
            
            //2.create a URLsession
            let session = URLSession(configuration: .default)
            
            //3.Give the session a task
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    print(error!)
                    return
                }
                if let safeData = data {
                    if let covid = self.parseJson(safeData) {
                        delegate?.updateData(covid: covid)
                        print("\(covid.countryName) is the country that got passed in")
                        print("\(covid.todayCinModel) people got infected today")
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJson(_ covid19Data: Data) -> Covid19Model?{
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(Covid19Data.self, from: covid19Data)
            print(decodedData.country)
            let country = decodedData.country
            let todayCasesCount = decodedData.todayCases
            let totalCasesCount = decodedData.cases
            let todayDeathsCount = decodedData.todayDeaths
            let totalDeathsCount = decodedData.deaths
            let countryID = decodedData.countryInfo.iso2
            let countryFlag = decodedData.countryInfo.flag
            
            let covid = Covid19Model(countryName: country, todayCinModel: todayCasesCount, totalCinModel: totalCasesCount, todayDinModel: todayDeathsCount, totoalDinModel: totalDeathsCount, idinModel: countryID, countryFlag: countryFlag)
            return covid
        } catch {
            print(error)
            return nil
        }
    }
}
