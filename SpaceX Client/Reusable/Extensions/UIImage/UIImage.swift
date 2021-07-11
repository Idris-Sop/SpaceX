//
//  UIImage.swift
//  SpaceX Client
//
//  Created by Idris Sop on 2021/07/08.
//

import UIKit

extension UIImage {
  static func localImage(_ name: String, template: Bool = false) -> UIImage {
    var image = UIImage(named: name)!
    if template {
      image = image.withRenderingMode(.alwaysTemplate)
    }
    return image
  }
}
