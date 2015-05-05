#!/bin/bash

ls *.pdf | sed "s/\.[^\.]*$//" | xargs -I {} convert -density 300 {}.pdf png/{}.png
#find . -name "*.pdf" -print0 | xargs -0 -I {} pdfcrop {} {}
