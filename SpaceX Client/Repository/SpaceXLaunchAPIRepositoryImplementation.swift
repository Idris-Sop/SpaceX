//
//  SpaceXLaunchAPIRepositoryImplementation.swift
//  SpaceX Client
//
//  Created by Idris Sop on 2021/07/10.
//

import UIKit

class SpaceXLaunchAPIRepositoryImplementation: SpaceXLaunchAPIRepository {

    func retrieveCompanyInfo(with success: @escaping RetrieveCompanyInfoCompletionBlock,
                             failure: @escaping CompletionFailureBlock) {
        let cachedCompanyInfo = ManageCache.sharedInstance.companyInfo
        if cachedCompanyInfo != nil {
            success(cachedCompanyInfo ?? CompanyModel())
        } else {
            let webServiceManager = WebServicesManager()
            webServiceManager.performServerOperationWithURLRequest(stringURL: "https://api.spacexdata.com/v3/info",
                                                                   bodyRequestParameter: nil,
                                                                   httpMethod: "GET",
                                                                   httpHeaderField: nil,
                                                                   success: { (data) in
                                                                    do {
                                                                        let jsonObject = try JSONSerialization.jsonObject(with: data! as Data, options: []) as? [String : Any]
                                                                        
                                                        
                                                                        if let companyObject = jsonObject {
                                                                            let companyModel = CompanyModel(companyName: companyObject["name"] as? String, founderName: companyObject["founder"] as? String, foundedYear: companyObject["founded"] as? Int, employeesNumber: companyObject["employees"] as? Int, launchSitesNumber: companyObject["launch_sites"] as? Int, valuation: companyObject["valuation"] as? UInt64)
                                                                            
                                                                            ManageCache.sharedInstance.companyInfo = companyModel
                                                                            success(companyModel)
                                                                        }
                                                                    } catch  {
                                                                        let dataError = NSError(domain: "The data couldn’t be read due to technical problem.", code: 0, userInfo: nil)
                                                                        failure(dataError)
                                                                    }
                                                                    
            }) { (error) in
                failure(error ?? NSError())
            }
        }
    }
    
    func retrieveLaunchesList(with success: @escaping RetrieveLaunchesListCompletionBlock,
                              failure: @escaping CompletionFailureBlock)  {
        let cachedLaunches = ManageCache.sharedInstance.launchesList
        if cachedLaunches?.count ?? 0 > 0 {
            success(cachedLaunches ?? [LaunchModel]())
        } else {
            let webServiceManager = WebServicesManager()
            webServiceManager.performServerOperationWithURLRequest(stringURL: "https://api.spacexdata.com/v3/launches",
                                                                   bodyRequestParameter: nil,
                                                                   httpMethod: "GET",
                                                                   httpHeaderField: nil,
                                                                   success: { (data) in
                                                                    do {
                                                                        var launchList = [LaunchModel]()
                                                                        let jsonObjectArray = try JSONSerialization.jsonObject(with: data! as Data, options: []) as? Array<Any>
                                                                        
                                                        
                                                                        if let itemsList = jsonObjectArray {
                                                                            for(_, launch) in (itemsList.enumerated()) {
                                                                                
                                                                                if let currentlaunch = launch as? [String : Any] {
                                                                                    guard let missionLink = currentlaunch["links"] as? [String : Any] else { return }
                                                                                    guard let rocket = currentlaunch["rocket"] as? [String : Any] else { return }
                                                                                    
                                                                                    let rocketModel = RocketModel(rocketId: rocket["rocket_id"] as? String, rocketName: rocket["rocket_name"] as? String, rocketType: rocket["rocket_type"] as? String)
                                                                                    
                                                                                    let missionLinkModel = MissionLinkModel(missionImageLink: missionLink["mission_patch"] as? String, missionSmallImageLink: missionLink["mission_patch_small"] as? String, articleLink: missionLink["article_link"] as? String, wikipediaLink: missionLink["wikipedia"] as? String, youTubeVideoLink: missionLink["video_link"] as? String, youTubeVideoId: missionLink["youtube_id"] as? String)
                                                                                    
                                                                                    let launchDate = currentlaunch["launch_date_local"] as? String
                                                                                    
                                                                                    let launchModel = LaunchModel(flightNumber: NSNumber(value: currentlaunch["flight_number"] as? Int ?? 0), missionName: currentlaunch["mission_name"] as? String, launchYear: currentlaunch["launch_year"] as? String, launchDate: launchDate?.convertStringToDate(), rocket: rocketModel, launchSuccess: currentlaunch["launch_success"] as? Bool, missionLink: missionLinkModel)
                                                            
                                                                                    launchList.append(launchModel)
                                                                                }
                                                                                
                                                                            }
                                                                        }
                                                                        launchList.sort(by: { $0.flightNumber?.compare($1.flightNumber ?? 0) == .orderedAscending })
                                                                        ManageCache.sharedInstance.launchesList = launchList
                                                                        success(launchList)
                                                                    } catch  {
                                                                        let dataError = NSError(domain: "The data couldn’t be read due to technical problem.", code: 0, userInfo: nil)
                                                                        failure(dataError)
                                                                    }
                                                                    
            }) { (error) in
                failure(error ?? NSError())
            }
        }
    }
}

