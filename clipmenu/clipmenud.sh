#!/bin/bash

cache_dir=/tmp/clipmenu/
mkdir -p "$cache_dir"

declare -A last_data

while sleep 1; do
    for selection in clipboard primary; do
        if type -p xsel >/dev/null 2>&1; then
            data=$(xclip -o -selection "$selection"; printf x)
        # else
        #    data=$(xsel --"$selection"; printf x)
        fi

        data=${data%x}

        [[ $data ]] || continue

        [[ ${last_data[$selection]} == "$data" ]] && continue
        last_data[$selection]=$data

        md5=$(md5sum <<< "$data")
        md5=${md5%% *}

        printf '%s' "$data" > "$cache_dir/$md5"
    done
done
