//
//  NamesDataModel.swift
//  WillowTreeNameGame
//
//  Created by Christopher Myers on 4/22/18.
//  Copyright © 2018 Dragoman Developers. All rights reserved.
//

import Foundation
import RealmSwift

class NamesDataModel: Object {
    
    @objc dynamic var id: String?
    @objc dynamic var firstName: String?
    @objc dynamic var lastName: String?
    @objc dynamic var jobTitle: String?
    @objc dynamic var headShotURL: String?   // "headshot" is dict keyword, "url" is key for string rep of url
}

extension NamesDataModel {
    convenience init(jsonArray: JSONArray) {
        self.init()

        for item in jsonArray {
            if let id = item["id"] as? String {
                self.id = id
            }
            
            if let firstName = item["firstName"] as? String {
                self.firstName = firstName
            }
            
            if let lastName = item["lastName"] as? String {
                self.lastName = lastName
            }
            
            if let headShotDict = item["headshot"] as? JSONDictionary {
                if let headShotURL = headShotDict["url"] as? String {
                    self.headShotURL = "http:" + headShotURL
                }
            }

            if let jobTitle = item["jobTitle"] as? String {
                self.jobTitle = jobTitle
            }
        }
    }
    
    func fullName() -> String {
        var fullName = "name not found"
        if let firstName = self.firstName {
            if let lastName = self.lastName {
                fullName = "\(firstName) \(lastName)"
            }
        }
        return fullName
    }
    
    func employeeTitle() -> String {
        var jobTitle = "Job title not listed."
        if let jt = self.jobTitle {
            jobTitle = jt
        }
        return jobTitle
    }
}
