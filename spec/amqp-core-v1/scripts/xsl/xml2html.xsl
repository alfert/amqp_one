<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:output method="html" doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd" doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN" indent="no"/>
    <xsl:template match="node()[name()='amqp']">
<xsl:variable name="title"><xsl:value-of select='@name'/></xsl:variable>
<xsl:variable name="oasisTitle"><xsl:value-of select="document('../output/metadata.xml')/descendant::node()[name()='title']"/></xsl:variable>
<xsl:variable name="partNo"><xsl:apply-templates mode="partNo" select="document('index.xml')/descendant::node()[name()='xref' and @name=$title]"/></xsl:variable>
<xsl:variable name="version"><xsl:value-of select="document('../output/metadata.xml')/descendant::node()[name()='version']"/></xsl:variable>
<xsl:variable name="baseURL"><xsl:value-of select="document('../output/metadata.xml')/descendant::node()[name()='baseURL']"/></xsl:variable>
<xsl:variable name="docVersion"><xsl:value-of select="document('../output/metadata.xml')/descendant::node()[name()='docVersion']"/></xsl:variable>
<xsl:variable name="document"><xsl:value-of select="document('../output/metadata.xml')/descendant::node()[name()='document']"/></xsl:variable>
<xsl:variable name="oasisTCId"><xsl:value-of select="document('../output/metadata.xml')/descendant::node()[name()='committeeId']"/></xsl:variable>

<html>
    <head>
        <title><xsl:value-of select="$oasisTitle"/> Version <xsl:value-of select="$version"/>, Part <xsl:value-of select="$partNo"/>: <xsl:call-template name="initCap"><xsl:with-param name="input" select="@name"/></xsl:call-template></title>
        <style type="text/css">
            body {
            margin: 2em;
            padding: 1em;
            font-size: 10.0pt;
            font-family: "DejaVu LGC Sans", "Bitstream Vera Sans", arial, helvetica, sans-serif;
            }
h1
	{margin-top:24.0pt;
	margin-right:0in;
	margin-bottom:6.0pt;
	margin-left:.3in;
	text-indent:-.3in;
	page-break-before:always;
	page-break-after:avoid;
	text-autospace:ideograph-other;
	border:none;
	padding:0in;
	font-size:13.0pt;
	font-family:"Arial","sans-serif";
	color:#3B006F;
	font-weight:bold;}
h2
	{margin-top:12.0pt;
	margin-right:0in;
	margin-bottom:0in;
	margin-left:.4in;
	margin-bottom:.0001pt;
	text-indent:-.4in;
	page-break-after:avoid;
	text-autospace:ideograph-other;
	font-size:12.0pt;
	font-family:"Arial","sans-serif";
	color:#3B006F;
	font-weight:bold;}
h3
	{margin-top:12.0pt;
	margin-right:0in;
	margin-bottom:0in;
	margin-left:.5in;
	margin-bottom:.0001pt;
	text-indent:-.5in;
	page-break-after:avoid;
	text-autospace:ideograph-other;
	font-size:11.0pt;
	font-family:"Arial","sans-serif";
	color:#3B006F;
	font-weight:bold;}
h4
	{margin-top:12.0pt;
	margin-right:0in;
	margin-bottom:0in;
	margin-left:.6in;
	margin-bottom:.0001pt;
	text-indent:-.6in;
	page-break-after:avoid;
	text-autospace:ideograph-other;
	font-size:10.0pt;
	font-family:"Arial","sans-serif";
	color:#3B006F;
	font-weight:bold;}
h5
	{margin-top:12.0pt;
	margin-right:0in;
	margin-bottom:0in;
	margin-left:.7in;
	margin-bottom:.0001pt;
	text-indent:-.7in;
	page-break-after:avoid;
	text-autospace:ideograph-other;
	font-size:10.0pt;
	font-family:"Arial","sans-serif";
	color:#3B006F;
	font-weight:bold;}
h6
	{margin-top:12.0pt;
	margin-right:0in;
	margin-bottom:0in;
	margin-left:.8in;
	margin-bottom:.0001pt;
	text-indent:-.8in;
	page-break-after:avoid;
	text-autospace:ideograph-other;
	font-size:9.0pt;
	font-family:"Arial","sans-serif";
	color:#3B006F;
	font-weight:bold;}
                  
            h1 a, h2 a, h3 a, h4 a {
            color: #3B006F
            }
      
            a {
            text-decoration: none;
            color: #66f;
            }
            
            a.anchor {
            color: #000;
            }
            
            a.toc {
            float: right;
            }
            
            table {
            border-collapse: collapse;
            margin: 1em 1em;
            }
            
            dt {
            font-weight: bold;
            }
            
            dt:after {
            content: ":";
            }
            
            div.toc {
            border: 1px solid #ccc;
            padding: 1em;
            }
            
            table.toc {
            margin: 0;
            }
            
            table.pre {
            background: #eee;
            border: 1px solid #ccc;
            margin-left: auto;
            margin-right: auto;
            }
            
            table.pre td {
            font-family: Courier, monospace;
            font-size:10.0pt;
            white-space: pre;
            padding: 0em 2em;
            }
            
            table.definition {
            width: 100%;
            }
            
            table.signature {
            background: #eee;
            border: 1px solid #ccc;
            width: 100%;
            }
            
            table.signature td {
            font-family: monospace;
            font-size:9.0pt;
            white-space: pre;
            padding: 1em;
            }

            table.encodings th {
            font-size:10.0pt;
            padding: 2px 2em;
            border-bottom-style:solid;
            border-bottom-width:2px;
            text-align:left;
            }

            table.encodings td {
            font-size:10.0pt;
            padding: 2px 2em;
            }
            
            table.constants td {
            font-size:10.0pt;
            padding: 2px 1em;
            }

            table.composite {
            width: 100%;
            }
            
            td.field {
            padding: 0.5em 2em;
            }
            
            div.section {
            padding: 0 0 0 1em;
            }
            
            div.doc {
            padding: 0 0 1em 0;
            }
            
            table.composite div.doc {
            padding: 0;
            }
            
            table.error {
            width: 100%;
            margin: 0;
            }
            
            table.error tr:last-child td {
            padding: 0 0 0 1em;
            }
            
            .todo:before {
            content: "TODO: ";
            font-weight: bold;
            color: red;
            }
            
            .todo {
            font-variant: small-caps;
            font-weight: bold;
            color: red;
            }

p.OasisTitle
	{margin-top:0in;
	margin-right:0in;
	margin-bottom:12.0pt;
	margin-left:0in;
	text-autospace:ideograph-other;
	border:none;
	padding:0in;
	font-size:24.0pt;
	font-family:"Arial","sans-serif";
	color:#3B006F;
	font-weight:bold;}

p.OasisContributor
	{margin-top:0in;
	margin-right:0in;
	margin-bottom:0in;
	margin-left:.5in;
	margin-bottom:.0001pt;
	text-autospace:ideograph-other;
	font-size:10.0pt;
	font-family:"Arial","sans-serif";}
a:link, span.OasisHyperlink
	{color:#0000EE;
	text-decoration:none;}
a:visited, span.OasisHyperlinkFollowed
	{color:purple;
	text-decoration:underline;}

p.OasisSubtitle
	{margin-top:0in;
	margin-right:0in;
	margin-bottom:12.0pt;
	margin-left:0in;
	text-autospace:ideograph-other;
	border:none;
	padding:0in;
	font-size:18.0pt;
	font-family:"Arial","sans-serif";
	color:#3B006F;
	font-weight:bold;}
p.OasisTitlePageInfo
	{margin-top:4.3pt;
	margin-right:0in;
	margin-bottom:0in;
	margin-left:0in;
	margin-bottom:.0001pt;
	page-break-after:avoid;
	text-autospace:ideograph-other;
	font-size:10.0pt;
	font-family:"Arial","sans-serif";
	color:#3B006F;
	font-weight:bold;}
p.OasisTitlePageInfoDescription
	{margin-top:0in;
	margin-right:0in;
	margin-bottom:4.3pt;
	margin-left:.5in;
	text-autospace:ideograph-other;
	font-size:10.0pt;
	font-family:"Arial","sans-serif";}

        table.RevisionHistory {
            width: 650px;
            }
        table.RevisionHistory th {
            font-size:11.0pt;
            padding: 2px;
            padding-below: 4px;
            color:#3B006F;
            text-align:left;
            font-weight:bold;}
        table.RevisionHistory td.issue {
            width:6em;
            padding-left: 1em;
            vertical-align: top;
            text-align: right}
