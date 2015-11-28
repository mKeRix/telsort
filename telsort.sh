#!/bin/bash

a=true
s=true
d=true
files=('Controlling' 'Vorstand' 'Service')

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
		echo "$sorted"
	else
		# sort files separately
		echo "alles seperato"
fi
