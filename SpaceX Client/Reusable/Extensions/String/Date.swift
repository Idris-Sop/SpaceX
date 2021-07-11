//
//  Date.swift
//  SpaceX Client
//
//  Created by Idris Sop on 2021/07/10.
//

import Foundation

extension Date {
    func convertDateToString(_ stringFormat: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = stringFormat
        return formatter.string(from: self)
    }
}
