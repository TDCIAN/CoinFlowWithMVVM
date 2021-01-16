//
//  ChartXAxisValueFormatter.swift
//  CoinFlowWithMVVM
//
//  Created by APPLE on 2021/01/16.
//

import Foundation
import Charts

class ChartXAxisDayFormatter: NSObject, IAxisValueFormatter {
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "H"
        let hour = formatter.string(from: Date(timeIntervalSince1970: value))
        return hour
    }
}

class ChartXAxisWeekFormatter: NSObject, IAxisValueFormatter {
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        let day = formatter.string(from: Date(timeIntervalSince1970: value))
        return day
    }
}

class ChartXAxisMonthFormatter: NSObject, IAxisValueFormatter {
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM"
        let date = formatter.string(from: Date(timeIntervalSince1970: value))
        return date
    }
}

class ChartXAxisYearFormatter: NSObject, IAxisValueFormatter {
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM"
        let month = formatter.string(from: Date(timeIntervalSince1970: value))
        return month
    }
}
