//
//  helper.swift
//  MetalExample
//
//  Created by Boris Dering on 09.04.20.
//  Copyright © 2020 Boris Dering. All rights reserved.
//

import Foundation
import Metal

/// Populates a given buffer with the enumuraeted lenght values.
/// - Parameters:
///   - buffer: buffer to fill
///   - lenght: lenght of the buffer
func populate(buffer: MTLBuffer, lenght: Int) {
    
    let pointer = buffer.contents()
    pointer.initializeMemory(as: Float.self, repeating: Float(0), count: lenght)
    
    // fill the buffer arrays
    for i in 0...lenght {
        pointer.advanced(by: i * MemoryLayout<Float>.stride).storeBytes(of: Float(i), as: Float.self)
    }
}
