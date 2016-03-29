<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:param name="completeDoc"/>
<xsl:output method="xml"/>
<xsl:template match="/">
<xsl:variable name="oasisTitle"><xsl:value-of select="document('../output/metadata.xml')/descendant::node()[name()='title']"/></xsl:variable>
<xsl:variable name="version"><xsl:value-of select="document('../output/metadata.xml')/descendant::node()[name()='version']"/></xsl:variable>
<xsl:variable name="baseURL"><xsl:value-of select="document('../output/metadata.xml')/descendant::node()[name()='baseURL']"/></xsl:variable>
<xsl:variable name="docVersion"><xsl:value-of select="document('../output/metadata.xml')/descendant::node()[name()='docVersion']"/></xsl:variable>
<xsl:variable name="document"><xsl:value-of select="document('../output/metadata.xml')/descendant::node()[name()='document']"/></xsl:variable>
<xsl:variable name="oasisTCId"><xsl:value-of select="document('../output/metadata.xml')/descendant::node()[name()='committeeId']"/></xsl:variable>
<xsl:variable name="title"><xsl:value-of select="child::node()[name()='amqp']/@name"/></xsl:variable>
<xsl:variable name="partNo"><xsl:apply-templates mode="partNo" select="document('index.xml')/descendant::node()[name()='xref' and @name=$title]"/></xsl:variable>
<xsl:variable name="thisVersionUrl"><xsl:value-of select="$baseURL"/>/v<xsl:value-of select="$version"/>/<xsl:value-of select="$docVersion"/>/<xsl:value-of select="$document"/>-<xsl:value-of select="$title"/>-v<xsl:value-of select="$version"/>-<xsl:value-of select="$docVersion"/></xsl:variable>
<xsl:variable name="thisVersionPDFUrl"><xsl:value-of select="$baseURL"/>/v<xsl:value-of select="$version"/>/<xsl:value-of select="$docVersion"/>/<xsl:value-of select="$document"/>-complete-v<xsl:value-of select="$version"/>-<xsl:value-of select="$docVersion"/></xsl:variable>
<xsl:variable name="latestVersionUrl"><xsl:value-of select="$baseURL"/>/v<xsl:value-of select="$version"/>/<xsl:value-of select="$document"/>-<xsl:value-of select="$title"/>-v<xsl:value-of select="$version"/></xsl:variable>
<xsl:variable name="latestVersionPDFUrl"><xsl:value-of select="$baseURL"/>/v<xsl:value-of select="$version"/>/<xsl:value-of select="$document"/>-complete-v<xsl:value-of select="$version"/></xsl:variable>
<xsl:comment><xsl:text>
  </xsl:text><xsl:value-of select="$oasisTitle"/> Version <xsl:value-of select="$version"/><xsl:text>
  </xsl:text>Part <xsl:value-of select="$partNo"/>: <xsl:call-template name="initCap"><xsl:with-param name="input" select="$title"/></xsl:call-template><xsl:text>

  </xsl:text><xsl:choose>
    <xsl:when test="contains(document('../output/metadata.xml')/descendant::node()[name()='status'],'/')"><xsl:value-of select="substring-before(document('../output/metadata.xml')/descendant::node()[name()='status'],'/')"/>/<xsl:text>
 </xsl:text><xsl:value-of select="substring-after(document('../output/metadata.xml')/descendant::node()[name()='status'],'/')"/></xsl:when>
    <xsl:otherwise><xsl:value-of select="document('../output/metadata.xml')/descendant::node()[name()='status']"/></xsl:otherwise>
  </xsl:choose><xsl:text>
  </xsl:text><xsl:value-of select="document('../output/metadata.xml')/descendant::node()[name()='date']"/><xsl:text>
    
  </xsl:text>Specification URIs:<xsl:text>
    
    </xsl:text>This version:<xsl:text>
        </xsl:text><xsl:value-of select="$thisVersionUrl"/>.xml (Authoritative)<xsl:text>
        </xsl:text><xsl:value-of select="$thisVersionUrl"/>.html<xsl:text>
        </xsl:text><xsl:value-of select="$thisVersionPDFUrl"/>.pdf<xsl:text>
        
    </xsl:text>Previous version:<xsl:choose>
