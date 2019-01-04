//
//  TagByteArray.swift
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

public final class TagByteArray: Tag {
	public static var typeID: TagID { return .ByteArray }
	public var payload: [Int8]
	public var description: String { return "\(payload)" }
	
	public init(payload: [Int8]) {
		self.payload = payload
	}
	
	public func encodePayload(encoder: BinaryEncoder) throws {
		encoder.encode(Int32(payload.count))
		encoder.encode(payload)
	}
	
	public static func decodePayload(decoder: BinaryDecoder) throws -> Self {
		let count = try decoder.decode(Int32.self)
		var payload = [Int8]()
		for _ in 0 ..< count {
			payload.append(try decoder.decode())
		}
		return self.init(payload: payload)
	}
}
