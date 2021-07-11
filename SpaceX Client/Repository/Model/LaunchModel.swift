//
//  LaunchModel.swift
//  SpaceX Client
//
//  Created by Idris Sop on 2021/07/10.
//

import UIKit

struct LaunchModel {
    var flightNumber: NSNumber?
    var missionName: String?
    var launchYear: String?
    var launchDate: Date?
    var rocket: RocketModel?
    var launchSuccess: Bool?
    var missionLink: MissionLinkModel?
}

struct RocketModel {
    var rocketId: String?
    var rocketName: String?
    var rocketType: String?
}

struct MissionLinkModel {
    var missionImageLink: String?
    var missionSmallImageLink: String?
    var articleLink: String?
    var wikipediaLink: String?
    var youTubeVideoLink: String?
    var youTubeVideoId: String?
}