<xsl:when test="document('../output/metadata.xml')/descendant::node()[name()='prevDocVersion']"><xsl:variable name="prevDocVersion"><xsl:value-of select="document('../output/metadata.xml')/descendant::node()[name()='prevDocVersion']"/></xsl:variable><xsl:variable name="prevVersionUrl"><xsl:value-of select="$baseURL"/>/v<xsl:value-of select="$version"/>/<xsl:value-of select="$prevDocVersion"/>/<xsl:value-of select="$document"/>-<xsl:value-of select="$title"/>-v<xsl:value-of select="$version"/>-<xsl:value-of select="$prevDocVersion"/></xsl:variable><xsl:variable name="prevVersionPDFUrl"><xsl:value-of select="$baseURL"/>/v<xsl:value-of select="$version"/>/<xsl:value-of select="$prevDocVersion"/>/<xsl:value-of select="$document"/>-complete-v<xsl:value-of select="$version"/>-<xsl:value-of select="$prevDocVersion"/></xsl:variable><xsl:text>
        </xsl:text><xsl:value-of select="$prevVersionUrl"/>.xml (Authoritative)<xsl:text>
        </xsl:text><xsl:value-of select="$prevVersionUrl"/>.html<xsl:text>
        </xsl:text><xsl:value-of select="$prevVersionPDFUrl"/>.pdf</xsl:when>
<xsl:otherwise><xsl:text>
        </xsl:text>N/A</xsl:otherwise>
