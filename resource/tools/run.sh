#!/bin/bash

cd /files

for dir in */; do
	g++ -std=c++17 ${dir}*.cpp 2> ${dir}error
	if [ $? -eq 0 ]; then
		for file in ${dir}*.in; do
			out="${file/%.in/.out}"
			./a.out < $file > ${out}
		done
		rm a.out
		rm ${dir}error
	fi
done
