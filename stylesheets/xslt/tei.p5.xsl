<?xml version="1.0"?>
<xsl:stylesheet 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:tei="http://www.tei-c.org/ns/1.0"
  xmlns:functx="http://www.functx.com"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xpath-default-namespace="http://www.tei-c.org/ns/1.0"
  xmlns="http://www.w3.org/1999/xhtml" version="2.0">


  <xsl:output method="xhtml" indent="no" encoding="UTF-8"/>
  <xsl:param name="pagetype"></xsl:param>
  <xsl:param name="subpagetype"></xsl:param>
  <xsl:param name="q"></xsl:param>
  <xsl:param name="fq"></xsl:param>
  <xsl:param name="pageid"></xsl:param>
  <xsl:param name="start">0</xsl:param>
  <xsl:param name="rows">50</xsl:param>
  
  <xsl:param name="start_num"><xsl:value-of select="number($start)"/></xsl:param>
  <xsl:param name="rows_num"><xsl:value-of select="number($rows)"/></xsl:param>

  <xsl:param name="searchtype"></xsl:param>
  <xsl:param name="sort"></xsl:param>

  <xsl:include href="../../config/config.xsl"/>

  <xsl:include href="common.xsl"/>
  <xsl:include href="page_templates.xsl"/>
  <xsl:include href="html_template.xsl"/>

  <!-- Things to hide -->

  <xsl:template match="teiHeader | revisionDesc | publicationStmt | sourceDesc | figDesc">
    <!-- hide -->
    <xsl:text> </xsl:text>
  </xsl:template>

  <!-- Paragraphs and line breaks, add a rule check for nested paragraphs -->
  
  <xsl:template match="html/body" xpath-default-namespace="">
 
    <xsl:copy-of select="."/>
    
  </xsl:template>

  <xsl:template match="p">
    <xsl:choose>
      <xsl:when test="ancestor::*[name() = 'p']">
        <div class="p">
          <xsl:apply-templates/>
        </div>
      </xsl:when>
      <xsl:otherwise>
        <p>
          <xsl:apply-templates/>
        </p>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="p[@rend='italics']">
    <p>
      <xsl:attribute name="class">
        <xsl:value-of select="name()"/>
      </xsl:attribute>
      <em>
        <xsl:apply-templates/>
      </em>
    </p>
  </xsl:template>

  <xsl:template match="lb">
    <xsl:apply-templates/>
    <br/>
  </xsl:template>

  <!-- FW -->
  <xsl:template match="fw">
    <xsl:if test="not(@type='sub')">
      <h6>
        <xsl:attribute name="class">
          <xsl:value-of select="name()"/>
        </xsl:attribute>
        <xsl:apply-templates/>
      </h6>
    </xsl:if>
  </xsl:template>

  <!-- Links -->

  <xsl:template match="xref[@n]">
    <a href="{@n}">
      <xsl:apply-templates/>
    </a>
  </xsl:template>

  <!-- Elements to turn to DIV's -->

  <xsl:template match="text">
    <xsl:apply-templates/>

    <xsl:if test="//note[@place='foot']">
      <br/>
      <hr/>
    </xsl:if>
    <div class="footnotes">
      <xsl:text> </xsl:text>
      <xsl:for-each select="//note[@place='foot']">
        <p>
          <span class="notenumber"><xsl:value-of select="substring(@xml:id, 2)"/>.</span>
          <xsl:text> </xsl:text>
          <xsl:apply-templates/>
          <xsl:text> </xsl:text>
          <a>
            <xsl:attribute name="href">
              <xsl:text>#</xsl:text>
              <xsl:text>body</xsl:text>
              <xsl:value-of select="@xml:id"/>

            </xsl:attribute>
            <xsl:attribute name="id">
              <xsl:text>foot</xsl:text>
              <xsl:value-of select="@xml:id"/>
            </xsl:attribute>
            <xsl:text>[back]</xsl:text>
          </a>
        </p>
      </xsl:for-each>
    </div>
  </xsl:template>

  <xsl:template
    match="byline | docDate | sp | speaker | letter | 
    notesStmt | titlePart | docDate | ab | trailer | 
    front | lg | l | bibl | dateline | salute | trailer | titlePage | closer">
    <div>
      <xsl:attribute name="class">
        <xsl:value-of select="name()"/>
      </xsl:attribute>
      <xsl:choose>
        <xsl:when test="@type='handwritten'">
          <span>
            <xsl:attribute name="class">
              <xsl:text>handwritten</xsl:text>
            </xsl:attribute>
            <xsl:apply-templates/>
          </span>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates/>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:text> </xsl:text>
    </div>
  </xsl:template>

  <!-- Special case, if encoding is fixed, can fold into rule above-->

  <xsl:template match="ab[@rend='italics']">
    <div>
      <xsl:attribute name="class">
        <xsl:value-of select="name()"/>
      </xsl:attribute>
      <em>
        <xsl:apply-templates/>
      </em>
    </div>
  </xsl:template>

  <!-- Elements to turn to SPAN's -->

  <xsl:template match="docAuthor | persName | placeName ">
    <span>
      <xsl:attribute name="class">
        <xsl:value-of select="name()"/>
      </xsl:attribute>
      <xsl:apply-templates/>
      <!-- <xsl:text> </xsl:text> -->
    </span>
  </xsl:template>

  <!-- HEADS -->

  <xsl:template match="head">
    <!-- need to fix for handwritten text -KD -->
    <xsl:choose>
      <xsl:when test="ancestor::*[name() = 'p']">
        <span class="head">
          <xsl:apply-templates/>
        </span>
      </xsl:when>
      <xsl:when test="ancestor::*[name() = 'figure']">
        <span class="head">
          <xsl:apply-templates/>
        </span>
      </xsl:when>
      <xsl:when test=".[@type='sub']">
        <h4>
          <xsl:apply-templates/>
        </h4>
      </xsl:when>
      <xsl:when test="preceding::*[name() = 'head']">
        <h4>
          <xsl:apply-templates/>
        </h4>
      </xsl:when>
      <xsl:otherwise>
        <h3>
          <xsl:apply-templates/>
        </h3>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- Gaps, Additions, Deletes, Unclear -->

  <xsl:template match="damage">
    <span>
      <xsl:attribute name="class">
        <xsl:value-of select="@type"/>
      </xsl:attribute>
      <xsl:apply-templates/>
      <xsl:text>[?]</xsl:text>
    </span>
  </xsl:template>

  <xsl:template match="gap">
    <span>
      <xsl:attribute name="class">
        <xsl:value-of select="@reason"/>
      </xsl:attribute>
      <xsl:apply-templates/>
      <xsl:text>[</xsl:text>
      <xsl:value-of select="@reason"/>
      <xsl:text>]</xsl:text>
    </span>
  </xsl:template>

  <xsl:template match="unclear">
    <span>
      <xsl:attribute name="class">
        <xsl:value-of select="@reason"/>
      </xsl:attribute>
      <xsl:text>[</xsl:text>
      <xsl:apply-templates/>
      <xsl:text>?]</xsl:text>
    </span>
  </xsl:template>

  <xsl:template match="del">
    <xsl:choose>
      <xsl:when test="@type='overwrite'">
        <!-- Don't show overwritten text -->
      </xsl:when>
      <xsl:otherwise>
        <del>
          <xsl:attribute name="class">
            <xsl:value-of select="@reason"/>
            <xsl:apply-templates/>
          </xsl:attribute>
          <xsl:value-of select="."/>
          <!-- <xsl:text>[?]</xsl:text> -->
        </del>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="add">
    <xsl:choose>
      <xsl:when test="@place='superlinear' or @place='supralinear'">
        <sup>
          <xsl:apply-templates/>
        </sup>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates/>
      </xsl:otherwise>
    </xsl:choose>


  </xsl:template>

  <!-- Sic's and corrections -->

  <xsl:template match="choice[child::corr]">
    <a>
      <xsl:attribute name="rel">
        <xsl:text>tooltip</xsl:text>
      </xsl:attribute>
      <xsl:attribute name="class">
        <xsl:text>sic</xsl:text>
      </xsl:attribute>
      <xsl:attribute name="title">
        <xsl:apply-templates select="corr"/>​ </xsl:attribute><xsl:apply-templates select="sic"
      /></a>​</xsl:template>

  <!-- orig and reg -->

  <xsl:template match="choice[child::orig]">
    <!-- Hidden because it breaks over pagebreaks -->
    <!--<a>
      <xsl:attribute name="rel">
        <xsl:text>tooltip</xsl:text>
      </xsl:attribute>
      <xsl:attribute name="class">
        <xsl:text>orig</xsl:text>
      </xsl:attribute>
      <xsl:attribute name="title">
        <xsl:apply-templates select="reg"/>​ </xsl:attribute><xsl:apply-templates select="orig"
      /></a>​-->
    <xsl:apply-templates select="orig"/>
  </xsl:template>

  <!-- abbr and expan -->

  <xsl:template match="choice[child::abbr]">
    <a>
      <xsl:attribute name="rel">
        <xsl:text>tooltip</xsl:text>
      </xsl:attribute>
      <xsl:attribute name="class">
        <xsl:text>abbr</xsl:text>
      </xsl:attribute>
      <xsl:attribute name="title">
        <xsl:apply-templates select="expan"/>​ </xsl:attribute><xsl:apply-templates select="abbr"
      /></a>​</xsl:template>

  <!-- Page Images -->

  <xsl:template match="pb">
    <xsl:if test="@xml:id">
      <span class="hr">&#160;</span>
      <span>
        <xsl:attribute name="class">
          <xsl:text>pageimage</xsl:text>
        </xsl:attribute>

        <a>
          <xsl:attribute name="href">
            <xsl:value-of select="$externalfileroot"/>
            <!--<xsl:text>figures/</xsl:text>-->
            <xsl:text>large/</xsl:text>
            <xsl:value-of select="@xml:id"/>
            <xsl:text>.jpg</xsl:text>
          </xsl:attribute>
          <xsl:attribute name="rel">
            <xsl:text>prettyPhoto[pp_gal]</xsl:text>
          </xsl:attribute>
          <xsl:attribute name="title">
            <xsl:text>&lt;a href="</xsl:text>
            <xsl:value-of select="$externalfileroot"/>
            <!--<xsl:text>figures/</xsl:text>-->
            <xsl:text>large/</xsl:text>
            <xsl:value-of select="@xml:id"/>
            <xsl:text>.jpg</xsl:text>
            <xsl:text>" target="_blank" &gt;open image in new window&lt;/a&gt;</xsl:text>
          </xsl:attribute>

          <img>
            <xsl:attribute name="src">
              <xsl:value-of select="$externalfileroot"/>
              <!--<xsl:text>figures/</xsl:text>-->
              <xsl:text>thumbnails/</xsl:text>
              <xsl:value-of select="@xml:id"/>
              <xsl:text>.jpg</xsl:text>
            </xsl:attribute>
            <xsl:attribute name="class">
              <xsl:text>display</xsl:text>
            </xsl:attribute>
          </img>
        </a>
      </span>
    </xsl:if>
  </xsl:template>

  <!-- Div types for styling -->

  <xsl:template match="div1 | div2">
    <xsl:choose>
      <xsl:when test="@type='html'">
        <xsl:copy-of select="."/>
      </xsl:when>
      <xsl:otherwise>
        <div>
          <xsl:attribute name="class">
            <xsl:value-of select="@type"/>

            <xsl:attribute name="class">
              <xsl:if test="preceding-sibling::div1">
                <xsl:text> doublespace</xsl:text>
              </xsl:if>
              <xsl:text> </xsl:text>
              <xsl:value-of select="@subtype"/>
            </xsl:attribute>

          </xsl:attribute>

          <xsl:if test="@corresp">
            <xsl:attribute name="id">
              <xsl:value-of select="substring-after(@corresp, '#')"/>
            </xsl:attribute>
          </xsl:if>

          <xsl:apply-templates/>

        </div>
      </xsl:otherwise>
    </xsl:choose>


  </xsl:template>

  <!-- Handwritten -->
  <xsl:template match="seg[@type='handwritten']">
    <span>
      <xsl:attribute name="class">
        <xsl:text>handwritten</xsl:text>
      </xsl:attribute>
      <xsl:apply-templates/>
    </span>
  </xsl:template>

  <xsl:template match="div2[@subtype='handwritten']">
    <div>
      <xsl:attribute name="class">
        <xsl:text>handwritten</xsl:text>
      </xsl:attribute>
      <xsl:apply-templates/>
    </div>
  </xsl:template>


  <!-- Milestone / horizontal rule -->

  <xsl:template match="milestone">
    <div>
      <xsl:attribute name="class">
        <xsl:text>milestone </xsl:text>
        <xsl:value-of select="@unit"/>
      </xsl:attribute>
      <xsl:text> </xsl:text>
    </div>
  </xsl:template>

  <!-- Notes / Footnotes / references -->


  <xsl:template match="note">
    <xsl:choose>
      <xsl:when test="@place='foot'">
        <span>
          <xsl:attribute name="class">
            <xsl:text>foot</xsl:text>
          </xsl:attribute>
          <a>
            <xsl:attribute name="href">
              <xsl:text>#</xsl:text>
              <xsl:text>foot</xsl:text>
              <xsl:value-of select="@xml:id"/>
            </xsl:attribute>
            <xsl:attribute name="id">
              <xsl:text>body</xsl:text>
              <xsl:value-of select="@xml:id"/>
            </xsl:attribute>

            <xsl:text>(</xsl:text>
            <xsl:value-of select="substring(@xml:id, 2)"/>
            <xsl:text>)</xsl:text>
          </a>
        </span>
      </xsl:when>
      <xsl:when test="@type='editorial'"/>
      <xsl:otherwise>
        <div>
          <xsl:attribute name="class">
            <xsl:value-of select="name()"/>
          </xsl:attribute>
          <xsl:apply-templates/>
        </div>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


  <xsl:template match="ref">
    <xsl:choose>
      <xsl:when test="starts-with(@target, 'n')">
        <xsl:variable name="n" select="@target"/>
        <a>
          <xsl:attribute name="id">
            <xsl:text>ref</xsl:text>
            <xsl:value-of select="@target"/>
          </xsl:attribute>
          <xsl:attribute name="class">
            <xsl:text>inlinenote</xsl:text>
          </xsl:attribute>
          <xsl:attribute name="href">
            <xsl:text>#note</xsl:text>
            <xsl:value-of select="@target"/>
          </xsl:attribute>
          <xsl:text> [note </xsl:text>
          <xsl:apply-templates/>
          <xsl:text>] </xsl:text>
        </a>
      </xsl:when>
      <xsl:when test="starts-with(@target, 'edi')">
        <a href="{$siteroot}topics/{substring-before(@target, 'xml')}html">
          <xsl:apply-templates/>
        </a>
      </xsl:when>
      <xsl:when test="ends-with(@target, '.xml')">
        <a href="{$siteroot}{substring-before(@target, 'xml')}html">
          <xsl:apply-templates/>
        </a>
      </xsl:when>
      <xsl:when test="@type='link'">
        <a href="{@target}">
          <xsl:apply-templates/>
        </a>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text> </xsl:text>
        <a href="{@target}" id="{@target}.ref" class="footnote">

          <xsl:choose>
            <xsl:when test="descendant::text()">
              <xsl:apply-templates/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="@n"/>
            </xsl:otherwise>
          </xsl:choose>

        </a>
        <xsl:text> </xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


  <!-- Rules for em tag -->

  <xsl:template
    match="term | foreign | emph | title[not(@level='a')] | biblScope[@type='volume'] | 
    hi[@rend='italic'] | hi[@rend='italics']">
    <em>
      <xsl:apply-templates/>
    </em>
  </xsl:template>

  <xsl:template match="hi[@rend='underlined']">
    <u>
      <xsl:apply-templates/>
    </u>
  </xsl:template>

  <!-- Things that should be strong -->

  <xsl:template match="item/label">
    <strong>
      <xsl:apply-templates/>
    </strong>
  </xsl:template>

  <xsl:template match="hi[@rend='bold']">
    <strong>
      <xsl:apply-templates/>
    </strong>
  </xsl:template>

  <!-- Rules to account for hi tags other than em and strong-->

  <xsl:template match="hi[@rend='underline']">
    <u>
      <xsl:apply-templates/>
    </u>
  </xsl:template>

  <xsl:template match="hi[@rend='quoted']">
    <xsl:text>"</xsl:text>
    <xsl:apply-templates/>
    <xsl:text>"</xsl:text>
  </xsl:template>

  <xsl:template match="hi[@rend='super']">
    <sup>
      <xsl:apply-templates/>
    </sup>
  </xsl:template>

  <xsl:template match="hi[@rend='subscript']">
    <sub>
      <xsl:apply-templates/>
    </sub>
  </xsl:template>

  <xsl:template match="hi[@rend='smallcaps'] | hi[@rend='roman']">
    <span>
      <xsl:attribute name="class">
        <xsl:value-of select="@rend"/>
      </xsl:attribute>
      <xsl:apply-templates/>
    </span>
  </xsl:template>

  <xsl:template match="hi[@rend='right'] | hi[@rend='center']">
    <div>
      <xsl:attribute name="class">
        <xsl:value-of select="@rend"/>
      </xsl:attribute>
      <xsl:apply-templates/>
    </div>
  </xsl:template>

  <!-- Signed -->
  <xsl:template match="//signed">
    <br/>
    <xsl:apply-templates/>
  </xsl:template>

  <!-- Table Rules -->

  <xsl:template match="table">
    <xsl:choose>
      <xsl:when test="@rend='handwritten'">
        <table>
          <xsl:attribute name="class">
            <xsl:text>handwritten</xsl:text>
          </xsl:attribute>
          <xsl:apply-templates/>
        </table>
      </xsl:when>
      <xsl:otherwise>
        <table>
          <xsl:apply-templates/>
        </table>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="row">
    <tr>
      <xsl:apply-templates/>
    </tr>
  </xsl:template>

  <xsl:template match="cell">
    <td>
      <xsl:apply-templates/>
    </td>
  </xsl:template>

  <!-- Lists -->

  <xsl:template match="list">
    <xsl:choose>
      <xsl:when test="@type='handwritten'">
        <ul>
          <xsl:attribute name="class">
            <xsl:text>handwritten</xsl:text>
          </xsl:attribute>
          <xsl:apply-templates/>
        </ul>
      </xsl:when>
      <xsl:otherwise>
        <ul>
          <xsl:apply-templates/>
        </ul>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="item">
    <li>
      <xsl:apply-templates/>
    </li>
  </xsl:template>

  <!-- Space -->

  <xsl:template match="space">
    <span class="teispace">
      <xsl:text>[no handwritten text supplied here]</xsl:text>
    </span>
  </xsl:template>

  <!-- Quotes -->

  <xsl:template match="q | quote">
    <blockquote>
      <p>
        <xsl:apply-templates/>
      </p>
    </blockquote>
  </xsl:template>

</xsl:stylesheet>
