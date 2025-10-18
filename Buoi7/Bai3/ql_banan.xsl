<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- Dùng cho gom nhóm (loại trùng) -->
  <xsl:key name="kCTByMon" match="CTHD" use="MAMON"/>
  <xsl:key name="kHDBYnv"  match="HOADON" use="MANV"/>

  <xsl:output method="html" indent="yes" encoding="UTF-8"/>

  <xsl:template match="/QUANLY">
  <html>
  <head>
    <meta charset="UTF-8"/>
    <title>Quản lý bàn ăn - Bài 3</title>
    <style>
      body { font-family: Arial, sans-serif; margin: 20px; }
      h2   { color:#0d47a1; border-bottom:2px solid #1565c0; margin-top:30px; }
      table{ border-collapse:collapse; width:100%; margin-top:10px; margin-bottom:25px; }
      th,td{ border:1px solid #333; padding:8px; text-align:left; }
      th   { background:#e0e0e0; }
      tr:nth-child(even){ background:#f9f9f9; }
    </style>
  </head>
  <body>

  <!-- 1) Tất cả bàn -->
  <h2>Hiển thị danh sách tất cả các bàn</h2>
  <table>
    <tr><th>STT</th><th>Số bàn</th><th>Tên bàn</th></tr>
    <xsl:for-each select="BANS/BAN">
      <tr>
        <td><xsl:value-of select="position()"/></td>
        <td><xsl:value-of select="SOBAN"/></td>
        <td><xsl:value-of select="TENBAN"/></td>
      </tr>
    </xsl:for-each>
  </table>

  <!-- 2) Tất cả nhân viên -->
  <h2>Hiển thị danh sách các nhân viên</h2>
  <table>
    <tr><th>STT</th><th>Mã NV</th><th>Tên NV</th><th>SĐT</th><th>Địa chỉ</th><th>Giới tính</th></tr>
    <xsl:for-each select="NHANVIENS/NHANVIEN">
      <tr>
        <td><xsl:value-of select="position()"/></td>
        <td><xsl:value-of select="MANV"/></td>
        <td><xsl:value-of select="TENV"/></td>
        <td><xsl:value-of select="SDT"/></td>
        <td><xsl:value-of select="DIACHI"/></td>
        <td><xsl:value-of select="GIOITINH"/></td>
      </tr>
    </xsl:for-each>
  </table>

  <!-- 3) Tất cả món -->
  <h2>Hiển thị danh sách các món ăn</h2>
  <table>
    <tr><th>STT</th><th>Mã món</th><th>Tên món</th><th>Giá</th></tr>
    <xsl:for-each select="MONS/MON">
      <tr>
        <td><xsl:value-of select="position()"/></td>
        <td><xsl:value-of select="MAMON"/></td>
        <td><xsl:value-of select="TENMON"/></td>
        <td><xsl:value-of select="GIA"/></td>
      </tr>
    </xsl:for-each>
  </table>

  <!-- 4) Thông tin NV02 -->
  <h2>Hiển thị thông tin của nhân viên NV02</h2>
  <table>
    <tr><th>STT</th><th>Mã NV</th><th>Tên NV</th><th>SĐT</th><th>Địa chỉ</th><th>Giới tính</th></tr>
    <xsl:for-each select="NHANVIENS/NHANVIEN[MANV='NV02']">
      <tr>
        <td>1</td>
        <td><xsl:value-of select="MANV"/></td>
        <td><xsl:value-of select="TENV"/></td>
        <td><xsl:value-of select="SDT"/></td>
        <td><xsl:value-of select="DIACHI"/></td>
        <td><xsl:value-of select="GIOITINH"/></td>
      </tr>
    </xsl:for-each>
  </table>

  <!-- 5) Món giá > 50,000 -->
  <h2>Hiển thị danh sách các món ăn có giá &gt; 50,000</h2>
  <table>
    <tr><th>STT</th><th>Mã món</th><th>Tên món</th><th>Giá</th></tr>
    <xsl:for-each select="MONS/MON[number(GIA)&gt;50000]">
      <tr>
        <td><xsl:value-of select="position()"/></td>
        <td><xsl:value-of select="MAMON"/></td>
        <td><xsl:value-of select="TENMON"/></td>
        <td><xsl:value-of select="GIA"/></td>
      </tr>
    </xsl:for-each>
  </table>

  <!-- 6) Thông tin liên quan HD03 -->
  <h2>Thông tin hóa đơn HD03 (tên nhân viên phục vụ, số bàn, ngày lập, tổng tiền)</h2>
  <table>
    <tr><th>STT</th><th>Tên NV</th><th>Số bàn</th><th>Ngày lập</th><th>Tổng tiền</th></tr>
    <xsl:for-each select="HOADONS/HOADON[SOHD='HD03']">
      <tr>
        <td>1</td>
        <td><xsl:value-of select="/QUANLY/NHANVIENS/NHANVIEN[MANV=current()/MANV]/TENV"/></td>
        <td><xsl:value-of select="SOBAN"/></td>
        <td><xsl:value-of select="NGAYLAP"/></td>
        <td><xsl:value-of select="TONGTIEN"/></td>
      </tr>
    </xsl:for-each>
  </table>

  <!-- 7) Tên các món trong HD02 -->
  <h2>Hiển thị tên các món ăn trong hóa đơn HD02</h2>
  <table>
    <tr><th>STT</th><th>Tên món</th></tr>
    <xsl:for-each select="HOADONS/HOADON[SOHD='HD02']/CTHDS/CTHD">
      <tr>
        <td><xsl:value-of select="position()"/></td>
        <td><xsl:value-of select="/QUANLY/MONS/MON[MAMON=current()/MAMON]/TENMON"/></td>
      </tr>
    </xsl:for-each>
  </table>

  <!-- 8) Tên NV lập HD02 -->
  <h2>Lấy tên nhân viên lập hóa đơn HD02</h2>
  <table>
    <tr><th>STT</th><th>Tên nhân viên</th></tr>
    <tr>
      <td>1</td>
      <td>
        <xsl:value-of select="/QUANLY/NHANVIENS/NHANVIEN[MANV=/QUANLY/HOADONS/HOADON[SOHD='HD02']/MANV]/TENV"/>
      </td>
    </tr>
  </table>

  <!-- 9) Đếm số bàn -->
  <h2>Đếm số bàn</h2>
  <table>
    <tr><th>STT</th><th>Chỉ số</th><th>Giá trị</th></tr>
    <tr>
      <td>1</td><td>Tổng số bàn</td><td><xsl:value-of select="count(BANS/BAN)"/></td>
    </tr>
  </table>

  <!-- 10) Đếm số hóa đơn lập bởi NV01 -->
  <h2>Đếm số hóa đơn lập bởi NV01</h2>
  <table>
    <tr><th>STT</th><th>Chỉ số</th><th>Giá trị</th></tr>
    <tr>
      <td>1</td><td>Số HĐ của NV01</td><td><xsl:value-of select="count(HOADONS/HOADON[MANV='NV01'])"/></td>
    </tr>
  </table>

  <!-- 11) Danh sách các món từng bán cho bàn số 2 (loại trùng) -->
  <h2>Hiển thị danh sách các món từng bán cho bàn số 2</h2>
  <table>
    <tr><th>STT</th><th>Tên món</th></tr>
    <!-- Muenchian grouping để loại trùng theo MAMON -->
    <xsl:for-each select="HOADONS/HOADON[SOBAN='2']/CTHDS/CTHD
                          [generate-id()=generate-id(key('kCTByMon', MAMON)[1])]">
      <tr>
        <td><xsl:value-of select="position()"/></td>
        <td><xsl:value-of select="/QUANLY/MONS/MON[MAMON=current()/MAMON]/TENMON"/></td>
      </tr>
    </xsl:for-each>
  </table>

  <!-- 12) Danh sách nhân viên từng lập hóa đơn cho bàn số 3 (loại trùng) -->
  <h2>Hiển thị danh sách nhân viên từng lập hóa đơn cho bàn số 3</h2>
  <table>
    <tr><th>STT</th><th>Mã NV</th><th>Tên NV</th></tr>
    <xsl:for-each select="HOADONS/HOADON[SOBAN='3']
                          [generate-id()=generate-id(key('kHDBYnv', MANV)[1])]">
      <xsl:variable name="ma" select="MANV"/>
      <tr>
        <td><xsl:value-of select="position()"/></td>
        <td><xsl:value-of select="$ma"/></td>
        <td><xsl:value-of select="/QUANLY/NHANVIENS/NHANVIEN[MANV=$ma]/TENV"/></td>
      </tr>
    </xsl:for-each>
  </table>

  <!-- 13) Các món được gọi > 1 lần trong tất cả HĐ -->
  <h2>Hiển thị các món ăn được gọi nhiều hơn 1 lần trong các hóa đơn</h2>
  <table>
    <tr><th>STT</th><th>Tên món</th><th>Tổng lượt gọi</th></tr>
    <xsl:for-each select="MONS/MON">
      <xsl:variable name="ma"   select="MAMON"/>
      <xsl:variable name="tong" select="sum(/QUANLY/HOADONS/HOADON/CTHDS/CTHD[MAMON=$ma]/SOLUONG)"/>
      <xsl:if test="$tong &gt; 1">
        <tr>
          <td><xsl:value-of select="position()"/></td>
          <td><xsl:value-of select="TENMON"/></td>
          <td><xsl:value-of select="$tong"/></td>
        </tr>
      </xsl:if>
    </xsl:for-each>
  </table>

  <!-- 14) Hóa đơn HD04 - chi tiết tính tiền: mã món, tên món, đơn giá, tiền -->
  <h2>Hiển thị thông tin hóa đơn chi tiết tính tiền cho hóa đơn HD04</h2>
  <table>
    <tr><th>STT</th><th>Mã món</th><th>Tên món</th><th>Đơn giá</th><th>Tiền</th></tr>
    <xsl:for-each select="HOADONS/HOADON[SOHD='HD04']/CTHDS/CTHD">
      <xsl:variable name="ma"  select="MAMON"/>
      <xsl:variable name="gia" select="/QUANLY/MONS/MON[MAMON=$ma]/GIA"/>
      <xsl:variable name="ten" select="/QUANLY/MONS/MON[MAMON=$ma]/TENMON"/>
      <tr>
        <td><xsl:value-of select="position()"/></td>
        <td><xsl:value-of select="$ma"/></td>
        <td><xsl:value-of select="$ten"/></td>
        <td><xsl:value-of select="$gia"/></td>
        <td><xsl:value-of select="number(SOLUONG) * number($gia)"/></td>
      </tr>
    </xsl:for-each>
  </table>

  </body>
  </html>
  </xsl:template>
</xsl:stylesheet>
