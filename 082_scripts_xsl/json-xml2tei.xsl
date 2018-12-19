<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:o2t="http://www.acdh.oeaw.ac.at/oracc2tei"
    xpath-default-namespace="http://www.w3.org/2005/xpath-functions"
    exclude-result-prefixes="xs"
    xmlns="http://www.tei-c.org/ns/1.0"
    version="2.0">
    <xsl:output method="xml" indent="yes"/>
    <xsl:strip-space elements="*"/>
    <xsl:variable name="textid" select="/map/string[@key = 'textid']"/>
    <xsl:template match="/">
        <TEI xml:id="{$textid}">
            <teiHeader>
                <fileDesc>
                    <titleStmt>
                        <title><xsl:value-of select="$textid"/></title>
                        <editor>
                            <persName>Reinhard Pirngruber</persName>
                        </editor>
                    </titleStmt>
                    <publicationStmt>
                        <p>Unpublished version.</p>
                    </publicationStmt>
                    <sourceDesc>
                        <p>Source</p>
                    </sourceDesc>
                </fileDesc>
            </teiHeader>
            <text>
                <body><ab><xsl:apply-templates/></ab></body>
                <back>
                    <xsl:apply-templates select="//map[@key = 'f']" mode="back"/>
                </back>
            </text>
        </TEI>
    </xsl:template>
    
    <xsl:template match="string"/>
    
    <xsl:template match="map">
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:function name="o2t:node" as="xs:string">
        <xsl:param name="o" as="element(map)"/>
        <xsl:value-of select="$o/string[@key = 'node']"/>
    </xsl:function>

    <xsl:function name="o2t:node-type" as="xs:string">
        <xsl:param name="o" as="element(map)"/>
        <xsl:value-of select="$o/string[@key = 'type']"/>
    </xsl:function>
    
    <xsl:function name="o2t:node-subtype" as="xs:string">
        <xsl:param name="o" as="element(map)"/>
        <xsl:value-of select="$o/string[@key = 'subtype']"/>
    </xsl:function>
    
    <xsl:function name="o2t:property" as="item()?">
        <xsl:param name="o" as="element(map)"/>
        <xsl:param name="property" as="xs:string"/>
        <xsl:variable name="pc" select="$o/*[@key = $property]/node()"/>
        <xsl:choose>
            <xsl:when test="$pc/self::map or $pc/self::array">
                <xsl:sequence select="$pc"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$pc"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    <xsl:function name="o2t:feature" as="item()?">
        <xsl:param name="o" as="element(map)"/>
        <xsl:param name="f" as="xs:string"/>
        <xsl:variable name="f" select="$o/map[@key = 'f']/*[@key = $f]"/>
        <xsl:choose>
            <xsl:when test="$f/self::map or $f/self::array">
                <xsl:sequence select="$f"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$f"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    
    <xsl:template match="map[o2t:node(.) = 'd'][o2t:node-type(.) = ('obverse', 'reverse')]">
        <milestone unit="surface" n="{string[@key='type']}"/>
    </xsl:template>
    
    <xsl:template match="map[o2t:node(.) = 'd'][o2t:node-type(.) = 'line-start']">
        <lb xml:id="{string[@key = 'ref']}" n="{string[@key = 'label']}"/>
    </xsl:template>
    
    <xsl:template match="map[o2t:node(.) = 'c']">
        <xsl:variable name="type" select="o2t:node-type(.)"/>
        <xsl:variable name="subtype" select="o2t:node-subtype(.)"/>
        <seg>
            <xsl:if test="$type != ''">
                <xsl:attribute name="type" select="$type"/>
            </xsl:if>
            <xsl:if test="$subtype != ''">
                <xsl:attribute name="subtype" select="$subtype"/>
            </xsl:if>
            <xsl:apply-templates/>
        </seg>
    </xsl:template>
    
    
    <xsl:template match="map[o2t:node(.) = 'l']">
        <xsl:variable name="id" select="o2t:property(.,'id')"/>
        <w xml:id="{$id}" ana="#{$id}.fs"><xsl:value-of select="o2t:property(.,'frag')"/></w>
    </xsl:template>
    
    <xsl:template match="map[@key = 'f']" mode="back">
        <fs xml:id="{../*[@key = 'id']}.fs">
            <!--            type="{o2t:feature(., 'pos')}" norm="{o2t:feature(., 'norm')}" ana="sense:{o2t:feature(., 'sense')}" -->
            <xsl:apply-templates mode="#current"/>
        </fs>
    </xsl:template>
    
    <xsl:template match="string[@key = 'id']" mode="back"/>
    
    <xsl:template match="string[@key != 'id']" mode="back">
        <f name="{@key}"><xsl:value-of select="."/></f>
    </xsl:template>
</xsl:stylesheet>