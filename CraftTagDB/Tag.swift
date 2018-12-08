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
	
	var description: String {
		return "TAG_\(self)"
	}
}

protocol Tag: Codable {
	var id: TagID { get }
}
