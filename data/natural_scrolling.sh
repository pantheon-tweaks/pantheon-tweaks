#!/bin/bash
# Natural Scrolling Script
id=`xinput list | grep -Po "[Tt]ouch[^=]*id=[0-9]+" | grep -Po [0-9]+`
prop_id=`xinput --list-props $id | grep -P ".*[^C][^i][^r][^c][^u][^l][^a][^r]\sScrolling Distance" | grep -Po '\([0-9]+\)' | grep -Po "[0-9]+"`
arg="$1"
state=`xinput --list-props $id | grep -P ".*[^C][^i][^r][^c][^u][^l][^a][^r]\sScrolling Distance" | grep -Po '\s+[-+]?[0-9]+[,]?' | tr -d ',' | tr -d ' \t' | tr -d '0-9' | tr -d '\n' | tr '-' '1'`

if [ "$1" == true ]; then
    xinput --list-props $id | grep -P ".*[^C][^i][^r][^c][^u][^l][^a][^r]\sScrolling Distance" | grep -Po '\s+[-+]?[0-9]+[,]?' | tr -d '-' | tr -d ',' | tr ' \t' '-' | xargs xinput --set-prop $id $prop_id
elif [ "$1" == false ]; then
    xinput --list-props $id | grep -P ".*[^C][^i][^r][^c][^u][^l][^a][^r]\sScrolling Distance" | grep -Po '\s+[-+]?[0-9]+[,]?' | tr -d '-' | tr -d ',' | tr -d ' \t' | xargs xinput --set-prop $id $prop_id
else
    if [ "$state" == 11 ]; then
        echo "true"
    else
        echo "false"
    fi
fi
