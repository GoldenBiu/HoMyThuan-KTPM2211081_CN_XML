<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<!-- Xuất ra dạng văn bản (text) thay vì HTML -->
<xsl:output method="text" encoding="UTF-8"/>

<!-- Template: Chuyển danh sách sinh viên sang JSON -->
<xsl:template match="/school">
{
  "students": [
  <xsl:for-each select="student">
    {
      "id": "<xsl:value-of select='id'/>",
      "name": "<xsl:value-of select='name'/>",
      "date": "<xsl:value-of select='date'/>"
    }<xsl:if test="position() != last()">,</xsl:if>
  </xsl:for-each>
  ]
}
</xsl:template>

</xsl:stylesheet>
