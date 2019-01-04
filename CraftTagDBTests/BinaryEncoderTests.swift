//
//  BinaryEncoderTests.swift
//  CraftTagDBTests
//
//  Created by Silas Schwarz on 12/9/18.
//  Copyright 2018 Silas Schwarz
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import XCTest
@testable import CraftTagDB

class BinaryEncoderTests: XCTestCase {
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
		let encoder = BinaryEncoder()
		encoder.encode(Int8(0x12))
		encoder.encode(Int16(0x1234).bigEndian)
		for i in 0 ..< 200 {
			encoder.encode(UInt8(i))
		}
		try! encoder.data.write(to: FileManager.default.homeDirectoryForCurrentUser.appendingPathComponent("Desktop/BinaryEncoderTest.dat"))
    }
	
	func testEncodeTagID() {
		let encoder = BinaryEncoder()
		for tagID in TagID.allCases {
			encoder.encode(tagID)
		}
		try! encoder.data.write(to: FileManager.default.homeDirectoryForCurrentUser.appendingPathComponent("Desktop/EncodedTagIDs.dat"))
	}
}
