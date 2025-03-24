### Ứng Dụng Đo Chiều Cao

## Giới thiệu

Ứng dụng Đo Chiều Cao là một ứng dụng iOS sử dụng công nghệ ARKit và Body Tracking để đo chiều cao của người dùng một cách chính xác thông qua camera của thiết bị. Ứng dụng cung cấp giao diện trực quan, dễ sử dụng và nhiều tính năng hữu ích.

## Tính năng chính

- **Đo chiều cao chính xác**: Sử dụng ARKit và Body Tracking để nhận diện và đo chiều cao người dùng
- **Hiệu chỉnh kết quả**: Cho phép người dùng hiệu chỉnh kết quả đo dựa trên chiều cao thực tế
- **Đa dạng đơn vị đo**: Hỗ trợ nhiều đơn vị đo khác nhau (mét, centimét, feet, inch)
- **Trực quan hóa**: Hiển thị hình ảnh trực quan của skeleton người dùng
- **Lưu kết quả**: Lưu trữ lịch sử các kết quả đo
- **Chụp màn hình**: Cho phép chụp và lưu kết quả đo vào thư viện ảnh
- **Chế độ tối/sáng**: Hỗ trợ chuyển đổi giữa giao diện tối và sáng


## Yêu cầu hệ thống

- iOS 14.0 trở lên
- iPhone XS, XR, 11 trở lên hoặc iPad Pro với chip A12 Bionic trở lên (yêu cầu hỗ trợ ARKit 3 và Body Tracking)
- Xcode 12.0 trở lên (để build và chạy dự án)


## Cài đặt

1. Clone repository:


```shellscript
git clone https://github.com/yourusername/HeightMeasurement.git
```

2. Mở file HeightMeasurement.xcodeproj bằng Xcode
3. Chọn thiết bị đích (iPhone hoặc iPad hỗ trợ ARKit 3)
4. Build và chạy ứng dụng (⌘+R)


## Hướng dẫn sử dụng

1. Khi mở ứng dụng, cho phép ứng dụng truy cập camera
2. Di chuyển camera để quét môi trường xung quanh
3. Đứng cách thiết bị khoảng 2-3 mét để camera có thể nhìn thấy toàn thân
4. Khi ứng dụng phát hiện người, chiều cao sẽ được hiển thị trên màn hình
5. Sử dụng nút "Hiệu chỉnh" để điều chỉnh chiều cao nếu cần
6. Sử dụng nút "Đơn vị" để chuyển đổi giữa các đơn vị đo khác nhau
7. Sử dụng nút "Chụp ảnh" để lưu kết quả vào thư viện ảnh


## Cấu trúc dự án

- **AppDelegate.swift**: Quản lý vòng đời ứng dụng
- **ViewController.swift**: Màn hình chính, xử lý AR và đo chiều cao
- **CalibrationView.swift**: Giao diện hiệu chỉnh chiều cao
- **MeasurementManager.swift**: Quản lý lưu trữ kết quả đo
- **Extensions.swift**: Các extension hỗ trợ
- **Renderer.swift**: Xử lý render Metal
- **Shaders.metal**: Shader Metal cho hiệu ứng đồ họa
- **ShaderTypes.h**: Định nghĩa các kiểu dữ liệu cho shader


## Công nghệ sử dụng

- ARKit: Nhận diện và theo dõi cơ thể người dùng
- SceneKit: Hiển thị đối tượng 3D
- Metal: Xử lý đồ họa hiệu suất cao
- UIKit: Xây dựng giao diện người dùng


## Đóng góp

Mọi đóng góp đều được hoan nghênh! Nếu bạn muốn đóng góp, vui lòng:

1. Fork dự án
2. Tạo nhánh tính năng (`git checkout -b feature/amazing-feature`)
3. Commit thay đổi (`git commit -m 'Add some amazing feature'`)
4. Push lên nhánh (`git push origin feature/amazing-feature`)
5. Mở Pull Request


## Giấy phép

Dự án này được phân phối dưới giấy phép MIT. Xem file `LICENSE` để biết thêm chi tiết.

## Liên hệ

Trương Đạt - [https://truongdat.glitch.me/](https://truongdat.glitch.me/)

Link dự án: [https://github.com/yourusername/HeightMeasurement](https://github.com/yourusername/HeightMeasurement)

---

© 2025 Trương Đạt. Bảo lưu mọi quyền.
