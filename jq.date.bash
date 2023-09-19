#!/bin/bash

JQ='.
|.[0] as $BIG 
|.[1] as $ID
|($BIG
|[.[] 
| { (.META.IDENTIFIANT): { (.META.CARTON+"_"+.META.DOC_ID) : ((.DATE | capture("^.(?<YEAR>[0-9]{4})" )|.YEAR |tonumber| select(.>0)|[.]) ) } }
]
| unique
|[ group_by(keys)
|.[]
| group_by(.[]|keys)
|.[] 
| reduce .[] as $a ({}; .[$a|keys[0]] [ $a[]|keys[0] ]+=$a[][])
| { (keys[0]): { (.[keys[0]]|keys[0]): ([(.[keys[0]][]|min) , (.[keys[0]][]|max)]|unique) }}
]
| reduce .[] as $a ({}; .[$a|keys[0]] [ $a[]|keys[0] ]=$a[][])
) as $dates
##########################################################
#|{(.key):([(.value|min), (.value|max)]|unique|join("-"))}
##########################################################
|[$ID[]
| select((.CARTONS)!=null)
| { (.IDENTIFIANT) : (.CARTONS) }  
| select(.[]
| to_entries
| select((.[].key|test("^_";"x"))==false)
)] as $cartons

| $cartons
|.
'

#JQ='.'
jq -s "$JQ"<<<$(cat BIG.RAW.json bdoa.json)

