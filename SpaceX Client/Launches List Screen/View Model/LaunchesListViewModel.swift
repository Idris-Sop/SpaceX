//
//  LaunchesListViewModel.swift
//  SpaceX Client
//
//  Created by Idris Sop on 2021/07/10.
//

import UIKit

enum LaunchOpenOption: String, CaseIterable {
    case article
    case wikipedia
    case video
}

extension LaunchOpenOption {
    var description: String{
        get {
            switch self {
                case .article:
                    return "Article"
                case .wikipedia:
                    return "Wikipedia"
                case .video:
                    return "YouTube Video"
            }
        }
    }
}

enum SortOption: String, CaseIterable {
    case byLaunchSuccess
    case byAscendingOrder
    case byDescendingOrder
}

extension SortOption {
    var description: String{
        get {
            switch self {
                case .byLaunchSuccess:
                    return "Launch Success"
                case .byAscendingOrder:
                    return "Ascending Order"
                case .byDescendingOrder:
                    return "Descending Order"
            }
        }
    }
}

class LaunchesListViewModel {

    private weak var delegate: LaunchesListViewDelegate?
    private let repository: SpaceXLaunchAPIRepository
    private var launchList = [LaunchModel]()
    private var filteredLaunchList = [LaunchModel]()
    private var tableViewSections = ["COMPANY", "LAUNCHES"]
    private var companyInfoModel = CompanyModel()
    var sortOptions: [SortOption]
    var openOptions: [LaunchOpenOption]
     
    init(repository: SpaceXLaunchAPIRepository = SpaceXLaunchAPIRepositoryImplementation(), delegate: LaunchesListViewDelegate) {
        self.delegate = delegate
        self.repository = repository
        self.sortOptions = [.byLaunchSuccess, .byAscendingOrder, .byDescendingOrder]
        self.openOptions = [.article, .wikipedia, .video]
    }
    
    func fetchData() {
        fecthCompanyInfo()
        fetchLaunches()
    }
    
    func fecthCompanyInfo() {
        self.delegate?.showLoadingIndicator()
        AsynchronousProvider.runOnConcurrent({
            self.repository.retrieveCompanyInfo(with: { [weak self](companyInfo) in
                AsynchronousProvider.runOnMain {
                    self?.companyInfoModel = companyInfo
                }
            }, failure: { [weak self](error) in
                AsynchronousProvider.runOnMain {
                    self?.delegate?.showError(with: error.localizedDescription)
                }
            })
        }, .userInitiated)
    }
    
    func fetchLaunches() {
        AsynchronousProvider.runOnConcurrent({
            self.repository.retrieveLaunchesList(with: { [weak self](launchesArray) in
                AsynchronousProvider.runOnMain {
                    self?.launchList = launchesArray
                    self?.filteredLaunchList = launchesArray
                    self?.delegate?.hideLoadingIndicator()
                    self?.handlefetchLaunchesResponse()
                }
                
            }, failure: { [weak self](error) in
                AsynchronousProvider.runOnMain {
                    self?.delegate?.hideLoadingIndicator()
                    self?.delegate?.showError(with: error.localizedDescription)
                }
            })
        }, .userInitiated)
    }
    
    var companyInfoDetails: String {
        return String(format: "%@ was founded by %@ in %d. It has now %d, %d launch sites, and is valued at USD %lld", companyInfoModel.companyName?.capitalized ?? "", companyInfoModel.founderName?.capitalized ?? "", companyInfoModel.foundedYear ?? 0, companyInfoModel.employeesNumber ?? 0, companyInfoModel.launchSitesNumber ?? 0, companyInfoModel.valuation ?? 0)
    }
    
    private func handlefetchLaunchesResponse() {
        let launchesToDisplay = numberOfLaunchesInList() > 0
        if (launchesToDisplay) {
            self.delegate?.refreshContentView()
        } else {
            self.delegate?.showNoRecordsFoundText()
        }
    }
    
