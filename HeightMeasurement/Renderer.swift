import Foundation
import Metal
import MetalKit
import ARKit

class Renderer {
    private let device: MTLDevice
    private let commandQueue: MTLCommandQueue
    private var renderPipelineState: MTLRenderPipelineState!
    
    init(metalDevice: MTLDevice, renderDestination: MTKView) {
        self.device = metalDevice
        self.commandQueue = device.makeCommandQueue()!
        
        renderDestination.depthStencilPixelFormat = .depth32Float_stencil8
        renderDestination.colorPixelFormat = .bgra8Unorm
        renderDestination.sampleCount = 1
        
        setupPipeline(renderDestination: renderDestination)
    }
    
    private func setupPipeline(renderDestination: MTKView) {
        let library = device.makeDefaultLibrary()!
        let vertexFunction = library.makeFunction(name: "vertexShader")
        let fragmentFunction = library.makeFunction(name: "fragmentShader")
        
        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        pipelineDescriptor.vertexFunction = vertexFunction
        pipelineDescriptor.fragmentFunction = fragmentFunction
        pipelineDescriptor.colorAttachments[0].pixelFormat = renderDestination.colorPixelFormat
        pipelineDescriptor.depthAttachmentPixelFormat = renderDestination.depthStencilPixelFormat
        pipelineDescriptor.stencilAttachmentPixelFormat = renderDestination.depthStencilPixelFormat
        
        do {
            renderPipelineState = try device.makeRenderPipelineState(descriptor: pipelineDescriptor)
        } catch {
            print("Không thể tạo pipeline state: \(error)")
        }
    }
    
    func update(_ frame: ARFrame) {
        // Cập nhật dữ liệu từ ARFrame
    }
    
    func draw(in view: MTKView) {
        guard let drawable = view.currentDrawable,
              let renderPassDescriptor = view.currentRenderPassDescriptor else {
            return
        }
        
        let commandBuffer = commandQueue.makeCommandBuffer()!
        let renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor)!
        
        renderEncoder.setRenderPipelineState(renderPipelineState)
        
        // Vẽ các đối tượng
        
        renderEncoder.endEncoding()
        commandBuffer.present(drawable)
        commandBuffer.commit()
    }
}

