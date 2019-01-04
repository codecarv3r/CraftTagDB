//
//  TagList.swift
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

public final class TagList: Tag {
	public static var typeID: TagID { return .List }
	public var listID: TagID
	public var payload: [Tag]
	public var description: String { return "\(payload)" }
	
	public init(listID: TagID, payload: [Tag]) {
		self.listID = listID
		self.payload = payload
	}
	
	enum TagListCodingKeys: CodingKey {
		case ListID
		case List
	}
	
	required public init(from decoder: Decoder) throws {
		self.payload = [Tag]()
		let container = try decoder.container(keyedBy: TagListCodingKeys.self)
		listID = try container.decode(TagID.self, forKey: .ListID)
		var entriesContainer = try container.nestedUnkeyedContainer(forKey: .List)
		while !entriesContainer.isAtEnd {
			let next = try listID.idType.decode(from: &entriesContainer)
			payload.append(next)
		}
	}
	
	public func encode(to encoder: Encoder) throws {
		var listContainer = encoder.container(keyedBy: TagListCodingKeys.self)
		try listContainer.encode(listID, forKey: .ListID)
		var container = listContainer.nestedUnkeyedContainer(forKey: .List)
		for tag in payload {
			try tag.encode(to: &container)
		}
	}
	
	public func encodePayload(encoder: BinaryEncoder) throws {
		encoder.encode(listID)
		encoder.encode(Int32(payload.count))
		for tag in payload {
			try tag.encodePayload(encoder: encoder)
		}
	}
	
	public static func decodePayload(decoder: BinaryDecoder) throws -> Self {
		if let listID = TagID(rawValue: try decoder.decode(UInt8.self)) {
			let count = try decoder.decode(Int32.self)
			var payload = [Tag]()
			for _ in 0 ..< count {
				payload.append(try listID.idType.decodePayload(decoder: decoder))
			}
			return self.init(listID: listID, payload: payload)
		} else {
			throw TagCodingError.UnknownTagID
		}
	}
}
