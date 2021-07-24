//
//  Covid19Data.swift
//  Covid19
//
//  Created by curry敏 on 2021/7/20.
//

import Foundation

struct Covid19Data: Decodable {
    let country: String
    let cases: Int
    let todayCases: Int
    let deaths: Int
    let todayDeaths: Int
    let countryInfo: CountryInfo
}

struct CountryInfo: Decodable {
    let iso2: String
    let flag: String
}
