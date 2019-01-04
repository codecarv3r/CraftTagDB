//
//  CraftTagDBTests.swift
//  CraftTagDBTests
//
//  Created by Silas Schwarz on 12/8/18.
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

class CraftTagDBTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
//		let list: Tag = TagList<TagString>(payload: [TagString(payload: "Hi there")])
//		let mirror = Mirror(reflecting: list)
//		print(mirror.subjectType)
//		print("Is it \(TagList<TagString>.self): \(mirror.subjectType == TagList<TagString>.self)")
//		for child in mirror.children {
//			print("\(child.label): \(child.value)")
//		}
		
		let nestedList1 = TagList(listID: .Int, payload: [TagInt(payload: 1), TagInt(payload: 2), TagInt(payload: 3)])
		let nestedList2 = TagList(listID: .String, payload: [TagString(payload: "1"), TagString(payload: "2"), TagString(payload: "3")])
		var array = [Tag]()
		array.append(nestedList1)
		array.append(nestedList2)
		let list = TagList(listID: .List, payload: array)
		let encoder = JSONEncoder()
		let data = try! encoder.encode(list)
		print(String(data: data, encoding: .utf8)!)
		let decoder = JSONDecoder()
		let remade = try! decoder.decode(TagList.self, from: data)
		print(remade)
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

	func testLevelDAT() {
		let data = try! Data(contentsOf: FileManager.default.homeDirectoryForCurrentUser.appendingPathComponent("Desktop/level.dat"))
		var decoder = BinaryDecoder(data: data)
		let firstInt = try! decoder.decode(Int32.self)
		let secondInt = try! decoder.decode(Int32.self)
		let dbTagID = try! decoder.decode(TagID.self)
		let dbNameLength = try! decoder.decode(Int16.self)
		XCTAssert(dbNameLength == 0)
		var compoundTag = try! TagCompound.decodePayload(decoder: decoder)
		let jsonEncoder = JSONEncoder()
		let jsonData = try! jsonEncoder.encode(compoundTag)
		try! jsonData.write(to: FileManager.default.homeDirectoryForCurrentUser.appendingPathComponent("Desktop/level.json"))
		XCTAssert(decoder.total == decoder.index)
		var encoder = NBTEncoder()
		let recreatedData = try! encoder.encode(tag: compoundTag)
		try! recreatedData.write(to: FileManager.default.homeDirectoryForCurrentUser.appendingPathComponent("Desktop/level2.dat"))
		decoder = BinaryDecoder(data: recreatedData)
		compoundTag = try! TagCompound.decodePayload(decoder: decoder)
		encoder = NBTEncoder()
		let recreatedData2 = try! encoder.encode(tag: compoundTag)
		try! recreatedData.write(to: FileManager.default.homeDirectoryForCurrentUser.appendingPathComponent("Desktop/level3.dat"))
	}
}
