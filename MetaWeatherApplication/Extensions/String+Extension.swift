//
//  String+Extension.swift
//  MetaWeatherApplication
//
//  Created by bora on 17.09.2021.
//

import Foundation

extension String {
    func formatDateString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateFormatterFinal = DateFormatter()
        dateFormatterFinal.dateFormat = "dd.MM.yyyy"
        let date = dateFormatter.date(from: self)
        return dateFormatterFinal.string(from: date ?? Date())
    }
    
    func formatFilterYearDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateFormatterFinal = DateFormatter()
        dateFormatterFinal.dateFormat = "yyyy"
        let date = dateFormatter.date(from: self)
        return dateFormatterFinal.string(from: date ?? Date())
    }
}
