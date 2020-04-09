//
//  ComputeFunction.metal
//  MetalExample
//
//  Created by Boris Dering on 09.04.20.
//  Copyright © 2020 Boris Dering. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

kernel void add_arrays(device const float* a,
                       device const float* b,
                       device float* r,
                       uint index [[thread_position_in_grid]])
{
    // using thread position as index to accelarate gpu
    r[index] = a[index] + b[index];
}

