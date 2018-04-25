//
//  AppConstants.swift
//  WillowTreeNameGame
//
//  Created by Christopher Myers on 4/22/18.
//  Copyright © 2018 Dragoman Developers. All rights reserved.
//

import Foundation
import UIKit

// Type Aliases
typealias JSONDictionary = [String : AnyObject]
typealias JSONArray = [JSONDictionary]

// Constants
struct AppConstants {
    static let namesURL = "https://willowtreeapps.com/api/v1.0/profiles/"
    static let homeScreenVC = "HomeScreenVC"
    static let nameGameVC = "NameGameVC"
    static let feedbackPopupVC = "FeedbackPopupVC"
    static let gameSummaryVC = "GameSummaryVC"
    static let feedbackContinueButtonTitle = "Continue"
    static let willowTreeColor = UIColor(red: 100/255, green: 214/255, blue: 196/255, alpha: 1.0)
    
}
