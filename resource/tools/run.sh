#!/bin/bash

cd /files

for dir in */; do
	g++ -std=c++17 $dir/*.cpp 2> /dev/null
	if [ $? -eq 0 ]; then
		for file in $dir*.in; do
			out="${file/%.in/.out}"
			./a.out < $file > ${out}
		done
		rm a.out
	else
		echo $'\e[91mCompile Error:\e[0m '$(basename $dir)
	fi
done
