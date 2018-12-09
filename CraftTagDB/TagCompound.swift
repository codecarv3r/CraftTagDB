//
//  TagCompound.swift
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

public class TagCompound: Tag {
	public static var typeID: TagID { return .Compound }
	public var payload: [String : Tag]
	
	public init(payload: [String : Tag]) {
		self.payload = payload
	}
	
	enum TagCompoundEntryKey: CodingKey {
		case TagID
		case Name
		case Payload
	}
	
	required public init(from decoder: Decoder) throws {
		self.payload = [String : Tag]()
		var container = try decoder.unkeyedContainer()
		for _ in 0 ..< container.count! {
			let entryContainer = try container.nestedContainer(keyedBy: TagCompoundEntryKey.self)
			let tagID = try entryContainer.decode(TagID.self, forKey: .TagID)
			if tagID != .End {
				let name = try entryContainer.decode(String.self, forKey: .Name)
				let payload = try tagID.idType.decode(from: entryContainer, for: .Payload)
				self.payload[name] = payload
			}
		}
	}
	
	public func encode(to encoder: Encoder) throws {
		var container = encoder.unkeyedContainer()
		for key in payload.keys {
			let value = payload[key]!
			var entryContainer = container.nestedContainer(keyedBy: TagCompoundEntryKey.self)
			try entryContainer.encode(value.id, forKey: .TagID)
			try entryContainer.encode(key, forKey: .Name)
			try value.encode(to: &entryContainer, for: .Payload)
		}
		var entryContainer = container.nestedContainer(keyedBy: TagCompoundEntryKey.self)
		try entryContainer.encode(TagID.End, forKey: .TagID)
	}
}