</style>        
    </head>
    <body>
        <!-- OASIS Front Matter -->
        <!-- Logo -->
        <img width="203" height="54" src="oasis.jpg"/>
	<hr/>	
	<!-- Title -->
        <p class="OasisTitle"><xsl:value-of select="$oasisTitle"/> Version <xsl:value-of select="$version"/><br/>
        <!-- Part Title -->
        Part <xsl:value-of select="$partNo"/>: <xsl:call-template name="initCap"><xsl:with-param name="input" select="@name"/></xsl:call-template></p>
	<!-- Oasis Status -->
        <p class="OasisSubtitle"><xsl:choose>
            <xsl:when test="contains(document('../output/metadata.xml')/descendant::node()[name()='status'],'/')"><xsl:value-of select="substring-before(document('../output/metadata.xml')/descendant::node()[name()='status'],'/')"/>/<br/><xsl:value-of select="substring-after(document('../output/metadata.xml')/descendant::node()[name()='status'],'/')"/></xsl:when>
            <xsl:otherwise><xsl:value-of select="document('../output/metadata.xml')/descendant::node()[name()='status']"/></xsl:otherwise>
        </xsl:choose></p>
        <!-- Date -->
        <p class="OasisSubtitle"><xsl:value-of select="document('../output/metadata.xml')/descendant::node()[name()='date']"/></p>
        <!-- Specification URIs -->
        <p class="OasisTitlePageInfo"><span style='font-size:12.0pt'>Specification URIs</span></p>

        <p class="OasisTitlePageInfo">This version:</p>
<xsl:variable name="thisVersionUrl"><xsl:value-of select="$baseURL"/>/v<xsl:value-of select="$version"/>/<xsl:value-of select="$docVersion"/>/<xsl:value-of select="$document"/>-<xsl:value-of select="$title"/>-v<xsl:value-of select="$version"/>-<xsl:value-of select="$docVersion"/></xsl:variable>
<xsl:variable name="thisVersionPDFUrl"><xsl:value-of select="$baseURL"/>/v<xsl:value-of select="$version"/>/<xsl:value-of select="$docVersion"/>/<xsl:value-of select="$document"/>-complete-v<xsl:value-of select="$version"/>-<xsl:value-of select="$docVersion"/></xsl:variable>
<p class="OasisTitlePageInfoDescription" style='margin-bottom:0in;margin-bottom:.0001pt'>
<xsl:element name="a"><xsl:attribute name="href"><xsl:value-of select="$thisVersionUrl"/>.xml</xsl:attribute><xsl:value-of select="$thisVersionUrl"/>.xml</xsl:element> (Authoritative)</p> 
<p class="OasisTitlePageInfoDescription" style='margin-bottom:0in;margin-bottom:.0001pt'>
<xsl:element name="a"><xsl:attribute name="href"><xsl:value-of select="$thisVersionUrl"/>.html</xsl:attribute><xsl:value-of select="$thisVersionUrl"/>.html</xsl:element></p> 
<p class="OasisTitlePageInfoDescription" style='margin-bottom:0in;margin-bottom:.0001pt'>
<xsl:element name="a"><xsl:attribute name="href"><xsl:value-of select="$thisVersionPDFUrl"/>.pdf</xsl:attribute><xsl:value-of select="$thisVersionPDFUrl"/>.pdf</xsl:element></p> 
 

        <p class="OasisTitlePageInfo">Previous version:</p>
<xsl:choose>
<xsl:when test="document('../output/metadata.xml')/descendant::node()[name()='prevDocVersion']">
<xsl:variable name="prevDocVersion"><xsl:value-of select="document('../output/metadata.xml')/descendant::node()[name()='prevDocVersion']"/></xsl:variable>
<xsl:variable name="prevVersionUrl"><xsl:value-of select="$baseURL"/>/v<xsl:value-of select="$version"/>/<xsl:value-of select="$prevDocVersion"/>/<xsl:value-of select="$document"/>-<xsl:value-of select="$title"/>-v<xsl:value-of select="$version"/>-<xsl:value-of select="$prevDocVersion"/></xsl:variable>
<xsl:variable name="prevVersionPDFUrl"><xsl:value-of select="$baseURL"/>/v<xsl:value-of select="$version"/>/<xsl:value-of select="$prevDocVersion"/>/<xsl:value-of select="$document"/>-complete-v<xsl:value-of select="$version"/>-<xsl:value-of select="$prevDocVersion"/></xsl:variable> 
<p class="OasisTitlePageInfoDescription" style='margin-bottom:0in;margin-bottom:.0001pt'>
<xsl:element name="a"><xsl:attribute name="href"><xsl:value-of select="$prevVersionUrl"/>.xml</xsl:attribute><xsl:value-of select="$prevVersionUrl"/>.xml</xsl:element> (Authoritative)</p>
<p class="OasisTitlePageInfoDescription" style='margin-bottom:0in;margin-bottom:.0001pt'>
<xsl:element name="a"><xsl:attribute name="href"><xsl:value-of select="$prevVersionUrl"/>.html</xsl:attribute><xsl:value-of select="$prevVersionUrl"/>.html</xsl:element></p> 
<p class="OasisTitlePageInfoDescription" style='margin-bottom:0in;margin-bottom:.0001pt'>
<xsl:element name="a"><xsl:attribute name="href"><xsl:value-of select="$prevVersionPDFUrl"/>.pdf</xsl:attribute><xsl:value-of select="$prevVersionPDFUrl"/>.pdf</xsl:element></p>
</xsl:when>
<xsl:otherwise>
<p class="OasisTitlePageInfoDescription" style='margin-bottom:0in;margin-bottom:.0001pt'>N/A</p>
</xsl:otherwise>
</xsl:choose>

        <p class="OasisTitlePageInfo">Latest version:</p>
<xsl:variable name="latestVersionUrl"><xsl:value-of select="$baseURL"/>/v<xsl:value-of select="$version"/>/<xsl:value-of select="$document"/>-<xsl:value-of select="$title"/>-v<xsl:value-of select="$version"/></xsl:variable>
<xsl:variable name="latestVersionPDFUrl"><xsl:value-of select="$baseURL"/>/v<xsl:value-of select="$version"/>/<xsl:value-of select="$document"/>-complete-v<xsl:value-of select="$version"/></xsl:variable> 
<p class="OasisTitlePageInfoDescription" style='margin-bottom:0in;margin-bottom:.0001pt'>
<xsl:element name="a"><xsl:attribute name="href"><xsl:value-of select="$latestVersionUrl"/>.xml</xsl:attribute><xsl:value-of select="$latestVersionUrl"/>.xml</xsl:element> (Authoritative)</p>
<p class="OasisTitlePageInfoDescription" style='margin-bottom:0in;margin-bottom:.0001pt'>
<xsl:element name="a"><xsl:attribute name="href"><xsl:value-of select="$latestVersionUrl"/>.html</xsl:attribute><xsl:value-of select="$latestVersionUrl"/>.html</xsl:element></p> 
<p class="OasisTitlePageInfoDescription" style='margin-bottom:0in;margin-bottom:.0001pt'>
<xsl:element name="a"><xsl:attribute name="href"><xsl:value-of select="$latestVersionPDFUrl"/>.pdf</xsl:attribute><xsl:value-of select="$latestVersionPDFUrl"/>.pdf</xsl:element></p> 

        <p class="OasisTitlePageInfo">Technical Committee:</p>
<p class="OasisTitlePageInfoDescription" style='margin-bottom:0in;margin-bottom:.0001pt'><xsl:element name="a"><xsl:attribute name="href">http://www.oasis-open.org/committees/<xsl:value-of select="$oasisTCId"/>/</xsl:attribute><xsl:value-of select="$oasisTitle"/> TC</xsl:element></p>
        <p class="OasisTitlePageInfo">Chairs:</p>
<xsl:apply-templates mode="people" select="document('../front-matter/chairs.xml')"/>
        <p class="OasisTitlePageInfo">Editors:</p>
<xsl:apply-templates mode="people" select="document('../front-matter/editors.xml')"/>
        <p class="OasisTitlePageInfo">Additional artifacts:</p>
<p class="OasisTitlePageInfoDescription" style='margin-bottom:0in;margin-bottom:.0001pt'>This specification consists of the following documents:</p>
<xsl:for-each select="document('index.xml')/descendant::node()[name()='xref' and @type='amqp']">
<xsl:variable name="partDoc"><xsl:value-of select="@name"/>.xml</xsl:variable>
<p class="OasisTitlePageInfoDescription" style='margin-bottom:0in;margin-bottom:.0001pt'><span style='font-family:Symbol'>·<span style='font:7.0pt "Times New Roman"'><xsl:text disable-output-escaping="yes">&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;</xsl:text></span></span><span class="OasisHyperLink"><xsl:element name="a"><xsl:attribute name="href"><xsl:value-of select="$baseURL"/>/v<xsl:value-of select="$version"/>/<xsl:value-of select="$docVersion"/>/<xsl:value-of select="$document"/>-<xsl:value-of select="@name"/>-v<xsl:value-of select="$version"/>-<xsl:value-of select="$docVersion"/>.html#toc</xsl:attribute>Part <xsl:apply-templates mode="partNo" select="."/>: <xsl:call-template name="initCap"><xsl:with-param name="input" select="@name"/></xsl:call-template></xsl:element></span> <xsl:if test="@name = $title"> (this document)</xsl:if> - <xsl:value-of select="document($partDoc)/descendant::node()[name()='amqp']/@label"/></p>
</xsl:for-each>
        <p class="OasisTitlePageInfoDescription" style='margin-bottom:0in;margin-bottom:.0001pt'><span style='font-family:Symbol'>·<span style='font:7.0pt "Times New Roman"'><xsl:text disable-output-escaping="yes">&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;</xsl:text></span></span><span class="OasisHyperLink"><xsl:element name="a"><xsl:attribute name="href"><xsl:value-of select="$baseURL"/>/v<xsl:value-of select="$version"/>/<xsl:value-of select="$docVersion"/>/amqp.dtd</xsl:attribute>XML Document Type Definition (DTD)</xsl:element></span></p>
        <p class="OasisTitlePageInfo">Related work:</p>
