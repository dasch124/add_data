<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs"
    version="2.0">
    <xsl:param name="project-path"/>
    <xsl:template match="/">
        <xsl:variable name="corpusTitle" select="/tei:teiCorpus/tei:teiHeader/tei:fileDesc//tei:title"/>
        <xsl:variable name="subcorpus">
            <xsl:analyze-string select="$corpusTitle" regex="(adart\d)">
                <xsl:matching-substring>
                    <xsl:value-of select="regex-group(1)"/>
                </xsl:matching-substring>
            </xsl:analyze-string>
        </xsl:variable>
        <xsl:for-each select="//tei:TEI">
            <xsl:variable name="filename" select="(descendant::tei:name[@type = 'cdlicat:primary_publication'],descendant::tei:text/@type)[1]"/>
            <xsl:result-document href="{$project-path}/102_derived_tei/single_files/{$subcorpus}/{escape-html-uri(translate($filename,'/','_'))}.xml" method="xml" indent="no">
                <xsl:sequence select="."/>
            </xsl:result-document>
        </xsl:for-each>
    </xsl:template>
        
</xsl:stylesheet>