#!/bin/bash
set -euo pipefail

URL="https://www.20min.ch"
html_content=$(curl -s "$URL")

# Links zu den Artikeln extrahieren
article_links=$(echo "$html_content" | grep -oP '(?<=href=")[^"]*(?=")' | grep '^/story/' | sort -u | head -n 5)

# überprüfe ob json oder stdout
if [[ "${1:-}" == "json" ]]; then
    echo "["
    first=true
    for link in $article_links; do
        full_url="$URL$link"
        article_content=$(curl -s "$full_url")
        article_title=$(echo "$article_content" | grep -oP '(?<=<title>).*?(?=</title>)' | tr -d '\n' | sed 's/"/\\"/g')

        if [ "$first" = true ]; then
            first=false
        else
            echo ","
        fi
        echo "  {\"title\": \"$article_title\", \"url\": \"$full_url\"}"
    done
    echo "]"
else
    echo -e "\033[1;34m================= Artikelübersicht =================\033[0m"
    for link in $article_links; do
        full_url="$URL$link"
        article_content=$(curl -s "$full_url")
        article_title=$(echo "$article_content" | grep -oP '(?<=<title>).*?(?=</title>)' | tr -d '\n')
        
        echo -e "\033[1;32mTitel:\033[0m $article_title"
        echo -e "\033[1;33mURL:\033[0m $full_url"
        echo "--------------------------------------------------------------"
    done
fi
