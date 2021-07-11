//
//  CompanyModel.swift
//  SpaceX Client
//
//  Created by Idris Sop on 2021/07/10.
//

import UIKit

struct CompanyModel: Codable, Equatable {
    var companyName: String?
    var founderName: String?
    var foundedYear: Int?
    var employeesNumber: Int?
    var launchSitesNumber: Int?
    var valuation: UInt64?
}
