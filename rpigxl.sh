#!/bin/bash
# rpigxl - RetroPie gamelist.xml Art Injector
# Written by VTSTech (www.VTS-Tech.org)
 
filename="/opt/retropie/configs/all/emulationstation/gamelists/nes/gamelist.xml"

declare -a artlist
declare -a xmlline
declare -a tmp

echo -e "###############################################"
echo -e "# rpigxl - RetroPie gamelist.xml Art Injector #"
echo -e "# Written by VTSTech (www.VTS-Tech.org)       #"
echo -e "# v0.1-alpha (01.12.2020)                     #"
echo -e "###############################################\n\n"
echo -e "** v0.1-alpha does <video> art only, Specify gamelist.xml on line 5 of script. ** \n"
echo -e "** Run ./rpigxl.sh from directory containing the art                           ** \n\n"
echo -e "Creating gamelist.xml backup...\n"
cp $filename ./rpigxl-backup.xml
echo -e "rpigxl-backup.xml created!\n"
#IFS=" \t\n"
i=0
echo -e "Building ART List...\n"
for artfile in "$search_dir"./*
do
  artlist[i]+=${artfile:2}
  (( i++ ))
done
#echo "Debug: [Art Filename]: "${artlist[2]}
i=0
echo -e "Now reading: " $filename "\n"
while read line
do
    xmlline[ $i ]="$line"
    (( i++ ))
done < $filename
xmltotal=$i
i=0
echo -e "Now matching ART to ROM Filenames...\n"
for x in "${xmlline[@]}" 
do	
	if [ "${x:0:6}" = "<path>" ]
		then
			#echo -e "Game path detected: " $x
			readarray -d "/" -t tmp <<< "$x"	
			rom_filename=${tmp[6]:0:-1} 
			if [ "${xmlline[ (( $i+5 )) ]}" = "<video />" ]
				then
					#echo -e "Empty <video> tag detected!\n"
					#echo -e "Checking ART List for match..."
					for y in "${artlist[@]}"
						do
							if [[ $y == *"${rom_filename:0:-4}"* ]]
								then
									artmatch=$PWD"/"$y
									echo -e "Match found!" $y
									xmlline[ (( $i+5 ))]="<video>"$artmatch"</video>"
								fi
						done					
				fi
		fi
	(( i++ ))
done
echo -e "All filenames checked. Injecting found ART into XML...\n"
rm -rf gamelist.xml
for z in "${xmlline[@]}"
	do
		echo "$z"
	done>gamelist.xml

echo -e "gamelist.xml created in " $PWD
