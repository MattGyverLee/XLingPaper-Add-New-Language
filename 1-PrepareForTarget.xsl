<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">
    <xsl:output omit-xml-declaration="no" indent="yes" method="xml"/>
    <xsl:variable name="sourceLang">en</xsl:variable>
    <xsl:variable name="targetLang">fr</xsl:variable>
    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="p[@contentType = $sourceLang]">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
        <xsl:element name="p">
            <xsl:attribute name="contentType">
                <xsl:value-of select="$targetLang"/>
            </xsl:attribute>
            <xsl:apply-templates select="node()"/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="p[@contentType = $sourceLang]">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
        <xsl:element name="p">
            <xsl:attribute name="contentType">
                <xsl:value-of select="$targetLang"/>
            </xsl:attribute>
            <xsl:apply-templates select="node()"/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="pc[@contentType = $sourceLang]">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
        <xsl:element name="pc">
            <xsl:attribute name="contentType">
                <xsl:value-of select="$targetLang"/>
            </xsl:attribute>
            <xsl:apply-templates select="node()"/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="pc[not(@contentType)]">
        <xsl:copy>
            <xsl:attribute name="contentType">
                <xsl:value-of select="$sourceLang"/>
            </xsl:attribute>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
        <xsl:element name="pc">
            <xsl:attribute name="contentType">
                <xsl:value-of select="$targetLang"/>
            </xsl:attribute>
            <xsl:apply-templates select="node()"/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="li[@contentType = $sourceLang]">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
        <xsl:element name="li">
            <xsl:attribute name="contentType">
                <xsl:value-of select="$targetLang"/>
            </xsl:attribute>
            <xsl:apply-templates select="node()"/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="li[not(@contentType)]">
        <xsl:copy>
            <xsl:attribute name="contentType">
                <xsl:value-of select="$sourceLang"/>
            </xsl:attribute>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
        <xsl:element name="li">
            <xsl:attribute name="contentType">
                <xsl:value-of select="$targetLang"/>
            </xsl:attribute>
            <xsl:apply-templates select="node()"/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="table[@contentType = $sourceLang]">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
        <xsl:element name="li">
            <xsl:attribute name="contentType">
                <xsl:value-of select="$targetLang"/>
            </xsl:attribute>
            <xsl:apply-templates select="node()"/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="contents | abstract | acknowledgements | preface | appendix">
        <xsl:copy>
            <xsl:apply-templates select="@*"/>
            <xsl:element name="labelContentChoices">
                <xsl:element name="labelContent">
                    <xsl:attribute name="contentType">
                        <xsl:value-of select="$sourceLang"/>
                    </xsl:attribute>
                    <xsl:apply-templates select="@* | node()"/>
                </xsl:element>
                <xsl:element name="labelContent">
                    <xsl:attribute name="contentType">
                        <xsl:value-of select="$targetLang"/>
                    </xsl:attribute>
                    <xsl:apply-templates select="@* | node()"/>
                </xsl:element>
            </xsl:element>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="title | shortTitle | secTitle | subtitle">
        <xsl:variable name="current" select="local-name(.)"/>
        <xsl:copy>
            <xsl:apply-templates select="@*"/>
            <xsl:element name="titleContentChoices">
                <xsl:element name="titleContent">
                    <xsl:attribute name="contentType">
                        <xsl:value-of select="$sourceLang"/>
                    </xsl:attribute>
                    <xsl:apply-templates select="@* | node()"/>
                </xsl:element>
                <xsl:element name="titleContent">
                    <xsl:attribute name="contentType">
                        <xsl:value-of select="$targetLang"/>
                    </xsl:attribute>
                    <xsl:apply-templates select="@* | node()"/>
                </xsl:element>
            </xsl:element>
        </xsl:copy>
    </xsl:template>


</xsl:stylesheet>
