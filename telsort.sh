#!/bin/bash

# Variablen deklarieren und auf false setzen
# Files-Array zur Sammlung der Dateinamen
a=false
s=false
d=false 
declare -a files

# While-Schleife, die alle Parameter nach -a, -s oder -d absucht und ansonsten den Parameter als Dateinamen aufnimmt. Bei falschen Parametern Abbruch
while [ "$1" != '' ]
do
	case $1 in
		-a) shift; a=true;;
		-s) shift; s=true;;
		-d) shift; d=true;;
		*)  if [[ $1 != -* ]] ; then
				files+=($1);
			else
				echo Unbekannte Option $1
				exit
			fi;
			shift;;
	esac
done

# Durchläuft alle Elemente und Filtert alle nichtexistenten Dateien heraus
for i in "${!files[@]}"
do
	if [ ! -f "${files[$i]}" ] ; then
		echo "${files[$i]} existiert nicht"
		unset files[i];
	fi
done
  
# prüft ob Dateien vorhanden sind
if [ ${#files[@]} == 0 ] ; then
	echo Keine Dateien vorhanden.;
	exit;
fi

# output header
echo "Telefonlistenskript WI-14C"
echo "Matrikelnr.: 622424, 675704, 671137"

# explicitly declare associative array (implicit doesn't work)
declare -A content

# grab file contents
for i in "${files[@]}"
do
	# get file contents
	content[$i]=$(cat $i)
done

if [ "$a" = true ]
	then
		# sort everything together
		# join array into single var
		all=$(printf "\n%s" "${content[@]}")
		all=${all:1}
		sorted=$(echo "$all"|sort -k1 -k2)
		
		if [ "$d" = true ]
			then
				# sort into two columns
				sorted=$(echo "$sorted"|column)
		fi
		
		if [ "$s" = true ]
			then
				# output to console
				echo ""
				echo "$sorted"
			else
				echo "Telefonliste in Datei gespeichert, nicht am Screen ausgegeben"
		fi
		
		# ALWAYS save to a file
		echo "$sorted" > "list_sorted"
	else
		# sort files separately
		declare -A sorted_array
		
		# loop through content array
		for i in "${!content[@]}"
		do
			# sort single file
			sorted_array[$i]=$(echo "${content[$i]}"|sort -k1 -k2)
			
			if [ "$d" = true ]
			then
				# sort into two columns
				sorted_array[$i]=$(echo "${sorted_array[$i]}"|column)
			fi
			
			if [ "$s" = true ]
				then
					# output to console
					echo ""
					echo "Datei $i"
					echo "${sorted_array[$i]}"
				else
					echo "Telefonliste in Datei gespeichert, nicht am Screen ausgegeben"
			fi
			
			# ALWAYS save to a file
			echo "${sorted_array[$i]}" > "${i}_sorted"
		done
fi