    func numberOfLaunchesInListFor(section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return self.filteredLaunchList.count
    }
    
    func heightForRowAt(section: Int) -> CGFloat {
        if section == 0 {
            return UITableView.automaticDimension
        }
        return 120.0
    }
    
    func numberOfLaunchesInList() -> Int {
        return self.filteredLaunchList.count
    }
    
    func numberOfSectionsInTableView() -> Int {
        return self.tableViewSections.count
    }
    
    func sectionAtIndex(index: Int) -> String {
        return self.tableViewSections[index]
    }
    
    func launchAtIndex(index: Int) -> LaunchModel {
        return self.filteredLaunchList[index]
    }
    
    private func handleDisplayOfNoRecordsFoundText() {
        let launchesToDisplay = numberOfLaunchesInList() > 0
        if (launchesToDisplay) {
            self.delegate?.hideNoRecordsFoundText()
        } else {
            self.delegate?.showNoRecordsFoundText()
        }
    }
    
    func searchLaunchWithKeyword(searchString: String) {
        self.filteredLaunchList = [LaunchModel]()
        let launchArray = self.launchList
        
        AsynchronousProvider.runOnConcurrent ({
            if searchString.isEmpty {
                self.filteredLaunchList = launchArray
            } else {
                self.filteredLaunchList = launchArray.filter {return self.doesLaunchContainSearchData(launch: $0, search: searchString)}
            }
            AsynchronousProvider.runOnMain {
                self.handleDisplayOfNoRecordsFoundText()
                self.delegate?.refreshContentView()
            }
        }, .userInteractive)
    }
    
    private func doesLaunchContainSearchData(launch: LaunchModel, search: String) -> Bool {
        return launch.missionName?.ignoreCaseContains(search) ?? false || launch.launchYear?.ignoreCaseContains(search) ?? false
    }

    
    func sortOptionsValueChanged(selectedOption: SortOption) {
        self.filteredLaunchList = [LaunchModel]()
        switch selectedOption {
            case .byLaunchSuccess:
                let launchArray = self.launchList
                self.filteredLaunchList = launchArray.filter {( $0.launchSuccess == true) }
                self.delegate?.refreshContentView()
                break
                
            case .byAscendingOrder:
                self.filteredLaunchList = self.launchList
                self.filteredLaunchList.sort(by: { $0.flightNumber?.compare($1.flightNumber ?? 0) == .orderedAscending })
                self.delegate?.refreshContentView()
                break
                
            case .byDescendingOrder:
                self.filteredLaunchList = self.launchList
                self.filteredLaunchList.sort(by: { $0.flightNumber?.compare($1.flightNumber ?? 0) == .orderedDescending })
                self.delegate?.refreshContentView()
                break
        }
    }
    
    func didSelectedLaunchAtIndex(index: Int, selectedOpenOption: LaunchOpenOption) {
        let selectedLaunch = self.filteredLaunchList[index]
        switch selectedOpenOption {
            case .article:
                UIApplication.shared.open(URL(string: selectedLaunch.missionLink?.articleLink ?? "")!, options: [:], completionHandler: nil)
                break
            case .wikipedia:
                UIApplication.shared.open(URL(string: selectedLaunch.missionLink?.wikipediaLink ?? "")!, options: [:], completionHandler: nil)
                break
            case .video:
                if let youtubeId =  selectedLaunch.missionLink?.youTubeVideoId {
                    var youtubeUrl = URL(string:"youtube://\(youtubeId)")
                    if UIApplication.shared.canOpenURL(youtubeUrl!) {
                        UIApplication.shared.open(youtubeUrl!, options: [:], completionHandler: nil)
                    } else {
                        youtubeUrl = URL(string:selectedLaunch.missionLink?.youTubeVideoLink ?? "")!
                        UIApplication.shared.open(youtubeUrl!, options: [:], completionHandler: nil)
                    }
                }
                break
        }
    }
}

