//
//  Extensions.swift
//  RM
//
//  Created by Vlad Sadovodov on 07.07.2024.
//

import Foundation

import Foundation
import UIKit

extension UIView {
    func addSubViews(_ views: UIView...) {
        views.forEach({addSubview($0)})
    }
}
