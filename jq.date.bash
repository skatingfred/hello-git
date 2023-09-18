#!/bin/bash

JQ='.
|.[0] as $BIG 
|.[1] as $ID
| $BIG
|[.[] 
| { (.META.IDENTIFIANT+"-"+.META.CARTON) : (.DATE | capture("^.(?<YEAR>[0-9]{4})" )|.YEAR |tonumber)} 
| to_entries
| .[] ]
|group_by(.key)
|map(first+{value:( (map(.value|select(.!=0))|unique))})
| .[] 
|{(.key):([(.value|min), (.value|max)]|unique)}
#| $ID
#| .

##########################################################
#|{(.key):([(.value|min), (.value|max)]|unique|join("-"))}
##########################################################


|.
'

#JQ='.'

jq -s "$JQ"<<<$(cat BIG.RAW.json bdoa.json)



exit
  id: (.message | capture("id (?<id>[[:digit:]]+)").id)
