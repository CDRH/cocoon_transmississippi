<?xml version="1.0"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:functx="http://www.functx.com"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" 
    xpath-default-namespace="http://www.tei-c.org/ns/1.0"
    xmlns="http://www.w3.org/1999/xhtml" version="2.0">
    
    <xsl:template match="/">
        <xsl:element name="html">
            <xsl:attribute name="class">
                <xsl:value-of select="$pagetype"/>
                <xsl:if test="$subpagetype != ''">
                    <xsl:text> </xsl:text>
                    <xsl:value-of select="$subpagetype"/>
                    <xsl:text> subpage</xsl:text>
                </xsl:if>
            </xsl:attribute>
        
        <!--<html xmlns="http://www.w3.org/1999/xhtml" class="{$pagetype} {$subpagetype}">-->
            
            <head>
                <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
                <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
                
                <title>Trans-Mississippi International Exposition</title>
                
                <!--<link href='http://fonts.googleapis.com/css?family=Rokkitt:400,700|Marcellus' rel='stylesheet' type='text/css'/>-->
                <!--<link rel="shortcut icon" type="image/x-icon" href="favicon.ico"/>-->
                <!--<link href="http://fonts.googleapis.com/css?family=Rokkitt|Tangerine|Stint+Ultra+Expanded|Goudy+Bookletter+1911" rel="stylesheet" type="text/css" />-->
                <link rel="preconnect" href="https://fonts.gstatic.com" />
                <link href="https://fonts.googleapis.com/css2?family=Goudy+Bookletter+1911&amp;family=Rokkitt&amp;family=Stint+Ultra+Expanded&amp;family=Tangerine&amp;display=swap" rel="stylesheet" /> 
                    
                <link href="{$siteroot}files/css/reset.css" rel="stylesheet" type="text/css"/> 
                <link href="{$siteroot}files/css/style.css" rel="stylesheet" type="text/css"/>
                
                <!-- JQuery -->
                <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js"> &#160; </script>
                
                <!-- Pretty Photo -->
                <link rel="stylesheet" href="{$siteroot}files/js/prettyPhoto_compressed_3.1.3/css/prettyPhoto.css" type="text/css" media="screen" charset="utf-8" />
                <script src="{$siteroot}files/js/prettyPhoto_compressed_3.1.3/js/jquery.prettyPhoto.js"> &#160; </script>
                                
                <script src="{$siteroot}files/js/script.js"> &#160; </script>
                <script async src="https://www.googletagmanager.com/gtag/js?id=G-M1S6YLPYCQ">&#160; <:/script>
                <!-- Expand Text -->
                <!--<script type="text/javascript">
                    function unhide(divID) {
                    var item = document.getElementById(divID);
                    if (item) {
                    item.className=(item.className=='hidden')?'unhidden':'hidden';
                    }
                    }
                </script>-->
                <script  type="text/javascript">
                <![CDATA[
                
                   
                   
                   
                     window.dataLayer = window.dataLayer || [];
                     function gtag(){dataLayer.push(arguments);}
                     gtag('js', new Date());

                     gtag('config', 'G-M1S6YLPYCQ');

                   
                   ]]>
                   
             </script>
            </head>
            
            
            <body>
                <!-- Add a class if a main page, by detecting if there are variables. For styling purposes. Perhaps better to move into sitemap? -->
                <xsl:if test="$q = '' and $fq = '' and $subpagetype = ''">
                    <xsl:attribute name="class"><xsl:text>mainpage</xsl:text></xsl:attribute>
                </xsl:if>
                
                <div class="pagewrap">
                    <div id="header" class="header">
                        <div class="header_inner">
                        
                        <!-- Link takes one back to home page by clicking title -->
                            <h1><a href="{$siteroot}">
                            <span class="trans">Trans</span>
                            <span class="dash">-</span>
                            <span class="mississippi">Mississippi</span>
                            <span class="and">&amp;</span>
                            <span class="i_e">International Exposition</span></a></h1>
                        
                            
                            <form action="{$siteroot}search/all/" method="get" enctype="application/x-www-form-urlencoded">
                                <input id="basic-q" type="text" name="q" value="" class="textField"/>
                                    <input type="submit" value="Search" class="submit"/>
                            </form>
 
                        <div id="nav" class="nav">
                            <ul>
                                <li><a class="home" href="{$siteroot}">Home</a></li>
                                <li><a class="photographs" href="{$siteroot}photographs.html">Photographs</a></li>
                                <li><a class="memorabilia" href="{$siteroot}memorabilia.html">Memorabilia</a></li>
                                <li><a class="texts" href="{$siteroot}texts.html">Texts</a></li>
                                <li><a class="about" href="{$siteroot}about.html">About</a></li>
                            </ul>
                            
                        </div><!-- /nav -->
                        </div><!-- /header_inner -->
                    </div> <!-- /header -->
                    
                    <div id="main" class="main">
                        
                        <!-- Invoke rules in page_templates.xsl -->
                        <xsl:call-template name="mainContent"/>
                        
                    </div><!-- /main -->
                    
                    <div id="footer" class="footer">
                        
                        <!-- Currently hidden until more sections are added -->
                        <!--<div class="nav">
                            <ul>
                                <li><a href="{$siteroot}" class="home">Home</a></li>
                            </ul>
                        </div>--> <!-- /nav -->
                        
                        <div  class="footerinfo">
                            <p>Created by the <a href="http://cdrh.unl.edu">Center for Digital Research in the
                                Humanities</a>. 
                                <br/>Funding provided by the <a href="http://www.unl.edu/plains/pha/pha.shtml">Plains Humanities Alliance</a>, the <a href="http://www.unl.edu/plains/welcome">Center for Great Plains Studies</a>, and the 
                                <br/><a href="http://research.unl.edu/">Office of Research and Economic Development at the University of Nebraska–Lincoln</a>.
                                
                                <br />Thanks to <a href="http://www.omahapubliclibrary.org/">Omaha Public Library</a> and Jeffrey Spencer for use of collections.</p>
                        </div> <!-- /footerinfo -->
                        
                        <div class="icons">
                            <a href="http://www.omahapubliclibrary.org/"><img src="{$siteroot}files/template/opl_logo.png"  class="right"/></a> <a href="http://www.unl.edu/"><img src="{$siteroot}files/template/unl_logo.png"  class="right"/></a>
                        </div><!-- /icons -->
                        
                    </div> <!-- /footer -->
                </div><!-- /pagewrap -->
            </body>
        <!--</html>-->
        
        </xsl:element><!-- /html -->
        
    </xsl:template>

</xsl:stylesheet>
