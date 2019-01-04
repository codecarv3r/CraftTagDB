//
//  BinaryEncoder.swift
//  CraftTagDB
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

import Foundation

public class BinaryEncoder {
	struct Default {
		static var startingSpace = 128
	}
	var available = Default.startingSpace
	var index = 0
	var binary = UnsafeMutableRawBufferPointer.allocate(byteCount: Default.startingSpace, alignment: MemoryLayout<Int8>.alignment)
	
	func ensureSpace<T>(type: T.Type) {
		if index + MemoryLayout<T>.size > available {
			repeat {
				available <<= 1
			} while index + MemoryLayout<T>.size > available
			let newBinary = UnsafeMutableRawBufferPointer.allocate(byteCount: available, alignment: MemoryLayout<Int8>.alignment)
			newBinary.copyMemory(from: UnsafeRawBufferPointer(binary))
			binary.deallocate()
			binary = newBinary
		}
	}
	
	public func encode<T>(_ item: T) {
		withUnsafeBytes(of: item) { (buffer: UnsafeRawBufferPointer) in
			ensureSpace(type: T.self)
			UnsafeMutableRawBufferPointer(rebasing: binary.suffix(from: index)).copyMemory(from: buffer)
		}
		index += MemoryLayout<T>.size
	}
	
	public var data: Data {
		return Data(bytes: binary.baseAddress!, count: index)
	}
	
	deinit {
		binary.deallocate()
	}
}
