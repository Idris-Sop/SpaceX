//
//  LaunchesListViewDelegate.swift
//  SpaceX Client
//
//  Created by Idris Sop on 2021/07/10.
//

import UIKit

protocol LaunchesListViewDelegate: AnyObject {
    func refreshContentView()
    func showLoadingIndicator()
    func hideLoadingIndicator()
    func showError(with message: String)
    func showNoRecordsFoundText()
    func hideNoRecordsFoundText()
}
