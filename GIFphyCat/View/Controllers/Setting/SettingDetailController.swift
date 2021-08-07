//
//  SettingDetailController.swift
//  GIFphyCat
//
//  Created by Namrata Akash on 02/08/21.
//

import UIKit
import GiphyKit

protocol SettingsDetailController {
    
    // The alert controller that the settings details are presented in.
    var viewController: UIViewController { get }
    
    // The title of the view controller
    var title: String? { get }
}
