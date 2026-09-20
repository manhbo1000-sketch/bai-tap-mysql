# BÀI LÀM: CHUYỂN ĐỔI MÔ HÌNH ERD SANG MÔ HÌNH DỮ LIỆU QUAN HỆ

**Họ và tên:** Dương Đức Mạnh

---

## BƯỚC 1: XÁC ĐỊNH CÁC THỰC THỂ

Từ mô hình ERD, xác định được 5 thực thể:

1. **PHIEUXUAT** – Phiếu xuất
2. **VATTU** – Vật tư
3. **PHIEUNHAP** – Phiếu nhập
4. **DONDH** – Đơn đặt hàng
5. **NHACC** – Nhà cung cấp

### Các thuộc tính của thực thể

| Thực thể | Khóa chính | Thuộc tính |
|---|---|---|
| PHIEUXUAT | SoPX | SoPX, NgayXuat |
| VATTU | MaVTU | MaVTU, TenVTU |
| PHIEUNHAP | SoPN | SoPN, NgayNhap |
| DONDH | SoDH | SoDH, NgayDH |
| NHACC | MaNCC | MaNCC, TenNCC, DiaChi, SDT |

---

## BƯỚC 2: XÁC ĐỊNH CÁC MỐI QUAN HỆ

### 1. Quan hệ Chi tiết phiếu xuất

Giữa hai thực thể:

**PHIEUXUAT – VATTU**

Bội số: **N : N**

- Một phiếu xuất có thể có nhiều vật tư.
- Một vật tư có thể xuất hiện trong nhiều phiếu xuất.

Vì đây là quan hệ N:N nên tạo bảng trung gian:

**CHITIETPHIEUXUAT**

Các thuộc tính:

- SoPX – khóa chính, khóa ngoại
- MaVTU – khóa chính, khóa ngoại
- DGXuat – đơn giá xuất
- SLXuat – số lượng xuất

Khóa chính ghép:

**(SoPX, MaVTU)**

---

### 2. Quan hệ Chi tiết phiếu nhập

Giữa hai thực thể:

**VATTU – PHIEUNHAP**

Bội số: **N : N**

- Một phiếu nhập có thể có nhiều vật tư.
- Một vật tư có thể xuất hiện trong nhiều phiếu nhập.

Vì đây là quan hệ N:N nên tạo bảng trung gian:

**CHITIETPHIEUNHAP**

Các thuộc tính:

- MaVTU – khóa chính, khóa ngoại
- SoPN – khóa chính, khóa ngoại
- DGNhap – đơn giá nhập
- SLNhap – số lượng nhập

Khóa chính ghép:

**(MaVTU, SoPN)**

---

### 3. Quan hệ Chi tiết đơn đặt hàng

Giữa hai thực thể:

**VATTU – DONDH**

Bội số: **N : N**

- Một đơn đặt hàng có thể có nhiều vật tư.
- Một vật tư có thể xuất hiện trong nhiều đơn đặt hàng.

Vì đây là quan hệ N:N nên tạo bảng trung gian:

**CHITIETDONDH**

Các thuộc tính:

- MaVTU – khóa chính, khóa ngoại
- SoDH – khóa chính, khóa ngoại

Khóa chính ghép:

**(MaVTU, SoDH)**

---

### 4. Quan hệ Cung cấp

Giữa hai thực thể:

**DONDH – NHACC**

Bội số: **N : 1**

- Một nhà cung cấp có thể cung cấp cho nhiều đơn đặt hàng.
- Một đơn đặt hàng thuộc về một nhà cung cấp.

Đây là quan hệ 1:N nên đưa khóa chính của phía 1 sang phía N.

- NHACC là phía 1.
- DONDH là phía N.

Do đó đưa **MaNCC** vào bảng **DONDH** làm khóa ngoại.

DONDH sau khi chuyển đổi:

**DONDH(SoDH, NgayDH, MaNCC)**

Trong đó:

- SoDH: khóa chính
- MaNCC: khóa ngoại tham chiếu NHACC(MaNCC)

