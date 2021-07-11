//
//  MockLaunchesListViewDelegate.swift
//  SpaceX ClientTests
//
//  Created by Idris Sop on 2021/07/11.
//

import XCTest
@testable import SpaceX_Client

struct MockLaunchesListViewDelegateExpectation: TestExpectable {
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

class MockLaunchesListViewDelegate: NSObject {
    private var stubLaunchViewModelDelegateExpectation: [TestExpectable] = [TestExpectable]()
    private var invocation =  [String:Int]()
    private var error: NSError!
    private let refreshContentViewSignature = "refreshContentViewSignature"
    private let showLoadingIndicatorSignature = "showLoadingIndicatorSignature"
    private let hideLoadingIndicatorSignature = "hideLoadingIndicatorSignature"
    private let showErrorSignature = "showErrorSignature"
    private let showNoRecordsFoundTextSignature = "showNoRecordsFoundTextSignature"
    private let hideNoRecordsFoundTextSignature = "hideNoRecordsFoundTextSignature"
    
    func verify() {
        self.stubLaunchViewModelDelegateExpectation.verify()
    }
    
    func verifyRefreshContentView(count: Int) {
        stubLaunchViewModelDelegateExpectation.verifyExpectation(for: refreshContentViewSignature, count: count)
    }
    
    func expectRefreshContentView() {
        stubLaunchViewModelDelegateExpectation.append(MockLaunchesListViewDelegateExpectation(count: 1, functionSignature: refreshContentViewSignature))
    }
    
    func verifyShowLoadingIndicator(count: Int) {
        stubLaunchViewModelDelegateExpectation.verifyExpectation(for: showLoadingIndicatorSignature, count: count)
    }
    
    func expectShowLoadingIndicator() {
        stubLaunchViewModelDelegateExpectation.append(MockLaunchesListViewDelegateExpectation(count: 1, functionSignature: showLoadingIndicatorSignature))
    }
    
    func verifyHideLoadingIndicator(count: Int) {
        stubLaunchViewModelDelegateExpectation.verifyExpectation(for: hideLoadingIndicatorSignature, count: count)
    }
    
    func expectHideLoadingIndicator() {
        stubLaunchViewModelDelegateExpectation.append(MockLaunchesListViewDelegateExpectation(count: 1, functionSignature: hideLoadingIndicatorSignature))
    }
    
    func verifytShowError(count: Int) {
        stubLaunchViewModelDelegateExpectation.verifyExpectation(for: showErrorSignature, count: count)
    }
    
    func expectShowError(error: NSError) {
        self.error = error
        stubLaunchViewModelDelegateExpectation.append(MockLaunchesListViewDelegateExpectation(count: 1, functionSignature: showErrorSignature))
    }

    func verifyShowNoRecordsFound(count: Int) {
        stubLaunchViewModelDelegateExpectation.verifyExpectation(for: showNoRecordsFoundTextSignature, count: count)
    }
    
    func expectShowNoRecordsFound() {
        stubLaunchViewModelDelegateExpectation.append(MockLaunchesListViewDelegateExpectation(count: 1, functionSignature: showNoRecordsFoundTextSignature))
    }
    
    func verifyHideNoRecordsFound(count: Int) {
        stubLaunchViewModelDelegateExpectation.verifyExpectation(for: hideNoRecordsFoundTextSignature, count: count)
    }
    
    func expectHideNoRecordsFound() {
        stubLaunchViewModelDelegateExpectation.append(MockLaunchesListViewDelegateExpectation(count: 1, functionSignature: hideNoRecordsFoundTextSignature))
    }
}

extension MockLaunchesListViewDelegate: LaunchesListViewDelegate {
   
    func refreshContentView() {
        _ = stubLaunchViewModelDelegateExpectation.expectation(for: refreshContentViewSignature)
    }
    
    func showLoadingIndicator() {
        invocation[showLoadingIndicatorSignature] = invocation[showLoadingIndicatorSignature] ?? 0 + 1
        _ = stubLaunchViewModelDelegateExpectation.expectation(for: showLoadingIndicatorSignature)
    }
    
    func hideLoadingIndicator() {
        invocation[hideLoadingIndicatorSignature] = invocation[hideLoadingIndicatorSignature] ?? 0 + 1
        _ = stubLaunchViewModelDelegateExpectation.expectation(for: hideLoadingIndicatorSignature)
    }
    
    func showError(with message: String) {
        XCTAssertEqual(message, error!.localizedDescription)
        _ = stubLaunchViewModelDelegateExpectation.expectation(for: showErrorSignature)
    }
    
    func showNoRecordsFoundText() {
        _ = stubLaunchViewModelDelegateExpectation.expectation(for: showNoRecordsFoundTextSignature)
    }
    
    func hideNoRecordsFoundText() {
        _ = stubLaunchViewModelDelegateExpectation.expectation(for: hideNoRecordsFoundTextSignature)
    }
}