<p class="OasisTitlePageInfoDescription" style='margin-bottom:0in;margin-bottom:.0001pt'>This specification replaces or supersedes:</p>
<p class="OasisTitlePageInfoDescription" style='margin-bottom:0in;margin-bottom:.0001pt'><span style='font-family:Symbol'>·<span style='font:7.0pt "Times New Roman"'><xsl:text disable-output-escaping="yes">&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;</xsl:text></span></span>AMQP v1.0 Final, 07 October 2011. <span class="OasisHyperLink"><a href="http://www.amqp.org/specification/1.0/amqp-org-download">http://www.amqp.org/specification/1.0/amqp-org-download</a></span></p>

	<p class="OasisTitlePageInfo">Abstract:</p>
<xsl:apply-templates mode="abstract" select="document('../front-matter/abstract.xml')"/>
        <p class="OasisTitlePageInfo">Status:</p>
<p class="OasisTitlePageInfoDescription">
This document was last revised or approved by the membership of OASIS on the above date. The level of approval is also listed above. Check the "Latest version" location noted above for possible later revisions of this document.
</p>
<p class="OasisTitlePageInfoDescription">
Technical Committee members should send comments on this specification to the Technical Committee's email list. Others should send comments to the Technical Committee by using the "<xsl:element name="a"><xsl:attribute name="href">http://www.oasis-open.org/committees/comments/index.php?wg_abbrev=<xsl:value-of select="$oasisTCId"/></xsl:attribute>Send A Comment</xsl:element>" button on the Technical Committee's web page at <xsl:element name="a"><xsl:attribute name="href">http://www.oasis-open.org/committees/<xsl:value-of select="$oasisTCId"/>/</xsl:attribute>http://www.oasis-open.org/committees/comments/<xsl:value-of select="$oasisTCId"/>/</xsl:element>.
</p>
<p class="OasisTitlePageInfoDescription">For information on whether any patents have been disclosed that may be essential to implementing this specification, and any offers of patent licensing terms, please refer to the Intellectual Property Rights section of the Technical Committee web page (<xsl:element name="a"><xsl:attribute name="href">http://www.oasis-open.org/committees/<xsl:value-of select="$oasisTCId"/>/ipr.php</xsl:attribute>http://www.oasis-open.org/committees/<xsl:value-of select="$oasisTCId"/>/ipr.php</xsl:element>).
</p>

        <p class="OasisTitlePageInfo">Citation format:</p>
<p class="OasisTitlePageInfoDescription">When referencing this specification the
following citation format should be used:</p>

<p class="OasisTitlePageInfoDescription"><b><span
style='color:black'>[<xsl:value-of select="$document"/>-<xsl:value-of select="$title"/>-v<xsl:value-of select="$version"/>]</span></b></p>

<p class="OasisTitlePageInfoDescription"><i><span style='color:black'><xsl:value-of select="$oasisTitle"/> Version <xsl:value-of select="$version"/> Part <xsl:value-of select="$partNo"/>: <xsl:call-template name="initCap"><xsl:with-param name="input" select="@name"/></xsl:call-template></span></i><span style='color:black'>.
<xsl:value-of select="document('../output/metadata.xml')/descendant::node()[name()='date']"/>. <xsl:if test="not(contains(document('../output/metadata.xml')/descendant::node()[name()='status'], 'OASIS'))">OASIS </xsl:if><xsl:value-of select="document('../output/metadata.xml')/descendant::node()[name()='status']"/>. </span><span
class="OasisHyperlink"><xsl:element name="a"><xsl:attribute name="href"><xsl:value-of select="$thisVersionUrl"/>.html</xsl:attribute><xsl:value-of select="$thisVersionUrl"/>.html</xsl:element></span><span
style='color:black'>.</span></p>


<hr/>
<p class="OasisTitlePageInfo"><span style='font-size:12.0pt'>Notices</span></p>
<xsl:apply-templates mode="notices" select="document('../front-matter/notice.xml')"/>     
<hr/>
        <xsl:if test="descendant-or-self::node()[name()='section']"><xsl:call-template name="toc"/></xsl:if>
<hr/>
        <xsl:apply-templates mode="spec" select="."/>
<hr/>
<table width="100%" class="partNav" border="0">
<tr>
<td width="50%" align="left"><xsl:apply-templates mode="prevPart" select="document('index.xml')/descendant::node()[name()='xref' and @name=$title]"/></td>
<td width="50%" align="right"><xsl:apply-templates mode="nextPart" select="document('index.xml')/descendant::node()[name()='xref' and @name=$title]"/></td>
</tr>
</table>
    </body>
</html>
    </xsl:template>

    <xsl:template mode="partNo" match="node()[name()='xref']"><xsl:value-of select="count(ancestor::node()/preceding-sibling::node()/descendant::node()[name()='xref' and @type='amqp'])"/></xsl:template>
    <xsl:template mode="prevPart" match="node()[name()='xref']">
      <xsl:if test="preceding::node()[name()='xref' and @type='amqp']">
        <xsl:variable name="previous" select="preceding::node()[name()='xref' and @type='amqp']"/>
        <xsl:variable name="title" select="$previous[position()=last()]/@name"/>
        <xsl:variable name="partNo"><xsl:apply-templates mode="partNo" select="document('index.xml')/descendant::node()[name()='xref' and @name=$title]"/></xsl:variable>
        <xsl:variable name="version"><xsl:value-of select="document('../output/metadata.xml')/descendant::node()[name()='version']"/></xsl:variable>
        <xsl:variable name="baseURL"><xsl:value-of select="document('../output/metadata.xml')/descendant::node()[name()='baseURL']"/></xsl:variable>
        <xsl:variable name="docVersion"><xsl:value-of select="document('../output/metadata.xml')/descendant::node()[name()='docVersion']"/></xsl:variable>
        <xsl:variable name="document"><xsl:value-of select="document('../output/metadata.xml')/descendant::node()[name()='document']"/></xsl:variable>
        <xsl:variable name="thisVersionUrl"><xsl:value-of select="$baseURL"/>/v<xsl:value-of select="$version"/>/<xsl:value-of select="$docVersion"/>/<xsl:value-of select="$document"/>-<xsl:value-of select="$title"/>-v<xsl:value-of select="$version"/>-<xsl:value-of select="$docVersion"/>.html</xsl:variable>
        <xsl:element name="a">
          <xsl:attribute name="href"><xsl:value-of select="$thisVersionUrl"/>#toc</xsl:attribute>&lt;&lt; Part <xsl:value-of select="$partNo"/>: <xsl:call-template name="initCap"><xsl:with-param name="input" select="$previous[position()=last()]/@name"/></xsl:call-template>
        </xsl:element>
      </xsl:if>
    </xsl:template>

    <xsl:template mode="nextPart" match="node()[name()='xref']">
      <xsl:if test="following::node()[name()='xref' and @type='amqp']">
        <xsl:variable name="following" select="following::node()[name()='xref' and @type='amqp']"/>
        <xsl:variable name="title" select="$following[position()=1]/@name"/>
        <xsl:variable name="partNo"><xsl:apply-templates mode="partNo" select="document('index.xml')/descendant::node()[name()='xref' and @name=$title]"/></xsl:variable>
        <xsl:variable name="version"><xsl:value-of select="document('../output/metadata.xml')/descendant::node()[name()='version']"/></xsl:variable>
        <xsl:variable name="baseURL"><xsl:value-of select="document('../output/metadata.xml')/descendant::node()[name()='baseURL']"/></xsl:variable>
        <xsl:variable name="docVersion"><xsl:value-of select="document('../output/metadata.xml')/descendant::node()[name()='docVersion']"/></xsl:variable>
        <xsl:variable name="document"><xsl:value-of select="document('../output/metadata.xml')/descendant::node()[name()='document']"/></xsl:variable>
        <xsl:variable name="thisVersionUrl"><xsl:value-of select="$baseURL"/>/v<xsl:value-of select="$version"/>/<xsl:value-of select="$docVersion"/>/<xsl:value-of select="$document"/>-<xsl:value-of select="$title"/>-v<xsl:value-of select="$version"/>-<xsl:value-of select="$docVersion"/>.html</xsl:variable>
        <xsl:element name="a">
          <xsl:attribute name="href"><xsl:value-of select="$thisVersionUrl"/>#toc</xsl:attribute>
          Part <xsl:value-of select="$partNo"/>: <xsl:call-template name="initCap"><xsl:with-param name="input" select="$title"/></xsl:call-template> &gt;&gt;
        </xsl:element>
      </xsl:if>
    </xsl:template>
    
    <xsl:template mode="people" match="node()[name()='person']"><p class="OasisContributor"><xsl:value-of select="@name"/> (<span class="OasisHyperlink"><xsl:element name="a"><xsl:attribute name="href">
mailto:<xsl:value-of select="@mail"/></xsl:attribute><xsl:value-of select="@mail"/></xsl:element></span>),
<span class="OasisHyperlink"><xsl:element name="a"><xsl:attribute name="href"><xsl:value-of select="@homepage"/></xsl:attribute><xsl:value-of select="@company"/></xsl:element></span></p>
</xsl:template>
    <xsl:template mode="abstract" match="node()[name()='p']"><p class="OasisTitlePageInfoDescription"><xsl:apply-templates mode="spec" select="*|text()"/></p></xsl:template>
    <xsl:template mode="notices" match="node()[name()='p']"><p class="OasisTitlePageInfoDescription"><xsl:apply-templates mode="spec" select="*|text()"/></p></xsl:template>
    <xsl:template mode="spec" match="node()[name()='copyright']"><xsl:text disable-output-escaping="yes">&amp;copy;</xsl:text></xsl:template>

    <!-- Table of Contents -->

    <xsl:template name="toc">
        <h2><a name="toc">Table of Contents</a></h2>
<br/><br/>        
            <table class="toc" summary="Table of Contents">
                <xsl:apply-templates mode="toc" select="."/>
            </table>
                
    </xsl:template>

    <xsl:template mode="toc" match="node()[name()='section']">
        <xsl:variable name="title"><xsl:choose>
            <xsl:when test="@title"><xsl:value-of select="@title"/></xsl:when>
            <xsl:otherwise><xsl:call-template name="initCapWords"><xsl:with-param name="input" select="translate(@name,'-',' ')"/></xsl:call-template></xsl:otherwise>
        </xsl:choose>
        </xsl:variable>
        <xsl:variable name="ref">#section-<xsl:value-of select="@name"/></xsl:variable>
        <xsl:variable name="section-number"><xsl:apply-templates mode="section-number" select="."/></xsl:variable>
        <tr><td><xsl:value-of select="$section-number"/><xsl:text> </xsl:text><xsl:element name="a"><xsl:attribute name="href"><xsl:value-of select="$ref"/></xsl:attribute><xsl:value-of select="$title"/></xsl:element></td></tr>
        <xsl:apply-templates mode="toc" select="node()[( name()='type') or name()='definition' or ( name()='doc' and attribute::node()[name()='title']!='')]"/>
    </xsl:template>

    <xsl:template mode="toc" match="node()[name()='doc' and  attribute::node()[name()='title']]">
      <xsl:if test="count(ancestor::node()[name() = 'section' and @name='revhistory']) = 0">
        <xsl:variable name="ref">#doc-<xsl:choose><xsl:when test="@name"><xsl:value-of select="@name"/></xsl:when><xsl:otherwise><xsl:value-of select="generate-id(.)"/></xsl:otherwise></xsl:choose></xsl:variable>
        <xsl:variable name="section-number"><xsl:apply-templates mode="doc-number" select="."/></xsl:variable>
        <tr><td><xsl:text>&#160;&#160;&#160;&#160;&#160;&#160;</xsl:text><xsl:value-of select="$section-number"/><xsl:text> </xsl:text><xsl:element name="a"><xsl:attribute name="href"><xsl:value-of select="$ref"/></xsl:attribute><xsl:value-of select="@title"/></xsl:element></td></tr>        
      </xsl:if>
    </xsl:template>

    <xsl:template mode="toc" match="node()[name()='type']">
        <xsl:variable name="ref">#<xsl:value-of select="name()"/>-<xsl:value-of select="@name"/></xsl:variable>        
        <xsl:variable name="section-number"><xsl:apply-templates mode="type-number" select="."/></xsl:variable>        
        <tr><td><xsl:text>&#160;&#160;&#160;&#160;&#160;&#160;</xsl:text><xsl:if test="contains(substring-after(substring-after($section-number,'.'),'.'),'.')"><xsl:text>&#160;&#160;&#160;&#160;&#160;&#160;</xsl:text></xsl:if><xsl:value-of select="$section-number"/><xsl:text> </xsl:text><xsl:element name="a"><xsl:attribute name="href"><xsl:value-of select="$ref"/></xsl:attribute><xsl:call-template name="initCapWords"><xsl:with-param name="input" select="translate(@name,'-',' ')"/></xsl:call-template></xsl:element></td></tr>        
    </xsl:template>

    <xsl:template mode="toc" match="node()[name()='definition']">
        <xsl:if test="count(preceding-sibling::node()[name()='definition']) = 0">
        <xsl:variable name="ref">#definition-<xsl:value-of select="generate-id(.)"/></xsl:variable>        
        <xsl:variable name="section-number"><xsl:apply-templates mode="type-number" select="."/></xsl:variable>        
        <tr><td><xsl:text>&#160;&#160;&#160;&#160;&#160;&#160;</xsl:text><xsl:if test="contains(substring-after(substring-after($section-number,'.'),'.'),'.')"><xsl:text>&#160;&#160;&#160;&#160;&#160;&#160;</xsl:text></xsl:if><xsl:value-of select="$section-number"/><xsl:text> </xsl:text><xsl:element name="a"><xsl:attribute name="href"><xsl:value-of select="$ref"/></xsl:attribute>Constant Definitions</xsl:element></td></tr>        
        </xsl:if>
    </xsl:template>
    
    <!-- Sections -->
    
    <xsl:template match="node()[name()='section']" mode="spec">
        <xsl:variable name="title"><xsl:choose>
            <xsl:when test="@title"><xsl:value-of select="@title"/></xsl:when>
            <xsl:otherwise><xsl:call-template name="initCapWords"><xsl:with-param name="input" select="translate(@name,'-',' ')"/></xsl:call-template></xsl:otherwise>
        </xsl:choose>
        </xsl:variable>        
        <h2><a class="toc" href="#toc"><xsl:text>&#8592;</xsl:text></a> <xsl:apply-templates mode="section-number" select="."/><xsl:text> </xsl:text><xsl:element name="a"><xsl:attribute name="name">section-<xsl:value-of select="@name"/></xsl:attribute><xsl:value-of select="$title"/></xsl:element></h2>
        <div class="section">
            <xsl:apply-templates mode="spec" select="*|comment()"/>
        </div>
    </xsl:template>
    
    <!-- docs -->
    <xsl:template match="node()[name()='doc']" mode="spec">
        <xsl:choose>
          <xsl:when test="ancestor::node()[name() = 'doc']">
        <xsl:if test="@title">
            <h4><a class="toc" href="#toc"><xsl:text>&#8592;</xsl:text></a><xsl:element name="a"><xsl:attribute name="name">doc-<xsl:choose><xsl:when test="@name"><xsl:value-of select="@name"/></xsl:when><xsl:otherwise><xsl:value-of select="generate-id(.)"/></xsl:otherwise></xsl:choose></xsl:attribute><xsl:call-template name="initCapWords"><xsl:with-param name="input" select="translate(@title,'-',' ')"></xsl:with-param></xsl:call-template></xsl:element></h4>
        </xsl:if>
            <xsl:apply-templates mode="spec" select="*|comment()"/>            
          </xsl:when>
          <xsl:otherwise>
        <xsl:if test="@title">
            <h3><a class="toc" href="#toc"><xsl:text>&#8592;</xsl:text></a> <xsl:apply-templates mode="doc-number" select="."/><xsl:text> </xsl:text><xsl:element name="a"><xsl:attribute name="name">doc-<xsl:choose><xsl:when test="@name"><xsl:value-of select="@name"/></xsl:when><xsl:otherwise><xsl:value-of select="generate-id(.)"/></xsl:otherwise></xsl:choose></xsl:attribute><xsl:call-template name="initCapWords"><xsl:with-param name="input" select="translate(@title,'-',' ')"></xsl:with-param></xsl:call-template></xsl:element></h3>
        </xsl:if>
        <div class="doc">
            <xsl:apply-templates mode="spec" select="*|comment()"/>            
        </div>
          </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- picture -->
    
    <xsl:template match="node()[name()='picture']" mode="spec">
        <xsl:element name="table"><xsl:attribute name="class">pre</xsl:attribute><xsl:if test="@title"><xsl:attribute name="summary"><xsl:value-of select="@title"/></xsl:attribute></xsl:if>
            <xsl:if test="@title"><caption style="caption-side:bottom">Figure <xsl:apply-templates mode="figure-number" select="."/>: <xsl:value-of select="@title"/></caption></xsl:if>
<tr><td>
<xsl:apply-templates select="*|text()" mode="spec"/>    
</td></tr></xsl:element>
    </xsl:template>

    <!-- xref -->
<xsl:template match="node()[name()='xref']" mode="spec">
    <xsl:variable name="ref" select="@name"/>
    <xsl:choose>
        <!-- section xref -->
        <xsl:when test="ancestor-or-self::node()/descendant-or-self::node()[name()='section' and @name=$ref]">
            <xsl:element name="a"><xsl:attribute name="href">#section-<xsl:value-of select="@name"/></xsl:attribute><xsl:attribute name="title"><xsl:value-of select="@name"/></xsl:attribute>section <xsl:apply-templates mode="section-number" select="ancestor-or-self::node()/descendant-or-self::node()[name()='section' and @name=$ref]"/></xsl:element>
        </xsl:when>
        <!-- type xref -->
        <xsl:when test="@choice and ancestor-or-self::node()/descendant-or-self::node()[name()='type' and @name=$ref]">
            <xsl:element name="a"><xsl:attribute name="href">#choice-<xsl:value-of select="@name"/>-<xsl:value-of select="@choice"/></xsl:attribute><xsl:value-of select="@choice"/></xsl:element>
        </xsl:when>
        <xsl:when test="ancestor-or-self::node()/descendant-or-self::node()[name()='type' and @name=$ref]">
            <xsl:element name="a"><xsl:attribute name="href">#type-<xsl:value-of select="@name"/></xsl:attribute><xsl:choose>
<xsl:when test="text()"><xsl:attribute name="title"><xsl:value-of select="@name"/></xsl:attribute><xsl:value-of select="text()"/></xsl:when>
<xsl:when test="ancestor::node()[name()='field' and @type=$ref]"><xsl:attribute name="title"><xsl:value-of select="@name"/></xsl:attribute>subsection <xsl:apply-templates mode="type-number" select="ancestor-or-self::node()/descendant-or-self::node()[name()='type' and @name=$ref]"/></xsl:when>
<xsl:otherwise><xsl:value-of select="@name"/></xsl:otherwise>
</xsl:choose></xsl:element>
        </xsl:when>
        <!-- doc xref -->
        <xsl:when test="ancestor-or-self::node()/descendant-or-self::node()[name()='doc' and @name=$ref]">
            <xsl:element name="a"><xsl:attribute name="href">#doc-<xsl:value-of select="@name"/></xsl:attribute><xsl:attribute name="title"><xsl:value-of select="@name"/></xsl:attribute>subsection <xsl:apply-templates mode="doc-number" select="ancestor-or-self::node()/descendant-or-self::node()[name()='doc' and @name=$ref]"/></xsl:element>
        </xsl:when>
        <!-- definition xref -->
        <xsl:when test="ancestor-or-self::node()/descendant-or-self::node()[name()='definition' and @name=$ref]">
            <xsl:element name="a"><xsl:attribute name="href">#definition-<xsl:value-of select="@name"/></xsl:attribute><xsl:value-of select="ancestor-or-self::node()/descendant-or-self::node()[name()='definition' and @name=$ref]/@value"/> (<xsl:value-of select="@name"/>)</xsl:element>
        </xsl:when>
        <xsl:when test="@type='extern'">
            <xsl:element name="a"><xsl:attribute name="href"><xsl:value-of select="@name"/></xsl:attribute><xsl:choose><xsl:when test="text()"><xsl:value-of select="text()"/></xsl:when><xsl:otherwise><xsl:value-of select="@name"/></xsl:otherwise></xsl:choose></xsl:element>
        </xsl:when>
        <xsl:otherwise><xsl:variable name="type"><xsl:choose><xsl:when test="@type"><xsl:value-of select="@type"/></xsl:when><xsl:otherwise>any</xsl:otherwise></xsl:choose></xsl:variable><xsl:variable name="xrefList"><xsl:call-template name="crossPartXref"><xsl:with-param name="ref" select="@name"/><xsl:with-param name="type" select="$type"/></xsl:call-template></xsl:variable><xsl:choose>
             <xsl:when test="contains($xrefList, '|')">
<xsl:variable name="file" select="substring-before($xrefList, '%')"/>
<xsl:variable name="href" select="substring-after(substring-before($xrefList,'|'),'%')"/>
<xsl:variable name="version"><xsl:value-of select="document('../output/metadata.xml')/descendant::node()[name()='version']"/></xsl:variable>
<xsl:variable name="baseURL"><xsl:value-of select="document('../output/metadata.xml')/descendant::node()[name()='baseURL']"/></xsl:variable>
<xsl:variable name="docVersion"><xsl:value-of select="document('../output/metadata.xml')/descendant::node()[name()='docVersion']"/></xsl:variable>
<xsl:variable name="document"><xsl:value-of select="document('../output/metadata.xml')/descendant::node()[name()='document']"/></xsl:variable>
<xsl:element name="a"><xsl:attribute name="href"><xsl:value-of select="concat($baseURL, '/v', $version, '/', $docVersion, '/', $document, '-', $file, '-v', $version, '-', $docVersion, '.html#')"/><xsl:choose>
   <xsl:when test="@choice"><xsl:value-of select="concat('choice-', @name, '-', @choice)"/></xsl:when>
   <xsl:when test="$href='part'">toc</xsl:when>
   <xsl:otherwise><xsl:value-of select="concat($href, '-', @name)"/></xsl:otherwise>
</xsl:choose></xsl:attribute><xsl:choose>
    <xsl:when test="@type='part'"><xsl:choose><xsl:when test="text()"><xsl:value-of select="text()"/></xsl:when><xsl:otherwise><xsl:call-template name="initCapWords"><xsl:with-param name="input" select="@name"/></xsl:call-template></xsl:otherwise></xsl:choose></xsl:when>
    <xsl:when test="@choice"><xsl:value-of select="@choice"/></xsl:when>
    <xsl:when test="$href='section'"><xsl:attribute name="title"><xsl:value-of select="@name"/></xsl:attribute>section <xsl:value-of select="substring-after(substring-before($xrefList,'@'),'|')"/></xsl:when>
    <xsl:when test="$href='doc'"><xsl:attribute name="title"><xsl:value-of select="@name"/></xsl:attribute>subsection <xsl:value-of select="substring-after(substring-before($xrefList,'@'),'|')"/></xsl:when>
    <xsl:otherwise><xsl:value-of select="@name"/></xsl:otherwise></xsl:choose></xsl:element></xsl:when>
             <xsl:otherwise><xsl:value-of select="@name"/></xsl:otherwise>
          </xsl:choose></xsl:otherwise>
    </xsl:choose>    
</xsl:template>

<xsl:template name="crossPartXref"><xsl:param name="ref"/><xsl:param name="type" select="any"/><xsl:for-each select="document('index.xml')/descendant::node()[name()='xref' and @type='amqp']"><xsl:variable name="file"><xsl:value-of select="@name"/>.xml</xsl:variable><xsl:choose>
      <xsl:when test="document($file)/descendant-or-self::node()[name()='amqp' and @name=$ref and ($type = 'any' or $type='part')]"><xsl:value-of select="@name"/>%part|<xsl:apply-templates mode="part-number" select="document($file)/descendant-or-self::node()[name()='amqp' and @name=$ref]"/>@</xsl:when>
      <xsl:when test="document($file)/descendant-or-self::node()[name()='section' and @name=$ref and ($type = 'any' or $type='section')]"><xsl:value-of select="@name"/>%section|<xsl:apply-templates mode="section-number" select="document($file)/descendant-or-self::node()[name()='section' and @name=$ref]"/>@</xsl:when>
      <xsl:when test="document($file)/descendant-or-self::node()[name()='type' and @name=$ref and ($type = 'any' or $type='type')]"><xsl:value-of select="@name"/>%type|</xsl:when>
      <xsl:when test="document($file)/descendant-or-self::node()[name()='doc' and @name=$ref and ($type = 'any' or $type='doc')]"><xsl:value-of select="@name"/>%doc|<xsl:apply-templates mode="doc-number" select="document($file)/descendant-or-self::node()[name()='doc' and @name=$ref]"/>@</xsl:when>
      <xsl:when test="document($file)/descendant-or-self::node()[name()='definition' and @name=$ref]"><xsl:value-of select="@name"/>%definition|</xsl:when>
      <xsl:when test="document($file)/descendant-or-self::node()[name()='anchor' and @name=$ref]"><xsl:value-of select="@name"/>%anchor|</xsl:when>
      <xsl:otherwise/>
</xsl:choose></xsl:for-each></xsl:template>
        
    <!-- todo -->
    <xsl:template match="node()[name()='todo']" mode="spec"><span class="todo"><xsl:apply-templates select="*|text()" mode="spec"/></span></xsl:template>
    
    <!-- primitive type -->
    <xsl:template match="node()[name()='type' and @class='primitive']" mode="spec">
        <h3><a class="toc" href="#toc"><xsl:text>&#8592;</xsl:text></a> <xsl:apply-templates mode="type-number" select="."/><xsl:text> </xsl:text> <xsl:element name="a"><xsl:attribute name="name">type-<xsl:value-of select="@name"/></xsl:attribute><xsl:value-of select="@name"/></xsl:element></h3>
<xsl:if test="@label"><p><xsl:call-template name="initCap"><xsl:with-param name="input" select="@label"/></xsl:call-template>.</p>
</xsl:if>
        <xsl:apply-templates select="." mode="type-signature"/>
        <xsl:apply-templates select="node()[name()='doc']" mode="spec"/>
        <xsl:apply-templates select="encoding/node()[name()='doc']" mode="spec"/>
    </xsl:template>        
    
    
    
    <!-- composite type -->
    <xsl:template match="node()[name()='type' and @class='composite']" mode="spec">
        <h3><a class="toc" href="#toc"><xsl:text>&#8592;</xsl:text></a> <xsl:apply-templates mode="type-number" select="."/><xsl:text> </xsl:text> <xsl:element name="a"><xsl:attribute name="name">type-<xsl:value-of select="@name"/></xsl:attribute><xsl:call-template name="initCapWords"><xsl:with-param name="input" select="translate(@name,'-',' ')"></xsl:with-param></xsl:call-template></xsl:element></h3>
<xsl:if test="@label"><p><xsl:call-template name="initCap"><xsl:with-param name="input" select="@label"/></xsl:call-template>.</p>
</xsl:if>
        <xsl:apply-templates select="." mode="type-signature"/>        
        <xsl:apply-templates select="node()[name()='doc']" mode="spec"/>
        <xsl:element name="table"><xsl:attribute name="class">composite</xsl:attribute><xsl:attribute name="summary"><xsl:value-of select="@name"/> fields</xsl:attribute>
        <xsl:for-each select="node()[name()='field']">    
            <tr><td><b><xsl:value-of select="@name"/></b></td><td><i><xsl:value-of select="@label"/></i></td><td><xsl:choose>
                <xsl:when test="@mandatory">mandatory</xsl:when>
                <xsl:otherwise>optional</xsl:otherwise>
            </xsl:choose><xsl:text> </xsl:text><xsl:call-template name="genTypeXref"><xsl:with-param name="type" select="@type"/></xsl:call-template><xsl:if test="@multiple">[]</xsl:if></td></tr>            
            <tr><td class="field" colspan="2"><xsl:apply-templates select="node()[name()='doc' or name()='error']" mode="spec"/></td></tr>
        </xsl:for-each>
        </xsl:element>
    </xsl:template>
    
    <!-- restricted type -->
    <xsl:template match="node()[name()='type' and @class='restricted']" mode="spec">
        <xsl:variable name="name"><xsl:value-of select="@name"/></xsl:variable>
        <h3><a class="toc" href="#toc"><xsl:text>&#8592;</xsl:text></a> <xsl:apply-templates mode="type-number" select="."/><xsl:text> </xsl:text> <xsl:element name="a"><xsl:attribute name="name">type-<xsl:value-of select="@name"/></xsl:attribute><xsl:call-template name="initCapWords"><xsl:with-param name="input" select="translate(@name,'-',' ')"></xsl:with-param></xsl:call-template></xsl:element></h3>
<xsl:if test="@label"><p><xsl:call-template name="initCap"><xsl:with-param name="input" select="@label"/></xsl:call-template>.</p>
</xsl:if>
        <xsl:apply-templates select="." mode="type-signature"/>
        <xsl:apply-templates select="node()[name()='doc']" mode="spec"/>
        <xsl:element name="table"><xsl:attribute name="class">composite</xsl:attribute><xsl:attribute name="summary">possible values</xsl:attribute>
            <xsl:for-each select="node()[name()='choice']">
                <tr><td><b><xsl:element name="a"><xsl:attribute name="class">anchor</xsl:attribute><xsl:attribute name="name">choice-<xsl:value-of select="$name"/>-<xsl:value-of select="@name"/></xsl:attribute><xsl:value-of select="@name"/></xsl:element></b></td><td></td><td><xsl:value-of select="@value"/></td></tr>
            <tr><td class="field" colspan="2"><xsl:apply-templates select="node()[name()='doc' or name()='error']" mode="spec"/></td></tr>
            </xsl:for-each>
        </xsl:element>    
    </xsl:template>

    <!-- type signature -->
    <xsl:template match="node()[name()='type']" mode="type-signature">
        <table class="signature" summary="@(label)"><tr>
<td>&#60;type<xsl:if test="@name"><xsl:text> </xsl:text>name="<xsl:value-of select="@name"/>"</xsl:if><xsl:if test="@class"><xsl:text> </xsl:text>class="<xsl:value-of select="@class"/>"</xsl:if><xsl:if test="@source"><xsl:text> </xsl:text>source="<xsl:value-of select="@source"/>"</xsl:if><xsl:if test="@provides"><xsl:text> </xsl:text>provides="<xsl:value-of select="@provides"/>"</xsl:if><xsl:if test="not( node()[name() = 'field' or name() = 'choice' or name() = 'descriptor' or name() = 'encoding'])">/</xsl:if>&#62;<xsl:if test="node()[name() = 'field' or name() = 'choice' or name() = 'descriptor' or name() = 'encoding']">
<xsl:apply-templates select="node()[name()='field' or name()='choice' or name()='descriptor' or name() = 'encoding']" mode="type-signature"/><xsl:text>
&#60;/type&#62;</xsl:text>    
</xsl:if>
        </td></tr></table>
    </xsl:template>
    
    <xsl:template match="node()[name()='descriptor']" mode="type-signature">
<xsl:text>
    </xsl:text>&#60;descriptor<xsl:if test="@name"><xsl:text> </xsl:text>name="<xsl:value-of select="@name"/>"</xsl:if><xsl:if test="@code"><xsl:text> </xsl:text>code="<xsl:value-of select="@code"/>"</xsl:if><xsl:text>/&#62;</xsl:text>        
    </xsl:template>
    
    <xsl:template match="node()[name()='choice']" mode="type-signature">
<xsl:text>
    </xsl:text>&#60;choice<xsl:for-each select="attribute::node()[name() != 'label']"><xsl:text> </xsl:text><xsl:value-of select="name()"/>="<xsl:value-of select="."/>"</xsl:for-each><xsl:text>/&#62;</xsl:text>        
    </xsl:template>
    
    <xsl:template match="node()[name()='field']" mode="type-signature">
<xsl:text>
    </xsl:text>&#60;field<xsl:for-each select="attribute::node()[name() != 'label']"><xsl:text> </xsl:text><xsl:value-of select="name()"/>="<xsl:value-of select="."/>"</xsl:for-each><xsl:if test="not( node()[name()='error'] )"><xsl:text>/</xsl:text></xsl:if>&#62;<xsl:if test="node()[name()='error']">
<xsl:apply-templates mode="type-signature" select="node()[name()='error']"/><xsl:text>
    &#60;/field&#62;</xsl:text></xsl:if>        
    </xsl:template>

    <xsl:template match="node()[name()='error']" mode="type-signature">
<xsl:text>
        </xsl:text>&#60;error<xsl:for-each select="attribute::node()[name() != 'label']"><xsl:text> </xsl:text><xsl:value-of select="name()"/>="<xsl:value-of select="."/>"</xsl:for-each><xsl:text>/&#62;</xsl:text>        
    </xsl:template>

    <xsl:template match="node()[name()='encoding']" mode="type-signature">
<xsl:text>
    </xsl:text>&#60;encoding<xsl:if test="@name"><xsl:text> </xsl:text>name="<xsl:value-of select="@name"/>"</xsl:if><xsl:if test="@code"><xsl:text> </xsl:text>code="<xsl:value-of select="@code"/>"</xsl:if><xsl:if test="@category"><xsl:text> </xsl:text>category="<xsl:value-of select="@category"/>"</xsl:if><xsl:if test="@width"><xsl:text> </xsl:text>width="<xsl:value-of select="@width"/>"</xsl:if><xsl:if test="@label"><xsl:text> </xsl:text>label="<xsl:value-of select="@label"/>"</xsl:if><xsl:text>/&#62;</xsl:text>        
    </xsl:template>
    

    <!-- encoding -->    
    <xsl:template match="node()[name()='encoding']" mode="spec">
        <tr>
          <td><b><xsl:value-of select="@name"/></b></td>
          <td><xsl:value-of select="@code"/></td>
          <td><xsl:choose>
                <xsl:when test="@category='fixed'">fixed-width, <xsl:value-of select="@width"/>-byte value</xsl:when>
                <xsl:otherwise>variable-width, <xsl:value-of select="@width"/> byte size</xsl:otherwise>
              </xsl:choose></td>
          <td><i><xsl:value-of select="@label"/></i></td>
        </tr>
<xsl:if test="node()[name()='doc']">
        <tr><td/><td colspan="3"><xsl:apply-templates select="node()[name()='doc']" mode="spec"/></td></tr>
</xsl:if>
        
    </xsl:template>    
    

    <!-- TypeListTable comment -->
    <xsl:template match="comment()[self::comment()='TypeListTable']" mode="spec">
        <table class="" summary="Primitive Types">
            <xsl:for-each select="//descendant-or-self::node()[name()='type']">
                <tr><td><xsl:element name="a"><xsl:attribute name="href">#type-<xsl:value-of select="@name"/></xsl:attribute><xsl:value-of select="@name"/></xsl:element></td><td><xsl:value-of select="@label"/></td></tr>
            </xsl:for-each>
        </table>
    </xsl:template>

    <!-- EncodingListTable comment -->
    <xsl:template match="comment()[self::comment()='EncodingListTable']" mode="spec">
        <table class="" summary="Primitive Type Encodings">
            <tr><th>Type</th><th>Encoding</th><th>Code</th><th>Category</th><th>Description</th></tr>
            <xsl:for-each select="//descendant-or-self::node()[name()='type']">
                <xsl:variable name="type" select="@name"/>
                <xsl:for-each select="node()[name()='encoding']">
                    <tr>
                        <td><xsl:element name="a"><xsl:attribute name="href">#type-<xsl:value-of select="$type"/></xsl:attribute><xsl:value-of select="$type"/></xsl:element></td>
                        <td><xsl:value-of select="@name"/></td>
                        <td><xsl:value-of select="@code"/></td>
                        <td><xsl:value-of select="@category"/>/<xsl:value-of select="@width"/></td>
                        <td><xsl:value-of select="@label"/></td>
                    </tr>
                </xsl:for-each>                
            </xsl:for-each>
        </table>
    </xsl:template>
    
    <!-- RevisionHistory comment -->
    <xsl:template match="comment()[self::comment()='RevisionHistory']" mode="spec">
      <xsl:for-each select="document('../output/versions.xml')/versions/version">
        <xsl:variable name="version" select="@name"/>
        <table class="RevisionHistory" summary="Document Revision History">
<tr><th colspan="2"><xsl:value-of select="substring-before(@date,'T')"/> : <xsl:value-of select="@title"/></th></tr>
      <xsl:for-each select="document('../output/version-history.xml')/version-history/version[@name = $version]/jira">
      <xsl:element name="tr">
        <td class="issue"><xsl:element name="a"><xsl:attribute name="href"><xsl:value-of select="@url"/></xsl:attribute><xsl:value-of select="@id"/></xsl:element> :</td><td><xsl:value-of select="text()"/></td>
      </xsl:element>
      </xsl:for-each>
        </table>
      </xsl:for-each>
    </xsl:template>

    <xsl:template match="node()[name()='section' and @name='revhistory']" mode="spec">
        <xsl:variable name="title"><xsl:choose>
            <xsl:when test="@title"><xsl:value-of select="@title"/></xsl:when>
            <xsl:otherwise><xsl:call-template name="initCapWords"><xsl:with-param name="input" select="translate(@name,'-',' ')"/></xsl:call-template></xsl:otherwise>
        </xsl:choose>
        </xsl:variable>
        <h2><a class="toc" href="#toc"><xsl:text>&#8592;</xsl:text></a> <xsl:apply-templates mode="section-number" select="."/><xsl:text> </xsl:text><xsl:element name="a"><xsl:attribute name="name">section-<xsl:value-of select="@name"/></xsl:attribute><xsl:value-of select="$title"/></xsl:element></h2>
      <xsl:for-each select="doc">
        <table class="RevisionHistory" summary="Document Revision History">
<tr><th colspan="2"><xsl:value-of select="substring-after(@title,' : ')"/> : <xsl:value-of select="substring-before(@title,' : ')"/></th></tr>
      <xsl:for-each select="ul/li/p">
      <xsl:element name="tr">
        <td class="issue"><xsl:element name="a"><xsl:attribute name="href">https://tools.oasis-open.org:443/issues/browse/<xsl:value-of select="substring-before(text(), ' :')"/></xsl:attribute><xsl:value-of select="substring-before(text(), ' :')"/></xsl:element> :</td><td><xsl:value-of select="substring-after(text(), ': ')"/></td>
      </xsl:element>
      </xsl:for-each>
        </table>
      </xsl:for-each>
    </xsl:template>

    <!-- text -->

    <xsl:template match="text()" mode="spec"><xsl:value-of select="."/></xsl:template>

    <!-- error -->
    
    <xsl:template match="node()[name()='error']" mode="spec">
        <table class="error" summary="">
            <tr>
                <td><b><xsl:value-of select="@name"/> error:</b> </td>
                
                <td align="right"><xsl:element name="a"><xsl:attribute name="href"><xsl:call-template name="genErrorXref"><xsl:with-param name="type" select="@value"/></xsl:call-template></xsl:attribute><xsl:value-of select="@value"/></xsl:element></td>
            </tr>
            <tr><td colspan="2"><xsl:apply-templates select="node()[name()='doc']" mode="spec"/></td></tr>
        </table>        
    </xsl:template>
    
    <!-- definition -->

    <xsl:template mode="spec" match="node()[name()='definition']">
<xsl:if test="count(preceding-sibling::node()[name()='definition']) = 0">
<h3><a class="toc" href="#toc"><xsl:text>&#8592;</xsl:text></a><xsl:apply-templates mode="type-number" select="."/><xsl:text> </xsl:text> <xsl:element name="a"><xsl:attribute name="name">definition-<xsl:value-of select="generate-id(.)"/></xsl:attribute>Constant Definitions</xsl:element></h3>
  <table class="constants">
<tr><td><xsl:element name="a"><xsl:attribute name="name">definition-<xsl:value-of select="@name"/></xsl:attribute><xsl:value-of select="@name"/></xsl:element> </td>
<td> <xsl:value-of select="@value"/> </td>
<td> <xsl:value-of select="@label"/>. </td>
</tr>
<xsl:if test="node()[name()='doc']">
<tr><td colspan="2"/><td><xsl:apply-templates mode="spec" select="node()[name()='doc']"/></td></tr>
</xsl:if>
<xsl:for-each select="following-sibling::node()[name()='definition']">
<tr><td><xsl:element name="a"><xsl:attribute name="name">definition-<xsl:value-of select="@name"/></xsl:attribute><xsl:value-of select="@name"/></xsl:element> </td> 
<td> <xsl:value-of select="@value"/> </td> 
<td> <xsl:value-of select="@label"/>. </td>
</tr>
<xsl:if test="node()[name()='doc']">
<tr><td colspan="2"/><td><xsl:apply-templates mode="spec" select="node()[name()='doc']"/></td></tr>
</xsl:if>

</xsl:for-each>
  </table>
</xsl:if>
    </xsl:template>

    <!-- pass through tags -->

    <xsl:template match="node()[name() = 'br']" mode="spec"><xsl:element name="br"/></xsl:template> 
    <xsl:template match="node()[name() = 'anchor']" mode="spec"><xsl:element name="a"><xsl:attribute name="name">anchor-<xsl:value-of select="@name"/></xsl:attribute><xsl:choose><xsl:when test="text()"><xsl:apply-templates mode="spec" select="*|text()"/></xsl:when><xsl:otherwise><xsl:value-of select="@name"/></xsl:otherwise></xsl:choose></xsl:element></xsl:template> 
    <xsl:template match="node()[name() = 'p']" mode="spec"> 
        <xsl:if test="@title"><h4><xsl:value-of select="@title"/></h4></xsl:if>
        <xsl:element name="p"><xsl:if test="@title"><xsl:attribute name="title"><xsl:value-of select="@title"/></xsl:attribute></xsl:if><xsl:apply-templates mode="spec" select="*|text()"/></xsl:element>                
    </xsl:template>
    <xsl:template match="node()[name() = 'i']" mode="spec"> 
        <xsl:element name="i"><xsl:if test="@title"><xsl:attribute name="title"><xsl:value-of select="@title"/></xsl:attribute></xsl:if><xsl:apply-templates mode="spec" select="*|text()"/></xsl:element>                
    </xsl:template>
    <xsl:template match="node()[name() = 'term']" mode="spec"> 
        <xsl:element name="i"><xsl:if test="@title"><xsl:attribute name="title"><xsl:value-of select="@title"/></xsl:attribute></xsl:if><xsl:apply-templates mode="spec" select="*|text()"/></xsl:element>                
    </xsl:template>
    <xsl:template match="node()[name() = 'sub']" mode="spec"> 
        <xsl:element name="sub"><xsl:apply-templates mode="spec" select="*|text()"/></xsl:element>                
    </xsl:template>
    <xsl:template match="node()[name() = 'sup']" mode="spec"> 
        <xsl:element name="sup"><xsl:apply-templates mode="spec" select="*|text()"/></xsl:element>                
    </xsl:template>
    <xsl:template match="node()[name() = 'b']" mode="spec"> 
        <xsl:element name="b"><xsl:if test="@title"><xsl:attribute name="title"><xsl:value-of select="@title"/></xsl:attribute></xsl:if><xsl:apply-templates mode="spec" select="*|text()"/></xsl:element>                
    </xsl:template>
    <xsl:template match="node()[name() = 'ol']" mode="spec"> 
        <xsl:element name="ol"><xsl:if test="@title"><xsl:attribute name="title"><xsl:value-of select="@title"/></xsl:attribute></xsl:if><xsl:apply-templates mode="spec" select="*|text()"/></xsl:element>                
    </xsl:template>
    <xsl:template match="node()[name() = 'ul']" mode="spec"> 
        <xsl:element name="ul"><xsl:if test="@title"><xsl:attribute name="title"><xsl:value-of select="@title"/></xsl:attribute></xsl:if><xsl:apply-templates mode="spec" select="*|text()"/></xsl:element>                
    </xsl:template>
    <xsl:template match="node()[name() = 'li']" mode="spec"> 
        <xsl:element name="li"><xsl:if test="@title"><xsl:attribute name="title"><xsl:value-of select="@title"/></xsl:attribute></xsl:if><xsl:apply-templates mode="spec" select="*|text()"/></xsl:element>                
    </xsl:template>
    <xsl:template match="node()[name() = 'dl']" mode="spec"> 
        <xsl:element name="dl"><xsl:if test="@title"><xsl:attribute name="title"><xsl:value-of select="@title"/></xsl:attribute></xsl:if><xsl:apply-templates mode="spec" select="*|text()"/></xsl:element>                
    </xsl:template>
    <xsl:template match="node()[name() = 'dt']" mode="spec"> 
        <xsl:element name="dt"><xsl:if test="@title"><xsl:attribute name="title"><xsl:value-of select="@title"/></xsl:attribute></xsl:if><xsl:apply-templates mode="spec" select="*|text()"/></xsl:element>                
    </xsl:template>
    <xsl:template match="node()[name() = 'dd']" mode="spec"> 
        <xsl:element name="dd"><xsl:if test="@title"><xsl:attribute name="title"><xsl:value-of select="@title"/></xsl:attribute></xsl:if><xsl:apply-templates mode="spec" select="*|text()"/></xsl:element>                
    </xsl:template>
    
    

    <!-- Document specific utilities -->

    <xsl:template name="count-third-level">
      <xsl:variable name="docNodes" select="count(preceding-sibling::node()[name()='doc' and attribute::title])"/>
      <xsl:variable name="initialTypes" select="count(preceding-sibling::node()[name()='type' and count(preceding-sibling::node()[name()='doc' and @title])=0])"/>
      <xsl:variable name="typesFollow" select="count(preceding-sibling::node()[name()='type' and count(preceding-sibling::node()[name()='doc' and @title])!=0 and count(preceding-sibling::node()[name()='doc' and @title][1]/descendant::node())>0])"/>
      <xsl:variable name="constants">
        <xsl:choose>
          <xsl:when test="preceding-sibling::node()[name()='definition']">1</xsl:when>
          <xsl:otherwise>0</xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <xsl:value-of select="1 + $docNodes + $initialTypes + $typesFollow + $constants"/>
    </xsl:template> 

    <xsl:template mode="part-number" match="node()[name()='amqp']"><xsl:variable name="title" select="@name"/><xsl:apply-templates mode="partNo" select="document('index.xml')/descendant::node()[name()='xref' and @name=$title]"/></xsl:template>
    <xsl:template mode="section-number" match="node()[name()='section']"><xsl:apply-templates mode="part-number" select="ancestor::node()[name()='amqp']"/>.<xsl:value-of select="count(preceding-sibling::node()[name()='section'])+1"/></xsl:template>
    <xsl:template mode="figure-number" match="node()[name()='picture']"><xsl:apply-templates mode="part-number" select="ancestor::node()[name()='amqp']"/>.<xsl:value-of select="count(ancestor-or-self::node()/preceding-sibling::node()/descendant-or-self::node()[name()='picture' and @title])+1"/></xsl:template>    
    <xsl:template mode="doc-number" match="node()[name()='doc']"><xsl:apply-templates mode="section-number" select="ancestor::node()[name()='section']"/>.<xsl:call-template name="count-third-level"/></xsl:template>    
    <xsl:template mode="type-number" match="node()[name()='type']">
        <xsl:choose>
            <xsl:when test="count(preceding-sibling::node()[name()='doc'])>0 and count(preceding-sibling::node()[name()='doc'][1]/descendant::node())=0">
                <xsl:variable name="doc-node" select="preceding-sibling::node()[name()='doc' and attribute::title]"/>
                <xsl:variable name="docPriorConstants"><xsl:choose><xsl:when test="$doc-node/preceding-sibling::node()[name()='definition']">1</xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></xsl:variable>
                <xsl:variable name="offset" select="count($doc-node/preceding-sibling::node()[name()='type']) + $docPriorConstants"></xsl:variable>
                <xsl:variable name="priorConstants"><xsl:choose><xsl:when test="preceding-sibling::node()[name()='definition']">1</xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></xsl:variable>
                <xsl:apply-templates mode="section-number" select="ancestor::node()[name()='section']"/>.<xsl:value-of select="count(preceding-sibling::node()[name()='doc' and attribute::title])"/>.<xsl:value-of select="1+count(preceding-sibling::node()[name()='type']) + $priorConstants - $offset"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates mode="section-number" select="ancestor::node()[name()='section']"/>.<xsl:call-template name="count-third-level"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template mode="type-number" match="node()[name()='definition']">
                <xsl:apply-templates mode="section-number" select="ancestor::node()[name()='section']"/>.<xsl:call-template name="count-third-level"/>
    </xsl:template>
    <xsl:template name="genTypeXref">
        <xsl:param name="type"/>
        <xsl:choose>
            <xsl:when test="$type='*'">*</xsl:when>
            <xsl:otherwise><xsl:element name="a"><xsl:attribute name="href"><xsl:choose>                
                <xsl:when test="/ancestor-or-self::node()/descendant-or-self::node()[name()='type' and @name=$type]">#type-<xsl:value-of select="$type"/></xsl:when>
            <xsl:otherwise>
                <xsl:for-each select="document('index.xml')/descendant-or-self::node()[name()='xref' and @type='amqp']">
                    <xsl:variable name="docname"><xsl:value-of select="@name"/>.xml</xsl:variable>
                    <xsl:if test="document($docname)/descendant-or-self::node()[name()='type' and @name=$type]">
<xsl:variable name="version"><xsl:value-of select="document('../output/metadata.xml')/descendant::node()[name()='version']"/></xsl:variable>
<xsl:variable name="baseURL"><xsl:value-of select="document('../output/metadata.xml')/descendant::node()[name()='baseURL']"/></xsl:variable>
<xsl:variable name="docVersion"><xsl:value-of select="document('../output/metadata.xml')/descendant::node()[name()='docVersion']"/></xsl:variable>
<xsl:variable name="document"><xsl:value-of select="document('../output/metadata.xml')/descendant::node()[name()='document']"/></xsl:variable>
<xsl:value-of select="concat($baseURL, '/v', $version, '/', $docVersion, '/', $document, '-', @name, '-v', $version, '-', $docVersion, '.html#')"/>type-<xsl:value-of select="$type"/></xsl:if>
                </xsl:for-each>
            </xsl:otherwise>
            </xsl:choose></xsl:attribute><xsl:value-of select="$type"/></xsl:element>
            </xsl:otherwise>
        </xsl:choose>        
    </xsl:template>
    
    <xsl:template name="genErrorXref">
        <xsl:param name="type"/>
        <xsl:choose>
            <xsl:when test="/ancestor-or-self::node()/descendant-or-self::node()[name()='type' and @provides='error']/node()[name()='choice' and @name=$type]">#choice-<xsl:value-of select="/ancestor-or-self::node()/descendant-or-self::node()[name()='type' and @provides='error' and child::node()[name()='choice' and @name=$type]]/@name"/>-<xsl:value-of select="$type"/></xsl:when>
            <xsl:otherwise>
                <xsl:for-each select="document('index.xml')/descendant-or-self::node()[name()='xref' and @type='amqp']">
                    <xsl:variable name="docname"><xsl:value-of select="@name"/>.xml</xsl:variable>
                    <xsl:if test="document($docname)/descendant-or-self::node()[name()='type' and @provides='error']/node()[name()='choice' and @name=$type]">
                        #choice-<xsl:value-of select="document($docname)/descendant-or-self::node()[name()='type' and @provides='error' and child::node()[name()='choice' and @name=$type]]/@name"/>-<xsl:value-of select="$type"/>                        
                    </xsl:if>
                </xsl:for-each>
            </xsl:otherwise>
        </xsl:choose>            
    </xsl:template>
    <!-- General Utilities -->
    
    <xsl:template name="toUpper"><xsl:param name="input"/><xsl:value-of select="translate($input,'abcdefghijklmnopqrstuvwxyz','ABCDEFGHIJKLMNOPQRSTUVWXYZ')"></xsl:value-of></xsl:template>
    <xsl:template name="toLower"><xsl:param name="input"/><xsl:value-of select="translate($input,'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz')"></xsl:value-of></xsl:template>
    <xsl:template name="initCap"><xsl:param name="input"/><xsl:call-template name="toUpper"><xsl:with-param name="input" select="substring($input,1,1)"/></xsl:call-template><xsl:value-of select="substring($input,2)"/></xsl:template>
    <xsl:template name="initCapWords">
        <xsl:param name="input"/>
        <xsl:choose>
            <xsl:when test="contains($input,' ')">
                <xsl:call-template name="initCap"><xsl:with-param name="input" select="substring-before($input, ' ')"/></xsl:call-template><xsl:text> </xsl:text><xsl:call-template name="initCapWords"><xsl:with-param name="input" select="substring-after($input, ' ')"/></xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="initCap"><xsl:with-param name="input" select="$input"/></xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
</xsl:stylesheet>
