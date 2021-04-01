# **ReduceNoiseUse2Mic**

Programming by Verilog

## **Yêu cầu kĩ thuật**:

### **Yêu cầu chức năng**

Mạch giảm nhiễu tiếng nói sử dụng 2 mic

- Âm thanh được thu lại bằng 2 mic, một mic gần người nói, một mic xa người nói và gần nguồn nhiễu tần số f
- Đầu ra là dữ liệu âm thanh tiếng nói đã được giảm nhiễu
- Dữ liệu đầu ra có thể cho ra trực tiếp trong loa trong thời gian thực
- Có nút Start: Bắt đầu nhận đầu vào
- Có nút Reset: Đặt lại trạng thái của mạch về trạng thái ban đầu

### **Yêu cầu phi chức năng**

- Hai đầu vào xử lý tương ứng với 2 tín hiệu âm thanh được lượng tử hóa dưới dạng 8 bit, với tần số lấy mẫu là 16kHz
- Đầu ra là dữ liệu dưới dạng 8 bit đã được xử lý với tần số khôi phục là 16kHz
- Đầu ra đối chiếu được tạo bằng cách triển khai thuật toán trên Matlab với cùng tín hiệu đầu vào
- Đánh giá: Kết quả đầu ra mạch được so sánh với đầu vào và đầu ra đối chiếu thông qua chỉ số SNR và PESQ

## **Sơ đồ thuật toán**

![Sơ đồ thuật toán](img\BlockDiagram.PNG)

Sơ đồ khối của mạch sẽ gồm hai khối chính: Adaptive Filter và Adaption Procedure.

Đầu vào là hai tín hiệu main và sub.

Thuật toán LMS sử dụng 1 bộ lọc có hệ số thích ứng sao cho trung bình lỗi bình phương nhỏ nhất.

Mục tiêu: tìm hệ số của ĥ(n) gần với h(n) nhất để trừ được nhiễu ra khỏi tiếng nói.

## **Kết quả**

![Kết quả](img\result.PNG)
Hình thứ nhất là hình dạng tín hiệu trên miền thời gian, có thể thấy đầu ra Verilog có dạng giống đầu ra đầu vào main nhưng có ít nhiễu hơn

Hình thứ hai là phổ tần số của tín hiệu, có thể thấy nhiễu 1000Hz bị giảm rõ rệt, các dải tần số còn lại được giữ nguyên hình dạng và cường độ -> điều này ảnh hưởng rất nhiều đến chỉ số PESQ nhất là với dải tần số của tiếng nói từ 60Hz đến 280Hz
