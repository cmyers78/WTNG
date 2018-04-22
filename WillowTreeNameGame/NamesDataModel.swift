//
//  NamesDataModel.swift
//  WillowTreeNameGame
//
//  Created by Christopher Myers on 4/22/18.
//  Copyright © 2018 Dragoman Developers. All rights reserved.
//

import Foundation
import RealmSwift

class NamesDataModel : Object {
    typealias JSONDictionary = [String : AnyObject]
    typealias JSONArray = [JSONDictionary]
    
    @objc dynamic var id : String?
    @objc dynamic var firstName : String?
    @objc dynamic var lastName : String?
    @objc dynamic var jobTitle : String?
    @objc dynamic var headShotURL : String?   // "headshot" is dict keyword, "url" is key for string rep of url
}

extension NamesDataModel {
    convenience init(jsonArray : JSONArray) {
        self.init()
        for item in jsonArray {
            guard let id = item["id"] as? String, let firstName = item["firstName"] as? String, let lastName = item["lastName"] as? String,
                let jobTitle = item["jobTitle"] as? String else { return }
            
            guard let headShotDict = item["headshot"] as? JSONDictionary else { return }
            guard let headShotURL = headShotDict["url"] as? String else { return }
            
            self.id = id
            self.firstName = firstName
            self.lastName = lastName
            self.jobTitle = jobTitle
            self.headShotURL = headShotURL
        }
    }
}
