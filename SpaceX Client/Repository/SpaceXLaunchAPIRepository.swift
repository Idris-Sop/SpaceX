//
//  SpaceXLaunchAPIRepository.swift
//  SpaceX Client
//
//  Created by Idris Sop on 2021/07/10.
//

import UIKit

typealias RetrieveLaunchesListCompletionBlock = (_ success: [LaunchModel]) -> Void
typealias RetrieveCompanyInfoCompletionBlock = (_ success: CompanyModel) -> Void
typealias CompletionFailureBlock = (_ error: NSError) -> Void

protocol SpaceXLaunchAPIRepository {

    func retrieveLaunchesList(with success: @escaping RetrieveLaunchesListCompletionBlock,
                          failure: @escaping CompletionFailureBlock)
    
    func retrieveCompanyInfo(with success: @escaping RetrieveCompanyInfoCompletionBlock,
                             failure: @escaping CompletionFailureBlock)
}
