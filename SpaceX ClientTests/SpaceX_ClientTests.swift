//
//  SpaceX_ClientTests.swift
//  SpaceX ClientTests
//
//  Created by Idris Sop on 2021/07/08.
//

import XCTest
@testable import SpaceX_Client

class SpaceX_ClientTests: XCTestCase {
    
    private var mockRepository = MockSpaceXLaunchAPIRepository()
    private var viewModelUnderTest : LaunchesListViewModel!
    private var mockDelegate = MockLaunchesListViewDelegate()

    override func setUpWithError() throws {
        super.setUp()
        AsynchronousProvider.setAsyncRunner(DummyAsynchronousRunner())
        viewModelUnderTest = LaunchesListViewModel(repository: mockRepository, delegate: mockDelegate)
    }

    override func tearDownWithError() throws {
        mockRepository.verify()
        mockDelegate.verify()
        AsynchronousProvider.reset()
        super.tearDown()
    }
    
    func testThatWhenFetchCompanyInfoIsCalledThenShowLoadingIndicatorShouldBeCalled() {
        mockFetchinCompanyInfoSuccessfully()
        viewModelUnderTest.fecthCompanyInfo()
        mockDelegate.verifyShowLoadingIndicator(count: 1)
    }
    
    func testThatWhenFetchCompanyInfoWithFailureIsCalledThenShowErrorShouldBeCalled() {
        mockFetchingCompanyInfoFailure()
        viewModelUnderTest.fecthCompanyInfo()
        mockDelegate.verifytShowError(count: 1)
    }
    
    func testThatWhenFetchLaunchesWithSuccessIsCalledThenHideLoadingIndicatorShouldBeCalled() {
        mockFetchingLaunchesSuccessfully()
        viewModelUnderTest.fetchLaunches()
        mockDelegate.verifyHideLoadingIndicator(count: 1)
    }
    
    func testThatWhenFetchLaunchesWithSuccessIsCalledThenRefreshContentViewShouldBeCalled() {
        mockFetchingLaunchesSuccessfully()
        viewModelUnderTest.fetchLaunches()
        mockDelegate.verifyRefreshContentView(count: 1)
    }
    
    func testThatWhenFetchLaunchesWithFailureIsCalledThenHideLoadingIndicatorViewShouldBeCalled() {
        mockFetchingLaunchesFailure()
        viewModelUnderTest.fetchLaunches()
        mockDelegate.verifyHideLoadingIndicator(count: 1)
    }
    
    func testThatWhenFetchLaunchesWithFailureIsCalledThenShowErrorShouldBeCalled() {
        mockFetchingLaunchesFailure()
        viewModelUnderTest.fetchLaunches()
        mockDelegate.verifytShowError(count: 1)
    }
    
    func testThatWhenNumberOfLaunchesInListInSection0IsCalledThenReturnOne() {
        mockFetchingLaunchesSuccessfully()
        viewModelUnderTest.fetchLaunches()
        XCTAssertEqual(1, viewModelUnderTest.numberOfLaunchesInListFor(section: 0))
    }
    
    func testThatWhenNumberOfLaunchesInListInSection1IsCalledThenReturnLaunchesListCount() {
        let expectedLaunches = mockLaunchesData()
        mockFetchingLaunchesSuccessfully()
        viewModelUnderTest.fetchLaunches()
        XCTAssertEqual(expectedLaunches.count, viewModelUnderTest.numberOfLaunchesInListFor(section: 1))
    }
    
    func testThatWhenHeightForRowAtIndexInSection0IsCalledThenReturnTableViewAutomaticDimension() {
        XCTAssertEqual(UITableView.automaticDimension, viewModelUnderTest.heightForRowAt(section: 0))
    }
    
    func testThatWhenHeightForRowAtIndexInListInSection1IsCalledThenReturn120() {
        XCTAssertEqual(120.0, viewModelUnderTest.heightForRowAt(section: 1))
    }
    
    func testThatWhennumberOfSectionsInTableViewIsCalledThenReturnTwo() {
        XCTAssertEqual(2, viewModelUnderTest.numberOfSectionsInTableView())
    }
    
    func testThatWhenNumberOfLaunchesInListIsCalledThenReturnFilteredLaunchesListCount() {
        mockFilterWithRecord()
        mockFetchingLaunchesSuccessfully()
        viewModelUnderTest.fetchLaunches()
        viewModelUnderTest.searchLaunchWithKeyword(searchString: "Space")
        XCTAssertEqual(2, viewModelUnderTest.numberOfLaunchesInList())
    }
    
