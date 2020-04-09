//
//  main.swift
//  MetalExample
//
//  Created by Boris Dering on 09.04.20.
//  Copyright © 2020 Boris Dering. All rights reserved.
//

import Foundation
import Metal

let arrayLength = 100

// try to create system default device
guard let device = MTLCreateSystemDefaultDevice() else { fatalError("unable to create system default device") }

guard let library = device.makeDefaultLibrary() else { fatalError("unable to get default library") }
guard let computeFunction = library.makeFunction(name: "add_arrays") else { fatalError("unable to create add_array function") }

// create a pipeline...
let pipeline = try! device.makeComputePipelineState(function: computeFunction)

// so a command queue...
guard let commandQueue = device.makeCommandQueue() else { fatalError("unable to create command queue") }
guard let commandBuffer = commandQueue.makeCommandBuffer() else { fatalError("unable to create command buffer") }
guard let computeEncoder = commandBuffer.makeComputeCommandEncoder() else { fatalError("unable to create compute encoder") }

// create buffer to work with
// the size of the buffer is float 64 * stride of float
// and the resource option is storage mode shared to be
// able to use this memory in the GPU
let aBuffer = device.makeBuffer(length: arrayLength * MemoryLayout<Float>.stride, options: MTLResourceOptions.storageModeShared)!
let bBuffer = device.makeBuffer(length: arrayLength * MemoryLayout<Float>.stride, options: MTLResourceOptions.storageModeShared)!
let resultBuffer = device.makeBuffer(length: arrayLength * MemoryLayout<Float>.stride, options: MTLResourceOptions.storageModeShared)!

// fill buffer with test values
populate(buffer: aBuffer, lenght: arrayLength)
populate(buffer: bBuffer, lenght: arrayLength)

computeEncoder.setComputePipelineState(pipeline)
computeEncoder.setBuffer(aBuffer, offset: 0, index: 0)
computeEncoder.setBuffer(bBuffer, offset: 0, index: 1)
computeEncoder.setBuffer(resultBuffer, offset: 0, index: 2)

// specify Thread Count and Organization
let gridSize = MTLSize(width: arrayLength, height: 1, depth: 1)

// make sure that the sizes are aligned
var threadGroupSize = pipeline.maxTotalThreadsPerThreadgroup
if (threadGroupSize > arrayLength) {
    threadGroupSize = arrayLength
}
let threadsPerThreadgroup  = MTLSize(width: threadGroupSize, height: 1, depth: 1)

// encode the Compute Command to Execute the Threads
computeEncoder.dispatchThreads(gridSize, threadsPerThreadgroup: threadsPerThreadgroup)

// end the Compute Pass
computeEncoder.endEncoding()

// Commit the Command Buffer to Execute Its Commands
commandBuffer.commit()

// Wait for the Calculation to Complete
commandBuffer.waitUntilCompleted()

// verify results 
verify(aBuffer: aBuffer, bBuffer: bBuffer, resultBuffer: resultBuffer)
