# script to create the documentation pdf
touch report.md
cat main.md >> report.md
cat linear_1.md >> report.md
cat linear_2.md >> report.md
cat nonlinear_1.md >> report.md
cat nonlinear_2.md >> report.md
cat project_structure.md >> report.md
pandoc report.md -f markdown -s -o report.tex --pdf-engine=xelatex --variable mainfont="CMU Serif" --variable sansfont="CMU Sans Serif"
pandoc report.md -f markdown -s -o report.pdf --pdf-engine=xelatex --variable mainfont="CMU Serif" --variable sansfont="CMU Sans Serif"
rm report.md