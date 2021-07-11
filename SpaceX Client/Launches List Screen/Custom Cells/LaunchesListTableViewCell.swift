//
//  LaunchesListTableViewCell.swift
//  SpaceX Client
//
//  Created by Idris Sop on 2021/07/08.
//

import UIKit

class LaunchesListTableViewCell: UITableViewCell {

    @IBOutlet private var launchImageView: UIImageView?
    @IBOutlet private var missionNameLabel: UILabel?
    @IBOutlet private var launchDateLabel: UILabel?
    @IBOutlet private var rocketLabel: UILabel?
    @IBOutlet private var daysSinceOrFromNowLabel: UILabel?
    @IBOutlet private var imageViewLoadingIndicator: UIActivityIndicatorView!
    @IBOutlet private var launchStatusImageView: UIImageView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func populateCellWith(missionName: String?, launchDate: Date?, rocket: RocketModel?, daysSinceOrFromNow: String?, missionImageLink: String?, status: Bool) {
        self.missionNameLabel?.text = String(format: "Mission: %@", missionName ?? "")
        self.launchDateLabel?.text = String(format: "Date/Time: %@", launchDate?.convertDateToString("dd MMM yyyy | HH:mm") as String? ?? "") 
        self.rocketLabel?.text = String(format: "Rocket: %@ / %@", rocket?.rocketName ?? "", rocket?.rocketType ?? "")
        self.daysSinceOrFromNowLabel?.text = daysSinceOrFromNow

        self.launchImageView?.setImageWith(urlString: missionImageLink ?? "", {
            self.imageViewLoadingIndicator.stopAnimating()
            self.imageViewLoadingIndicator.isHidden = true
        })
        status ? (launchStatusImageView?.image = UIImage(named: "check_icon")) : (launchStatusImageView?.image = UIImage(named: "fail_icon"))
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
