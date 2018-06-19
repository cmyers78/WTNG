//
//  NamesDataStore.swift
//  WillowTreeNameGame
//
//  Created by Christopher Myers on 4/22/18.
//  Copyright © 2018 Dragoman Developers. All rights reserved.
//

import Foundation
import RealmSwift

class NamesDataStore {
    
    func saveNamesData(withName namesDataArray: [NamesDataModel]) {
        let configuration = Realm.Configuration(encryptionKey: getKey())
        let realm = try! Realm(configuration: configuration) // swiftlint:disable:this force_try
        
        // check to see if current dataStore count is the same as incoming JSON, if not, filter through the incoming json
        // to find unique names and add to array
        //
        // NOTE: - it will be nice to be able to hit the API and get back a response to see if there has been an update
        // so that the app could determine whether it needed to download names again.
        //
        let currentDataStoreCount = getNamesData(forGame: .normal).count
        
        if currentDataStoreCount == namesDataArray.count {
            // no new data
            print("Count equal for currentDataStore: \(currentDataStoreCount) and namesDataArray: \(namesDataArray.count)")
            return
        } else {
            let filteredForDuplicates = namesDataArray.filter { getNamesData(forGame: .normal).contains($0) == false }
            print("new data. write transaction")
            print("filteredDataCount = \(filteredForDuplicates.count)")
            // swiftlint:disable:next force_try
            try! realm.write {
                realm.add(filteredForDuplicates)
            }
        }
    }
    
    func getNamesData(forGame: GameType ) -> [NamesDataModel] {
        let configuration = Realm.Configuration(encryptionKey: getKey())
        let decryptNames = try! Realm(configuration: configuration) // swiftlint:disable:this force_try
        var filtered = [NamesDataModel]()
        switch forGame {
        case .normal:
            filtered = Array(decryptNames.objects(NamesDataModel.self))
        case .matt:
            filtered = Array(decryptNames.objects(NamesDataModel.self).filter { dataModel in
                (dataModel.firstName?.lowercased().contains("mat"))!
            })
        case .teams:
            filtered =  Array(decryptNames.objects(NamesDataModel.self).filter({ dataModel in
                dataModel.jobTitle != nil
            }))
        }
        
        return filtered
    }
    
    // From Realm.io encryption documents and not testing so marked private
   private func getKey() -> Data {
        let keychainIdentifier = "names.willowTreeApp.identiferKey"
        let keychainIdentifierData = keychainIdentifier.data(using: String.Encoding.utf8, allowLossyConversion: false)!
        
        // First check in the keychain for an existing key
        var query: [NSString: AnyObject] = [
            kSecClass: kSecClassKey,
            kSecAttrApplicationTag: keychainIdentifierData as AnyObject,
            kSecAttrKeySizeInBits: 512 as AnyObject,
            kSecReturnData: true as AnyObject
        ]
        var dataTypeRef: AnyObject?
        var status = withUnsafeMutablePointer(to: &dataTypeRef) { SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer($0)) }
        if status == errSecSuccess {
            return (dataTypeRef as! NSData) as Data // swiftlint:disable:this force_cast
        }

        // No pre-existing key from this application, so generate a new one
        var keyData = Data(count: 64)
        let result = keyData.withUnsafeMutableBytes { mutableBytes in SecRandomCopyBytes(kSecRandomDefault, keyData.count, mutableBytes)}
        
        assert(result == 0, "Failed to get random bytes")
        
        // Store the key in the keychain
        query = [
            kSecClass: kSecClassKey,
            kSecAttrApplicationTag: keychainIdentifierData as AnyObject,
            kSecAttrKeySizeInBits: 512 as AnyObject,
            kSecValueData: keyData as AnyObject
        ]
        
        status = SecItemAdd(query as CFDictionary, nil)
        assert(status == errSecSuccess, "Failed to insert the new key in the keychain")
        return keyData
    }
}
