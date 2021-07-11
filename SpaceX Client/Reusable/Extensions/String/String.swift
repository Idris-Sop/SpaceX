//
//  String.swift
//  SpaceX Client
//
//  Created by Idris Sop on 2021/07/10.
//

import Foundation

extension String {

    func convertStringToDate() -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let date = formatter.date(from: self)
        return date ?? Date()
    }
    
    func ignoreCaseContains(_ searchable: String) -> Bool {
        return self.lowercased().contains(searchable.lowercased())
    }
}
