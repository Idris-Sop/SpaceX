//
//  ManageCache.swift
//  SpaceX Client
//
//  Created by Idris Sop on 2021/07/10.
//

import UIKit

@objc public class ManageCache: NSObject {
    
    @objc public static let sharedInstance = ManageCache()
    var launchesList: [LaunchModel]?
    var companyInfo: CompanyModel?
    
    func invalidateLaunch() {
        launchesList = nil
    }
}

