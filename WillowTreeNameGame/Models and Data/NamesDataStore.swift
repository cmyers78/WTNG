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
    
    func saveNamesData(withName namesDataArray : [NamesDataModel]) {
        let configuration = Realm.Configuration(encryptionKey: getKey())
        let realm = try! Realm(configuration: configuration)
        if !realm.isEmpty {
            deleteNames()
        }
        try! realm.write {
            realm.add(namesDataArray)
        }
    }
    
    func getNamesData(forGame : GameType ) -> [NamesDataModel] {
        let configuration = Realm.Configuration(encryptionKey: getKey())
        let decryptNames = try! Realm(configuration: configuration)
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
    
    // Inefficient to do this but....
    // Would rather know if there has been a change in the json to
    // know if I should download again and add new users
    //
    func deleteNames() {
        let configuration = Realm.Configuration(encryptionKey: getKey())
        let realm = try! Realm(configuration: configuration)
        try! realm.write {
            realm.deleteAll()
        }
    }
    
    // From Realm.io encryption documents
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
            return (dataTypeRef as! NSData) as Data
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
