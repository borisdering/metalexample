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
    for i in 0...(lenght - 1) {
        pointer.advanced(by: i * MemoryLayout<Float>.stride).storeBytes(of: Float(i), as: Float.self)
    }
}

/// Verifies the buffers.
/// - Parameters:
///   - aBuffer: first buffer
///   - bBuffer: second buffer
///   - resultBuffer: result buffer
func verify(aBuffer: MTLBuffer, bBuffer: MTLBuffer, resultBuffer: MTLBuffer) {
    let aContents = aBuffer.contents()
    let bContents = bBuffer.contents()
    let rContents = resultBuffer.contents()
    
    let stride = MemoryLayout<Float>.stride
    
    for i in 0...(resultBuffer.length - 1) {
        
        let aValue = aContents.advanced(by: stride * i).load(as: Float.self)
        let bValue = bContents.advanced(by: stride * i).load(as: Float.self)
        let rValue = rContents.advanced(by: stride * i).load(as: Float.self)
        assert((aValue + bValue) == rValue, "elements at position \(i) do not match")
    }
}
