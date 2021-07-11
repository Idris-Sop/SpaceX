//
//  LaunchesListViewController.swift
//  SpaceX Client
//
//  Created by Idris Sop on 2021/07/08.
//

import UIKit

class LaunchesListViewController: BaseViewController {

    @IBOutlet private var launchSearchBar: UISearchBar! {
        didSet {
            launchSearchBar.delegate = self
        }
    }
    
    @IBOutlet private var launchTableView: UITableView! {
        didSet {
            launchTableView.rowHeight = UITableView.automaticDimension
            launchTableView.estimatedRowHeight = UITableView.automaticDimension
            launchTableView.tableFooterView = UIView(frame: .zero)
        }
    }
    
    @IBOutlet private var noRecordFoundLabel: UILabel!
    
    // MARK: Dependencies
    private var selectedlaunch: LaunchModel?
    private lazy var viewModel =  LaunchesListViewModel(delegate: self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.noRecordFoundLabel.isHidden = true
        viewModel.fetchData()
        hideKeyboardWhenTappedAround()
    }
    
    override func rightNavigationBarButtonImageTapped() {
        super.rightNavigationBarButtonImageTapped()
        
        let title = "Sort By: "
        let actionSheetAlert = UIAlertController.init(title: title, message: nil, preferredStyle: .actionSheet)
        
        for option in viewModel.sortOptions {
            actionSheetAlert.addAction(UIAlertAction.init(title: option.description, style: .default, handler: { (action) in
                if let selectedSortOptionIndex = self.viewModel.sortOptions.firstIndex(where: {$0.description == action.title}) {
                    let selectedOption = self.viewModel.sortOptions[selectedSortOptionIndex]
                    self.viewModel.sortOptionsValueChanged(selectedOption: selectedOption)
                }
            }))
        }
        actionSheetAlert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        self.present(actionSheetAlert, animated: true, completion: nil)
    }
    
    func showAlertActionForSelectedCellAtIndex(index: Int) {
        let title = "Open: "
        let actionSheetAlert = UIAlertController.init(title: title, message: nil, preferredStyle: .actionSheet)
        
        for option in viewModel.openOptions {
            actionSheetAlert.addAction(UIAlertAction.init(title: option.description, style: .default, handler: { (action) in
                if let selectedOpenOptionIndex = self.viewModel.openOptions.firstIndex(where: {$0.description == action.title}) {
                    let selectedOption = self.viewModel.openOptions[selectedOpenOptionIndex]
                    self.viewModel.didSelectedLaunchAtIndex(index: index, selectedOpenOption: selectedOption)
                }
            }))
        }
        actionSheetAlert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        self.present(actionSheetAlert, animated: true, completion: nil)
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "launchMapViewSegueIdentifier" {
//            let launchMapViewController = segue.destination as? launchMapViewController
//            guard let launch = selectedlaunch else {
//                return
//            }
//            launchMapViewController?.setupPointAnnotationWith(launch: launch)
//        }
//    }
}

// MARK: UITableViewDelegate, UITableViewDataSource

extension LaunchesListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfLaunchesInListFor(section: section)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSectionsInTableView()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let customCell = tableView.dequeueReusableCell(withIdentifier: "companyIdentifer", for: indexPath) as? CompanyInfoTableViewCell

            customCell?.populateCellWith(companyInfoDetails: viewModel.companyInfoDetails)
            return customCell ?? CompanyInfoTableViewCell()
        }
        let customCell = tableView.dequeueReusableCell(withIdentifier: "launchCellIdentifier", for: indexPath) as? LaunchesListTableViewCell
        let currentlaunch = viewModel.launchAtIndex(index: indexPath.row)

        customCell?.populateCellWith(missionName: currentlaunch.missionName, launchDate: currentlaunch.launchDate, rocket: currentlaunch.rocket, daysSinceOrFromNow: "", missionImageLink: currentlaunch.missionLink?.missionSmallImageLink, status: currentlaunch.launchSuccess ?? false)
        return customCell ?? LaunchesListTableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return viewModel.heightForRowAt(section: indexPath.section)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.showAlertActionForSelectedCellAtIndex(index: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.sectionAtIndex(index: section)
    }
}

// MARK: UISearchBarDelegate

extension LaunchesListViewController: UISearchBarDelegate {
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        return true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.searchLaunchWithKeyword(searchString: searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

// MARK: launchListViewModelDelegate

extension LaunchesListViewController: LaunchesListViewDelegate {
    
    func refreshContentView() {
        launchTableView.reloadData()
    }
    
    func showLoadingIndicator() {
        self.showLoadingActivityIndicator()
    }
    
    func hideLoadingIndicator() {
        self.hideLoadingActivityIndicator()
    }
    
    func showError(with message: String) {
        self.showErrorMessage(errorMessage: message)
    }
    
    func showNoRecordsFoundText() {
        self.noRecordFoundLabel.isHidden = false
        self.launchTableView.isHidden = true
    }
    
    func hideNoRecordsFoundText() {
        self.noRecordFoundLabel.isHidden = true
        self.launchTableView.isHidden = false
    }
    
//    func navigateToMapViewWith(launch: launch) {
//        self.selectedlaunch = launch
//        self.performSegue(withIdentifier: "launchMapViewSegueIdentifier", sender: self)
//    }
}

