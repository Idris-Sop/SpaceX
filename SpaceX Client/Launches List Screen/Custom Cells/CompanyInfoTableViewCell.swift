//
//  CompanyInfoTableViewCell.swift
//  SpaceX Client
//
//  Created by Idris Sop on 2021/07/10.
//

import UIKit

class CompanyInfoTableViewCell: UITableViewCell {

    @IBOutlet private var companyInfoLabel: UILabel?

    func populateCellWith(companyInfoDetails: String?) {
        self.companyInfoLabel?.text = companyInfoDetails
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