---

## BƯỚC 3: XÁC ĐỊNH THUỘC TÍNH ĐA TRỊ

Trong mô hình ERD, **SDT** của thực thể **NHACC** là thuộc tính đa trị, được biểu diễn bằng hình oval kép.

Điều này có nghĩa là một nhà cung cấp có thể có nhiều số điện thoại.

Vì vậy tạo một bảng mới:

**NHACC_SDT(MaNCC, SDT)**

Trong đó:

- MaNCC: khóa chính, đồng thời là khóa ngoại tham chiếu NHACC(MaNCC)
- SDT: khóa chính

Khóa chính ghép:

**(MaNCC, SDT)**

---

## BƯỚC 4: LIỆT KÊ CÁC BẢNG SAU KHI CHUYỂN ĐỔI

Sau khi chuyển đổi mô hình ERD sang mô hình dữ liệu quan hệ, thu được **9 bảng**:

### 1. PHIEUXUAT

```text
PHIEUXUAT(
    SoPX PK,
    NgayXuat
)
```

### 2. VATTU

```text
VATTU(
    MaVTU PK,
    TenVTU
)
```

### 3. PHIEUNHAP

```text
PHIEUNHAP(
    SoPN PK,
    NgayNhap
)
```

### 4. DONDH

```text
DONDH(
    SoDH PK,
    NgayDH,
    MaNCC FK
)
```

**MaNCC** tham chiếu đến **NHACC(MaNCC)**.

### 5. NHACC

```text
NHACC(
    MaNCC PK,
    TenNCC,
    DiaChi
)
```

Thuộc tính SDT được tách thành bảng riêng vì là thuộc tính đa trị.

### 6. CHITIETPHIEUXUAT

```text
CHITIETPHIEUXUAT(
    SoPX PK, FK,
    MaVTU PK, FK,
    DGXuat,
    SLXuat
)
```

Khóa chính:

```text
(SoPX, MaVTU)
```

### 7. CHITIETPHIEUNHAP

```text
CHITIETPHIEUNHAP(
    MaVTU PK, FK,
    SoPN PK, FK,
    DGNhap,
    SLNhap
)
```

Khóa chính:

```text
(MaVTU, SoPN)
```

### 8. CHITIETDONDH

```text
CHITIETDONDH(
    MaVTU PK, FK,
    SoDH PK, FK
)
```

Khóa chính:

```text
(MaVTU, SoDH)
```

### 9. NHACC_SDT

```text
NHACC_SDT(
    MaNCC PK, FK,
    SDT PK
)
```

Khóa chính:

```text
(MaNCC, SDT)
```

---

# TỔNG HỢP MÔ HÌNH DỮ LIỆU QUAN HỆ

```text
PHIEUXUAT(SoPX PK, NgayXuat)

VATTU(MaVTU PK, TenVTU)

PHIEUNHAP(SoPN PK, NgayNhap)

DONDH(SoDH PK, NgayDH, MaNCC FK)

NHACC(MaNCC PK, TenNCC, DiaChi)

CHITIETPHIEUXUAT(
    SoPX PK/FK,
    MaVTU PK/FK,
    DGXuat,
    SLXuat
)

CHITIETPHIEUNHAP(
    MaVTU PK/FK,
    SoPN PK/FK,
    DGNhap,
    SLNhap
)

CHITIETDONDH(
    MaVTU PK/FK,
    SoDH PK/FK
)

NHACC_SDT(
    MaNCC PK/FK,
    SDT PK
)
```

## KẾT LUẬN

Sau khi chuyển đổi mô hình ERD sang mô hình dữ liệu quan hệ:

- Có **5 bảng thực thể ban đầu**.
- Có **3 bảng trung gian** được tạo từ các quan hệ N:N.
- Có **1 bảng mới** được tạo để xử lý thuộc tính đa trị SDT.
- Tổng cộng thu được **9 bảng quan hệ**.
- Khóa ngoại **MaNCC** được đưa vào DONDH để biểu diễn quan hệ N:1.
