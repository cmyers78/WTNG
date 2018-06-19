//
//  WillowTreeNameGameTests.swift
//  WillowTreeNameGameTests
//
//  Created by Christopher Myers on 4/26/18.
//  Copyright © 2018 Dragoman Developers. All rights reserved.
//

import XCTest
@testable import WillowTreeNameGame

class WillowTreeNameGameTests: XCTestCase {
    var wtDataModel: NamesDataModel!
    var networkRequests: NetworkRequests!
    let jsonArray = """
[{
        "id": "4NCJTL13UkK0qEIAAcg4IQ",
        "type": "people",
        "slug": "joel-garrett",
        "jobTitle": "Senior Software Engineer",
        "firstName": "Joel",
        "lastName": "Garrett",
        "headshot": {
            "type": "image",
            "mimeType": "image/jpeg",
            "id": "4Mv2CONANym46UwuuCIgK",
            "url": "//images.ctfassets.net/3cttzl4i3k1h/4Mv2CONANym46UwuuCIgK/cbeb43c93a843a43c07b1de9954795e2/headshot_joel_garrett.jpg",
            "alt": "headshot joel garrett",
            "height": 340,
            "width": 340
        },
        "socialLinks": []
        }]
""".data(using: .utf8)
    
    override func setUp() {
        super.setUp()
        networkRequests = NetworkRequests()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testJSONSerialization() {
        let results = networkRequests.parseJSON(from: jsonArray)
        let count = results?.count
        XCTAssertNotNil(results)
        XCTAssertEqual(count, 1)
    }
}
