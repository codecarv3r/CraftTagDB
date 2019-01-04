//
//  TagString.swift
//  CraftTagDB
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

public final class TagString: Tag {
	public static var typeID: TagID { return .String }
	public var payload: String
	public var description: String { return "\"\(payload)\"" }
	
	public init(payload: String) {
		self.payload = payload
	}
	
	public func encodePayload(encoder: BinaryEncoder) throws {
		let array = payload.map { (character: Character) -> Int8 in
			return Int8(character.unicodeScalars.first!.utf16.first!)
		}
		encoder.encode(Int16(array.count))
		for character in array {
			encoder.encode(character)
		}
	}
	
	public static func decodePayload(decoder: BinaryDecoder) throws -> Self {
		let count = try decoder.decode(Int16.self)
		var payload = ""
		for _ in 0 ..< count {
			let character = try decoder.decode(UInt8.self)
			payload.append(Character(Unicode.Scalar(character)))
		}
		return self.init(payload: payload)
	}
}
