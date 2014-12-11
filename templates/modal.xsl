<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:template match="/">
        <xsl:choose>
            <xsl:when test="//REALM/@name='panel/addrealm'">
                <xsl:call-template name="addrealm"/>
            </xsl:when>
            <xsl:when test="//REALM/@name='panel/editrealm'">
                <xsl:call-template name="editrealm"/>
            </xsl:when>
            <xsl:when test="//REALM/@name='panel/adduser'">
                <xsl:call-template name="adduser"/>
            </xsl:when>
            <xsl:when test="//REALM/@name='panel/edituser'">
                <xsl:call-template name="edituser"/>
            </xsl:when>
            <xsl:when test="//REALM/@name='panel/addnode'">
                <xsl:call-template name="addnode"/>
            </xsl:when>
            <xsl:when test="//REALM/@name='panel/editnode'">
                <xsl:call-template name="editnode"/>
            </xsl:when>
            <xsl:when test="//REALM/@name='panel/insertinclude'">
                <xsl:call-template name="insertinclude"/>
            </xsl:when>
            <xsl:when test="//REALM/@name='panel/editinclude'">
                <xsl:call-template name="editinclude"/>
            </xsl:when>
            <xsl:when test="//REALM/@name='panel/addlist'">
                <xsl:call-template name="addlist"/>
            </xsl:when>
            <xsl:when test="//REALM/@name='panel/addgroup'">
                <xsl:call-template name="addgroup"/>
            </xsl:when>
            <xsl:when test="//REALM/@name='panel/editgroup'">
                <xsl:call-template name="editgroup"/>
            </xsl:when>
            <xsl:when test="//REALM/@name='panel/editusergroup'">
                <xsl:call-template name="editusergroup"/>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>