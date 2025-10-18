<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:output method="html" encoding="UTF-8" indent="yes"/>

<xsl:template match="/school">
<html>
<head>
    <meta charset="UTF-8"/>
    <title>Danh sách sinh viên</title>
    <style>
        body { font-family: Arial; margin: 20px; }
        h2 { color: #004aad; border-bottom: 2px solid #004aad; padding-bottom: 5px; }
        table { border-collapse: collapse; width: 100%; margin-bottom: 30px; }
        th, td { border: 1px solid #555; padding: 8px; text-align: left; }
        th { background-color: #e0e0e0; }
        tr:nth-child(even) { background-color: #f9f9f9; }
    </style>
</head>
<body>

<!-- 1️⃣ Liệt kê tất cả sinh viên gồm mã và họ tên -->
<h2>Danh sách tất cả sinh viên (Mã và Họ tên)</h2>
<table>
    <tr><th>Mã sinh viên</th><th>Họ tên</th></tr>
    <xsl:apply-templates select="student" mode="all-students"/>
</table>

<!-- 2️⃣ Danh sách sinh viên gồm mã, tên, điểm (sắp xếp điểm giảm dần) -->
<h2>Danh sách sinh viên (Mã, Họ tên, Điểm) – Sắp xếp theo điểm giảm dần</h2>
<table>
    <tr><th>Mã</th><th>Họ tên</th><th>Điểm</th></tr>
    <xsl:for-each select="student">
        <xsl:sort select="grade" data-type="number" order="descending"/>
        <tr>
            <td><xsl:value-of select="id"/></td>
            <td><xsl:value-of select="name"/></td>
            <td><xsl:value-of select="grade"/></td>
        </tr>
    </xsl:for-each>
</table>

<!-- 3️⃣ Sinh viên sinh tháng gần nhau -->
<h2>Danh sách sinh viên sinh cùng/tháng gần nhau</h2>
<table>
    <tr><th>STT</th><th>Họ tên</th><th>Ngày sinh</th></tr>
    <xsl:for-each select="student">
        <xsl:sort select="substring(date, 6, 2)" data-type="number" order="ascending"/>
        <tr>
            <td><xsl:value-of select="position()"/></td>
            <td><xsl:value-of select="name"/></td>
            <td><xsl:value-of select="date"/></td>
        </tr>
    </xsl:for-each>
</table>

<!-- 4️⃣ Danh sách các khóa học có sinh viên học -->
<h2>Danh sách các khóa học có sinh viên học (sắp xếp theo tên khóa học)</h2>
<table>
    <tr><th>Mã khóa học</th><th>Tên khóa học</th></tr>
    <xsl:for-each select="course">
        <xsl:sort select="name" order="ascending"/>
        <xsl:variable name="cid" select="id"/>
        <!-- chỉ hiển thị nếu có enrollment -->
        <xsl:if test="../enrollment/courseRef = $cid">
            <tr>
                <td><xsl:value-of select="id"/></td>
                <td><xsl:value-of select="name"/></td>
            </tr>
        </xsl:if>
    </xsl:for-each>
</table>

<!-- 5️⃣ Sinh viên học khóa "Hóa học 201" -->
<h2>Danh sách sinh viên đăng ký khóa học "Hóa học 201"</h2>
<table>
    <tr><th>Mã SV</th><th>Họ tên</th></tr>
    <xsl:for-each select="enrollment[courseRef = 'c3']">
        <xsl:variable name="sid" select="studentRef"/>
        <xsl:apply-templates select="../student[id = $sid]" mode="by-course"/>
    </xsl:for-each>
</table>

<!-- 6️⃣ Sinh viên sinh năm 1997 -->
<h2>Danh sách sinh viên sinh năm 1997</h2>
<table>
    <tr><th>Mã SV</th><th>Họ tên</th><th>Ngày sinh</th></tr>
    <xsl:apply-templates select="student[starts-with(date,'1997')]" mode="year1997"/>
</table>

<!-- 7️⃣ Sinh viên họ “Trần” -->
<h2>Danh sách sinh viên họ “Trần”</h2>
<table>
    <tr><th>Mã SV</th><th>Họ tên</th></tr>
    <xsl:apply-templates select="student[starts-with(name,'Trần')]" mode="ho-tran"/>
</table>

</body>
</html>
</xsl:template>

<!--  CÁC TEMPLATE ÁP DỤNG -->

<xsl:template match="student" mode="all-students">
<tr>
    <td><xsl:value-of select="id"/></td>
    <td><xsl:value-of select="name"/></td>
</tr>
</xsl:template>

<xsl:template match="student" mode="by-course">
<tr>
    <td><xsl:value-of select="id"/></td>
    <td><xsl:value-of select="name"/></td>
</tr>
</xsl:template>

<xsl:template match="student" mode="year1997">
<tr>
    <td><xsl:value-of select="id"/></td>
    <td><xsl:value-of select="name"/></td>
    <td><xsl:value-of select="date"/></td>
</tr>
</xsl:template>

<xsl:template match="student" mode="ho-tran">
<tr>
    <td><xsl:value-of select="id"/></td>
    <td><xsl:value-of select="name"/></td>
</tr>
</xsl:template>

</xsl:stylesheet>
