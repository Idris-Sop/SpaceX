//
//  MockSpaceXLaunchAPIRepository.swift
//  SpaceX ClientTests
//
//  Created by Idris Sop on 2021/07/10.
//

import UIKit

@testable import SpaceX_Client

struct MockSpaceXLaunchAPIRepositoryExpectation: TestExpectable {
    var expectedCount: Int
    var identifier: String
    var actualCount = 0
    var alreadyInvoked = false
    var expectedResult: Any?
    
    init(count: Int, functionSignature: String) {
        self.identifier = functionSignature
        self.expectedCount = count
    }
}

class MockSpaceXLaunchAPIRepository: NSObject {
    
    private var stubResponseExpectation: [TestExpectable] = [TestExpectable]()
    private let fetchLaunchListSignature = "fetchLaunchListSignature"
    private var isFetchLaunchListCallSucces = false
    private let fetchCompanyInfoSignature = "fetchCompanyInfoSignature"
    private var isFetchCompanyInfoCallSucces = false
    private var launchList = [LaunchModel]()
    private var companyInfo = CompanyModel()
    private var error: NSError!
    
    func verify() {
        self.stubResponseExpectation.verify()
    }
    
    func expectFetchLaunchListForSuccess(launchList: [LaunchModel]) {
        isFetchLaunchListCallSucces = true
        self.launchList = launchList
        stubResponseExpectation.append(MockSpaceXLaunchAPIRepositoryExpectation(count: 1, functionSignature: fetchLaunchListSignature))
    }
    
    func expectFetchLaunchListFailure(error: NSError) {
        isFetchLaunchListCallSucces = false
        self.error = error
        stubResponseExpectation.append(MockSpaceXLaunchAPIRepositoryExpectation(count: 1, functionSignature: fetchLaunchListSignature))
    }
    
    func expectFetchCompanyInfoForSuccess(companyInfo: CompanyModel) {
        isFetchCompanyInfoCallSucces = true
        self.companyInfo = companyInfo
        stubResponseExpectation.append(MockSpaceXLaunchAPIRepositoryExpectation(count: 1, functionSignature: fetchCompanyInfoSignature))
    }
    
    func expectFetchCompanyInfoFailure(error: NSError) {
        isFetchCompanyInfoCallSucces = false
        self.error = error
        stubResponseExpectation.append(MockSpaceXLaunchAPIRepositoryExpectation(count: 1, functionSignature: fetchCompanyInfoSignature))
    }
}

extension MockSpaceXLaunchAPIRepository: SpaceXLaunchAPIRepository {
    
    func retrieveLaunchesList(with success: @escaping RetrieveLaunchesListCompletionBlock,
                              failure: @escaping CompletionFailureBlock) {
        _ = stubResponseExpectation.expectation(for: fetchLaunchListSignature)
        
        if isFetchLaunchListCallSucces {
            success(self.launchList)
        } else {
            failure(self.error)
        }
    }
    
    func retrieveCompanyInfo(with success: @escaping RetrieveCompanyInfoCompletionBlock,
                             failure: @escaping CompletionFailureBlock) {
        _ = stubResponseExpectation.expectation(for: fetchCompanyInfoSignature)
        
        if isFetchCompanyInfoCallSucces {
            success(self.companyInfo)
        } else {
            failure(self.error)
        }
    }
}

