<?xml version="1.0"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:functx="http://www.functx.com"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0"
    xmlns="http://www.w3.org/1999/xhtml"
    version="2.0">
    
    <xsl:function 
        name="functx:capitalize-first" 
        xmlns:functx="http://www.functx.com" >
    
        <xsl:param name="arg"/>
        
        <xsl:sequence select=" 
            concat(upper-case(substring($arg,1,1)),
            substring($arg,2))
            "/>
    </xsl:function>
    
    <xsl:function name="functx:words-to-camel-case" 
        xmlns:functx="http://www.functx.com" >
        <xsl:param name="arg"/> 
        
        <xsl:sequence select=" 
            for $word in tokenize($arg,'\s+')
            return functx:capitalize-first($word)
            "/>
    </xsl:function>

    <xsl:template name="mainContent">
        
<!-- TESTING CODE ==================================================================== -->

<!--<p>For testing, variable list:</p>
<ul>
    <li>pagetype: <xsl:value-of select="$pagetype"/></li>
    <li>subpagetype: <xsl:value-of select="$subpagetype"/></li>
    <li>q: <xsl:value-of select="$q"/></li>
    <li>fq: <xsl:value-of select="$fq"/></li>
    <li>pageid: <xsl:value-of select="$pageid"/></li>
    <li>searchtype: <xsl:value-of select="$searchtype"/></li>
    <li>sort: <xsl:value-of select="$sort"/></li>
    <li>start: <xsl:value-of select="$start_num"/></li>
    <li>rows: <xsl:value-of select="$rows_num"/></li>
