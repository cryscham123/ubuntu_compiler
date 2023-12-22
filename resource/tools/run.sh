#!/bin/bash

cd /files

for dir in */; do
	g++ -std=c++17 $dir/*.cpp 2> /dev/null
	if [ $? -e 0 ]; then
		for file in $dir/*.in; do
			echo "result for $file" >> $dir/outfile
			./a.out < $file >> $dir/outfile
			echo  >> $dir/outfile
			echo  >> $dir/outfile
		done
	fi
	rm a.out
done
