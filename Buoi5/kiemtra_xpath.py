# -*- coding: utf-8 -*-
from lxml import etree
import os

print("📂 Đang chạy tại:", os.getcwd())

def run_xpath(xml_file, queries):
    print(f"\n==================== KIỂM TRA FILE: {xml_file} ====================")
    tree = etree.parse(xml_file)
    root = tree.getroot()

    for desc, expr in queries:
        print(f"\n👉 {desc}")
        print(f"🧭 XPath: {expr}")
        try:
            result = root.xpath(expr)
            if isinstance(result, list):
                if len(result) == 0:
                    print("❌ Không có kết quả.")
                else:
                    for r in result:
                        if isinstance(r, etree._Element):
                            print(" -", etree.tostring(r, pretty_print=True, encoding='unicode').strip())
                        else:
                            print(" -", r)
            else:
                print(" -", result)
        except Exception as e:
            print("⚠️ Lỗi:", e)

# ==========================
# 🧩 TRUY VẤN CHO SINHVIEN.XML
# ==========================
sinhvien_queries = [
    ("Lấy tất cả sinh viên", "//student"),
    ("Liệt kê tên tất cả sinh viên", "//student/name/text()"),
    ("Lấy tất cả id sinh viên", "//student/id/text()"),
    ("Lấy ngày sinh của sinh viên có id='SV01'", "//student[id='SV01']/date/text()"),
    ("Lấy tất cả các khóa học", "//enrollment/course/text()"),
    ("Lấy toàn bộ thông tin của sinh viên đầu tiên", "//student[1]/*/text()"),
    ("Lấy mã sinh viên đăng ký khóa học 'Vatly203'", "//enrollment[course='Vatly203']/studentRef/text()"),
    ("Lấy tên sinh viên học môn 'Toan101'", "//student[id=//enrollment[course='Toan101']/studentRef]/name/text()"),
    ("Lấy tên sinh viên học môn 'Vatly203'", "//student[id=//enrollment[course='Vatly203']/studentRef]/name/text()"),
    ("Lấy tên và ngày sinh của sinh viên sinh năm 1997",
     "//student[starts-with(date,'1997')]/name/text() | //student[starts-with(date,'1997')]/date/text()"),
    ("Lấy tên sinh viên có ngày sinh trước năm 1998", "//student[number(substring(date,1,4))<1998]/name/text()"),
    ("Đếm tổng số sinh viên", "count(//student)"),
    ("Lấy phần tử <date> ngay sau <name> của SV01", "//student[id='SV01']/name/following-sibling::date/text()"),
    ("Lấy phần tử <id> ngay trước <name> của SV02", "//student[name='Lê Thị Hồng Cẩm']/preceding-sibling::id/text()"),
    ("Lấy toàn bộ node <course> trong enrollment có studentRef='SV03'", "//enrollment[studentRef='SV03']/course/text()"),
    ("Lấy sinh viên có họ là 'Trần'", "//student[starts-with(name,'Trần')]/name/text()"),
    ("Lấy năm sinh của sinh viên SV01", "substring(//student[id='SV01']/date/text(),1,4)"),
    ("Lấy tất cả sinh viên chưa đăng ký môn nào", "//student[not(id=//enrollment/studentRef)]"),
]

# ==========================
# 🍜 TRUY VẤN CHO QUANLYBANAN.XML
# ==========================
quanlybanan_queries = [
    ("Lấy tất cả bàn", "//BAN"),
    ("Lấy tất cả nhân viên", "//NHANVIEN"),
    ("Lấy tất cả tên món", "//MON/TENMON/text()"),
    ("Lấy tên nhân viên có mã NV02", "//NHANVIEN[MANV='NV02']/TENVN/text()"),
    # ✅ Sửa biểu thức hợp lệ
    ("Lấy tên và số điện thoại của nhân viên NV03",
     "//NHANVIEN[MANV='NV03']/TENVN/text() | //NHANVIEN[MANV='NV03']/SDT/text()"),
    ("Lấy tên món có giá > 50000", "//MON[GIA>50000]/TENMON/text()"),
    ("Lấy số bàn của hóa đơn HD03", "//HOADON[SOHD='HD03']/BAN_REF/text()"),
    ("Lấy tên món có mã M02", "//MON[MAMON='M02']/TENMON/text()"),
    ("Lấy ngày lập của hóa đơn HD03", "//HOADON[SOHD='HD03']/NGAYLAP/text()"),
    ("Lấy tất cả mã món trong hóa đơn HD01", "//HOADON[SOHD='HD01']//MAMON_REF/text()"),
    ("Lấy tên món trong hóa đơn HD01", "//MON[MAMON=//HOADON[SOHD='HD01']//MAMON_REF]/TENMON/text()"),
    ("Lấy tên nhân viên lập hóa đơn HD02", "//NHANVIEN[MANV=//HOADON[SOHD='HD02']/NV_REF]/TENVN/text()"),
    ("Đếm số bàn", "count(//BAN)"),
    ("Đếm số hóa đơn lập bởi NV01", "count(//HOADON[NV_REF='NV01'])"),
    ("Lấy tên tất cả món có trong hóa đơn bàn số 2", "//MON[MAMON=//HOADON[BAN_REF='BAN02']//MAMON_REF]/TENMON/text()"),
    ("Lấy tất cả nhân viên từng lập hóa đơn cho bàn số 3", "//NHANVIEN[MANV=//HOADON[BAN_REF='BAN03']/NV_REF]/TENVN/text()"),
    ("Lấy tất cả hóa đơn mà nhân viên nữ lập", "//HOADON[NV_REF=//NHANVIEN[GIOITINH='Nu']/MANV]"),
    ("Lấy tất cả nhân viên từng phục vụ bàn số 1", "//NHANVIEN[MANV=//HOADON[BAN_REF='BAN01']/NV_REF]/TENVN/text()"),
    # ✅ Đã sửa lại không dùng current()
    ("Lấy tất cả món được gọi nhiều hơn 1 lần", "//MON[MAMON=//CTHD[MAMON_REF]/MAMON_REF]/TENMON/text()"),
    # ✅ Đã sửa cú pháp hợp lệ
    ("Lấy tên bàn + ngày lập hóa đơn SOHD='HD02'",
     "//HOADON[SOHD='HD02']/BAN_REF/text() | //HOADON[SOHD='HD02']/NGAYLAP/text()"),
]

# ==========================
# 🚀 CHẠY KIỂM TRA
# ==========================
run_xpath("sinhvien.xml", sinhvien_queries)
run_xpath("quanlybanan.xml", quanlybanan_queries)

input("\nNhấn Enter để thoát...")
