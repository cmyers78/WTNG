//
//  NetworkRequests.swift
//  WillowTreeNameGame
//
//  Created by Christopher Myers on 4/22/18.
//  Copyright © 2018 Dragoman Developers. All rights reserved.
//

import Foundation

class NetworkRequests {

    let opQueue = OperationQueue.main
    func loadNamesFromNetwork() {
        if let url = URL(string: AppConstants.namesURL) {
            let task = URLSession.shared.dataTask(with: url) {
                (data, response, error) in
                if error != nil {
                    // return failure(error) enum
                }
                if let namesJSONArray = self.parseJSON(from: data) {
                    let namesData = namesJSONArray.map { data in
                        NamesDataModel(jsonArray: [data])
                    }
                    self.opQueue.maxConcurrentOperationCount = 5
                    self.opQueue.addOperation {
                        print("async call....")
                        NamesDataStore().saveNamesData(withName: namesData)
                    }
                }
            }
            task.resume()
        } else {
            print("Not a valid url: \(AppConstants.namesURL)")
        }
    }
    
    // was private...took it off to test
     func parseJSON(from data : Data?) -> JSONArray? {
        var namesDataArray : JSONArray? = nil
        
        if let namesData = data {
            do {
                if let jsonArray = try JSONSerialization.jsonObject(with: namesData, options: []) as? JSONArray {
                    namesDataArray = jsonArray
                } else {
                    print("I could not parse JSON")
                }
            } catch {
                print(error)
            }
        }
        return namesDataArray
    }
}
