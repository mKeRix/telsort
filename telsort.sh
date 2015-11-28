#!/bin/bash

a=false
s=true
d=true
files=('Controlling' 'Vorstand' 'Service')

# output header
echo "Telefonlistenskript WI-14C"
echo "Matrikelnr.: 622424"

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
