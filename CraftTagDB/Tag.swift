//
//  Tag.swift
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

public enum TagID: UInt8, Codable, CaseIterable {
	case End		= 0
	case Byte		= 1
	case Short		= 2
	case Int		= 3
	case Long		= 4
	case Float		= 5
	case Double		= 6
	case ByteArray	= 7
	case String		= 8
	case List		= 9
	case Compound	= 10
	case IntArray	= 11
	case LongArray	= 12
	
	public var idType: Tag.Type {
		switch self {
		case .End: fatalError()
		case .Byte: return TagByte.self
		case .Short: return TagShort.self
		case .Int: return TagInt.self
		case .Long: return TagLong.self
		case .Float: return TagFloat.self
		case .Double: return TagDouble.self
		case .ByteArray: return TagByteArray.self
		case .String: return TagString.self
		case .List: return TagList.self
		case .Compound: return TagCompound.self
		case .IntArray: return TagIntArray.self
		case .LongArray: return TagLongArray.self
		}
	}
}

public protocol Tag: Codable {
	static var typeID: TagID { get }
	var id: TagID { get }
	func encode<K>(to container: inout KeyedEncodingContainer<K>, for key: KeyedEncodingContainer<K>.Key) throws
	func encode(to container: inout UnkeyedEncodingContainer) throws
	static func decode<K>(from container: KeyedDecodingContainer<K>, for key: KeyedEncodingContainer<K>.Key) throws -> Tag
	static func decode(from container: inout UnkeyedDecodingContainer) throws -> Tag
}

public extension Tag {
	var id: TagID { return type(of: self).typeID }
	
	func encode<K>(to container: inout KeyedEncodingContainer<K>, for key: KeyedEncodingContainer<K>.Key) throws {
		try container.encode(self, forKey: key)
	}
	
	func encode(to container: inout UnkeyedEncodingContainer) throws {
		try container.encode(self)
	}
	
	static func decode<K>(from container: KeyedDecodingContainer<K>, for key: KeyedEncodingContainer<K>.Key) throws -> Tag {
		return try container.decode(self, forKey: key)
	}
	
	static func decode(from container: inout UnkeyedDecodingContainer) throws -> Tag {
		return try container.decode(self)
	}
}

public enum TagCodingError: Error {
	case UnexpectedEndTag
}
