xquery version "3.0" ;
module namespace example.webapp = 'example.webapp' ;

(:~
 : This module is the RESTXQ for SynopsX's example
 :
 : @version 2.0 (Constantia edition)
 : @since 2015-02-05 
 : @author synopsx team
 :
 : This file is part of SynopsX.
 : created by AHN team (http://ahn.ens-lyon.fr)
 :
 : SynopsX is free software: you can redistribute it and/or modify
 : it under the terms of the GNU General Public License as published by
 : the Free Software Foundation, either version 3 of the License, or
 : (at your option) any later version.
 :
 : SynopsX is distributed in the hope that it will be useful,
 : but WITHOUT ANY WARRANTY; without even the implied warranty of
 : MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
 : See the GNU General Public License for more details.
 : You should have received a copy of the GNU General Public License along 
 : with SynopsX. If not, see http://www.gnu.org/licenses/
 :
 :)

(: Import synopsx's globals variables and libraries :)
import module namespace G = "synopsx.globals" at '../../../globals.xqm' ;
import module namespace synopsx.models.synopsx = 'synopsx.models.synopsx' at '../../../models/synopsx.xqm' ;

(: Put here all import modules declarations as needed :)
import module namespace synopsx.models.tei = 'synopsx.models.tei' at '../../../models/tei.xqm' ;

(: Put here all import declarations for mapping according to models :)
import module namespace synopsx.mappings.htmlWrapping = 'synopsx.mappings.htmlWrapping' at '../../../mappings/htmlWrapping.xqm' ;

(: Use a default namespace :)
declare default function namespace 'TEI2015Workshop.webapp' ;


declare variable $example.webapp:project := 'example' ;
declare variable $example.webapp:db := synopsx.models.synopsx:getProjectDB($example.webapp:project) ;



(:~
 : this resource function redirect to /home
 :
 :)
declare 
  %restxq:path("/TEI2015Workshop")
function index() {
  <rest:response>
    <http:response status="303" message="See Other">
      <http:header name="location" value="/example/home"/>
    </http:response>
  </rest:response>
};

(:~
 : this resource function is the html representation of the corpus resource
 :
 : @return an html representation of the corpus resource with a bibliographical list
 : the HTML serialization also shows a bibliographical list
 :)
declare 
  %restxq:path('/TEI2015Workshop/home')
  %rest:produces('text/html')
  %output:method("html")
  %output:html-version("5.0")
function home() {
  let $queryParams := map {
    'project' : $example.webapp:project,
    'dbName' :  $example.webapp:db,
    'model' : 'tei' ,
    'function' : 'queryCorpusList',
    'id' : $example.webapp:project
    }
  let $outputParams := map {
    'lang' : 'fr',
    'layout' : 'home.xhtml',
    'pattern' : 'inc_textItem.xhtml',
    'xsl':'tei2html5'
    }  
 return synopsx.models.synopsx:htmlDisplay($queryParams, $outputParams)
};



(:~
 : this resource function is the corpus resource
 :
 : @return an HTTP message with Content-location against the user-agent request
 : @rmq Content-location in HTTP can be used when a requested resource has 
 : multiple representations. The selection of the resource returned will depend 
 : on the Accept headers in the original GET request.
 : @bug not working curl -I -H "Accept:text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8" http://localhost:8984/corpus/
 :)
declare 
  %restxq:path('/TEI2015Workshop/letters')
  %rest:produces('application/json')
  %output:method('json')
function textsJS() {
   let $queryParams := map {
      'project' : $example.webapp:project,     
      'dbName' : $example.webapp:db,
      'model' : 'tei',
      'function' : 'queryTEIList'
    }    
   let $function := xs:QName(synopsx.models.synopsx:getModelFunction($queryParams))
    return fn:function-lookup($function, 1)($queryParams)
};

(:~
 : this resource function is the html representation of the corpus resource
 :
 : @return an html representation of the corpus resource with a bibliographical list
 : the HTML serialization also shows a bibliographical list
 :)
declare 
  %restxq:path('/TEI2015Workshop/letters')
  %rest:produces('text/html')
  %output:method("html")
  %output:html-version("5.0")
function textsHtml() {  
    let $queryParams := map {
    'project' : $example.webapp:project,
    'dbName' :  $example.webapp:db,
    'model' : 'tei' ,
    'function' : 'queryTEIList'
    }
   let $outputParams := map {
    'lang' : 'fr',
    'layout' : 'home.xhtml',
    'pattern' : 'inc_defaultItem.xhtml'
    (: specify an xslt mode and other kind of output options :)
    }
 return synopsx.models.synopsx:htmlDisplay($queryParams, $outputParams)
};


(:~
 : this resource function is the html representation of the corpus resource
 :
 : @return an html representation of the corpus resource with a bibliographical list
 : the HTML serialization also shows a bibliographical list
 :)
declare 
  %restxq:path('/TEI2015Workshop/letter/{$id}')
  %rest:produces('text/html')
  %output:method("html")
  %output:html-version("5.0")
function textHtml($id) {
  let $queryParams := map {
  'project' : $example.webapp:project,
  'dbName' :  $example.webapp:db,
  'model' : 'tei' ,
  'function' : 'queryTEIList',
  'id':$id
  }
 let $outputParams := map {
  'lang' : 'fr',
  'layout' : 'home.xhtml',
  'pattern' : 'inc_textItem.xhtml'
  (: specify an xslt mode and other kind of output options :)
  }
return synopsx.models.synopsx:htmlDisplay($queryParams, $outputParams)
};  
