# script to create the documentation pdf
pandoc main.md -f markdown -s -o report.pdf --pdf-engine=xelatex --variable mainfont="CMU Serif" --variable sansfont="CMU Sans Serif"