</ul>-->
        
        <!-- =====================================================================================
        Main Pages - Home | Photos | Memorabilia | Texts | Commentary | About
        ===================================================================================== -->

        <xsl:if test="($pagetype = 'home' or
                      $pagetype = 'photographs' or 
                      $pagetype = 'memorabilia' or 
                      $pagetype = 'texts' or 
                      $pagetype = 'commentary' or 
                      $pagetype = 'about') and 
                      $pageid = ''">

            <xsl:choose>
                <!-- Keyword display pages -->
                <xsl:when test="$fq != ''"><h2><xsl:value-of select="functx:words-to-camel-case($pagetype)"/> with <xsl:value-of select="translate($fq, ':', ' ')"/></h2></xsl:when>
                <!-- Pages powered by SOLR search -->
                <xsl:when test="$subpagetype != ''">
                    <h2>
                        <xsl:value-of select="functx:words-to-camel-case(translate($pagetype, '_', ' '))"/>
                        <xsl:text> - </xsl:text>
                        <xsl:value-of select="functx:words-to-camel-case(translate($subpagetype, '_', ' '))"/>
                    </h2>
                </xsl:when>
                <!-- main pages -->

                
                
                <xsl:otherwise><div class="main_content"><xsl:apply-templates/></div></xsl:otherwise>
            </xsl:choose>
            
            <xsl:if test="$pagetype = 'photographs' or 
                          $pagetype = 'memorabilia' or 
                          $pagetype = 'texts'">
                <div class="intro_content"><xsl:call-template name="search-generated-page"/></div>
            </xsl:if> 
            
            <!-- TEST Bringing keywords into commentary -->
            <!--<xsl:if test="$pagetype = 'commentary'">
                
                <xsl:variable name="solrsearchurl">
                    <xsl:call-template name="solrURL">
                        <xsl:with-param name="rowstart">0</xsl:with-param>
                        <xsl:with-param name="rowend">1</xsl:with-param>
                        <xsl:with-param name="searchfields">id,category,sub_category,keywords,date,creator,title,pages</xsl:with-param>
                        <xsl:with-param name="facet">true</xsl:with-param>
                        <xsl:with-param name="fq"></xsl:with-param>
                        <xsl:with-param name="facetfield">sub_category</xsl:with-param>
                        <xsl:with-param name="other">
                            <xsl:text>&amp;facet.field=keywords</xsl:text>
                            <xsl:text>&amp;facet.mincount=1</xsl:text>
                            <xsl:text>&amp;facet.sort=index</xsl:text>
                        </xsl:with-param>
                        <xsl:with-param name="q"><xsl:text>*:*</xsl:text></xsl:with-param>
                        <xsl:with-param name="sort"><xsl:text>title</xsl:text></xsl:with-param>
                    </xsl:call-template>
                </xsl:variable>
                <!-\-<p>
                    <xsl:value-of select="$solrsearchurl"/>
                    
                </p>-\->
                
                <h3>Keywords:</h3>
                <xsl:for-each select="document($solrsearchurl)" xpath-default-namespace="">
                <ul class="keywords">
                    
                    <xsl:for-each select="//lst[@name='keywords']/int">
                        <xsl:if test="@name != ''">
                        <li>
                            <a>
                                <xsl:attribute name="href">
                                    <xsl:call-template name="urlbuilder">
                                        <xsl:with-param name="fq">
                                            <xsl:text>keywords:"</xsl:text>
                                            <xsl:value-of select="encode-for-uri(@name)"/>
                                            <xsl:text>"</xsl:text></xsl:with-param>
                                        <xsl:with-param name="pagetype">search</xsl:with-param>
                                        <xsl:with-param name="subpagetype">all</xsl:with-param>
                                    </xsl:call-template>
                                </xsl:attribute>
                                
                                <span class="name"><xsl:value-of select="functx:words-to-camel-case(@name)"/></span> 
                                <span class="number"><xsl:value-of select="."/></span>
                            </a>
                        </li></xsl:if>
                    </xsl:for-each>
                </ul>
                </xsl:for-each>
                
            </xsl:if>-->
            
        </xsl:if> <!-- /main pages -->

    
    <!-- =====================================================================================
        Subpages
        ===================================================================================== -->
    
        <xsl:if test="($pagetype = 'home' or
            $pagetype = 'photographs' or 
            $pagetype = 'memorabilia' or 
            $pagetype = 'texts' or 
            $pagetype = 'commentary' or 
            $pagetype = 'about') and 
            $pageid != ''">
            
            <xsl:choose>
                <!-- Use SOLR to display individual photographs or memorabilia -->
                <xsl:when test="$pagetype = 'photographs' or $pagetype = 'memorabilia'">
                    <xsl:call-template name="solr-file-list"/>
                </xsl:when>
                <!-- Display texts using XSL on the TEI files -->
                <xsl:otherwise>
                    <h2><xsl:value-of select="//title[@type='main'][1]"/></h2>
                    <!-- metadata for texts section -->
                    <ul class="callout">    
                        <!--Subtitle: <title level="a" type="sub"/>-->
                        
                        <xsl:if test="/TEI/teiHeader/fileDesc/titleStmt/title[@type='sub'][normalize-space()]">
                            <li><strong><xsl:text>Subtitle: </xsl:text></strong> <xsl:value-of select="/TEI/teiHeader/fileDesc/titleStmt/title[@type='sub']"/></li>
                        </xsl:if>
                        
                        <!-- Periodical (or publication): <title level="j"/> -->
                        
                        <xsl:if test="/TEI/teiHeader/fileDesc/sourceDesc/bibl/title[@level='j'][normalize-space()]">
                            <li><strong><xsl:text>Publication: </xsl:text></strong> <xsl:value-of select="/TEI/teiHeader/fileDesc/sourceDesc/bibl/title[@level='j']"/></li>
                        </xsl:if>
                        
                        <!-- Book: <title level="m"/> -->
                        <!-- None, shows as page title -->
                        
                        <!-- Date: <date when="1898-01-01"/> -->
                        
                        <xsl:if test="/TEI/teiHeader/fileDesc/sourceDesc/bibl/date[normalize-space()]">
                            <li><strong><xsl:text>Date: </xsl:text></strong> <xsl:value-of select="/TEI/teiHeader/fileDesc/sourceDesc/bibl/date"/></li>
                        </xsl:if>
                        
                        <!-- Author(s): <author/> -->
                        
                        <xsl:if test="/TEI/teiHeader/fileDesc/sourceDesc/bibl/author[normalize-space()]">
                            <li><strong><xsl:text>Author(s): </xsl:text></strong> <xsl:value-of select="/TEI/teiHeader/fileDesc/sourceDesc/bibl/author"/></li>
                        </xsl:if>
                      
                        <!--Publisher: <publisher/>, <pubPlace/>-->
                        
                        <xsl:if test="/TEI/teiHeader/fileDesc/sourceDesc/bibl/publisher[normalize-space()]">
                            <li><strong><xsl:text>Publisher: </xsl:text></strong> <xsl:value-of select="/TEI/teiHeader/fileDesc/sourceDesc/bibl/publisher"/></li>
                        </xsl:if>
                        
                        <xsl:if test="/TEI/teiHeader/fileDesc/sourceDesc/bibl/pubPlace[normalize-space()]">
                            <li><strong><xsl:text>Publication Place: </xsl:text></strong> <xsl:value-of select="/TEI/teiHeader/fileDesc/sourceDesc/bibl/pubPlace"/></li>
                        </xsl:if>
                        
                        <!--Vol, issue, and pages: <biblScope type="vol"/>, <biblScope type="issue"/>, <biblScope type="pp"/>-->
                        
                        <xsl:if test="/TEI/teiHeader/fileDesc/sourceDesc/bibl/biblScope[@type='vol'][normalize-space()]">
                            <li><strong><xsl:text>Volume: </xsl:text></strong> <xsl:value-of select="/TEI/teiHeader/fileDesc/sourceDesc/bibl/biblScope[@type='vol']"/></li>
                        </xsl:if>
                        
                        <xsl:if test="/TEI/teiHeader/fileDesc/sourceDesc/bibl/biblScope[@type='issue'][normalize-space()]">
                            <li><strong><xsl:text>Issue: </xsl:text></strong> <xsl:value-of select="/TEI/teiHeader/fileDesc/sourceDesc/bibl/biblScope[@type='issue']"/></li>
                        </xsl:if>
                        
                        <xsl:if test="/TEI/teiHeader/fileDesc/sourceDesc/bibl/biblScope[@type='pp'][normalize-space()]">
                            <li><strong><xsl:text>Pages: </xsl:text></strong> <xsl:value-of select="/TEI/teiHeader/fileDesc/sourceDesc/bibl/biblScope[@type='pp']"/></li>
                        </xsl:if>
                        
                        <!--Document: <note type="doc"/>-->
                        
                        <xsl:if test="/TEI/teiHeader/fileDesc/sourceDesc/bibl/note[@type='doc'][normalize-space()]">
                            <li><strong><xsl:text>Document: </xsl:text></strong> <xsl:value-of select="/TEI/teiHeader/fileDesc/sourceDesc/bibl/note[@type='doc']"/></li>
                        </xsl:if>
                        
                        <!-- If text, add xml -->
                        <!--<xsl:if test="/TEI/teiHeader/fileDesc/sourceDesc/bibl/note[@type='doc'][normalize-space()]">-->
                        
                        <li><strong><xsl:text>TEI XML: </xsl:text></strong> <a href="{/TEI/@xml:id}.xml"><xsl:value-of select="/TEI/@xml:id"/>.xml</a></li>
                        <!--</xsl:if>-->
    
                        
                    </ul>
                    <xsl:apply-templates/>
                </xsl:otherwise>
            </xsl:choose>
            
           

    </xsl:if>
        
        <!-- =====================================================================================
        Search Results
        ===================================================================================== -->
        
        <xsl:if test="$pagetype = 'search'">
            
            <h2>Search Results</h2>
            
            <xsl:call-template name="search-generated-page"/>
            
        </xsl:if>
    
    <!-- =====================================================================================
        Posts Page (testing incorporating blog posts)
        ===================================================================================== -->
    
    <xsl:if test="$pagetype = 'posts' and 
        $pageid = ''">
        
        <xsl:apply-templates/>
        <xsl:for-each select="document('http://theswangondola.tumblr.com/rss')" xpath-default-namespace="">
            <xsl:for-each select="//item">
                <h3><a href="{link}"><xsl:value-of select="title"/></a></h3>
                <p><xsl:value-of select="description" disable-output-escaping="yes"/></p>
            </xsl:for-each>
        </xsl:for-each>
        
    </xsl:if>
        
    </xsl:template>

    <!-- =====================================================================================
        search-generated-page - For pages featuring search listings (most of them)
        ===================================================================================== -->
    
    <xsl:template name="search-generated-page" xpath-default-namespace="">
        
        <!-- Call solrsearchurl template -->
        <xsl:variable name="solrsearchurl">
            <xsl:call-template name="solrURL">
                <xsl:with-param name="rowstart"><xsl:value-of select="$start_num"/></xsl:with-param>
                <xsl:with-param name="rowend"><xsl:value-of select="$rows_num"/></xsl:with-param>
                <xsl:with-param name="searchfields">id,category,sub_category,keywords,date,creator,title,pages,collection,provenance,publication</xsl:with-param>
                <xsl:with-param name="facet">true</xsl:with-param>
                <xsl:with-param name="fq">
                    <xsl:choose>
                        <xsl:when test="$fq != ''"><xsl:value-of select="$fq"/></xsl:when>
                        <xsl:when test="$pagetype = 'search'"></xsl:when>
                        <xsl:when test="$subpagetype = 'all'"></xsl:when>
                        <xsl:when test="$subpagetype != ''">sub_category:"<xsl:value-of select="translate($subpagetype, '_', ' ')"/>"</xsl:when>
                        <xsl:otherwise></xsl:otherwise>
                    </xsl:choose>
                    </xsl:with-param>
                <xsl:with-param name="facetfield">sub_category</xsl:with-param>
                <xsl:with-param name="other">
                    <xsl:text>&amp;facet.field=keywords</xsl:text>
                    <xsl:text>&amp;facet.field=creator</xsl:text>
                    <xsl:text>&amp;facet.field=collection</xsl:text>
                    <xsl:text>&amp;facet.mincount=1</xsl:text>
                    <xsl:text>&amp;facet.sort=index</xsl:text>
                    <!--<xsl:text>&amp;facet.limit=-1</xsl:text>-->
                    <xsl:text>&amp;facet.field={!ex=dt}category</xsl:text>
                    <xsl:text>&amp;facet.field={!ex=dt}provenance</xsl:text>
                    <xsl:if test="$pagetype = 'search' and $subpagetype != 'all'"><xsl:text>&amp;fq={!tag=dt}category:</xsl:text><xsl:value-of select="$subpagetype"/></xsl:if>
                </xsl:with-param>
                <xsl:with-param name="q">
                    <xsl:choose>
                        <xsl:when test="$q != ''"><xsl:value-of select="$q"/></xsl:when>
                        <xsl:otherwise><xsl:text>category:</xsl:text><xsl:value-of select="$pagetype"/></xsl:otherwise>
                    </xsl:choose>
                </xsl:with-param>
                <xsl:with-param name="sort">
                    <xsl:choose>
                        <xsl:when test="$pagetype = 'search' and $sort = ''">
                            <xsl:text>relevance</xsl:text>
                        </xsl:when>
                        <xsl:when test="$sort = ''"><xsl:text>title</xsl:text></xsl:when>
                        <xsl:otherwise><xsl:value-of select="$sort"/></xsl:otherwise>
                    </xsl:choose></xsl:with-param>
            </xsl:call-template>
        </xsl:variable>
        
        <!-- uncomment to see the solr url for testing -->
        <!--<xsl:value-of select="$solrsearchurl"/>-->
        
        <!-- Call solr document -->
        <xsl:for-each select="document($solrsearchurl)">
     
        <xsl:choose>
            
        <!-- Main search display page for list/gallery views -->    
        
            <xsl:when test="$subpagetype != '' or $fq != ''">
                
                
                <!-- Browse list by  -->
                <xsl:variable name="numFound" select="//result/@numFound"/>
                
                <xsl:if test="$numFound = 0"><p class="search_descriptor">Your search returned no results</p></xsl:if> 
                
                  <!-- View Choices - only show if there are results -->
                <xsl:if test="$numFound > 0">
                <xsl:if test="$pagetype = 'search'">    
                
                <!-- Search options - categories (search results only), view, and sort -->
                <p class="show_choices"> 
                    <xsl:text>Show: </xsl:text> 
                    <a>
                        <xsl:attribute name="href">
                            <xsl:call-template name="urlbuilder">
                                <xsl:with-param name="subpagetype">all</xsl:with-param>
                            </xsl:call-template>
                        </xsl:attribute>
                        <xsl:if test="$subpagetype = 'all'"><xsl:attribute name="class">selected</xsl:attribute></xsl:if>
                        <xsl:text>all</xsl:text>
                    </a>
                    <xsl:text> | </xsl:text>
                    <xsl:choose>
                        <xsl:when test="//lst[@name='category']/int[@name='photographs']">
                            <a>
                                <xsl:attribute name="href">
                                    <xsl:call-template name="urlbuilder">
                                        <xsl:with-param name="subpagetype">photographs</xsl:with-param>
                                    </xsl:call-template>
                                </xsl:attribute>
                                <xsl:if test="$subpagetype = 'photographs'"><xsl:attribute name="class">selected</xsl:attribute></xsl:if>
                                <xsl:text>photographs (</xsl:text>
                                <xsl:value-of select="//lst[@name='category']/int[@name='photographs']"/>
                                <xsl:text>)</xsl:text>
                            </a>
                        </xsl:when>
                        <xsl:otherwise>photographs (0)</xsl:otherwise>
                    </xsl:choose>
                    
                    <xsl:text> | </xsl:text>
                    <xsl:choose>
                        <xsl:when test="//lst[@name='category']/int[@name='memorabilia']">
                            <a>
                                <xsl:attribute name="href">
                                    <xsl:call-template name="urlbuilder">
                                        <xsl:with-param name="subpagetype">memorabilia</xsl:with-param>
                                    </xsl:call-template>
                                </xsl:attribute>
                                <xsl:if test="$subpagetype = 'memorabilia'"><xsl:attribute name="class">selected</xsl:attribute></xsl:if>
                                <xsl:text>memorabilia (</xsl:text>
                                <xsl:value-of select="//lst[@name='category']/int[@name='memorabilia']"/>
                                <xsl:text>)</xsl:text>
                            </a>
                        </xsl:when>
                        <xsl:otherwise>memorabilia (0)</xsl:otherwise>
                    </xsl:choose>
                    
                    <xsl:text> | </xsl:text>
                    
                    <xsl:choose>
                        <xsl:when test="//lst[@name='category']/int[@name='texts']">
                            <a>
                                <xsl:attribute name="href">
                                    <xsl:call-template name="urlbuilder">
                                        <xsl:with-param name="subpagetype">texts</xsl:with-param>
                                    </xsl:call-template>
                                </xsl:attribute>
                                <xsl:if test="$subpagetype = 'texts'"><xsl:attribute name="class">selected</xsl:attribute></xsl:if>
                                <xsl:text>texts (</xsl:text>
                                <xsl:value-of select="//lst[@name='category']/int[@name='texts']"/>
                                <xsl:text>)</xsl:text>
                            </a>
                        </xsl:when>
                        <xsl:otherwise>texts (0)</xsl:otherwise>
                    </xsl:choose>
                    
                </p>
                </xsl:if>
                <div class="callout">   
                <p class="view_choices"> 
                    <xsl:text>View: </xsl:text> 
                    <a>
                        <xsl:attribute name="href">
                            <xsl:call-template name="urlbuilder">
                                <xsl:with-param name="searchtype">list</xsl:with-param>
                            </xsl:call-template>
                        </xsl:attribute>
                        <xsl:if test="$searchtype = '' or $searchtype = 'list'"><xsl:attribute name="class">selected</xsl:attribute></xsl:if>
                        <xsl:text>list</xsl:text>
                    </a>
                    <xsl:text> | </xsl:text>
                    <a>
                        <xsl:attribute name="href">
                            <xsl:call-template name="urlbuilder">
                                <xsl:with-param name="searchtype">gallery</xsl:with-param>
                            </xsl:call-template>
                        </xsl:attribute>
                        <xsl:if test="$searchtype = 'gallery'"><xsl:attribute name="class">selected</xsl:attribute></xsl:if>
                        <xsl:text>gallery</xsl:text>
                    </a>
                </p>
                    
                    <!-- Only show sort on search pages, because there is nothing to sort by otherwise -->
                    <xsl:if test="$pagetype = 'search'">
                <p class="sort_choices"> 
                    <xsl:text>Sort: </xsl:text> 
                    <xsl:if test="$pagetype = 'search'"><a>
                        <xsl:attribute name="href">
                            <xsl:call-template name="urlbuilder">
                                <xsl:with-param name="sort">relevance</xsl:with-param>
                                <xsl:with-param name="start">0</xsl:with-param>
                            </xsl:call-template>
                        </xsl:attribute>
                        <xsl:if test="$sort = 'relevance' or ($sort = '' and $pagetype = 'search')"><xsl:attribute name="class">selected</xsl:attribute></xsl:if>
                        <xsl:text>relevance</xsl:text>
                    </a>
                    <xsl:text> | </xsl:text></xsl:if>
                    <a>
                        <xsl:attribute name="href">
                            <xsl:call-template name="urlbuilder">
                                <xsl:with-param name="sort">title</xsl:with-param>
                                <xsl:with-param name="start">0</xsl:with-param>
                            </xsl:call-template>
                        </xsl:attribute>
                        <xsl:if test="$sort = 'title' or ($sort = '' and $pagetype != 'search')"><xsl:attribute name="class">selected</xsl:attribute></xsl:if>
                        <xsl:text>title</xsl:text>
                    </a>
                    <!-- Commented out for production -KMD -->
                    <!--<xsl:text> | </xsl:text>
                    <a>
                        <xsl:attribute name="href">
                            <xsl:call-template name="urlbuilder">
                                <xsl:with-param name="sort">id</xsl:with-param>
                                <xsl:with-param name="start">0</xsl:with-param>
                            </xsl:call-template>
                        </xsl:attribute>
                        <xsl:if test="$sort = 'id'"><xsl:attribute name="class">selected</xsl:attribute></xsl:if>
                        <xsl:text>id</xsl:text>
                    </a>-->
                </p>
                    </xsl:if>
                </div> <!-- /callout -->
            
                    <p class="search_descriptor">
                        <xsl:if test="$pagetype = 'search'">Your search for <span class="selected">
                            <xsl:choose>
                                <!-- first is for keyword searches, second for all other -->
                                <xsl:when test="$q = '*:*' and $fq != ''"><xsl:value-of select="$fq"/></xsl:when>
                                <xsl:otherwise><xsl:value-of select="$q"/></xsl:otherwise>
                            </xsl:choose>
                        </span> returned </xsl:if>
                        <xsl:choose>
                            <!-- First takes sum of all facets (so it is the same when drilled down), second just uses num found -->
                            <xsl:when test="$pagetype = 'search'">
                                <xsl:value-of select="sum(//lst[@name='category']/int[@name])"/>
                            </xsl:when>
                            <xsl:otherwise><xsl:value-of select="$numFound"/></xsl:otherwise>
                        </xsl:choose>
                        <xsl:text> results</xsl:text>
                    </p>
           
           <!-- Call pagination -->   
                
                <xsl:call-template name="paginationLinks">
                    <xsl:with-param name="numFound" select="$numFound"/>
                    <xsl:with-param name="start" select="$start_num"/>
                    <xsl:with-param name="rows" select="$rows_num"/>
                </xsl:call-template>
                
           <!-- Search results list with variables for gallery and list -->
           <div class="searchresults">
                    <xsl:for-each select="/response/result/doc">
                        <div>
                            <xsl:attribute name="class">
                                <xsl:text>thumbnail_listing</xsl:text>
                                <xsl:if test="$searchtype = 'gallery'"><xsl:text>_images</xsl:text></xsl:if>
                            </xsl:attribute>
                            <a>
                                <xsl:attribute name="href">
                                    <xsl:call-template name="urlbuilder">
                                        <xsl:with-param name="pageid"><xsl:value-of select="str[@name='id']"/></xsl:with-param>
                                        <xsl:with-param name="pagetype"><xsl:value-of select="str[@name='category']"/></xsl:with-param>
                                    </xsl:call-template>
                                </xsl:attribute>
                                
                                <span class="thumbnail_div">
                                    <img>
                                        <xsl:attribute name="src">
                                            <xsl:value-of select="$externalfileroot"/>
                                                <xsl:choose>
                                                    <xsl:when test="$searchtype = 'gallery'"><xsl:text>medium</xsl:text></xsl:when>
                                                    <xsl:otherwise><xsl:text>thumbnails</xsl:text></xsl:otherwise>
                                                </xsl:choose>
                                                <xsl:text>/</xsl:text>
                                            <xsl:value-of select="str[@name='id']"/>
                                            <xsl:if test="str[@name='pages'] != '' or str[@name='sub_category'] = 'scrapbooks'">
                                                <xsl:text>-001</xsl:text>
                                            </xsl:if>
                                            <xsl:if test="str[@name='category'] = 'texts' and str[@name='sub_category'] != 'scrapbooks'">
                                                <xsl:text>.001</xsl:text>
                                            </xsl:if>
                                            <xsl:text>.jpg</xsl:text>  
                                            
                                        </xsl:attribute>
                                    </img>
                                </span>
                                
                                <!-- pull title -->
                                <p>
                                    <xsl:value-of select="str[@name='title']"/>
                                    <!-- if texts and not gallery view, add publication and date -->
                                    <xsl:if test="not($searchtype = 'gallery') and str[@name='category'] = 'texts'">
                                    <xsl:if test="str[@name='publication']"><xsl:text>, </xsl:text><xsl:value-of select="str[@name='publication']"/></xsl:if><xsl:text>, </xsl:text>
                                    <xsl:value-of select="str[@name='date']"/>
                                </xsl:if>
                                </p>
                            </a>
                            
                        </div><!-- /thumbnail_listing -->
                    </xsl:for-each>
           </div><!-- /searchresults -->
                
                <!-- Call pagination --> 
                    
                <xsl:call-template name="paginationLinks">
                    <!--<xsl:with-param name="baseLinkURL" select="concat($siteroot, $pagetype,'/', $subpagetype, '.html')"/>-->
                    <xsl:with-param name="numFound" select="$numFound"/>
                    <xsl:with-param name="start" select="$start_num"/>
                    <xsl:with-param name="rows" select="$rows_num"/>
                </xsl:call-template>
                    
                </xsl:if><!-- End check for numResults -->

                
            </xsl:when>
     
            
            <xsl:otherwise>
                <!-- Photos, Memorabilia, Texts main pages with faceted categories -->
                <h3><xsl:choose>
                    <xsl:when test="$pagetype = 'photographs'">Exposition Grounds</xsl:when>
                    <xsl:when test="$pagetype = 'memorabilia'">Sub Categories</xsl:when>
                    <xsl:when test="$pagetype = 'texts'">Sub Categories</xsl:when>
                </xsl:choose></h3>
                <ul class="sub_categories">
                    <xsl:for-each select="//lst[@name='sub_category']/int">
                        <li class="{translate(lower-case(@name), ' ', '_')}">
                            <a>
                                <xsl:attribute name="href">
                                    <xsl:call-template name="urlbuilder">
                                        <xsl:with-param name="subpagetype"><xsl:value-of select="translate(lower-case(@name), ' ', '_')"/></xsl:with-param>
                                    </xsl:call-template>
                                </xsl:attribute>
                                <span class="shade"><span class="name"><xsl:value-of select="functx:words-to-camel-case(@name)"/></span>
                                <span class="number"><xsl:value-of select="."/></span></span>
                            </a>
                        </li>
                    </xsl:for-each>
                </ul>
                
                <!--<h3>Keywords:</h3>
                <ul class="keywords">
                    <xsl:for-each select="//lst[@name='keywords']/int">
                        <li>
                            <a>
                                <xsl:attribute name="href">
                                    <xsl:call-template name="urlbuilder">
                                        <xsl:with-param name="fq">
                                            <xsl:text>keywords:"</xsl:text>
                                            <xsl:value-of select="encode-for-uri(@name)"/>
                                            <xsl:text>"</xsl:text></xsl:with-param>
                                    </xsl:call-template>
                                </xsl:attribute>
                                
                                <span class="name"><xsl:value-of select="functx:words-to-camel-case(@name)"/></span> 
                                <span class="number"><xsl:value-of select="."/></span>
                            </a>
                        </li>
                    </xsl:for-each>
                </ul>-->
         
                
                <xsl:if test="$pagetype = 'photographs'">
                    
                    <!--<h3>Interior:</h3>
                    <ul class="keywords">
                            <li>
                                <a>
                                    <xsl:attribute name="href">
                                        http://spacely.unl.edu/cocoon/transmississippi/photographs/.html?&amp;fq=keywords:%22exhibit%22
                                    </xsl:attribute>
                                    
                                    
                                    <span class="name">Exhibits</span> 
                                    <span class="number">345</span>
                                </a>
                            </li>
                        
                    </ul>-->
                    
                    <h3>Creator:</h3>
                <ul class="keywords">
                    <xsl:for-each select="//lst[@name='creator']/int">
                        <li>
                            <a>
                                <xsl:attribute name="href">
                                    <xsl:call-template name="urlbuilder">
                                        <xsl:with-param name="fq">
                                            <xsl:text>creator:"</xsl:text>
                                            <xsl:value-of select="encode-for-uri(@name)"/>
                                            <xsl:text>"</xsl:text></xsl:with-param>
                                    </xsl:call-template>
                                </xsl:attribute>
                                
                                <span class="name"><xsl:value-of select="functx:words-to-camel-case(@name)"/></span> 
                                <span class="number"><xsl:value-of select="."/></span>
                            </a>
                        </li>
                    </xsl:for-each>
                </ul>
                </xsl:if>
                
                <xsl:if test="//lst[@name='collection']/int != ''">
                
                <h3>Collection:</h3>
                
                <ul class="keywords">
                    <xsl:for-each select="//lst[@name='collection']/int">
                        <li>
                            <a>
                                <xsl:attribute name="href">
                                    <xsl:call-template name="urlbuilder">
                                        <xsl:with-param name="fq">
                                            <xsl:text>collection:"</xsl:text>
                                            <xsl:value-of select="encode-for-uri(@name)"/>
                                            <xsl:text>"</xsl:text></xsl:with-param>
                                    </xsl:call-template>
                                </xsl:attribute>
                                
                                <span class="name"><xsl:value-of select="functx:words-to-camel-case(@name)"/></span> 
                                <span class="number"><xsl:value-of select="."/></span>
                            </a>
                        </li>
                    </xsl:for-each>
                </ul>
                </xsl:if>
             
                <h3>Provenance:</h3>
                
                <ul class="keywords">
                    <xsl:for-each select="//lst[@name='provenance']/int">
                        <li>
                            <a>
                                <xsl:attribute name="href">
                                    <xsl:call-template name="urlbuilder">
                                        <xsl:with-param name="fq">
                                            <xsl:text>provenance:"</xsl:text>
                                            <xsl:value-of select="encode-for-uri(@name)"/>
                                            <xsl:text>"</xsl:text></xsl:with-param>
                                    </xsl:call-template>
                                </xsl:attribute>
                                
                                <span class="name"><xsl:value-of select="functx:words-to-camel-case(@name)"/></span> 
                                <span class="number"><xsl:value-of select="."/></span>
                            </a>
                        </li>
                    </xsl:for-each>
                </ul>
            </xsl:otherwise>
            </xsl:choose>
            
           
           
            
        </xsl:for-each>
       
        
    </xsl:template>
    
    <!-- =====================================================================================
        solr-file-list ||| For listing individual files using solr (Photos and Memorabilia)
        ===================================================================================== -->
    
    <xsl:template name="solr-file-list" xpath-default-namespace="">
        
        <!-- Call solrsearchurl template -->
        <xsl:variable name="solrsearchurl">
            <xsl:call-template name="solrURL">
                <xsl:with-param name="rowstart">0</xsl:with-param>
                <xsl:with-param name="rowend">1</xsl:with-param>
                <xsl:with-param name="searchfields">id,category,sub_category,keywords,date,creator,pages,title,caption,location,description,keywords,medium,size,collection,provenance</xsl:with-param>
                <xsl:with-param name="facet">true</xsl:with-param>
                <xsl:with-param name="facetfield"></xsl:with-param>
                <xsl:with-param name="other"></xsl:with-param>
                <xsl:with-param name="q"><xsl:text>id:</xsl:text><xsl:value-of select="$pageid"/></xsl:with-param>
                <xsl:with-param name="sort"><xsl:text>title</xsl:text></xsl:with-param>
            </xsl:call-template>
        </xsl:variable>
        
        <!-- uncomment to see the solr url for testing -->
        <!--<xsl:value-of select="$solrsearchurl"/>-->
        
        <!-- Set the xpath default namespace because SOLR results don't have a namespace -->
        <xsl:for-each select="document($solrsearchurl)">
            
            <h2>Title: <xsl:value-of select="/response/result/doc/str[@name='title']"/></h2>
            
            <!-- List all the descriptors present (do not show if not present) -->
            <ul class="callout">
                <xsl:for-each select="/response/result/doc/str[@name='caption']">
                    <li><strong><xsl:text>Caption: </xsl:text></strong> <xsl:value-of select="."/></li>
                </xsl:for-each>
                <xsl:for-each select="/response/result/doc/str[@name='location']">
                    <li><strong><xsl:text>Location: </xsl:text></strong> <xsl:value-of select="."/></li>
                </xsl:for-each>
                
                <xsl:for-each select="/response/result/doc/str[@name='date']">
                    <li><strong><xsl:text>Date: </xsl:text></strong> <xsl:value-of select="."/></li>
                </xsl:for-each>
                <xsl:for-each select="/response/result/doc/str[@name='medium']">
                    <li><strong><xsl:text>Medium: </xsl:text></strong> <xsl:value-of select="."/></li>
                </xsl:for-each>
                <xsl:for-each select="/response/result/doc/str[@name='size']">
                    <li><strong><xsl:text>Size: </xsl:text></strong> <xsl:value-of select="."/></li>
                </xsl:for-each>
                <xsl:for-each select="/response/result/doc/str[@name='creator']">
                    <li><strong><xsl:text>Creator: </xsl:text></strong> <xsl:value-of select="."/></li>
                </xsl:for-each>
                <xsl:for-each select="/response/result/doc/str[@name='collection']">
                    <li><strong><xsl:text>Collection: </xsl:text></strong> <xsl:value-of select="."/></li>
                </xsl:for-each>
                <xsl:for-each select="/response/result/doc/str[@name='provenance']">
                    <li><strong><xsl:text>Provenance: </xsl:text></strong> <xsl:value-of select="."/></li>
                </xsl:for-each>
                </ul>
                
            <xsl:for-each select="/response/result/doc/str[@name='description']">
                    <p><strong><xsl:text>Description: </xsl:text></strong> <pre><xsl:value-of select="."/></pre></p>
                </xsl:for-each>
                
                <!-- Cycle through all keywords to display and link them -->
                <!--<xsl:if test="/response/result/doc/arr[@name='keywords']/str">
                    <li><strong><xsl:text>Keywords: </xsl:text></strong>
                        <xsl:for-each select="/response/result/doc/arr[@name='keywords']/str">
                            <span class="subject_link">
                                <a>
                                    <xsl:attribute name="href">
                                        <xsl:call-template name="urlbuilder">
                                            <xsl:with-param name="fq">
                                                <xsl:text>keywords:"</xsl:text>
                                                <xsl:value-of select="."/>
                                                <xsl:text>"</xsl:text></xsl:with-param>
                                            <xsl:with-param name="pagetype">search</xsl:with-param>
                                            <xsl:with-param name="subpagetype"><xsl:value-of select="$pagetype"/></xsl:with-param>
                                        </xsl:call-template>
                                    </xsl:attribute>
                                    <xsl:value-of select="."/>
                                </a><xsl:text>  </xsl:text> 
                            </span>
                    </xsl:for-each>
                    </li>
                </xsl:if>-->
            
            
            <!-- Show image: if there are pages, show all of them. If not, show the one present image. -->
            <xsl:choose>
                <xsl:when test="//str[@name='pages']">      
                    <xsl:call-template name="recurse_till_x">
                        <xsl:with-param name="times" as="xs:integer"><xsl:value-of select="//str[@name='pages']"/></xsl:with-param>
                    </xsl:call-template>
                </xsl:when>
                <xsl:otherwise>
                    <img src="{$externalfileroot}large/{/response/result/doc/str[@name='id']}.jpg"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>

    </xsl:template>
    
    <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        recurse_till_x ||| Recursive template
        ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
    
    <xsl:template name="recurse_till_x" xpath-default-namespace="">
        <xsl:param name="num">1</xsl:param>
        <xsl:param name="times"/>
        
        <!-- Build HTML. Consider moving this outside the recurse till x template later so it is reusable -->
        <xsl:choose>
            <!-- Currently showing thumbnails if more than 10 images. May want to decrease this, or show all as thumbnails? -->
            <xsl:when test="$times > 10">
                <div class="thumbnail_listing_images">
                    
                    <a>
                        <xsl:attribute name="rel">
                            <xsl:text>prettyPhoto[pp_gal]</xsl:text>
                        </xsl:attribute>
                        <xsl:attribute name="href">
                            <xsl:value-of select="$externalfileroot"/>
                            <xsl:text>large/</xsl:text>
                            <xsl:value-of select="/response/result/doc/str[@name='id']"/>
                            <xsl:text>-</xsl:text>
                            <xsl:value-of select="format-number(number($num), '000')"/>
                            <xsl:text>.jpg</xsl:text>
                        </xsl:attribute>
                        
                        <span class="thumbnail_div">
                            <img>
                                <xsl:attribute name="src">
                                    <xsl:value-of select="$externalfileroot"/>
                                    <xsl:text>medium/</xsl:text>
                                    <xsl:value-of select="/response/result/doc/str[@name='id']"/>
                                    <xsl:text>-</xsl:text>
                                    <xsl:value-of select="format-number(number($num), '000')"/>
                                    <xsl:text>.jpg</xsl:text>
                                    
                                </xsl:attribute>
                            </img>
                        </span>
                    </a>
                    
                </div><!-- /thumbnail_listing -->
            </xsl:when>
            <xsl:otherwise>
                <img>
                    <xsl:attribute name="src">
                        <xsl:value-of select="$externalfileroot"/>
                        <xsl:text>large/</xsl:text>
                        <xsl:value-of select="/response/result/doc/str[@name='id']"/>
                        <xsl:text>-</xsl:text>
                        <xsl:value-of select="format-number(number($num), '000')"/>
                        <xsl:text>.jpg</xsl:text>
                    </xsl:attribute>
                </img>
            </xsl:otherwise>
        </xsl:choose>
        
        <!-- The recursion part -->

        <xsl:if test="$num != $times">
            
            <xsl:call-template name="recurse_till_x">
                <xsl:with-param name="num"><xsl:value-of select="$num + 1"/></xsl:with-param>
                <xsl:with-param name="times" as="xs:integer"><xsl:value-of select="$times"/></xsl:with-param>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>
    
    <!-- =====================================================================================
        Helper Templates
        ===================================================================================== -->
    
    <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        url builder
        ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
    
    <xsl:template name="urlbuilder">
        <xsl:param name="sort"><xsl:value-of select="$sort"/></xsl:param>
        <xsl:param name="searchtype"><xsl:value-of select="$searchtype"/></xsl:param>
        <xsl:param name="start"><xsl:value-of select="$start_num"/></xsl:param>
        <xsl:param name="pagetype"><xsl:value-of select="$pagetype"/></xsl:param>
        <xsl:param name="subpagetype"><xsl:value-of select="$subpagetype"/></xsl:param>
        <xsl:param name="pageid"><xsl:value-of select="$pageid"/></xsl:param>
        <xsl:param name="fq"><xsl:value-of select="$fq"/></xsl:param>
        
        <xsl:value-of select="$siteroot"/>
        <xsl:value-of select="$pagetype"/>
        
        <xsl:choose>
            <!-- For top level pages, as long as texts has no subpages -->
            <xsl:when test="$subpagetype = '' and $fq = '' and $q = '' and $pagetype != 'texts'">
                <xsl:text>.html</xsl:text>
            </xsl:when>
            <!-- Search URL -->
            <xsl:when test="$pagetype = 'search'">
                <xsl:text>/</xsl:text>
                <xsl:value-of select="$subpagetype"/>
                <xsl:text>/</xsl:text>
            </xsl:when>
            <!-- Photographs, Memorabilia -->
            <xsl:when test="$pageid != '' and $subpagetype != 'item'">
                <xsl:text>/view/</xsl:text>
                <xsl:value-of select="$pageid"/>
                <xsl:text>.html</xsl:text>
            </xsl:when>
            <!-- Texts -->
            <xsl:when test="$pagetype != 'search' and $subpagetype != 'item'">
                <xsl:text>/</xsl:text>
                <xsl:value-of select="$subpagetype"/>
                <xsl:text>.html</xsl:text>
            </xsl:when>
            <!-- Individual items -->
            <xsl:when test="$subpagetype = 'item'">
                <xsl:text>.html</xsl:text>
            </xsl:when>
        </xsl:choose> 
        
        <!-- variables, show a ? if any search/display variables present -->
        <xsl:if test="($sort != '' or $searchtype != '' or $start != 0 or $fq != '' or $pagetype = 'search') and $pageid = ''">
            <xsl:text>?</xsl:text>
            <xsl:if test="$searchtype != ''">
                <xsl:text>&amp;searchtype=</xsl:text>
                <xsl:value-of select="$searchtype"/>
            </xsl:if>
            <xsl:if test="$sort != ''">
                <xsl:text>&amp;sort=</xsl:text>
                <xsl:value-of select="$sort"/>
            </xsl:if>
            <xsl:if test="$start != 0">
                <xsl:text>&amp;start=</xsl:text>
                <xsl:value-of select="$start"/>
            </xsl:if>
            <xsl:if test="$fq != ''">
                <xsl:text>&amp;fq=</xsl:text>
                <xsl:value-of select="$fq"/>
            </xsl:if>
            <xsl:if test="$q != ''">
                <xsl:text>&amp;q=</xsl:text>
                <xsl:value-of select="$q"/>
            </xsl:if>
        </xsl:if>
           
    </xsl:template>
    
    <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        paginationLinks ||| Constructs links for pagination
        ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
    
    <xsl:template name="paginationLinks">
        <xsl:param name="searchTerm"/>
        <xsl:param name="numFound"/>
        <xsl:param name="start"/> <!-- defaults to 0, unless changed in cocoon sitemap -->
        <xsl:param name="rows"/> <!-- defaults to 10, unless changed in cocoon sitemap -->
        <xsl:param name="sort"/>
        
        <xsl:variable name="prev-link">
            
            <xsl:choose>
                <xsl:when test="$start_num &lt;= 0">
                    <xsl:text>Previous</xsl:text>
                </xsl:when>
                <xsl:otherwise>

                    <a>
                        <xsl:attribute name="href">
                            <xsl:call-template name="urlbuilder">
                                <xsl:with-param name="start"><xsl:value-of select="$start_num - $rows_num"/></xsl:with-param>
                            </xsl:call-template>
                            <xsl:if test="$searchTerm">
                                <xsl:text>q=</xsl:text>
                                <xsl:value-of select="$searchTerm"/>
                                <xsl:text>&#38;</xsl:text>
                            </xsl:if>
                        </xsl:attribute>
                        <xsl:text>Previous</xsl:text>
                    </a>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        
        <xsl:variable name="next-link">
            <xsl:choose>
                <xsl:when test="$start_num + $rows_num &gt;= $numFound">
                    <xsl:text>Next</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <a>
                        <xsl:attribute name="href">
                            <xsl:call-template name="urlbuilder">
                                <xsl:with-param name="start"><xsl:value-of select="$start_num + $rows_num"/></xsl:with-param>
                            </xsl:call-template>
                            <xsl:if test="$searchTerm">
                                <xsl:text>q=</xsl:text>
                                <xsl:value-of select="$searchTerm"/>
                                <xsl:text>&#38;</xsl:text>
                            </xsl:if>
                        </xsl:attribute>
                        <xsl:text>Next</xsl:text>
                    </a>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        
        <!-- Pagination HTML (do not show if less than 2 pages) -->
        <xsl:choose>
            <xsl:when test="ceiling($numFound div $rows_num) != 1">
                <div class="pagination"><xsl:copy-of select="$prev-link"/> | Go to <!--page --><form class="jumpForm">
                    <input type="text" name="paginationJump" value="{$start_num div $rows_num + 1}"
                        class="paginationJump"/>
                    <input type="submit" value="Go" class="paginationJumpBtn submit"/>
                </form> of <xsl:value-of select="ceiling($numFound div $rows_num)"/> | <xsl:copy-of
                    select="$next-link"/>
                </div>
            </xsl:when>
            <xsl:otherwise>
                <div class="pagination"><p>Showing all results (Page 1 of 1)</p>
                </div>
            </xsl:otherwise>
        </xsl:choose>
        
        <!-- /end Pagination HTML -->
        
    </xsl:template>
    
    <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        solrURL ||| Constructs solr search URL
        ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->

    <xsl:template name="solrURL">
        <xsl:param name="rowstart">0</xsl:param>
        <xsl:param name="rowend">10</xsl:param>
        <xsl:param name="searchfields">id,title,caption,location,description,keywords,date,medium,size,creator,collection</xsl:param>
        <xsl:param name="facet">false</xsl:param>
        <xsl:param name="facetfield"></xsl:param>
        <xsl:param name="other"></xsl:param>
        <xsl:param name="q">*:*</xsl:param>
        <xsl:param name="fq">*:*</xsl:param>
        <xsl:param name="sort"></xsl:param>

        <xsl:value-of select="$searchroot"/>
        
        <!-- Add sort if not set to default -->
        <xsl:choose>
            <xsl:when test="$sort = 'relevance'"><!-- do nothing to leave as default sort --></xsl:when>
            <xsl:otherwise>
                <xsl:text>&amp;sort=</xsl:text>
                <xsl:value-of select="$sort"></xsl:value-of>
                <xsl:text>+asc,date+asc</xsl:text>
            </xsl:otherwise>
        </xsl:choose>

            <!-- Start and rows -->
                <xsl:text>&amp;start=</xsl:text>
            <xsl:value-of select="$rowstart"></xsl:value-of>
                <xsl:text>&amp;rows=</xsl:text>
                <xsl:value-of select="$rowend"/>
            <!-- Which fields to return -->
                <xsl:text>&amp;fl=</xsl:text>
                <xsl:value-of select="$searchfields"/>
            <!-- faceting options -->
                <xsl:text>&amp;facet=</xsl:text>
                <xsl:value-of select="$facet"/>
                <xsl:if test="$facetfield != ''">
                  <xsl:text>&amp;facet.field=</xsl:text>
                  <xsl:value-of select="$facetfield"/>
                </xsl:if>
            <!-- anything else, passed through the other variable -->
                <xsl:value-of select="$other"/>
            <!-- query -->
            <xsl:text>&amp;q=%28</xsl:text>
            <xsl:value-of select="encode-for-uri($q)"/>
            <xsl:text>%29</xsl:text>
        <!-- filter query -->
        <xsl:if test="$fq != ''">
            <xsl:text>&amp;fq=</xsl:text>
            <xsl:value-of select="encode-for-uri($fq)"/>
        </xsl:if>
        
    </xsl:template>  
    
</xsl:stylesheet>
