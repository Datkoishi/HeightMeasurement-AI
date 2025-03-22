import UIKit
import ARKit
import SceneKit
import Photos

class ViewController: UIViewController, ARSCNViewDelegate {
    
    // MARK: - Properties
    private let sceneView = ARSCNView()
    private var measurements: [MeasurementRecord] = []
    private var measurementNode: SCNNode?
    private var bodyNode: SCNNode?
    
    private var calibrationHeight: CGFloat = 1.7 // Chiều cao mặc định 1.7m
    private var selectedUnit = MeasurementUnit.meters
    private var isDarkMode = false
    
    // MARK: - UI Elements
    private let measurementLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.layer.cornerRadius = 10
        label.clipsToBounds = true
        label.isHidden = true
        return label
    }()
    
    private let instructionLabel: UILabel = {
        let label = UILabel()
        label.text = "Di chuyển camera để quét môi trường"
        label.textColor = .white
        label.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.layer.cornerRadius = 10
        label.clipsToBounds = true
        return label
    }()
    
    private lazy var resetButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Đặt lại", for: .normal)
        button.setImage(UIImage(systemName: "arrow.counterclockwise"), for: .normal)
        button.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        button.tintColor = .white
        button.layer.cornerRadius = 10
        return button
    }()
    
    private lazy var unitButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Đơn vị: m", for: .normal)
        button.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        button.tintColor = .white
        button.layer.cornerRadius = 10
        return button
    }()
    
    private lazy var calibrateButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Hiệu chỉnh", for: .normal)
        button.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        button.tintColor = .white
        button.layer.cornerRadius = 10
        return button
    }()
    
    private lazy var darkModeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "moon"), for: .normal)
        button.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        button.tintColor = .white
        button.layer.cornerRadius = 10
        return button
    }()
    
    private lazy var screenshotButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "camera"), for: .normal)
        button.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        button.tintColor = .white
        button.layer.cornerRadius = 10
        return button
    }()
    
    private let calibrationView = CalibrationView()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAR()
        setupUI()
        setupActions()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if ARBodyTrackingConfiguration.isSupported {
            let configuration = ARBodyTrackingConfiguration()
            sceneView.session.run(configuration)
        } else {
            instructionLabel.text = "Thiết bị không hỗ trợ Body Tracking"
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
    
    // MARK: - Setup
    private func setupAR() {
        sceneView.delegate = self
        sceneView.scene = SCNScene()
        sceneView.showsStatistics = false
        view.addSubview(sceneView)
        sceneView.frame = view.bounds
    }
    
    private func setupUI() {
        // Thêm các UI elements
        view.addSubview(instructionLabel)
        view.addSubview(measurementLabel)
        view.addSubview(resetButton)
        view.addSubview(unitButton)
        view.addSubview(calibrateButton)
        view.addSubview(darkModeButton)
        view.addSubview(screenshotButton)
        
        // Thiết lập constraints
        instructionLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            instructionLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            instructionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            instructionLabel.widthAnchor.constraint(lessThanOrEqualTo: view.widthAnchor, constant: -40),
            instructionLabel.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        measurementLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            measurementLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            measurementLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100),
            measurementLabel.widthAnchor.constraint(equalToConstant: 200),
            measurementLabel.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        // Thiết lập button stack
        let buttonStack = UIStackView(arrangedSubviews: [resetButton, unitButton, calibrateButton, darkModeButton, screenshotButton])
        buttonStack.axis = .horizontal
        buttonStack.distribution = .fillEqually
        buttonStack.spacing = 10
        
        view.addSubview(buttonStack)
        buttonStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            buttonStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            buttonStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            buttonStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            buttonStack.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        // Thiết lập calibration view
        calibrationView.isHidden = true
        view.addSubview(calibrationView)
        calibrationView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            calibrationView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            calibrationView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            calibrationView.widthAnchor.constraint(equalToConstant: 300),
            calibrationView.heightAnchor.constraint(equalToConstant: 200)
        ])
        
        calibrationView.onDone = { [weak self] height in
            self?.calibrationHeight = height
            self?.calibrationView.isHidden = true
        }
    }
    
    private func setupActions() {
        resetButton.addTarget(self, action: #selector(resetMeasurement), for: .touchUpInside)
        unitButton.addTarget(self, action: #selector(changeUnit), for: .touchUpInside)
        calibrateButton.addTarget(self, action: #selector(showCalibration), for: .touchUpInside)
        darkModeButton.addTarget(self, action: #selector(toggleDarkMode), for: .touchUpInside)
        screenshotButton.addTarget(self, action: #selector(takeScreenshot), for: .touchUpInside)
    }
    
    // MARK: - ARSCNViewDelegate
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let bodyAnchor = anchor as? ARBodyAnchor else { return }
        
        DispatchQueue.main.async {
            self.instructionLabel.text = "Người được phát hiện"
            self.measureHeight(bodyAnchor: bodyAnchor, node: node)
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let bodyAnchor = anchor as? ARBodyAnchor else { return }
        measureHeight(bodyAnchor: bodyAnchor, node: node)
    }
    
    // MARK: - Height Measurement
    private func measureHeight(bodyAnchor: ARBodyAnchor, node: SCNNode) {
        // Lấy skeleton
        let skeleton = bodyAnchor.skeleton
        
        // Lấy vị trí đầu và chân
        var headPosition: simd_float4x4?
        var footPosition: simd_float4x4?
        
        // Sử dụng các khớp có sẵn dựa trên khả năng của thiết bị
        if skeleton.definition.jointNames.contains("head") {
            let headJoint = ARSkeleton.JointName("head")
            headPosition = skeleton.modelTransform(for: headJoint)
        }
        
        if skeleton.definition.jointNames.contains("rightFoot") {
            let footJoint = ARSkeleton.JointName("rightFoot")
            footPosition = skeleton.modelTransform(for: footJoint)
        } else if skeleton.definition.jointNames.contains("rightAnkle") {
            let ankleJoint = ARSkeleton.JointName("rightAnkle")
            footPosition = skeleton.modelTransform(for: ankleJoint)
        }
        
        // Đảm bảo có cả hai vị trí
        guard let headTransform = headPosition, let footTransform = footPosition else {
            return
        }
        
        let headY = CGFloat(headTransform.columns.3.y)
        let footY = CGFloat(footTransform.columns.3.y)
        
        // Tính chiều cao với hệ số hiệu chỉnh
        let rawHeightInMeters = abs(headY - footY) * CGFloat(bodyAnchor.estimatedScaleFactor)
        
        // Áp dụng hiệu chỉnh
        let calibrationFactor = calibrationHeight / 1.7 // 1.7m là chiều cao tham chiếu
        let heightInMeters = rawHeightInMeters * calibrationFactor
        
        // Chuyển đổi sang đơn vị đã chọn
        let convertedHeight = convertHeight(heightInMeters, to: selectedUnit)
        
        DispatchQueue.main.async {
            self.measurementLabel.isHidden = false
            self.measurementLabel.text = String(format: "%.2f %@", convertedHeight, self.selectedUnit.symbol)
            
            // Tạo hình ảnh trực quan
            self.createBodyVisualization(bodyAnchor: bodyAnchor, node: node)
        }
        
        // Vẽ đường đo
        let startPoint = SCNVector3(x: Float(headTransform.columns.3.x),
                                  y: Float(headTransform.columns.3.y),
                                  z: Float(headTransform.columns.3.z))
        
        let endPoint = SCNVector3(x: Float(footTransform.columns.3.x),
                                y: Float(footTransform.columns.3.y),
                                z: Float(footTransform.columns.3.z))
        
        updateMeasurementVisualization(from: startPoint, to: endPoint, on: node)
    }
    
    private func createBodyVisualization(bodyAnchor: ARBodyAnchor, node: SCNNode) {
        // Xóa hình ảnh trực quan cũ
        bodyNode?.removeFromParentNode()
        
        // Tạo node mới cho hình ảnh trực quan
        bodyNode = SCNNode()
        
        // Lấy skeleton
        let skeleton = bodyAnchor.skeleton
        let jointNames = skeleton.definition.jointNames
        
        // Vẽ các điểm khớp cho các khớp có sẵn
        for jointNameStr in jointNames {
            let jointName = ARSkeleton.JointName(jointNameStr)
            if let transform = skeleton.modelTransform(for: jointName) {
                let position = SCNVector3(
                    x: Float(transform.columns.3.x),
                    y: Float(transform.columns.3.y),
                    z: Float(transform.columns.3.z)
                )
                
                let jointNode = createJointNode(at: position)
                bodyNode?.addChildNode(jointNode)
            }
        }
        
        // Định nghĩa các cặp kết nối
        let possibleConnections: [(String, String)] = [
            ("head", "neck"),
            ("neck", "root"),
            ("root", "rightUpLeg"),
            ("rightUpLeg", "rightLeg"),
            ("rightLeg", "rightFoot"),
            ("root", "leftUpLeg"),
            ("leftUpLeg", "leftLeg"),
            ("leftLeg", "leftFoot")
        ]
        
        // Vẽ các kết nối
        for (startJointStr, endJointStr) in possibleConnections {
            if jointNames.contains(startJointStr) && jointNames.contains(endJointStr) {
                let startJoint = ARSkeleton.JointName(startJointStr)
                let endJoint = ARSkeleton.JointName(endJointStr)
                
                if let startTransform = skeleton.modelTransform(for: startJoint),
                   let endTransform = skeleton.modelTransform(for: endJoint) {
                    
                    let startPoint = SCNVector3(
                        x: Float(startTransform.columns.3.x),
                        y: Float(startTransform.columns.3.y),
                        z: Float(startTransform.columns.3.z)
                    )
                    
                    let endPoint = SCNVector3(
                        x: Float(endTransform.columns.3.x),
                        y: Float(endTransform.columns.3.y),
                        z: Float(endTransform.columns.3.z)
                    )
                    
                    let connectionNode = createConnectionNode(from: startPoint, to: endPoint)
                    bodyNode?.addChildNode(connectionNode)
                }
            }
        }
        
        node.addChildNode(bodyNode!)
    }
    
    private func createJointNode(at position: SCNVector3) -> SCNNode {
        let sphere = SCNSphere(radius: 0.01)
        sphere.firstMaterial?.diffuse.contents = UIColor.systemGreen
        let node = SCNNode(geometry: sphere)
        node.position = position
        return node
    }
    
    private func createConnectionNode(from start: SCNVector3, to end: SCNVector3) -> SCNNode {
        let node = SCNNode()
        
        // Tạo geometry đường thẳng
        let indices: [Int32] = [0, 1]
        let source = SCNGeometrySource(vertices: [start, end])
        let element = SCNGeometryElement(indices: indices, primitiveType: .line)
        
        let geometry = SCNGeometry(sources: [source], elements: [element])
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.systemBlue
        material.isDoubleSided = true
        geometry.materials = [material]
        
        return SCNNode(geometry: geometry)
    }
    
    private func updateMeasurementVisualization(from start: SCNVector3, to end: SCNVector3, on node: SCNNode) {
        measurementNode?.removeFromParentNode()
        
        let indices: [Int32] = [0, 1]
        let source = SCNGeometrySource(vertices: [start, end])
        let element = SCNGeometryElement(indices: indices, primitiveType: .line)
        
        let geometry = SCNGeometry(sources: [source], elements: [element])
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.systemRed
        material.isDoubleSided = true
        geometry.materials = [material]
        
        measurementNode = SCNNode(geometry: geometry)
        node.addChildNode(measurementNode!)
    }
    
    // MARK: - Unit Conversion
    private func convertHeight(_ heightInMeters: CGFloat, to unit: MeasurementUnit) -> CGFloat {
        switch unit {
        case .meters:
            return heightInMeters
        case .centimeters:
            return heightInMeters * 100
        case .feet:
            return heightInMeters * 3.28084
        case .inches:
            return heightInMeters * 39.3701
        }
    }
    
    // MARK: - Actions
    @objc private func resetMeasurement() {
        measurementNode?.removeFromParentNode()
        bodyNode?.removeFromParentNode()
        
        measurementNode = nil
        bodyNode = nil
        
        measurementLabel.isHidden = true
        instructionLabel.text = "Di chuyển camera để quét môi trường"
    }
    
    @objc private func changeUnit() {
        // Chuyển đổi giữa các đơn vị
        switch selectedUnit {
        case .meters:
            selectedUnit = .centimeters
        case .centimeters:
            selectedUnit = .feet
        case .feet:
            selectedUnit = .inches
        case .inches:
            selectedUnit = .meters
        }
        
        unitButton.setTitle("Đơn vị: \(selectedUnit.symbol)", for: .normal)
    }
    
    @objc private func showCalibration() {
        calibrationView.setHeight(calibrationHeight)
        calibrationView.isHidden = false
    }
    
    @objc private func toggleDarkMode() {
        isDarkMode = !isDarkMode
        
        if isDarkMode {
            darkModeButton.setImage(UIImage(systemName: "sun.max"), for: .normal)
            overrideUserInterfaceStyle = .dark
            view.window?.overrideUserInterfaceStyle = .dark
        } else {
            darkModeButton.setImage(UIImage(systemName: "moon"), for: .normal)
            overrideUserInterfaceStyle = .light
            view.window?.overrideUserInterfaceStyle = .light
        }
    }
    
    @objc private func takeScreenshot() {
        // Tạo ảnh chụp màn hình
        let renderer = UIGraphicsImageRenderer(size: view.bounds.size)
        let screenshot = renderer.image { _ in
            view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        }
        
        // Lưu ảnh vào thư viện ảnh
        UIImageWriteToSavedPhotosAlbum(screenshot, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @objc private func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            showToast(message: "Lỗi: \(error.localizedDescription)")
        } else {
            showToast(message: "Ảnh chụp màn hình đã được lưu vào thư viện ảnh")
        }
    }
    
    private func showToast(message: String) {
        let toastLabel = UILabel()
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        toastLabel.textColor = .white
        toastLabel.textAlignment = .center
        toastLabel.font = UIFont.systemFont(ofSize: 14)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10
        toastLabel.clipsToBounds = true
        
        view.addSubview(toastLabel)
        toastLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            toastLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -100),
            toastLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            toastLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 300),
            toastLabel.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        UIView.animate(withDuration: 2.0, delay: 0.5, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: { _ in
            toastLabel.removeFromSuperview()
        })
    }
}

// MARK: - Models
enum MeasurementUnit {
    case meters, centimeters, feet, inches
    
    var name: String {
        switch self {
        case .meters: return "Mét (m)"
        case .centimeters: return "Centimét (cm)"
        case .feet: return "Feet (ft)"
        case .inches: return "Inch (in)"
        }
    }
    
    var symbol: String {
        switch self {
        case .meters: return "m"
        case .centimeters: return "cm"
        case .feet: return "ft"
        case .inches: return "in"
        }
    }
}

