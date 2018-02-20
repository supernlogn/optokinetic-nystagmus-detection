#!/bin/bash
mkdir Ioannis_Athanasiadis_7848_Spyridon_Antoniadis_8030
mkdir -p Ioannis_Athanasiadis_7848_Spyridon_Antoniadis_8030/assets
mkdir -p Ioannis_Athanasiadis_7848_Spyridon_Antoniadis_8030/data
while IFS='' read -r line || [[ -n "$line" ]]; do
    cp -R $line Ioannis_Athanasiadis_7848_Spyridon_Antoniadis_8030/
done < deliverable_list.txt

zip Ioannis_Athanasiadis_7848_Spyridon_Antoniadis_8030.zip -r Ioannis_Athanasiadis_7848_Spyridon_Antoniadis_8030
rm -rd Ioannis_Athanasiadis_7848_Spyridon_Antoniadis_8030