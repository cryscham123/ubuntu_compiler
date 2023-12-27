#!/bin/bash

printUsage()
{
	echo "Usage: yo [OPTION]... [DIRECTORY]"
	echo
	echo $' -D\t\tCompile in ubuntu with docker'
	echo $' -I[number]\tCreate infile before compile'
}

compileInDocker()
{
	echo $'\n\e[92mCompile in ubuntu with docker...\e[0m\n'

	docker-compose -f ${RESOURCE_PWD}/docker-compose.yaml build
	if [ $? -ne 0 ]; then
		echo $'\e[91mError: \e[0m docker-compose execute failed.'
		exit 1
	fi

	docker-compose -f ${RESOURCE_PWD}/docker-compose.yaml up
	if [ $? -ne 0 ]; then
		echo $'\e[91mError: \e[0m docker-compose execute failed.'
		exit 1
	fi
}

# validate argument
if [[ $# -lt 1 ]]; then
	printUsage
	exit 1
fi
for arg in "$@"; do
	if [[ $arg == -* ]]; then
		case ${arg:1} in 
			D*)
				export exe_docker
				;;
			I*)
				if [[ ! ${arg:2} =~ ^[0-9]+$ ]]; then
					echo $'\e[91mError: \e[0m'"Invalid Argument '${arg:2}'"
					echo
					printUsage
					exit 1
				fi
				input="$input ${arg:2}"
				;;
			*)
				echo $'\e[91mError: \e[0m'"Invalid Argument '$arg'"
				echo
				printUsage
				exit 1
				;;
		esac
	else
		if [ -v target ]; then
			echo $'\e[91mError: \e[0m'"Invalid Argument '$arg'"
			echo
			printUsage
			exit 1
		fi
		target=$arg
	fi
done

# check argument
target_path=$(pwd)/$target
if [ ! -d $target_path ]; then
	echo $'\e[91mError: \e[0m'"No such directory '$target'"
	exit 1
fi
for file in $input; do
	printf "Infile creation for \e[93m\'%s\'\e[0m\n" $file
	echo "Type all input and press cntl+d."
	echo
	cat > ${target_path}/${file}.in
	echo
	if [ $? -eq 0 ]; then
		echo $'\e[92mInFile creation success: \e[0m'${target}/${file}.in
		echo
	else
		echo $'\e[92mInFile creation Failed: \e[0m'${target}/${file}.in
		exit 1
	fi
done

# copy files and execute
export RESOURCE_PWD=${HOME}/boj/resource
if [ ! -e ${RESOURCE_PWD}/files ]; then
	mkdir -p ${RESOURCE_PWD}/files
fi
cp -r ${target_path} ${RESOURCE_PWD}/files/$target
if [ $? -ne 0 ]; then
	echo $'\e[91mError: \e[0mcopy to '${RESOURCE_PWD}/files failed.
	exit 1
fi

if [ -v exe_docker ]; then
	compileInDocker
else
	echo $'\n\e[92mCompile in local...\e[0m\n'
	${RESOURCE_PWD}/tools/run.sh ${RESOURCE_PWD}/files
fi

for dir in ${RESOURCE_PWD}/files/*/; do
	if compgen -G ${dir}error > /dev/null; then
		echo $'\e[91mError:\e[0m '$(basename $dir)
		echo
		cat ${dir}error
		break
	fi
	printf "\e[92m========== RESULT FOR %s ==========\e[0m\n\n" $(basename $dir)
	for file in ${dir}*.out; do
		cp $file $(pwd)/$(basename $dir)
		echo $'\e[95mresult: \e[0m'$(basename $file)
		cat $file
		echo
		echo
	done
done

rm -rf ${RESOURCE_PWD}/files/*
