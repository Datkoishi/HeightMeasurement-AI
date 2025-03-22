//
//  ShaderTypes.h
//  HeightMeasurement
//
//  Created for HeightMeasurement app
//

#ifndef ShaderTypes_h
#define ShaderTypes_h

#include <simd/simd.h>

// Cấu trúc dữ liệu cho các shader
typedef struct {
    matrix_float4x4 modelMatrix;
    matrix_float4x4 viewMatrix;
    matrix_float4x4 projectionMatrix;
    matrix_float4x4 modelViewProjectionMatrix;
} Uniforms;

typedef struct {
    vector_float3 position;
    vector_float2 texCoord;
} Vertex;

#endif /* ShaderTypes_h */

