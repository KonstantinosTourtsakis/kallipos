#!/bin/sh


if [ ! -d "./pollen" ]; then
  mkdir ./pollen
fi

if [ ! -d "./book" ]; then
  mkdir ./book
fi


pandoc text/pre.txt --lua-filter=epigraph.lua --to markdown | pandoc --top-level-division=chapter --to html > pollen/pre.html
pandoc text/intro.txt --lua-filter=epigraph.lua --to markdown | pandoc --top-level-division=chapter --to html > pollen/intro.html

for filename in text/ch*.txt; do
   [ -e "$filename" ] || continue
   pandoc --lua-filter=extras.lua "$filename" --to markdown | pandoc --lua-filter=contribution.lua --to markdown| pandoc --lua-filter=extras.lua --to markdown | pandoc --lua-filter=epigraph.lua --to markdown | pandoc --lua-filter=figure-pollen.lua --to markdown  | pandoc --filter pandoc-fignos --to html | pandoc --metadata-file=meta.yml --top-level-division=chapter --citeproc --bibliography=bibliography/"$(basename "$filename" .txt).bib" --reference-location=section --to html > pollen/"$(basename "$filename" .txt).html"
done

pandoc text/web.txt --lua-filter=epigraph.lua --to markdown | pandoc --top-level-division=chapter --to html > pollen/web.html
pandoc text/bio.txt --lua-filter=epigraph.lua --to markdown | pandoc --top-level-division=chapter --to html > pollen/bio.html

for filename in text/apx*.txt; do
   [ -e "$filename" ] || continue
   pandoc --lua-filter=extras.lua "$filename" --to markdown | pandoc --lua-filter=extras.lua --to markdown | pandoc --lua-filter=epigraph.lua --to markdown | pandoc --lua-filter=figure-pollen.lua --to markdown | pandoc --filter pandoc-fignos --to html | pandoc --metadata-file=meta.yml --top-level-division=chapter --citeproc --bibliography=bibliography/"$(basename "$filename" .txt).bib" --reference-location=section --to html > pollen/"$(basename "$filename" .txt).html"
done


pandoc --quiet -s pollen/*.html -o book/index.html.pp --metadata title="Ο Προγραμματισμός της Διάδρασης"
sed -i '1s/^/#lang pollen\n/' book/index.html.pp
raco pollen render book/index.html.pp

echo -e "Book build: book/index.html\n"