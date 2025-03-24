Thought for 2 seconds### HeightMeasurement

## Giới thiệu | Introduction

| **Tiếng Việt**

HeightMeasurement là ứng dụng iOS sử dụng công nghệ AR (Augmented Reality) để đo chiều cao của người dùng một cách chính xác. Ứng dụng sử dụng camera của thiết bị để nhận diện cơ thể người và tính toán chiều cao dựa trên khoảng cách từ đầu đến chân.

 | **English**

HeightMeasurement is an iOS application that uses AR (Augmented Reality) technology to accurately measure a person's height. The app uses the device's camera to detect the human body and calculate height based on the distance from head to feet.




## Ảnh minh họa | Screenshots

*Hình ảnh ứng dụng sẽ được thêm vào sau khi triển khai*

*Screenshots will be added after deployment*

## Tính năng | Features

| **Tiếng Việt**

- Đo chiều cao người thời gian thực
- Hiển thị kết quả đo bằng nhiều đơn vị khác nhau (m, cm, feet, inches)
- Hiệu chỉnh kết quả đo dựa trên chiều cao thực tế của người dùng
- Hiển thị trực quan khung xương người
- Chế độ tối/sáng
- Chụp ảnh màn hình kết quả đo
- Giao diện người dùng đơn giản, dễ sử dụng


 | **English**

- Real-time human height measurement
- Display measurement results in multiple units (m, cm, feet, inches)
- Calibrate measurement results based on the user's actual height
- Visual display of human skeleton
- Dark/light mode
- Screenshot measurement results
- Simple, user-friendly interface





## Yêu cầu hệ thống | System Requirements

| **Tiếng Việt**

- iOS 16.0 trở lên
- iPhone XS/XR trở lên hoặc iPad Pro (2018) trở lên
- Thiết bị hỗ trợ ARKit và Body Tracking
- Xcode 14.0 trở lên (để build)


 | **English**

- iOS 16.0 or later
- iPhone XS/XR or later, or iPad Pro (2018) or later
- Device supporting ARKit and Body Tracking
- Xcode 14.0 or later (for building)





## Cài đặt | Installation

| **Tiếng Việt**

### Từ mã nguồn:

1. Clone repository:


```shellscript
git clone https://github.com/yourusername/HeightMeasurement.git
```

2. Mở file HeightMeasurement.xcodeproj bằng Xcode
3. Chọn thiết bị đích và nhấn Run


### Yêu cầu quyền:

Ứng dụng sẽ yêu cầu quyền truy cập:

- Camera (để sử dụng AR)
- Thư viện ảnh (để lưu ảnh chụp màn hình)


 | **English**

### From source code:

1. Clone the repository:


```shellscript
git clone https://github.com/yourusername/HeightMeasurement.git
```

2. Open HeightMeasurement.xcodeproj with Xcode
3. Select your target device and press Run


### Required permissions:

The app will request access to:

- Camera (for AR functionality)
- Photo Library (to save screenshots)





## Cách sử dụng | How to Use

| **Tiếng Việt**

1. Mở ứng dụng và cho phép truy cập camera
2. Di chuyển camera để quét môi trường xung quanh
3. Đứng cách thiết bị khoảng 2-3 mét để camera có thể nhìn thấy toàn bộ cơ thể
4. Ứng dụng sẽ tự động nhận diện và hiển thị chiều cao
5. Sử dụng nút "Hiệu chỉnh" để điều chỉnh kết quả đo nếu cần
6. Thay đổi đơn vị đo bằng nút "Đơn vị"
7. Chụp ảnh màn hình kết quả bằng nút camera


 | **English**

1. Open the app and allow camera access
2. Move the camera to scan the surrounding environment
3. Stand about 2-3 meters away from the device so the camera can see your entire body
4. The app will automatically detect and display your height
5. Use the "Calibrate" button to adjust the measurement if needed
6. Change the measurement unit with the "Unit" button
7. Take a screenshot of the result using the camera button





## Công nghệ sử dụng | Technologies Used

- Swift 5
- ARKit
- SceneKit
- Metal/MetalKit
- UIKit


## Kiến trúc | Architecture

| **Tiếng Việt**

Ứng dụng được xây dựng theo mô hình MVC (Model-View-Controller):

- **Model**: MeasurementRecord, MeasurementUnit, MeasurementManager
- **View**: CalibrationView, ARSCNView, các UI elements
- **Controller**: ViewController


Các thành phần chính:

- ARKit: Nhận diện cơ thể người và theo dõi chuyển động
- SceneKit: Hiển thị hình ảnh 3D của khung xương
- Metal: Xử lý đồ họa hiệu suất cao


 | **English**

The app is built using the MVC (Model-View-Controller) pattern:

- **Model**: MeasurementRecord, MeasurementUnit, MeasurementManager
- **View**: CalibrationView, ARSCNView, UI elements
- **Controller**: ViewController


Key components:

- ARKit: Human body detection and motion tracking
- SceneKit: 3D visualization of the skeleton
- Metal: High-performance graphics processing





## Đóng góp | Contributing

| **Tiếng Việt**

Đóng góp cho dự án luôn được chào đón. Để đóng góp:

1. Fork repository
2. Tạo branch mới (`git checkout -b feature/amazing-feature`)
3. Commit thay đổi của bạn (`git commit -m 'Add some amazing feature'`)
4. Push lên branch (`git push origin feature/amazing-feature`)
5. Mở Pull Request


 | **English**

Contributions are always welcome. To contribute:

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request








---

Developed with ❤️ using ARKit and Swift