    func testThatWhenNumberOfLaunchesInListIsCalledThenReturnZeroCount() {
        mockFilterWithNoRecordFound()
        mockFetchingLaunchesSuccessfully()
        viewModelUnderTest.fetchLaunches()
        viewModelUnderTest.searchLaunchWithKeyword(searchString: "GH")
        XCTAssertEqual(0, viewModelUnderTest.numberOfLaunchesInList())
    }
    
    
    func testThatWhenSearchLaunchWithKeywordIsCalledAndKeywordFoundThenHideNoRecordsFoundTextShouldBeCalled() {
        mockFilterWithRecord()
        mockFetchingLaunchesSuccessfully()
        viewModelUnderTest.fetchLaunches()
        viewModelUnderTest.searchLaunchWithKeyword(searchString: "Space")
        mockDelegate.verifyHideNoRecordsFound(count: 1)
    }
    
    func testThatWhenSearchLaunchWithKeywordIsCalledAndKeywordNOTFoundThenHideNoRecordsFoundTextShouldBeCalled() {
        mockFilterWithNoRecordFound()
        mockFetchingLaunchesSuccessfully()
        viewModelUnderTest.fetchLaunches()
        viewModelUnderTest.searchLaunchWithKeyword(searchString: "GH")
        mockDelegate.verifyShowNoRecordsFound(count: 1)
    }
    
    func testThatWhenSortOptionsValueChangedIsCalledThenRefreshContentViewShouldBeCalled() {
        mockDelegate.expectRefreshContentView()
        viewModelUnderTest.sortOptionsValueChanged(selectedOption: .byAscendingOrder)
        mockDelegate.verifyRefreshContentView(count: 1)
    }

    func mockFetchingLaunchesSuccessfully() {
        mockDelegate.expectHideLoadingIndicator()
        mockDelegate.expectRefreshContentView()
        stubFetchLaunchesSuccess()
    }
    
    func mockFetchingLaunchesFailure() {
        mockDelegate.expectHideLoadingIndicator()
        mockDelegate.expectShowError(error: mockError())
        stubFetchLaunchesFailure()
    }
    
    func mockFetchinCompanyInfoSuccessfully() {
        mockDelegate.expectShowLoadingIndicator()
        stubFetchCompanyInfoSuccess()
    }
    
    func mockFetchingCompanyInfoFailure() {
        mockDelegate.expectShowLoadingIndicator()
        mockDelegate.expectShowError(error: mockError())
        stubFetchCompanyInfoFailure()
    }
    
    func mockFilterWithRecord() {
        mockDelegate.expectHideNoRecordsFound()
        mockDelegate.expectRefreshContentView()
    }
    
    func mockFilterWithNoRecordFound() {
        mockDelegate.expectShowNoRecordsFound()
        mockDelegate.expectRefreshContentView()
    }
    
    func stubFetchLaunchesSuccess() {
        mockRepository.expectFetchLaunchListForSuccess(launchList: mockLaunchesData())
    }
    
    func stubFetchLaunchesFailure() {
        mockRepository.expectFetchLaunchListFailure(error: mockError())
    }
    
    func stubFetchCompanyInfoSuccess() {
        mockRepository.expectFetchCompanyInfoForSuccess(companyInfo: mockCompanyInfo())
    }
    
    func stubFetchCompanyInfoFailure() {
        mockRepository.expectFetchCompanyInfoFailure(error: mockError())
    }
    
    func mockError() -> NSError {
        return NSError(domain: "Failed to fetch", code: 0)
    }
    
    func mockLaunchesData() -> [LaunchModel] {
        return [LaunchModel(flightNumber: 1, missionName: "Space", launchYear: "2008", launchDate: Date(), rocket: RocketModel(rocketId: "1", rocketName: "Rock1", rocketType: "RockType"), launchSuccess: true, missionLink: MissionLinkModel(missionImageLink: "HSIS", missionSmallImageLink: "jdjd", articleLink: "idjcoj", wikipediaLink: "idojc", youTubeVideoLink: "kjddj", youTubeVideoId: "8493hdhddj")), LaunchModel(flightNumber: 2, missionName: "SpapeX", launchYear: "2010", launchDate: Date(), rocket: RocketModel(rocketId: "2", rocketName: "Rock2", rocketType: "RockType"), launchSuccess: false, missionLink: MissionLinkModel(missionImageLink: "HSIS", missionSmallImageLink: "jdjd", articleLink: "idjcoj", wikipediaLink: "idojc", youTubeVideoLink: "kjddj", youTubeVideoId: "8493hdhddj")), LaunchModel(flightNumber: 2, missionName: "SpaceZ", launchYear: "2005", launchDate: Date(), rocket: RocketModel(rocketId: "3", rocketName: "Rock3", rocketType: "RockType"), launchSuccess: false, missionLink: MissionLinkModel(missionImageLink: "HSIS", missionSmallImageLink: "jdjd", articleLink: "idjcoj", wikipediaLink: "idojc", youTubeVideoLink: "kjddj", youTubeVideoId: "8493hdhddj"))]
    }
    
    func mockCompanyInfo() -> CompanyModel {
        return CompanyModel(companyName: "Comp", founderName: "John", foundedYear: 2020, employeesNumber: 23, launchSitesNumber: 34, valuation: 393930303)
    }
}
