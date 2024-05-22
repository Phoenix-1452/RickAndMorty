//
//  Extensions.swift
//  RickAndMorty
//
//  Created by Vlad Sadovodov on 21.05.2024.
//

import Foundation
import UIKit

extension UIView {
    func addSubViews(_ views: UIView...) {
        views.forEach({addSubview($0)})
    }
}
