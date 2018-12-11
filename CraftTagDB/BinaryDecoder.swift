//
//  BinaryDecoder.swift
//  CraftTagDB
//
//  Created by Silas Schwarz on 12/11/18.
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

import Foundation

public class BinaryDecoder {
	var index = 0
	var total: Int
	public var available: Int { return total - index }
	var binary: UnsafeMutableRawBufferPointer
	
	public init(data: Data) {
		total = data.count
		binary = UnsafeMutableRawBufferPointer.allocate(byteCount: data.count, alignment: MemoryLayout<Int8>.alignment)
		data.withUnsafeBytes { (pointer: UnsafePointer<Int8>) in
			binary.copyMemory(from: UnsafeRawBufferPointer(start: UnsafeRawPointer(pointer), count: total))
		}
	}
	
	public func decode<T>(_ type: T.Type) -> T? {
		if MemoryLayout<T>.size > available {
			return nil
		}
		let positionPointer = UnsafeMutableRawBufferPointer(rebasing: binary.suffix(from: index))
		let basket = UnsafeMutablePointer<T>.allocate(capacity: 1)
		UnsafeMutableRawPointer(basket).copyMemory(from: UnsafeRawPointer(positionPointer.baseAddress!), byteCount: MemoryLayout<T>.size)
		let value = basket.pointee
		basket.deallocate()
		return value
	}
	
	deinit {
		binary.deallocate()
	}
}
