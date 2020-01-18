#!/bin/bash
# rpigxl - RetroPie gamelist.xml Art Injector
# Written by VTSTech (www.VTS-Tech.org)
 
nes="/opt/retropie/configs/all/emulationstation/gamelists/nes/gamelist.xml"

declare -a artlist
declare -a xmlline
declare -a tmp
declare -a args
i=0
verbose=0
args=( "$@" )

echo -e "###############################################"
echo -e "# rpigxl - RetroPie gamelist.xml Art Injector #"
echo -e "# Written by VTSTech (www.VTS-Tech.org)       #"
echo -e "# v0.1-alpha1 (01.18.2020)                    #"
echo -e "# GitHub https://github.com/Veritas83/rpigxl  #"
echo -e "###############################################\n\n"

if [ $# == 0 ]
then
	echo -e "Usage:\n"
	echo -e "./rpigxl.sh -type video -core snes -art /opt/retropie/configs/all/emulationstation/downloaded_media/snes/videos/\n\n"
	echo -e "* rpigxl.sh assumes you have run SkyScraper and generated an empty game list with your Rom Names and Filenames *"
	echo -e "* future versions of rpigxl.sh will simply do this for you. For now do it prior to running rpigxl.sh           *\n\n"
	echo -e "-core specify single core, all lowercase ie: nes, snes, psx, arcade"
	echo -e "-art  full path to directory with art, do not use ."
	echo -e "-type XML Tag to replace, Supported values: image, video"
	echo -e "-v    verbosity level, 1 displays found matches\n"
	echo -e "Use arguments!"
	exit 0
else 
	#echo -e ${args[0]}
	for arg in $@
		do
			#echo -e ${args[i+1]}
			#echo -e ${args[i]}
			if [ ${args[i]} = "-core" ]
			then
				filename="/opt/retropie/configs/all/emulationstation/gamelists/"${args[i+1]}"/gamelist.xml"
			fi
			if [ ${args[i]} = "-art" ]
			then
				artpath=${args[i+1]}
			fi
			if [ ${args[i]} = "-type" ]
			then
				tagtype=${args[i+1]}
			fi
			if [ ${args[i]} = "-v" ]
			then
				verbose=1
			fi
			((i++))
		done
	echo -e "gamelist.xml:" ${filename}
	echo -e "ART Path:" ${artpath}
	echo -e "XML Tag:" ${tagtype}
	echo -e "Verbosity:" ${verbose}
	echo -e "\nCreating gamelist.xml backup...\n"
	if test -f "$filename"
	then
		cp $filename ./rpigxl-backup.xml
		echo -e "rpigxl-backup.xml created!\n"
	fi
	#IFS=" \t\n"
	i=0
	echo -e "Building ART List...\n"
	for artfile in "${artpath}"*
	do
	  artlist[i]+=${artfile}
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
			rom_filename=${tmp[6]} 
			#video tag
			if [ "${tagtype}" = "video" ]
			then
				if [ "${xmlline[ (( $i+5 )) ]}" = "<video />" ]
				then
					#echo -e "Empty <video> tag detected!\n"
					#echo -e "Checking ART List for match..."
					for y in "${artlist[@]}"
					do
						if [[ $y == *"${rom_filename:0:-4}"* ]]
						then
							artmatch=$y
							if [[ ${verbose} == 1 ]]
							then
								echo -e "Match found!" $artmatch
							fi								
							xmlline[ (( $i+5 ))]="<video>"$artmatch"</video>"
						fi
					done
				fi
			elif [ "${tagtype}" = "image" ]
			then
				if [ "${xmlline[ (( $i+3 )) ]}" = "<image />" ]
				then
					#echo -e "Empty <video> tag detected!\n"
					#echo -e "Checking ART List for match..."
					for y in "${artlist[@]}"
					do
						if [[ $y == *"${rom_filename:0:-4}"* ]]
						then
							artmatch=$y
							if [[ ${verbose} == 1 ]]
							then
								echo -e "Match found!" $artmatch
							fi								
							xmlline[ (( $i+3 ))]="<image>"$artmatch"</image>"
						fi
					done
				fi
			elif [ "${tagtype}" = "cover" ]
			then
				if [ "${xmlline[ (( $i+2 )) ]}" = "<cover />" ]
				then
					#echo -e "Empty <video> tag detected!\n"
					#echo -e "Checking ART List for match..."
					for y in "${artlist[@]}"
					do
						if [[ $y == *"${rom_filename:0:-4}"* ]]
						then
							artmatch=$y
							if [[ ${verbose} == 1 ]]
							then
								echo -e "Match found!" $artmatch
							fi								
							xmlline[ (( $i+2 ))]="<cover>"$artmatch"</cover>"
						fi
					done
				fi
			fi					
	fi
	(( i++ ))
	done
	echo -e "\nAll filenames checked. Injecting found ART into XML...\n"
	rm -fv gamelist.xml
	for z in "${xmlline[@]}"
	do
		echo "$z"
	done>gamelist.xml

	echo -e "gamelist.xml created in " $PWD
fi
