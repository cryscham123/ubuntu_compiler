#!/bin/bash

cd $1

for dir in */; do
	g++ -Wall -Werror -Wextra -std=c++17 ${dir}*.cpp 2> ${dir}error
	if [ $? -eq 0 ]; then
		for file in ${dir}*.in; do
			out="${file/%.in/.out}"
			if [ ! -v file ]; then
				echo "No infile found" > ${dir}error
				exit 1
			fi
			./a.out < $file > ${out}
			if [ $? -ne 0 ]; then
				echo $'\e[91mError: \e[0m'"Failed to run $(basename $file)" >> ${out}
			fi
		done
		rm a.out
		rm ${dir}error
	fi
done
