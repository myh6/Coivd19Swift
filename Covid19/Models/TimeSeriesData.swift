//
//  TimeSeriesData.swift
//  Covid19
//
//  Created by curry敏 on 2021/7/23.
//

import Foundation

struct TimeSeriesData: Decodable {
    let timeline: CovidData
}

struct CovidData: Decodable {
    let cases: [String: Int]
}
