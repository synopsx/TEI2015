xquery version '3.0' ;
module namespace TEI2015.models.tei = 'TEI2015.models.tei' ;

(:~
 : This module is for TEI models
 :
 : @version 2.0 (Constantia edition)
 : @since 2014-11-10 
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

import module namespace synopsx.models.synopsx = 'synopsx.models.synopsx' at '../../../models/synopsx.xqm' ;

declare namespace tei = 'http://www.tei-c.org/ns/1.0' ;

declare default function namespace "TEI2015.models.tei";






declare function queryPerson($queryParams as map(*)) as map(*) {
  let $texts := getPersonItems($queryParams)
  
   let $meta := map{
    'title' : fn:count($texts) || ' TEI texts' 
    }
    
  let $content := for $text in $texts return getPersonMap($text)
  
  return  map{
    'meta'    : $meta,
    'content' : $content
    }
};


declare function getPersonItems($queryParams){

  let $sequence := synopsx.models.synopsx:getDb($queryParams)//tei:person
  (: TODO : analyse query params : is an id specified ?  is a sorting order specified ? ... :)
  return 
      if ($queryParams('id'))  then $sequence[@xml:id = $queryParams('id')] else $sequence
};



declare function getPersonMap($item as item()) as map(*) {
 map{
      'surname':$item/tei:surname/text()
      }
  };






