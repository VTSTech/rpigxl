#!/bin/bash
# rpigxl - RetroPie gamelist.xml Art Injector
# Written by VTSTech (www.VTS-Tech.org)
# GitHub https://github.com/Veritas83/rpigxl

declare -a artlist
declare -a xmlline
declare -a tmp
declare -a args

i=0
verbose=0
gen=0
args=( "$@" )

echo -e "###############################################"
echo -e "# rpigxl - RetroPie gamelist.xml Art Injector #"
echo -e "# Written by VTSTech (www.VTS-Tech.org)       #"
echo -e "# v0.1-alpha3 (01.18.2020)                    #"
echo -e "# GitHub https://github.com/Veritas83/rpigxl  #"
echo -e "###############################################\n\n"

function showusage() {
	echo -e "Usage:\n"
	echo -e "./rpigxl.sh -type video -core snes -art /opt/retropie/configs/all/emulationstation/downloaded_media/snes/videos/\n\n"
	echo -e "* rpigxl.sh assumes you have generated an empty gamelist.xml use -gen to do this *\n"
	echo -e "-core specify single core, all lowercase ie: nes, snes, psx, arcade"
	echo -e "-gen  Generate empty gamelist.xml using SkyScraper, Requires -core be set"
	echo -e "-art  full path to directory with art, do not use ."
	echo -e "-type XML Tag to replace, Supported values: image, video"
	echo -e "-v    verbosity level, 1 displays found matches use -vv for more\n"
	echo -e "Use arguments!"	
}

if [ $# == 0 ]
then
	showusage
	exit 0
else 
	#echo -e ${args[0]}
	for arg in $@
		do
			#echo -e ${args[i+1]}
			#echo -e ${args[i]}
			if [ ${args[i]} = "-core" ]
			then
				core=${args[i+1]}
				filename="/opt/retropie/configs/all/emulationstation/gamelists/"${core}"/gamelist.xml"
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
			if [ ${args[i]} = "-vv" ]
			then
				verbose=2
			fi
			if [ ${args[i]} = "-gen" ]
			then
				gen=1
			fi
			((i++))
		done
	echo -e "gamelist.xml:" ${filename}
	echo -e "ART Path:" ${artpath}
	echo -e "XML Tag:" ${tagtype}
	echo -e "Generate:" ${gen}
	echo -e "Verbosity:" ${verbose}
	
	if [ $# -le 2 ]
	then
		echo -e "\nERROR: rpigxl.sh requires at least 3 arguments when run correctly\n"
		showusage
		exit 3
	fi
	if [[ ${gen} == 1 ]]
	then
		if [[ ${#core} -gt 2 ]]
		then
			echo -e "\n* Running in gamelist.xml Generation Mode, Checking Skyscraper existence..."
			if test -f /opt/retropie/supplementary/skyscraper/Skyscraper
			then
				echo -e "\n* Skyscraper detected! Proceeding...\n"
				/opt/retropie/supplementary/skyscraper/Skyscraper -p "${core}" -s import
				/opt/retropie/supplementary/skyscraper/Skyscraper -p "${core}" --nobrackets --skipped --unattend -g /opt/retropie/configs/all/emulationstation/gamelists/"${core}"/ --nohints
				echo -e "\n* gamelist.xml generation complete. You can rpigxl.sh without -gen now!"
				exit 0
			else
				echo -e "\nERROR: Skyscraper not installed. Install Skyscraper to generate gamelist.xml"
				exit 2
			fi
		else
			echo -e "\nERROR: Cannot generate gamelist.xml without -core"
			exit 1
		fi
	fi
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
			# video tag
			if [ "${tagtype}" = "video" ]
			then
				if [ "${xmlline[ (( $i+5 )) ]}" = "<video />" ]
				then
					if [[ ${verbose} -ge 2 ]]
					then
						echo -e "Empty <video> tag detected!"
						echo -e "Checking ART List for match..."
					fi
					for y in "${artlist[@]}"
					do
						if [[ $y == *"${rom_filename:0:-4}"* ]]
						then
							artmatch=$y
							if [[ ${verbose} -ge 1 ]]
							then
								echo -e "Match found!" $artmatch
							fi								
							xmlline[ (( $i+5 ))]="<video>"$artmatch"</video>"
						fi
					done
				fi
			# image tag
			elif [ "${tagtype}" = "image" ]
			then
				if [ "${xmlline[ (( $i+3 )) ]}" = "<image />" ]
				then
					if [[ ${verbose} -ge 2 ]]
					then
						echo -e "Empty <image> tag detected!"
						echo -e "Checking ART List for match..."
					fi
					for y in "${artlist[@]}"
					do
						if [[ $y == *"${rom_filename:0:-4}"* ]]
						then
							artmatch=$y
							if [[ ${verbose} -ge 1 ]]
							then
								echo -e "Match found!" $artmatch
							fi								
							xmlline[ (( $i+3 ))]="<image>"$artmatch"</image>"
						fi
					done
				fi
			# cover tag
			elif [ "${tagtype}" = "cover" ]
			then
				if [ "${xmlline[ (( $i+2 )) ]}" = "<cover />" ]
				then
					if [[ ${verbose} -ge 2 ]]
					then
						echo -e "Empty <cover> tag detected!"
						echo -e "Checking ART List for match..."
					fi
					for y in "${artlist[@]}"
					do
						if [[ $y == *"${rom_filename:0:-4}"* ]]
						then
							artmatch=$y
							if [[ ${verbose} -ge 1 ]]
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
	cp -vi gamelist.xml "/opt/retropie/configs/all/emulationstation/gamelists/"${core}"/"
	exit 0
fi