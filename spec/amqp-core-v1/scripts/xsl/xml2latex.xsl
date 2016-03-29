<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:param name="completeDoc"/>
<xsl:output method="text"/>
<xsl:template match="node()[name()='amqp']">
<xsl:variable name="oasisTitle"><xsl:call-template name="nohyphens"><xsl:with-param name="input"><xsl:value-of select="document('../output/metadata.xml')/descendant::node()[name()='title']"/></xsl:with-param></xsl:call-template></xsl:variable>
<xsl:variable name="version"><xsl:value-of select="document('../output/metadata.xml')/descendant::node()[name()='version']"/></xsl:variable>
<xsl:variable name="baseURL"><xsl:value-of select="document('../output/metadata.xml')/descendant::node()[name()='baseURL']"/></xsl:variable>
<xsl:variable name="docVersion"><xsl:value-of select="document('../output/metadata.xml')/descendant::node()[name()='docVersion']"/></xsl:variable>
<xsl:variable name="document"><xsl:value-of select="document('../output/metadata.xml')/descendant::node()[name()='document']"/></xsl:variable>
<xsl:variable name="oasisTCId"><xsl:value-of select="document('../output/metadata.xml')/descendant::node()[name()='committeeId']"/></xsl:variable>
\documentclass{<xsl:choose><xsl:when test="$completeDoc">report</xsl:when><xsl:otherwise>article</xsl:otherwise></xsl:choose>}
<xsl:if test="$completeDoc">\renewcommand{\chaptername}{Part}</xsl:if>
<xsl:variable name="title"><xsl:choose><xsl:when test="$completeDoc">complete</xsl:when><xsl:otherwise><xsl:value-of select='@name'/></xsl:otherwise></xsl:choose></xsl:variable>
<xsl:variable name="partNo"><xsl:choose><xsl:when test="$completeDoc"/><xsl:otherwise><xsl:apply-templates mode="partNo" select="document('index.xml')/descendant::node()[name()='xref' and @name=$title]"/></xsl:otherwise></xsl:choose></xsl:variable>
\usepackage{float}
\usepackage{fontenc}
\usepackage{helvet}
\renewcommand*\familydefault{\sfdefault}
\usepackage{enumitem}
\usepackage{longtable}
\usepackage[pdftex,colorlinks,linkcolor=black,citecolor=black,urlcolor=black,bookmarks,bookmarksopen,bookmarksnumbered]{hyperref}
\usepackage{geometry}
\usepackage{fancyhdr}
\usepackage{fancyvrb}
\geometry{letterpaper,textwidth=17.5cm,textheight=23.2cm}
\setlength{\headheight}{15.2pt}
\pagestyle{fancy}
\fancyhf{}%
\lfoot{\small <xsl:value-of select="$document"/>-<xsl:choose><xsl:when test="$completeDoc">complete</xsl:when><xsl:otherwise><xsl:value-of select="@name"/></xsl:otherwise></xsl:choose>-v<xsl:value-of select="$version"/>-<xsl:value-of select="$docVersion"/>\\Standards Track Work Product}%
\cfoot{\small \ \newline Copyright \copyright\ OASIS Open 2012. All Rights Reserved.}%
\rfoot{\small <xsl:value-of select="document('../output/metadata.xml')/descendant::node()[name()='date']"/>\\Page \thepage\ of \pageref{LastPage}}%
\renewcommand{\headrulewidth}{0.4pt}%
\renewcommand{\footrulewidth}{0pt}%
\usepackage{lastpage}
\usepackage{parskip}
\usepackage{titlesec}
\usepackage{graphicx}
\usepackage{xcolor}
\newcommand{\superscript}[1]{\ensuremath{^{\textrm{#1}}}}
\newcommand{\subscript}[1]{\ensuremath{_{\textrm{#1}}}}
\definecolor{oasispurple}{HTML}{3B006F}
\titleformat{\section}
{\color{oasispurple}\normalfont\Large\bfseries}
{\color{oasispurple}\thesection}{1em}{}
\titleformat{\subsection}
{\color{oasispurple}\normalfont\large\bfseries}
{\color{oasispurple}\thesubsection}{1em}{}
<xsl:if test="$completeDoc">
\titlespacing*{\chapter}{0pt}{-10pt}{20pt}
\titleformat{\chapter}
{\color{oasispurple}\normalfont\Huge\bfseries}
{\color{oasispurple}Part \thechapter :}{1em}{}
</xsl:if>
\begin{document}
\renewcommand{\headrulewidth}{0.4pt}
\renewcommand{\footrulewidth}{0pt}
\renewcommand{\sectionmark}[1]{\markright{#1}{}}
\fancypagestyle{plain}{%
\fancyhf{}%
\lfoot{\small <xsl:value-of select="$document"/>-<xsl:choose><xsl:when test="$completeDoc">complete</xsl:when><xsl:otherwise><xsl:value-of select="@name"/></xsl:otherwise></xsl:choose>-v<xsl:value-of select="$version"/>-<xsl:value-of select="$docVersion"/>\\Standards Track Work Product}%
\cfoot{\small \ \newline Copyright \copyright\ OASIS Open 2012. All Rights Reserved.}%
\rfoot{\small <xsl:value-of select="document('../output/metadata.xml')/descendant::node()[name()='date']"/>\\Page \thepage\ of \pageref{LastPage}}%
\renewcommand{\headrulewidth}{0.4pt}%
\renewcommand{\footrulewidth}{0pt}%
}
\begin{titlepage}
\includegraphics{oasis}
\\
\line(1,0){450}
\vspace*{0.2cm}\\
{\Huge{\bfseries\color{oasispurple}<xsl:value-of select="$oasisTitle"/> Version <xsl:value-of select="$version"/>}}<xsl:choose>
<xsl:when test="$completeDoc"></xsl:when>
<xsl:otherwise>\\
{\Huge{\bfseries\color{oasispurple}Part <xsl:value-of select="$partNo"/>: <xsl:call-template name="initCap"><xsl:with-param name="input" select="@name"/></xsl:call-template>}}</xsl:otherwise>
</xsl:choose>\vspace*{0.4cm}\\
<xsl:choose>
<xsl:when test="contains(document('../output/metadata.xml')/descendant::node()[name()='status'],'/')">
{\huge{\bfseries\color{oasispurple}<xsl:value-of select="substring-before(document('../output/metadata.xml')/descendant::node()[name()='status'],'/')"/>/}}\\
{\huge{\bfseries\color{oasispurple}<xsl:value-of select="substring-after(document('../output/metadata.xml')/descendant::node()[name()='status'],'/')"/>}}
</xsl:when>
<xsl:otherwise>
{\huge{\bfseries\color{oasispurple}<xsl:value-of select="document('../output/metadata.xml')/descendant::node()[name()='status']"/>}}</xsl:otherwise>
</xsl:choose>\vspace*{0.4cm}\\
{\huge{\bfseries\color{oasispurple}<xsl:value-of select="document('../output/metadata.xml')/descendant::node()[name()='date']"/>}}
\vspace*{0.6cm}\\
{\Large\bfseries\color{oasispurple}Specification URIs}
\vspace*{0.3cm}\\
{\bfseries\color{oasispurple}This version:}<xsl:variable name="thisVersionUrl"><xsl:value-of select="$baseURL"/>/v<xsl:value-of select="$version"/>/<xsl:value-of select="$docVersion"/>/<xsl:value-of select="$document"/>-<xsl:value-of select="$title"/>-v<xsl:value-of select="$version"/>-<xsl:value-of select="$docVersion"/></xsl:variable>\\<xsl:choose><xsl:when test="$completeDoc"><xsl:variable name="thisVersionOverviewUrl"><xsl:value-of select="$baseURL"/>/v<xsl:value-of select="$version"/>/<xsl:value-of select="$docVersion"/>/<xsl:value-of select="$document"/>-overview-v<xsl:value-of select="$version"/>-<xsl:value-of select="$docVersion"/></xsl:variable>
\hspace*{1cm}{\small{\href{<xsl:value-of select="$thisVersionOverviewUrl"/>.xml}{<xsl:value-of select="$thisVersionOverviewUrl"/>.xml} (Authoritative)}}\\
\hspace*{1cm}{\small{\href{<xsl:value-of select="$thisVersionOverviewUrl"/>.html}{<xsl:value-of select="$thisVersionOverviewUrl"/>.html}}}\\
\hspace*{1cm}{\small{\href{<xsl:value-of select="$thisVersionUrl"/>.pdf}{<xsl:value-of select="$thisVersionUrl"/>.pdf}}}</xsl:when><xsl:otherwise>
\hspace*{1cm}{\small{\href{<xsl:value-of select="$thisVersionUrl"/>.xml}{<xsl:value-of select="$thisVersionUrl"/>.xml} (Authoritative)}}\\
\hspace*{1cm}{\small{\href{<xsl:value-of select="$thisVersionUrl"/>.html}{<xsl:value-of select="$thisVersionUrl"/>.html}}}\\
\hspace*{1cm}{\small{\href{<xsl:value-of select="$thisVersionUrl"/>.pdf}{<xsl:value-of select="$thisVersionUrl"/>.pdf}}}</xsl:otherwise></xsl:choose>
\vspace*{0.2cm}\\
{\bfseries\color{oasispurple}Previous version:}<xsl:choose>
<xsl:when test="document('../output/metadata.xml')/descendant::node()[name()='prevDocVersion']">
<xsl:variable name="prevDocVersion"><xsl:value-of select="document('../output/metadata.xml')/descendant::node()[name()='prevDocVersion']"/></xsl:variable>
<xsl:variable name="prevVersionUrl"><xsl:value-of select="$baseURL"/>/v<xsl:value-of select="$version"/>/<xsl:value-of select="$prevDocVersion"/>/<xsl:value-of select="$document"/>-<xsl:value-of select="$title"/>-v<xsl:value-of select="$version"/>-<xsl:value-of select="$prevDocVersion"/></xsl:variable>\\<xsl:choose><xsl:when test="$completeDoc"><xsl:variable name="prevVersionOverviewUrl"><xsl:value-of select="$baseURL"/>/v<xsl:value-of select="$version"/>/<xsl:value-of select="$prevDocVersion"/>/<xsl:value-of select="$document"/>-overview-v<xsl:value-of select="$version"/>-<xsl:value-of select="$prevDocVersion"/></xsl:variable>
\hspace*{1cm}{\small{\href{<xsl:value-of select="$prevVersionOverviewUrl"/>.xml}{<xsl:value-of select="$prevVersionOverviewUrl"/>.xml} (Authoritative)}}\\
\hspace*{1cm}{\small{\href{<xsl:value-of select="$prevVersionOverviewUrl"/>.html}{<xsl:value-of select="$prevVersionOverviewUrl"/>.html}}}\\
\hspace*{1cm}{\small{\href{<xsl:value-of select="$prevVersionUrl"/>.pdf}{<xsl:value-of select="$prevVersionUrl"/>.pdf}}}</xsl:when><xsl:otherwise>
\hspace*{1cm}{\small{\href{<xsl:value-of select="$prevVersionUrl"/>.html}{<xsl:value-of select="$prevVersionUrl"/>.html}}}\\
\hspace*{1cm}{\small{\href{<xsl:value-of select="$prevVersionUrl"/>.pdf}{<xsl:value-of select="$prevVersionUrl"/>.pdf}}}\\
\hspace*{1cm}{\small{\href{<xsl:value-of select="$prevVersionUrl"/>.xml}{<xsl:value-of select="$prevVersionUrl"/>.xml} (Authoritative)}}</xsl:otherwise></xsl:choose></xsl:when>
<xsl:otherwise>\\
\hspace*{1cm}{\small{N/A}}</xsl:otherwise>
</xsl:choose>
\vspace*{0.2cm}\\
{\bfseries\color{oasispurple}Latest version:}<xsl:variable name="latestVersionUrl"><xsl:value-of select="$baseURL"/>/v<xsl:value-of select="$version"/>/<xsl:value-of select="$document"/>-<xsl:value-of select="$title"/>-v<xsl:value-of select="$version"/></xsl:variable>\\<xsl:choose><xsl:when test="$completeDoc"><xsl:variable name="latestVersionOverviewUrl"><xsl:value-of select="$baseURL"/>/v<xsl:value-of select="$version"/>/<xsl:value-of select="$document"/>-overview-v<xsl:value-of select="$version"/></xsl:variable>
\hspace*{1cm}{\small{\href{<xsl:value-of select="$latestVersionOverviewUrl"/>.xml}{<xsl:value-of select="$latestVersionOverviewUrl"/>.xml} (Authoritative)}}\\
\hspace*{1cm}{\small{\href{<xsl:value-of select="$latestVersionOverviewUrl"/>.html}{<xsl:value-of select="$latestVersionOverviewUrl"/>.html}}}\\
\hspace*{1cm}{\small{\href{<xsl:value-of select="$latestVersionUrl"/>.pdf}{<xsl:value-of select="$latestVersionUrl"/>.pdf}}}</xsl:when><xsl:otherwise>
\hspace*{1cm}{\small{\href{<xsl:value-of select="$latestVersionUrl"/>.html}{<xsl:value-of select="$latestVersionUrl"/>.html}}}\\
\hspace*{1cm}{\small{\href{<xsl:value-of select="$latestVersionUrl"/>.pdf}{<xsl:value-of select="$latestVersionUrl"/>.pdf}}}\\
\hspace*{1cm}{\small{\href{<xsl:value-of select="$latestVersionUrl"/>.xml}{<xsl:value-of select="$latestVersionUrl"/>.xml} (Authoritative)}}</xsl:otherwise></xsl:choose>
\vspace*{0.2cm}\\
{\bfseries\color{oasispurple}Technical Committee:}\\
\hspace*{1cm}{\small\href{http://www.oasis-open.org/committees/<xsl:value-of select="$oasisTCId"/>/}{<xsl:value-of select="$oasisTitle"/> TC}}
\vspace*{0.2cm}\\
{\bfseries\color{oasispurple}Chairs:}<xsl:apply-templates mode="people" select="document('../front-matter/chairs.xml')"/> 
\vspace*{0.2cm}\\
{\bfseries\color{oasispurple}Editors:}<xsl:apply-templates mode="people" select="document('../front-matter/editors.xml')"/> 
\vspace*{0.2cm}\\
\end{titlepage}
\newpage
\section*{}
\vspace*{-1.5cm}
{\bfseries\color{oasispurple}Additional artifacts:}\\ 
\hspace*{1cm}{\small This specification consists of the following documents:}
{\small\begin{itemize}
<xsl:for-each select="document('index.xml')/descendant::node()[name()='xref' and @type='amqp']"><xsl:variable name="partDoc"><xsl:value-of select="@name"/>.xml</xsl:variable>\item <xsl:choose><xsl:when test="$completeDoc">\hyperref[chapter-<xsl:value-of select="@name"/>]</xsl:when><xsl:otherwise>\href{<xsl:value-of select="$baseURL"/>/v<xsl:value-of select="$version"/>/<xsl:value-of select="$docVersion"/>/<xsl:value-of select="$document"/>-<xsl:value-of select="@name"/>-v<xsl:value-of select="$version"/>-<xsl:value-of select="$docVersion"/>.pdf}</xsl:otherwise></xsl:choose>{Part <xsl:apply-templates mode="partNo" select="."/>: <xsl:call-template name="initCap"><xsl:with-param name="input" select="@name"/></xsl:call-template> <xsl:if test="@name = $title"> (this document)</xsl:if> - <xsl:value-of select="document($partDoc)/descendant::node()[name()='amqp']/@label"/>} <xsl:if test="$completeDoc">\\
{\small{\href{<xsl:value-of select="$baseURL"/>/v<xsl:value-of select="$version"/>/<xsl:value-of select="$docVersion"/>/<xsl:value-of select="$document"/>-<xsl:value-of select="@name"/>-v<xsl:value-of select="$version"/>-<xsl:value-of select="$docVersion"/>.xml}{<xsl:value-of select="$baseURL"/>/v<xsl:value-of select="$version"/>/<xsl:value-of select="$docVersion"/>/<xsl:value-of select="$document"/>-<xsl:value-of select="@name"/>-v<xsl:value-of select="$version"/>-<xsl:value-of select="$docVersion"/>.xml} (Authoritative)}}\\
{\small{\href{<xsl:value-of select="$baseURL"/>/v<xsl:value-of select="$version"/>/<xsl:value-of select="$docVersion"/>/<xsl:value-of select="$document"/>-<xsl:value-of select="@name"/>-v<xsl:value-of select="$version"/>-<xsl:value-of select="$docVersion"/>.html}{<xsl:value-of select="$baseURL"/>/v<xsl:value-of select="$version"/>/<xsl:value-of select="$docVersion"/>/<xsl:value-of select="$document"/>-<xsl:value-of select="@name"/>-v<xsl:value-of select="$version"/>-<xsl:value-of select="$docVersion"/>.html}}}</xsl:if>
</xsl:for-each>
\item <xsl:choose><xsl:when test="$completeDoc">\hyperref[appendix-dtd] </xsl:when><xsl:otherwise>\href{<xsl:value-of select="$baseURL"/>/v<xsl:value-of select="$version"/>/<xsl:value-of select="$docVersion"/>/amqp.dtd}</xsl:otherwise></xsl:choose>{XML Document Type Definition (DTD)}
\\{\small{\href{<xsl:value-of select="$baseURL"/>/v<xsl:value-of select="$version"/>/<xsl:value-of select="$docVersion"/>/amqp.dtd}{<xsl:value-of select="$baseURL"/>/v<xsl:value-of select="$version"/>/<xsl:value-of select="$docVersion"/>/amqp.dtd} (Authoritative)}}
\end{itemize}}
{\bfseries\color{oasispurple}Related work:}\\
\hspace*{1cm}{\small This specification replaces or supersedes:}
{\small\begin{itemize}
\item AMQP v1.0 Final, 07 October 2011. \href{http://www.amqp.org/specification/1.0/amqp-org-download}{http://www.amqp.org/specification/1.0/amqp-org-download}
\end{itemize}}
{\bfseries\color{oasispurple}Abstract:}\vspace*{0.2cm}\\ 
{\small
<xsl:apply-templates mode="abstract" select="document('../front-matter/abstract.xml')"/>
}\vspace*{0.4cm}\\
{\bfseries\color{oasispurple}Status:}\vspace*{0.2cm}\\ 
{\small
This document was last revised or approved by the membership of OASIS on the above date. The level of approval is also listed above. Check the ``Latest version'' location noted above for possible later revisions of this document.

Technical Committee members should send comments on this specification to the Technical Committee's email list. Others should send comments to the Technical Committee by using the ``\href{http://www.oasis-open.org/committees/comments/index.php?wg_abbrev=<xsl:value-of select="$oasisTCId"/>}{Send A Comment}'' button on the Technical Committee's web page at \url{http://www.oasis-open.org/committees/<xsl:value-of select="$oasisTCId"/>/}.

For information on whether any patents have been disclosed that may be essential to implementing this specification, and any offers of patent licensing terms, please refer to the Intellectual Property Rights section of the Technical Committee web page (\url{http://www.oasis-open.org/committees/<xsl:value-of select="$oasisTCId"/>/ipr.php}). 
}\vspace*{0.4cm}\\
{\bfseries\color{oasispurple}Citation format:}\vspace*{0.2cm}\\
{\small When referencing this specification the following citation format should be used:}\\
{\small{\bfseries [<xsl:value-of select="$document"/>-<xsl:value-of select="$title"/>-v<xsl:value-of select="$version"/>]}\\
{\em <xsl:value-of select="$oasisTitle"/> Version <xsl:value-of select="$version"/><xsl:if test="not( $completeDoc )"> Part <xsl:value-of select="$partNo"/>: <xsl:call-template name="initCap"><xsl:with-param name="input" select="@name"/></xsl:call-template></xsl:if>}. <xsl:value-of select="document('../output/metadata.xml')/descendant::node()[name()='date']"/>. <xsl:if test="not(contains(document('../output/metadata.xml')/descendant::node()[name()='status'], 'OASIS'))">OASIS </xsl:if><xsl:value-of select="document('../output/metadata.xml')/descendant::node()[name()='status']"/>.\\
\href{<xsl:value-of select="$thisVersionUrl"/>.pdf}{<xsl:value-of select="$thisVersionUrl"/>.pdf}.}\vspace*{0.2cm}\\
\newpage
{\Large\bfseries\color{oasispurple}Notices:}\vspace*{0.2cm}\\
{\small <xsl:apply-templates mode="notices" select="document('../front-matter/notice.xml')"/>}
\newpage
\setcounter{secnumdepth}{3}
\setcounter{tocdepth}{3}
\tableofcontents
\newpage
\fancypagestyle{plain}{%
\fancyhf{}%
\lfoot{\small <xsl:value-of select="$document"/>-<xsl:choose><xsl:when test="$completeDoc">complete</xsl:when><xsl:otherwise><xsl:value-of select="@name"/></xsl:otherwise></xsl:choose>-v<xsl:value-of select="$version"/>-<xsl:value-of select="$docVersion"/>\\Standards Track Work Product}%
\cfoot{\small \ \newline Copyright \copyright\ OASIS Open 2012. All Rights Reserved.}%
\rfoot{\small <xsl:value-of select="document('../output/metadata.xml')/descendant::node()[name()='date']"/>\\Page \thepage\ of \pageref{LastPage}}%
\renewcommand{\headrulewidth}{0.4pt}%
\renewcommand{\footrulewidth}{0pt}%
}
\renewcommand{\sectionmark}[1]{\markright{\thesection\ #1}}

<xsl:choose>
  <xsl:when test="$completeDoc">
\setcounter{chapter}{-1}
    <xsl:for-each select="descendant::node()[name()='xref' and @type='amqp']">
\chapter{<xsl:call-template name="initCap"><xsl:with-param name="input" select="@name"/></xsl:call-template>} 
\label{chapter-<xsl:value-of select="@name"/>}  
\fancypagestyle{plain}{%
\fancyhf{}%
\lhead{\leftmark}
\rhead{\rightmark}
\lfoot{\small <xsl:value-of select="$document"/>-<xsl:choose><xsl:when test="$completeDoc">complete</xsl:when><xsl:otherwise><xsl:value-of select="@name"/></xsl:otherwise></xsl:choose>-v<xsl:value-of select="$version"/>-<xsl:value-of select="$docVersion"/>\\Standards Track Work Product}%
\cfoot{\small \ \newline Copyright \copyright\ OASIS Open 2012. All Rights Reserved.}%
\rfoot{\small <xsl:value-of select="document('../output/metadata.xml')/descendant::node()[name()='date']"/>\\Page \thepage\ of \pageref{LastPage}}%
\renewcommand{\headrulewidth}{0.4pt}%
\renewcommand{\footrulewidth}{0pt}%
}
\pagestyle{fancy}{%
\fancyhf{}%
\lhead{\leftmark}
\rhead{\rightmark}
\lfoot{\small <xsl:value-of select="$document"/>-<xsl:choose><xsl:when test="$completeDoc">complete</xsl:when><xsl:otherwise><xsl:value-of select="@name"/></xsl:otherwise></xsl:choose>-v<xsl:value-of select="$version"/>-<xsl:value-of select="$docVersion"/>\\Standards Track Work Product}%
\cfoot{\small \ \newline Copyright \copyright\ OASIS Open 2012. All Rights Reserved.}%
\rfoot{\small <xsl:value-of select="document('../output/metadata.xml')/descendant::node()[name()='date']"/>\\Page \thepage\ of \pageref{LastPage}}%
\renewcommand{\headrulewidth}{0.4pt}%
\renewcommand{\footrulewidth}{0pt}%
}

<xsl:apply-templates mode="spec" select="document(concat(@name, '.xml'))/descendant-or-self::node()[name()='amqp']"/>
    </xsl:for-each>
  </xsl:when>
  <xsl:otherwise>
    <xsl:apply-templates mode="spec" select="."/>
  </xsl:otherwise>
</xsl:choose>

<xsl:if test="$completeDoc">
\chapter*{XML Document Type Definition (DTD)}
\addcontentsline{toc}{chapter}{\protect\numberline{}XML Document Type Definition (DTD)}
\label{appendix-dtd}
\fancypagestyle{plain}{%
\fancyhf{}%
\lhead{XML Document Type Definition (DTD)}
\rhead{}
\lfoot{\small <xsl:value-of select="$document"/>-<xsl:choose><xsl:when test="$completeDoc">complete</xsl:when><xsl:otherwise><xsl:value-of select="@name"/></xsl:otherwise></xsl:choose>-v<xsl:value-of select="$version"/>-<xsl:value-of select="$docVersion"/>\\Standards Track Work Product}%
\cfoot{\small \ \newline Copyright \copyright\ OASIS Open 2012. All Rights Reserved.}%
\rfoot{\small <xsl:value-of select="document('../output/metadata.xml')/descendant::node()[name()='date']"/>\\Page \thepage\ of \pageref{LastPage}}%
\renewcommand{\headrulewidth}{0.4pt}%
\renewcommand{\footrulewidth}{0pt}%
}
\pagestyle{fancy}{%
\fancyhf{}%
\lhead{XML Document Type Definition (DTD)}
\rhead{}
\lfoot{\small <xsl:value-of select="$document"/>-<xsl:choose><xsl:when test="$completeDoc">complete</xsl:when><xsl:otherwise><xsl:value-of select="@name"/></xsl:otherwise></xsl:choose>-v<xsl:value-of select="$version"/>-<xsl:value-of select="$docVersion"/>\\Standards Track Work Product}%
\cfoot{\small \ \newline Copyright \copyright\ OASIS Open 2012. All Rights Reserved.}%
\rfoot{\small <xsl:value-of select="document('../output/metadata.xml')/descendant::node()[name()='date']"/>\\Page \thepage\ of \pageref{LastPage}}%
\renewcommand{\headrulewidth}{0.4pt}%
\renewcommand{\footrulewidth}{0pt}%
}

\fvset{fontsize=\small,numbers=left,numbersep=3pt}
\VerbatimInput{../../specification/amqp.dtd}

</xsl:if>

    
\end{document}

</xsl:template>        

    <xsl:template mode="partNo" match="node()[name()='xref']"><xsl:value-of select="count(ancestor::node()/preceding-sibling::node()/descendant::node()[name()='xref' and @type='amqp'])"/></xsl:template>
    <xsl:template mode="people" match="node()[name()='person']">\\
\hspace*{1cm}{\small <xsl:value-of select="@name"/> (\href{mailto:<xsl:value-of select="@mail"/>}{<xsl:value-of select="@mail"/>}), \href{<xsl:value-of select="@homepage"/>}{<xsl:call-template name="fix-text"><xsl:with-param name="input"><xsl:value-of select="@company"/></xsl:with-param></xsl:call-template>}}</xsl:template>
    <xsl:template mode="people" match="text()"/>
    <xsl:template mode="abstract" match="node()[name()='p']"><xsl:apply-templates mode="spec" select="*|text()"/></xsl:template>
    <xsl:template mode="abstract" match="text()"/>
    <xsl:template mode="notices" match="node()[name()='p']"><xsl:apply-templates mode="spec" select="*|text()"/></xsl:template>
    <xsl:template mode="spec" match="node()[name()='copyright']">\copyright\ </xsl:template>
    <xsl:template mode="notices" match="text()"/>

    <!-- Sections -->
    

    <xsl:template match="node()[name()='section']" mode="spec">
        <xsl:variable name="title"><xsl:choose>
            <xsl:when test="@title"><xsl:value-of select="@title"/></xsl:when>
            <xsl:otherwise><xsl:call-template name="initCapWords"><xsl:with-param name="input" select="translate(@name,'-',' ')"/></xsl:call-template></xsl:otherwise>
        </xsl:choose>
        </xsl:variable>
\section{<xsl:value-of select="$title"/>}  
\label{section-<xsl:value-of select="@name"/>}        
<xsl:apply-templates mode="spec" select="*|comment()"/>        
    </xsl:template>

<!-- doc -->

    <xsl:template match="node()[name()='doc']" mode="spec">
        <xsl:param name="no-figures">N</xsl:param>
        <xsl:if test="@title">
\<xsl:if test="ancestor::node()[name()='doc']">sub</xsl:if>subsection{<xsl:call-template name="initCapWords"><xsl:with-param name="input" select="@title"/></xsl:call-template>}
\label{doc-<xsl:value-of select="generate-id(.)"/>}            
<xsl:if test="@name">
\label{doc-<xsl:value-of select="@name"/>}
</xsl:if>
        </xsl:if>
        <xsl:apply-templates mode="spec" select="*|comment()"><xsl:with-param name="no-figures" select="$no-figures"/></xsl:apply-templates>            
    </xsl:template>

<!-- picture -->
    
    <xsl:template match="node()[name()='picture']" mode="spec">
        <xsl:param name="no-figures">N</xsl:param>
        <xsl:param name="force-caption">N</xsl:param>
<xsl:choose>
    <xsl:when test="$no-figures='Y'">(See Figure \ref{fig-<xsl:value-of select="generate-id(.)"/>}).        
    </xsl:when>
<xsl:otherwise>        
\begin{figure}[H]
\label{fig-<xsl:value-of select="generate-id(.)"/>}    
\begin{center}
\begin{minipage}{<xsl:variable name="longestline"><xsl:call-template name="findlongest"><xsl:with-param name="input" select="*|text()"/></xsl:call-template></xsl:variable><xsl:value-of select="4.75 * $longestline"/>pt}
{\renewcommand{\baselinestretch}{0.7}
\small
\begin{verbatim}                
<xsl:apply-templates select="*|text()" mode="verbatim"><xsl:with-param name="no-figures" select="$no-figures"/></xsl:apply-templates>\end{verbatim}
\renewcommand{\baselinestretch}{1}
\normalsize}
\end{minipage}
\end{center}
<xsl:if test="@title or $force-caption='Y'">\caption{<xsl:call-template name="fix-text"><xsl:with-param name="input"><xsl:value-of select="@title"/></xsl:with-param></xsl:call-template>}</xsl:if>
\end{figure}
</xsl:otherwise>        
</xsl:choose>        
    </xsl:template>
    
    <!-- xref -->
<xsl:template match="node()[name()='xref']" mode="spec"><xsl:variable name="ref" select="@name"/><xsl:choose>        
        <xsl:when test="@type='extern'"><xsl:choose><xsl:when test="text()">\href{<xsl:value-of select="@name"/>}{<xsl:value-of select="text()"/>}</xsl:when><xsl:otherwise>\url{<xsl:value-of select="@name"/>}</xsl:otherwise></xsl:choose></xsl:when>        
        <!-- part xref -->
        <xsl:when test="@type='part' and $completeDoc">\hyperref[chapter-<xsl:value-of select="@name"/>]{<xsl:choose><xsl:when test="text()"><xsl:value-of select="text()"/></xsl:when><xsl:otherwise><xsl:variable name="part" select="@name"/>Part <xsl:apply-templates mode="partNo" select="document('index.xml')/descendant::node()[name()='xref' and @name=$part]"/></xsl:otherwise></xsl:choose>}</xsl:when>
        <!-- section xref -->
        <xsl:when test="(@type='section' and $completeDoc) or ancestor-or-self::node()/descendant-or-self::node()[name()='section' and @name=$ref]"><xsl:if test="not(ancestor-or-self::node()/descendant-or-self::node()[name()='section' and @name=$ref])"><xsl:variable name="xrefList"><xsl:call-template name="crossPartXref"><xsl:with-param name="ref" select="$ref"/><xsl:with-param name="type">section</xsl:with-param></xsl:call-template></xsl:variable><xsl:variable name="file" select="substring-before($xrefList, '%')"/>Part <xsl:apply-templates mode="partNo" select="document('index.xml')/descendant::node()[name()='xref' and @name=$file]"/>: </xsl:if>\autoref{section-<xsl:value-of select="@name"/>}</xsl:when>
        <xsl:when test="@choice and ((@type='type' and $completeDoc) or ancestor-or-self::node()/descendant-or-self::node()[name()='type' and @name=$ref])">\hyperref[choice-<xsl:value-of select="@name"/>-<xsl:value-of select="@choice"/>]{\tt\bfseries <xsl:value-of select="@choice"/>}</xsl:when>
        <!-- type xref -->
        <xsl:when test="(@type='type' and $completeDoc) or ancestor-or-self::node()/descendant-or-self::node()[name()='type' and @name=$ref]"><xsl:choose><xsl:when test="ancestor::node()[name()='field' and @type=$ref]">\autoref{type-<xsl:value-of select="@name"/>} \nameref{type-<xsl:value-of select="@name"/>}</xsl:when><xsl:otherwise>\hyperref[type-<xsl:value-of select="@name"/>]{\tt\bfseries <xsl:value-of select="@name"/>}</xsl:otherwise></xsl:choose></xsl:when>
        <!-- doc xref -->
        <xsl:when test="(@type='doc' and $completeDoc) or ancestor-or-self::node()/descendant-or-self::node()[name()='doc' and @name=$ref]">\hyperref[doc-<xsl:value-of select="@name"/>]{<xsl:choose><xsl:when test="text()"><xsl:value-of select="text()"/></xsl:when><xsl:when test="ancestor-or-self::node()/descendant-or-self::node()[name()='doc' and @name=$ref]/@title">\autoref{doc-<xsl:value-of select="@name"/>}</xsl:when><xsl:otherwise><xsl:if test="not(ancestor-or-self::node()/descendant-or-self::node()[name()='doc' and @name=$ref])"><xsl:variable name="xrefList"><xsl:call-template name="crossPartXref"><xsl:with-param name="ref" select="@name"/><xsl:with-param name="type">doc</xsl:with-param></xsl:call-template></xsl:variable><xsl:variable name="file" select="substring-before($xrefList, '%')"/>Part <xsl:apply-templates mode="partNo" select="document('index.xml')/descendant::node()[name()='xref' and @name=$file]"/>: </xsl:if>\ref{doc-<xsl:value-of select="@name"/>} \nameref{doc-<xsl:value-of select="@name"/>}</xsl:otherwise></xsl:choose>}</xsl:when>
        <xsl:when test="(@type='definition' and $completeDoc) or @type='definition'  or ancestor-or-self::node()/descendant-or-self::node()[name()='definition' and @name=$ref]">\hyperref[definition-<xsl:value-of select="@name"/>]{<xsl:value-of select="ancestor-or-self::node()/descendant-or-self::node()[name()='definition' and @name=$ref]/@value"/> (<xsl:value-of select="@name"/>)}</xsl:when>
        <xsl:when test="$completeDoc and @type='part'">\hyperref[chapter-<xsl:value-of select="@name"/>]{<xsl:choose><xsl:when test="text()"><xsl:value-of select="text()"/></xsl:when><xsl:otherwise><xsl:call-template name="initCapWords"><xsl:with-param name="input" select="@name"/></xsl:call-template></xsl:otherwise></xsl:choose>}</xsl:when>
        <xsl:when test="@type='amqp'">
<!--            <xsl:element name="a"><xsl:attribute name="href"><xsl:value-of select="@name"/>.xml</xsl:attribute><xsl:call-template name="initCap"><xsl:with-param name="input"><xsl:value-of select="@name"/></xsl:with-param></xsl:call-template></xsl:element>-->
        </xsl:when>
<xsl:otherwise><xsl:variable name="type"><xsl:choose><xsl:when test="@type"><xsl:value-of select="@type"/></xsl:when><xsl:otherwise>any</xsl:otherwise></xsl:choose></xsl:variable><xsl:variable name="xrefList"><xsl:call-template name="crossPartXref"><xsl:with-param name="ref" select="@name"/><xsl:with-param name="type" select="$type"/></xsl:call-template></xsl:variable><xsl:choose>
             <xsl:when test="contains($xrefList, '|')">
<xsl:variable name="file" select="substring-before($xrefList, '%')"/>
<xsl:variable name="href" select="substring-after(substring-before($xrefList,'|'),'%')"/>
<xsl:variable name="version"><xsl:value-of select="document('../output/metadata.xml')/descendant::node()[name()='version']"/></xsl:variable>
<xsl:variable name="baseURL"><xsl:value-of select="document('../output/metadata.xml')/descendant::node()[name()='baseURL']"/></xsl:variable>
<xsl:variable name="docVersion"><xsl:value-of select="document('../output/metadata.xml')/descendant::node()[name()='docVersion']"/></xsl:variable>
<xsl:variable name="document"><xsl:value-of select="document('../output/metadata.xml')/descendant::node()[name()='document']"/></xsl:variable>
<xsl:choose>
<xsl:when test="@type='part' or $href='part'">Part <xsl:apply-templates mode="partNo" select="document('index.xml')/descendant::node()[name()='xref' and @name=$file]"/>:<xsl:text> </xsl:text><xsl:call-template name="initCapWords"><xsl:with-param name="input" select="document(concat($file,'.xml'))/descendant-or-self::node()[name()='amqp' and @name=$ref]/@name"/></xsl:call-template> (\href{<xsl:value-of select="concat($baseURL, '/v', $version, '/', $docVersion, '/', $document, '-', $file, '-v', $version, '-', $docVersion, '.pdf')"/>}{\bfseries [<xsl:value-of select="$document"/>-<xsl:value-of select="$file"/>-v<xsl:value-of select="$version"/>]})</xsl:when>
<xsl:when test="$href='section'"><xsl:apply-templates select="document(concat($file,'.xml'))/descendant-or-self::node()[name()='section' and @name=$ref]" mode="section-number"/><xsl:text> </xsl:text><xsl:value-of select="document(concat($file,'.xml'))/descendant-or-self::node()[name()='section' and @name=$ref]/@title"/> of \href{<xsl:value-of select="concat($baseURL, '/v', $version, '/', $docVersion, '/', $document, '-', $file, '-v', $version, '-', $docVersion, '.pdf')"/>}{\bfseries [<xsl:value-of select="$document"/>-<xsl:value-of select="$file"/>-v<xsl:value-of select="$version"/>]}</xsl:when>
<xsl:when test="$href='type' and @choice">{\tt\bfseries <xsl:value-of select="@choice"/>}</xsl:when>
<xsl:when test="$href='doc'"><xsl:apply-templates select="document(concat($file,'.xml'))/descendant-or-self::node()[name()='doc' and @name=$ref]" mode="doc-number"/><xsl:text> </xsl:text><xsl:value-of select="document(concat($file,'.xml'))/descendant-or-self::node()[name()='doc' and @name=$ref]/@title"/> of \href{<xsl:value-of select="concat($baseURL, '/v', $version, '/', $docVersion, '/', $document, '-', $file, '-v', $version, '-', $docVersion, '.pdf')"/>}{\bfseries [<xsl:value-of select="$document"/>-<xsl:value-of select="$file"/>-v<xsl:value-of select="$version"/>]}</xsl:when>
<xsl:when test="$href='type' and @choice">{\tt\bfseries <xsl:value-of select="@choice"/>}</xsl:when>
<xsl:when test="$href='type'">{\tt\bfseries <xsl:value-of select="@name"/>}</xsl:when>
<xsl:when test="$href='anchor'"><xsl:choose><xsl:when test="$completeDoc">\hyperref[anchor-<xsl:value-of select="@name"/>]{<xsl:value-of select="@name"/>}</xsl:when><xsl:otherwise><xsl:variable name="refURL" select="document(concat($file,'.xml'))/descendant::node()[name()='anchor' and @name=$ref]/ancestor::node()[name()='p']/descendant::node()[name()='xref']/@name"/>\href{<xsl:value-of select="$refURL"/>}{<xsl:value-of select="@name"/>}</xsl:otherwise></xsl:choose></xsl:when>
<xsl:otherwise><xsl:value-of select="@name"/></xsl:otherwise>
</xsl:choose></xsl:when>
<xsl:otherwise><xsl:value-of select="@name"/></xsl:otherwise>
        </xsl:choose></xsl:otherwise></xsl:choose>
      </xsl:template>

<xsl:template name="crossPartXref"><xsl:param name="ref"/><xsl:param name="type" select="any"/><xsl:for-each select="document('index.xml')/descendant::node()[name()='xref' and @type='amqp']"><xsl:variable name="file"><xsl:value-of select="@name"/>.xml</xsl:variable><xsl:choose>
      <xsl:when test="document($file)/descendant-or-self::node()[name()='amqp' and @name=$ref and ($type='any' or $type='part')]"><xsl:value-of select="@name"/>%part|</xsl:when>
      <xsl:when test="document($file)/descendant-or-self::node()[name()='section' and @name=$ref and ($type='any' or $type='section')]"><xsl:value-of select="@name"/>%section|</xsl:when>
      <xsl:when test="document($file)/descendant-or-self::node()[name()='type' and @name=$ref and ($type = 'any' or $type='type')]"><xsl:value-of select="@name"/>%type|</xsl:when>
      <xsl:when test="document($file)/descendant-or-self::node()[name()='doc' and @name=$ref and ($type = 'any' or $type='doc')]"><xsl:value-of select="@name"/>%doc|</xsl:when>
      <xsl:when test="document($file)/descendant-or-self::node()[name()='definition' and @name=$ref]"><xsl:value-of select="@name"/>%definition|</xsl:when>
      <xsl:when test="document($file)/descendant-or-self::node()[name()='anchor' and @name=$ref]"><xsl:value-of select="@name"/>%anchor|</xsl:when>
      <xsl:when test="document($file)/descendant-or-self::node()[name()='amqp' and @name=$ref]"><xsl:value-of select="@name"/>%part|</xsl:when>           
<xsl:otherwise/>
</xsl:choose></xsl:for-each></xsl:template>
        
<xsl:template mode="section-number" match="node()[name()='section']"><xsl:value-of select="count(preceding-sibling::node()[name()='section'])+1"/></xsl:template>
    <xsl:template mode="doc-number" match="node()[name()='doc']"><xsl:apply-templates mode="section-number" select="ancestor::node()[name()='section']"/>.<xsl:value-of select="1+count(preceding-sibling::node()[name()='doc' and attribute::title])"/></xsl:template> 

<!-- todo -->
<xsl:template match="node()[name()='todo']" mode="spec">
\todo[inline<xsl:choose>
<xsl:when test="@class='intent'">,color=red!20</xsl:when>
<xsl:when test="@class='content'">,color=blue!20</xsl:when>
<xsl:when test="@class='presentation'">,color=green!20</xsl:when>
</xsl:choose>]{TODO (<xsl:value-of select="@class"/>): <xsl:call-template name="fix-text"><xsl:with-param name="input" select="."/></xsl:call-template>}
</xsl:template>

<!-- primitive type -->
<xsl:template match="node()[name()='type' and @class='primitive']" mode="spec">
    <xsl:param name="no-figures">N</xsl:param>
\subsection{{\tt <xsl:value-of select="@name"/>}}
\label{type-<xsl:value-of select="@name"/>}
<xsl:if test="@label"><xsl:call-template name="fix-text"><xsl:with-param name="input"><xsl:call-template name="initCap"><xsl:with-param name="input" select="@label"/></xsl:call-template></xsl:with-param></xsl:call-template>.
</xsl:if>
    
<xsl:apply-templates select="." mode="type-signature"/>
<!--    <xsl:element name="table"><xsl:attribute name="class">signature</xsl:attribute><xsl:attribute name="summary"><xsl:value-of select="@label"/></xsl:attribute>
        <tr><td><b><xsl:value-of select="@name"/></b>: <xsl:value-of select="@label"/></td></tr>        
    </xsl:element>-->

<xsl:apply-templates select="node()[name()='doc']" mode="spec"/>
<xsl:apply-templates select="encoding/node()[name()='doc']" mode="spec"/>

</xsl:template>        

<!-- RevisionHistory comment -->
<xsl:template match="node()[name()='section' and @name='revhistory']" mode="spec">

\section{Revision History}
\label{section-revhistory}

<xsl:for-each select="doc">
{\renewcommand{\arraystretch}{1.1} \begin{longtable}{r@{\hspace{0.5em}}p{15cm}}
{\large\bfseries\color{oasispurple} <xsl:value-of select="substring-before(@title, ' : ')"/> :} &amp; {\large\bfseries\color{oasispurple} <xsl:value-of select="substring-after(@title, ' : ')"/>} \vspace{0.2cm} \\
<xsl:for-each select="ul/li/p">
\href{https://tools.oasis-open.org:443/issues/browse/<xsl:value-of select="substring-before(text(), ' :')"/>}{<xsl:value-of select="substring-before(text(), ' :')"/>} : &amp; <xsl:call-template name="fix-text"><xsl:with-param name="input" select="substring-after(text(), ': ')"/></xsl:call-template> \\<xsl:text>
</xsl:text>
</xsl:for-each>
\end{longtable} }
</xsl:for-each>
</xsl:template>
    <xsl:template match="comment()[self::comment()='RevisionHistory']" mode="spec">
<xsl:for-each select="document('../output/versions.xml')/versions/version">
<xsl:variable name="version" select="@name"/>
{\renewcommand{\arraystretch}{1.1} \begin{longtable}{r@{\hspace{0.5em}}p{15cm}}
{\large\bfseries\color{oasispurple} <xsl:value-of select="substring-before(@date, 'T')"/> :} &amp; {\large\bfseries\color{oasispurple} <xsl:value-of select="@title"/>} \vspace{0.2cm} \\
<xsl:for-each select="document('../output/version-history.xml')/version-history/version[@name=$version]/jira">
\href{<xsl:value-of select="@url"/>}{<xsl:value-of select="@id"/>} : &amp; <xsl:call-template name="fix-text"><xsl:with-param name="input" select="text()"/></xsl:call-template> \\<xsl:text>
</xsl:text>
</xsl:for-each>
\end{longtable} }
</xsl:for-each>
    </xsl:template>

    
   
    <!-- composite type -->
    <xsl:template match="node()[name()='type' and @class='composite']" mode="spec">
\sub<xsl:if test="count(preceding-sibling::node()[name()='doc']) > 0 and count(preceding-sibling::node()[name()='doc'][1]/descendant::node())=0">sub</xsl:if>section{<xsl:call-template name="initCapWords"><xsl:with-param name="input" select="translate(@name,'-',' ')"></xsl:with-param></xsl:call-template>}
\label{type-<xsl:value-of select="@name"/>}

<xsl:if test="@label"><xsl:call-template name="initCap"><xsl:with-param name="input" select="@label"/></xsl:call-template>.
</xsl:if>
        <xsl:apply-templates select="." mode="type-signature"/> 
        
        <xsl:apply-templates select="node()[name()='doc']" mode="spec"/>
<xsl:if test="descendant::node()[name()='field']">
\subsubsection*{Field Details}
\vspace{-0.2cm}
\begin{longtable}[l]{lp{1.5cm}p{13cm}}
<xsl:for-each select="node()[name()='field']">    
\multicolumn{2}{l} {\tt <xsl:value-of select="@name"/> } &amp; {\em <xsl:value-of select="@label"/> } <xsl:if test="node()[name()='doc' or name()='error']">\vspace{4pt}\\

\hspace{0.7cm}    &amp; \multicolumn{2}{p{15cm}}{ <xsl:apply-templates select="node()[name()='doc' or name()='error']" mode="spec"/> }</xsl:if>\vspace{10pt}\\
</xsl:for-each>
\end{longtable} </xsl:if>
    </xsl:template>    

    <!-- restricted type -->
    <xsl:template match="node()[name()='type' and @class='restricted']" mode="spec">
        <xsl:variable name="name"><xsl:value-of select="@name"/></xsl:variable>
        \sub<xsl:if test="count(preceding-sibling::node()[name()='doc']) > 0 and count(preceding-sibling::node()[name()='doc'][1]/descendant::node())=0">sub</xsl:if>section{<xsl:call-template name="initCapWords"><xsl:with-param name="input" select="translate(@name,'-',' ')"></xsl:with-param></xsl:call-template>}
        \label{type-<xsl:value-of select="@name"/>}

<xsl:if test="@label"><xsl:call-template name="initCap"><xsl:with-param name="input" select="@label"/></xsl:call-template>.</xsl:if>  
<xsl:if test="not( @label or node()[name()='doc'])">\vspace{-2pt}
</xsl:if>
        <xsl:apply-templates select="." mode="type-signature"/>
<xsl:if test="not( @label or node()[name()='doc'])">\vspace{-2pt}
</xsl:if>
        <xsl:apply-templates select="node()[name()='doc']" mode="spec"/>
<xsl:if test="node()[name()='choice']">
\subsubsection*{Valid Values}
\vspace{-0.2cm}
<xsl:choose>
<xsl:when test="@source != 'symbol' or count(node()[name()='choice' and string-length(@name)>7])=0">\begin{longtable}[l]{p{1.5cm}p{12.5cm}}
   <xsl:for-each select="node()[name()='choice']">{{\bfseries \label{choice-<xsl:value-of select="$name"/>-<xsl:value-of select="@name"/>} <xsl:value-of select="@value"/> }} &amp; <xsl:choose><xsl:when test="node()[name()='doc']"><xsl:apply-templates select="node()[name()='doc' or name()='error']" mode="spec"/></xsl:when><xsl:otherwise><xsl:value-of select="@name"/></xsl:otherwise></xsl:choose>\vspace{10pt}\\
   </xsl:for-each>
\end{longtable} </xsl:when>
<xsl:when test="count(node()[name()='choice' and string-length(@value)>17])=0">\begin{longtable}[l]{p{3cm}p{13cm}}
   <xsl:for-each select="node()[name()='choice']">{{\bfseries \label{choice-<xsl:value-of select="$name"/>-<xsl:value-of select="@name"/>} <xsl:value-of select="@value"/> }} &amp; <xsl:choose><xsl:when test="node()[name()='doc']"><xsl:apply-templates select="node()[name()='doc' or name()='error']" mode="spec"/></xsl:when><xsl:otherwise><xsl:value-of select="@name"/></xsl:otherwise></xsl:choose>\vspace{10pt}\\
   </xsl:for-each>
\end{longtable} </xsl:when>
<xsl:otherwise>\begin{longtable}[l]{lll}
            <xsl:for-each select="node()[name()='choice']">
\multicolumn{3}{l}{{\bfseries \label{choice-<xsl:value-of select="$name"/>-<xsl:value-of select="@name"/>} <xsl:value-of select="@value"/> }} <xsl:if test="node()[name()='doc' or name()='error']">\vspace{4pt}\\
\hspace{0.7cm} &amp; \multicolumn{2}{p{14cm}}{<xsl:apply-templates select="node()[name()='doc' or name()='error']" mode="spec"/>}</xsl:if>\vspace{10pt}\\
            </xsl:for-each>
\end{longtable}</xsl:otherwise>
</xsl:choose>
</xsl:if>
    </xsl:template>
    
    <!-- type signature -->
    <xsl:template match="node()[name()='type']" mode="type-signature">
\begin{Verbatim}[samepage=true,fontsize=\small]
&#60;type<xsl:if test="@name"><xsl:text> </xsl:text>name="<xsl:value-of select="@name"/>"</xsl:if><xsl:if test="@class"><xsl:text> </xsl:text>class="<xsl:value-of select="@class"/>"</xsl:if><xsl:if test="@source"><xsl:text> </xsl:text>source="<xsl:value-of select="@source"/>"</xsl:if><xsl:if test="@provides"><xsl:text> </xsl:text>provides="<xsl:value-of select="@provides"/>"</xsl:if><xsl:if test="not( node()[name() = 'field' or name() = 'choice' or name() = 'descriptor' or name()='encoding'])">/</xsl:if>&#62;<xsl:if test="node()[name() = 'field' or name() = 'choice' or name() = 'descriptor' or name()='encoding']">
<xsl:apply-templates select="node()[name()='field' or name()='choice' or name()='descriptor' or name()='encoding']" mode="type-signature"/><xsl:text>
&#60;/type&#62;</xsl:text>    
</xsl:if>
\end{Verbatim}        
    </xsl:template>
    
    <xsl:template match="node()[name()='descriptor']" mode="type-signature">
<xsl:text>
    </xsl:text>&#60;descriptor<xsl:if test="@name"><xsl:text> </xsl:text>name="<xsl:value-of select="@name"/>"</xsl:if><xsl:if test="@code"><xsl:text> </xsl:text>code="<xsl:value-of select="@code"/>"</xsl:if><xsl:text>/&#62;</xsl:text>        
    </xsl:template>
    
    <xsl:template match="node()[name()='encoding']" mode="type-signature">
<xsl:text>
    </xsl:text>&#60;encoding<xsl:if test="@name"><xsl:text> </xsl:text>name="<xsl:value-of select="@name"/>"</xsl:if><xsl:if test="@code"><xsl:text> </xsl:text>code="<xsl:value-of select="@code"/>"</xsl:if><xsl:if test="@category"><xsl:text> </xsl:text>category="<xsl:value-of select="@category"/>"</xsl:if><xsl:if test="@width"><xsl:text> </xsl:text>width="<xsl:value-of select="@width"/>"</xsl:if><xsl:if test="@label"><xsl:if test="string-length(@label)>25"><xsl:text>
             </xsl:text></xsl:if><xsl:text> label="</xsl:text><xsl:value-of select="@label"/>"</xsl:if><xsl:text>/&#62;</xsl:text>        
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
    
    <xsl:template match="text()" mode="spec"><xsl:call-template name="fix-text"><xsl:with-param name="input"><xsl:value-of select="."/></xsl:with-param></xsl:call-template></xsl:template>

    <xsl:template name="fix-text"><xsl:param name="input"/><xsl:call-template name="replace">
        <xsl:with-param name="from">&lt;</xsl:with-param>
        <xsl:with-param name="to">$&lt;$</xsl:with-param>
        <xsl:with-param name="input"><xsl:call-template name="replace">
        <xsl:with-param name="from">&gt;</xsl:with-param>
        <xsl:with-param name="to">$&gt;$</xsl:with-param>
        <xsl:with-param name="input"><xsl:call-template name="replace">
        <xsl:with-param name="from">|</xsl:with-param>
        <xsl:with-param name="to">$|$</xsl:with-param>
        <xsl:with-param name="input"><xsl:call-template name="replace">
        <xsl:with-param name="from">&amp;</xsl:with-param>
        <xsl:with-param name="to">\&amp;</xsl:with-param>
        <xsl:with-param name="input"><xsl:call-template name="replace">
        <xsl:with-param name="from">_</xsl:with-param>
        <xsl:with-param name="to">\_</xsl:with-param>
        <xsl:with-param name="input"><xsl:call-template name="fix-quotes">
        <xsl:with-param name="input"><xsl:call-template name="caretToSuperscript">
                <xsl:with-param name="input" select="$input"/>
        </xsl:call-template>
        </xsl:with-param>
        </xsl:call-template>
        </xsl:with-param>
        </xsl:call-template>
        </xsl:with-param>
        </xsl:call-template>
        </xsl:with-param>
        </xsl:call-template>
        </xsl:with-param>
        </xsl:call-template>
        </xsl:with-param>
    </xsl:call-template></xsl:template>

    <!-- error -->
    
    <xsl:template match="node()[name()='error']" mode="spec">
\begin{tabular}{rl}        
{\bfseries <xsl:value-of select="@name"/> error:} &amp; 
\hyperref[<xsl:call-template name="genErrorXref"><xsl:with-param name="type" select="@value"/></xsl:call-template>]{<xsl:value-of select="@value"/>}
            \\
\multicolumn{2}{p{10.5cm}}{<xsl:apply-templates select="node()[name()='doc']" mode="spec"/>} \\
\end{tabular}        
    </xsl:template>
    
    <!-- definition -->
    
    <xsl:template mode="spec" match="node()[name()='definition']">
<xsl:choose>
<xsl:when test="count(preceding-sibling::node()[name()='definition']) = 0">
\subsection{Constant Definitions}

\begin{longtable}{lrp{9cm}}
\label{definition-<xsl:value-of select="@name"/>}<xsl:value-of select="@name"/> &amp; <xsl:value-of select="@value"/> &amp; <xsl:value-of select="@label"/>.
<xsl:choose>
<xsl:when test="node()[name()='doc']">

<xsl:apply-templates mode="spec" select="node()[name()='doc']"/> \vspace{4pt}\\
</xsl:when>
<xsl:otherwise> \vspace{4pt}\\ </xsl:otherwise>
</xsl:choose>
<xsl:for-each select="following-sibling::node()[name()='definition']">
\label{definition-<xsl:value-of select="@name"/>}<xsl:value-of select="@name"/> &amp; <xsl:value-of select="@value"/> &amp; <xsl:value-of select="@label"/>.
<xsl:choose>
<xsl:when test="node()[name()='doc']">

<xsl:apply-templates mode="spec" select="node()[name()='doc']"/> \vspace{4pt}\\
</xsl:when>
<xsl:otherwise> \vspace{4pt}\\ </xsl:otherwise>
</xsl:choose>
</xsl:for-each>
\end{longtable}
</xsl:when>
</xsl:choose>
    </xsl:template>
    
    <xsl:template match="node()[name() = 'br']" mode="spec">\\</xsl:template> 
<xsl:template match="node()[name() = 'anchor']" mode="spec">\label{anchor-<xsl:value-of select="@name"/>}<xsl:choose><xsl:when test="text()"><xsl:apply-templates mode="spec" select="*|text()"/></xsl:when><xsl:otherwise><xsl:value-of select="@name"/></xsl:otherwise></xsl:choose></xsl:template>
    <xsl:template match="node()[name() = 'p']" mode="spec"> 
<xsl:if test="@title">\paragraph{<xsl:value-of select="@title"/>}</xsl:if><xsl:apply-templates mode="spec" select="*|text()"/>                
    </xsl:template>
    
    
    <xsl:template match="node()[name() = 'i']" mode="spec">{\em <xsl:apply-templates mode="spec" select="*|text()"/>}</xsl:template>
    <xsl:template match="node()[name() = 'b']" mode="spec">{\bfseries <xsl:apply-templates mode="spec" select="*|text()"/>}</xsl:template>
    <xsl:template match="node()[name() = 'sub']" mode="spec">\subscript{<xsl:apply-templates mode="spec" select="*|text()"/>}</xsl:template>
    <xsl:template match="node()[name() = 'sup']" mode="spec">\textsuperscript{<xsl:apply-templates mode="spec" select="*|text()"/>}</xsl:template>
    <xsl:template match="node()[name() = 'term']" mode="spec">{\em <xsl:apply-templates mode="spec" select="*|text()"/>}</xsl:template>
    
    <xsl:template match="node()[name() = 'ol']" mode="spec">
\begin{enumerate}        
        <xsl:apply-templates mode="spec" select="*|text()"/>
\end{enumerate}        
    </xsl:template>
    <xsl:template match="node()[name() = 'ul']" mode="spec"> 
\begin{itemize}        
        <xsl:apply-templates mode="spec" select="*|text()"/>
\end{itemize}                        
    </xsl:template>
    <xsl:template match="node()[name() = 'li']" mode="spec"> 
\item <xsl:apply-templates mode="spec" select="*|text()"/>                
    </xsl:template>    
    <xsl:template match="node()[name() = 'dl']" mode="spec">
\begin{description}<xsl:if test="count(descendant::node()[name() = 'dt' and string-length(text())>30]) = 0">[leftmargin=3.4cm, style=nextline]</xsl:if>
        <xsl:apply-templates mode="spec" select="*|text()"/>
\end{description}        
    </xsl:template>
    <xsl:template match="node()[name() = 'dt']" mode="spec">
\item[<xsl:apply-templates select="descendant::text()" mode="spec"/>]<xsl:if test="count(parent::node()/child::node()[name()='dt' and string-length(text())>30])>0"> \hfill \\</xsl:if></xsl:template>
<xsl:template match="node()[name() = 'dd']" mode="spec"> <xsl:apply-templates mode="spec" select="*|text()"/>                
</xsl:template>    
    <!-- Document specific utilities -->
    
    
    <xsl:template name="genTypeXref">
        <xsl:param name="type"/>
        <xsl:choose>
            <xsl:when test="$type='*'">*</xsl:when>
            <xsl:otherwise>\hyperref[<xsl:choose>                
                <xsl:when test="/ancestor-or-self::node()/descendant-or-self::node()[name()='type' and @name=$type]">type-<xsl:value-of select="$type"/></xsl:when>
                <xsl:otherwise>
                    <xsl:for-each select="document('index.xml')/descendant-or-self::node()[name()='xref' and @type='amqp']">
                        <xsl:variable name="docname"><xsl:value-of select="@name"/>.xml</xsl:variable>
                        <xsl:if test="document($docname)/descendant-or-self::node()[name()='type' and @name=$type]">type-<xsl:value-of select="$type"/></xsl:if>
                    </xsl:for-each>
                </xsl:otherwise>
            </xsl:choose>]{\tt <xsl:value-of select="$type"/>}
            </xsl:otherwise>
        </xsl:choose>        
    </xsl:template>    

    <xsl:template name="genErrorXref">
        <xsl:param name="type"/>
        <xsl:choose>
            <xsl:when test="/ancestor-or-self::node()/descendant-or-self::node()[name()='type' and @provides='error']/node()[name()='choice' and @name=$type]">choice-<xsl:value-of select="/ancestor-or-self::node()/descendant-or-self::node()[name()='type' and @provides='error' and child::node()[name()='choice' and @name=$type]]/@name"/>-<xsl:value-of select="$type"/></xsl:when>
            <xsl:otherwise>
                <xsl:for-each select="document('index.xml')/descendant-or-self::node()[name()='xref' and @type='amqp']">
                    <xsl:variable name="docname"><xsl:value-of select="@name"/>.xml</xsl:variable>
                    <xsl:if test="document($docname)/descendant-or-self::node()[name()='type' and @provides='error']/node()[name()='choice' and @name=$type]">choice-<xsl:value-of select="document($docname)/descendant-or-self::node()[name()='type' and @provides='error' and child::node()[name()='choice' and @name=$type]]/@name"/>-<xsl:value-of select="$type"/>                        </xsl:if>
                </xsl:for-each>
            </xsl:otherwise>
        </xsl:choose>            
    </xsl:template>

    <xsl:template name="caretToSuperscript"><xsl:param name="input"/><xsl:choose>
        <xsl:when test="contains($input, '^')"><xsl:call-template name="caretToSuperscript2">
            <xsl:with-param name="before"><xsl:value-of select="substring-before($input,'^')"/></xsl:with-param>
            <xsl:with-param name="after"><xsl:value-of select="substring-after($input,'^')"/></xsl:with-param>
        </xsl:call-template></xsl:when>
        <xsl:otherwise><xsl:value-of select="$input"/></xsl:otherwise>
    </xsl:choose>
    </xsl:template>
    <xsl:template name="caretToSuperscript2"><xsl:param name="before"/><xsl:param name="base"/><xsl:param name="exp"/><xsl:param name="after"/><xsl:choose>
        <xsl:when test="string-length($before)>0 and translate(substring($before,string-length($before)),' \n','..')!='.'">
            <xsl:call-template name="caretToSuperscript2">
                <xsl:with-param name="before"><xsl:value-of select="substring($before,1,string-length($before)-1)"/></xsl:with-param>
                <xsl:with-param name="base"><xsl:value-of select="substring($before,string-length($before))"/><xsl:value-of select="$base"/></xsl:with-param>
                <xsl:with-param name="exp"><xsl:value-of select="$exp"/></xsl:with-param>
                <xsl:with-param name="after"><xsl:value-of select="$after"/></xsl:with-param>
            </xsl:call-template>    
        </xsl:when>
        <xsl:when test="string-length($after)>0 and translate(substring($after,1,1),'0123456789abcdefghijlmnopqrstuvwxyz','000000000000000000000000000000000000')='0'">
            <xsl:call-template name="caretToSuperscript2">
                <xsl:with-param name="before"><xsl:value-of select="$before"/></xsl:with-param>
                <xsl:with-param name="base"><xsl:value-of select="$base"/></xsl:with-param>
                <xsl:with-param name="exp"><xsl:value-of select="$exp"/><xsl:value-of select="substring($after,1,1)"/></xsl:with-param>
                <xsl:with-param name="after"><xsl:value-of select="substring($after,2)"/></xsl:with-param>
            </xsl:call-template>    
        </xsl:when>
        <xsl:otherwise><xsl:value-of select="$before"/>$<xsl:value-of select="$base"/>^{<xsl:value-of select="$exp"/>}$<xsl:call-template name="caretToSuperscript"><xsl:with-param name="input" select="$after"/></xsl:call-template></xsl:otherwise>
    </xsl:choose></xsl:template>
<!-- General Utilities -->
    
    <xsl:template name="toUpper"><xsl:param name="input"/><xsl:value-of select="translate($input,'abcdefghijklmnopqrstuvwxyz','ABCDEFGHIJKLMNOPQRSTUVWXYZ')"></xsl:value-of></xsl:template>
    <xsl:template name="toLower"><xsl:param name="input"/><xsl:value-of select="translate($input,'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz')"></xsl:value-of></xsl:template>
    <xsl:template name="initCap"><xsl:param name="input"/><xsl:call-template name="toUpper"><xsl:with-param name="input" select="substring($input,1,1)"/></xsl:call-template><xsl:value-of select="substring($input,2)"/></xsl:template>
    <xsl:template name="initCapWords">
        <xsl:param name="input"/>
        <xsl:variable name="special-case">
          %ietf|IETF%
          %amqp|AMQP%
          %sasl|SASL%
          %uuid|UUID%
          %ulong|ULong%
          %id|ID%
          %std|Standard%
          %dist|Distribution%
          %txn|Transaction%
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="contains($input,' ')">
                <xsl:call-template name="initCapWords"><xsl:with-param name="input" select="substring-before($input, ' ')"/></xsl:call-template><xsl:text> </xsl:text><xsl:call-template name="initCapWords"><xsl:with-param name="input" select="substring-after($input, ' ')"/></xsl:call-template>
            </xsl:when>
            <xsl:when test="contains($special-case,concat('%',$input,'|'))"><xsl:value-of select="substring-before(substring-after($special-case,concat('%',$input,'|')),'%')"/></xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="initCap"><xsl:with-param name="input" select="$input"/></xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="replace"><xsl:param name="from"/><xsl:param name="to"/><xsl:param name="input"/><xsl:choose>
        <xsl:when test="contains($input,$from)"><xsl:variable name="after"><xsl:call-template name="replace"><xsl:with-param name="from" select="$from"/><xsl:with-param name="to" select="$to"/><xsl:with-param name="input" select="substring-after($input,$from)"></xsl:with-param></xsl:call-template></xsl:variable><xsl:value-of select="concat(substring-before($input,$from),$to,$after)"/></xsl:when>
        <xsl:otherwise><xsl:value-of select="$input"/></xsl:otherwise>
    </xsl:choose>
    </xsl:template>

    <xsl:template name="nohyphens"><xsl:param name="input"/><xsl:choose>
      <xsl:when test="contains($input, ' ')">\mbox{<xsl:value-of select="substring-before($input,' ')"/>} <xsl:call-template name="nohyphens"><xsl:with-param name="input"><xsl:value-of select="substring-after($input,' ')"/></xsl:with-param></xsl:call-template></xsl:when>
      <xsl:otherwise>\mbox{<xsl:value-of select="$input"/>}</xsl:otherwise>
    </xsl:choose></xsl:template>

    <xsl:template name="fix-quotes"><xsl:param name="input"/><xsl:choose>
        <xsl:when test="contains($input,'&quot;')"><xsl:variable name="after"><xsl:call-template name="fix-quotes2"><xsl:with-param name="input" select="substring-after($input,'&quot;')"></xsl:with-param></xsl:call-template></xsl:variable><xsl:value-of select="concat(substring-before($input,'&quot;'),'``',$after)"/></xsl:when>
        <xsl:otherwise><xsl:value-of select="$input"/></xsl:otherwise>
    </xsl:choose>
    </xsl:template>

    <xsl:template name="fix-quotes2"><xsl:param name="input"/><xsl:choose>
        <xsl:when test="contains($input,'&quot;')"><xsl:variable name="after"><xsl:call-template name="fix-quotes"><xsl:with-param name="input" select="substring-after($input,'&quot;')"></xsl:with-param></xsl:call-template></xsl:variable><xsl:value-of select="concat(substring-before($input,'&quot;'),'&quot;',$after)"/></xsl:when>
        <xsl:otherwise><xsl:value-of select="$input"/></xsl:otherwise>
    </xsl:choose>
    </xsl:template>


  <xsl:template name='findlongest'>
    <xsl:param name='input' />
    <xsl:variable name="beforeNewline" select="substring-before($input,'&#xA;')"/>
    <xsl:variable name="afterNewline" select="substring-after($input,'&#xA;')"/>
    <xsl:choose>
      <xsl:when test="string-length($beforeNewline) = 0 and string-length($afterNewline) = 0">
        <xsl:value-of select="string-length($input)"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="firstlinelength"><xsl:value-of select="string-length($beforeNewline)"/></xsl:variable>
        <xsl:variable name="maxotherlength"><xsl:call-template name="findlongest"><xsl:with-param name="input" select="$afterNewline"></xsl:with-param></xsl:call-template></xsl:variable>
         <xsl:choose>
           <xsl:when test="number($firstlinelength) > number($maxotherlength)"><xsl:value-of select="$firstlinelength"/></xsl:when>
           <xsl:otherwise><xsl:value-of select="$maxotherlength"/></xsl:otherwise>
         </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
