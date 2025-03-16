import UIKit
import SceneKit

// MARK: - UIColor Extensions
extension UIColor {
    static func random() -> UIColor {
        return UIColor(
            red: .random(in: 0...1),
            green: .random(in: 0...1),
            blue: .random(in: 0...1),
            alpha: 1.0
        )
    }
}

// MARK: - SCNGeometrySource Extensions
extension SCNGeometrySource {
    convenience init(vertices: [SCNVector3]) {
        let data = Data(bytes: vertices, count: vertices.count * MemoryLayout<SCNVector3>.size)
        self.init(data: data,
                semantic: .vertex,
                vectorCount: vertices.count,
                usesFloatComponents: true,
                componentsPerVector: 3,
                bytesPerComponent: MemoryLayout<Float>.size,
                dataOffset: 0,
                dataStride: MemoryLayout<SCNVector3>.size)
    }
}

// MARK: - UIView Extensions
extension UIView {
    func addShadow(opacity: Float = 0.5, radius: CGFloat = 5, offset: CGSize = CGSize(width: 0, height: 2)) {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offset
        layer.shadowRadius = radius
        layer.masksToBounds = false
    }
}

// MARK: - Date Extensions
extension Date {
    func formattedString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss dd/MM/yyyy"
        return formatter.string(from: self)
    }
}