</xsl:choose><xsl:text>

    </xsl:text>Latest version:<xsl:text>
        </xsl:text><xsl:value-of select="$latestVersionUrl"/>.xml (Authoritative)<xsl:text>
        </xsl:text><xsl:value-of select="$latestVersionUrl"/>.html<xsl:text>
        </xsl:text><xsl:value-of select="$latestVersionPDFUrl"/>.pdf<xsl:text>
        
  </xsl:text>Technical Committee:<xsl:text>
        </xsl:text><xsl:value-of select="$oasisTitle"/> TC (http://www.oasis-open.org/committees/<xsl:value-of select="$oasisTCId"/>/)<xsl:text>

  </xsl:text>Chairs:<xsl:apply-templates mode="people" select="document('../front-matter/chairs.xml')"/><xsl:text>
  </xsl:text>Editors:<xsl:apply-templates mode="people" select="document('../front-matter/editors.xml')"/><xsl:text>
  </xsl:text>Additional artifacts:<xsl:text>
        </xsl:text>This specification consists of the following documents:<xsl:for-each select="document('index.xml')/descendant::node()[name()='xref' and @type='amqp']">
<xsl:variable name="partDoc"><xsl:value-of select="@name"/>.xml</xsl:variable><xsl:text>
        </xsl:text>Part <xsl:apply-templates mode="partNo" select="."/>: <xsl:call-template name="initCap"><xsl:with-param name="input" select="@name"/></xsl:call-template> - <xsl:value-of select="document($partDoc)/descendant::node()[name()='amqp']/@label"/> <xsl:choose><xsl:when test="@name = $title"> (this document)</xsl:when><xsl:otherwise> (<xsl:value-of select="$document"/>-<xsl:value-of select="@name"/>-v<xsl:value-of select="$version"/>-<xsl:value-of select="$docVersion"/>.xml)</xsl:otherwise></xsl:choose>
</xsl:for-each><xsl:text>
        XML Document Type Definition (DTD) (amqp.dtd)

  </xsl:text>Related work:<xsl:text>
        </xsl:text>This specification replaces or supersedes:<xsl:text>
            </xsl:text>AMQP v1.0 Final, 07 October 2001. http://www.amqp.org/specification/1.0/amqp-org-download<xsl:text>
  
  </xsl:text>Abstract:<xsl:text>

    </xsl:text><xsl:apply-templates select="document('../front-matter/abstract.xml')/descendant::node()[name()='p']"/><xsl:text>
    
  </xsl:text>Status:<xsl:text>
    
    </xsl:text>This document was last revised or approved by the membership of OASIS on the above date. The level of<xsl:text>
    </xsl:text>approval is also listed above. Check the "Latest version" location noted above for possible<xsl:text>
    </xsl:text>later revisions of this document.<xsl:text>

    </xsl:text>Technical Committee members should send comments on this specification to the Technical<xsl:text>
    </xsl:text>Committee's email list. Others should send comments to the Technical Committee by using the<xsl:text>
    </xsl:text>"Send A Comment" button on the Technical Committee's web page at<xsl:text>
    </xsl:text>http://www.oasis-open.org/committees/<xsl:value-of select="$oasisTCId"/>/.<xsl:text>

    </xsl:text>For information on whether any patents have been disclosed that may be essential to implementing<xsl:text>
    </xsl:text>this specification, and any offers of patent licensing terms, please refer to the Intellectual<xsl:text>
    </xsl:text>Property Rights section of the Technical Committee web page<xsl:text>
    </xsl:text>(http://www.oasis-open.org/committees/<xsl:value-of select="$oasisTCId"/>/ipr.php).<xsl:text>
    
  </xsl:text>Citation format:<xsl:text>
    
    </xsl:text>When referencing this specification the following citation format should be used:<xsl:text>
    
    </xsl:text>[<xsl:value-of select="$document"/>-<xsl:value-of select="$title"/>-v<xsl:value-of select="$version"/>]<xsl:text>
    </xsl:text><xsl:value-of select="$oasisTitle"/> Version <xsl:value-of select="$version"/> Part <xsl:value-of select="$partNo"/>: <xsl:call-template name="initCap"><xsl:with-param name="input" select="$title"/></xsl:call-template><xsl:text>. </xsl:text><xsl:value-of select="document('../output/metadata.xml')/descendant::node()[name()='date']"/>. <xsl:if test="not(contains(document('../output/metadata.xml')/descendant::node()[name()='status'], 'OASIS'))">OASIS </xsl:if><xsl:value-of select="document('../output/metadata.xml')/descendant::node()[name()='status']"/>.<xsl:text>
    </xsl:text><xsl:value-of select="$thisVersionUrl"/>.xml<xsl:text>
    
  </xsl:text>Notices:<xsl:apply-templates mode="notices" select="document('../front-matter/notice.xml')"/><xsl:text>     
</xsl:text>
</xsl:comment>
<xsl:apply-templates select="node()[name()='amqp']"/>
</xsl:template>

<xsl:template match="@*|node()|comment()">
  <xsl:copy>
    <xsl:apply-templates select="@*|node()|comment()"/>
  </xsl:copy>
</xsl:template>

<xsl:template match="comment()[self::comment()='RevisionHistory']">
<xsl:for-each select="document('../output/versions.xml')/versions/version"><xsl:variable name="version" select="@name"/><xsl:text>
    </xsl:text><xsl:element name="doc"><xsl:attribute name="title"><xsl:value-of select="substring-before(@date, 'T')"/> : <xsl:value-of select="@title"/></xsl:attribute><xsl:text>
      </xsl:text><ul>
        <xsl:for-each select="document('../output/version-history.xml')/version-history/version[@name=$version]/jira"><xsl:text>
        </xsl:text><li><p><xsl:value-of select="@id"/> : <xsl:value-of select="text()"/></p></li>
          </xsl:for-each><xsl:text>
      </xsl:text></ul><xsl:text>
    </xsl:text></xsl:element>
      </xsl:for-each>
</xsl:template>

<xsl:template match="comment()"/>

    <xsl:template mode="partNo" match="node()[name()='xref']"><xsl:value-of select="count(ancestor::node()/preceding-sibling::node()/descendant::node()[name()='xref' and @type='amqp'])"/></xsl:template>
    <xsl:template mode="people" match="node()[name()='person']"><xsl:text>      </xsl:text><xsl:value-of select="@name"/> (<xsl:value-of select="@mail"/>), <xsl:value-of select="@company"/></xsl:template>
    <xsl:template mode="notices" match="node()[name()='p']"><xsl:apply-templates mode="notices" select="node()"/></xsl:template>
    <xsl:template mode="notices" match="node()[name()='xref']"><xsl:choose><xsl:when test="text()"><xsl:apply-templates mode="notices" select="node()"/></xsl:when><xsl:otherwise><xsl:value-of select="@name"/></xsl:otherwise></xsl:choose></xsl:template>
    <xsl:template mode="notices" match="text()"><xsl:value-of select="."/></xsl:template>
    <xsl:template mode="notices" match="node()[name()='copyright']">(c)</xsl:template>
<!-- General Utilities -->
    
    <xsl:template name="toUpper"><xsl:param name="input"/><xsl:value-of select="translate($input,'abcdefghijklmnopqrstuvwxyz','ABCDEFGHIJKLMNOPQRSTUVWXYZ')"></xsl:value-of></xsl:template>
    <xsl:template name="toLower"><xsl:param name="input"/><xsl:value-of select="translate($input,'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz')"></xsl:value-of></xsl:template>
    <xsl:template name="initCap"><xsl:param name="input"/><xsl:call-template name="toUpper"><xsl:with-param name="input" select="substring($input,1,1)"/></xsl:call-template><xsl:value-of select="substring($input,2)"/></xsl:template>

</xsl:stylesheet>
