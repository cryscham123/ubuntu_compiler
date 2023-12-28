#!/bin/bash

printUsage()
{
	echo "Usage: yo [OPTION]... [DIRECTORY]"
	echo
	echo $' -d, -D\t\tCompile in ubuntu with docker'
	echo $' -i, -I[number]\tCreate infile before compile'
}

createInfile()
{
	printf "Infile creation for \e[93m\'%s\'\e[0m\n" $1
	echo "Type all input and press cntl+d."
	echo
	cat > ${target_path}/$1.in
	echo
	if [ $? -eq 0 ]; then
		echo $'\e[92mInFile creation success: \e[0m'${target}/$1.in
		echo
	else
		echo $'\e[92mInFile creation Failed: \e[0m'${target}/$1.in
		exit 1
	fi
}

compileInDocker()
{
	echo $'\n\e[92mCompile in ubuntu with docker...\e[0m\n'

	docker-compose -f ${RESOURCE_PWD}/docker-compose.yaml up
	if [ $? -ne 0 ]; then
		echo $'\e[91mError: \e[0m docker-compose execute failed.'
		exit 1
	fi
	echo
}

# validate argument
if [[ $# -lt 1 ]]; then
	printUsage
	exit 1
fi
for arg in "$@"; do
	if [[ $arg == -* ]]; then
		case ${arg:1} in 
			[dD]*)
				exe_docker=true
				;;
			[iI]*)
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
		if [ ! -z $target ]; then
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
	createInfile $file
done

# copy files and execute
export RESOURCE_PWD=${HOME}/boj/resource
if [ ! -e ${RESOURCE_PWD}/files/$target ]; then
	mkdir -p ${RESOURCE_PWD}/files/$target
fi

for file in ${target_path}/*; do
	case ${file##*.} in
		"in")
			cp $file ${RESOURCE_PWD}/files/$target
			in_chk=true
			;;
		"cpp")
			cp $file ${RESOURCE_PWD}/files/$target
			cpp_chk=true
			;;
	esac
done

if [ -z $in_chk ]; then
	echo $'There is no Infile. Infile \e[93m\'1\'\e[0m will created.'
	echo "If you want create more infile, use option -I[number]."
	echo
	createInfile 1
	cp "${target_path}/1.in" ${RESOURCE_PWD}/files/$target
fi

if [ -z $cpp_chk ]; then
	echo $'\e[91mError: \e[0m'"At least one .cpp file required in '$target'"
	exit 1
fi

if [ ! -z $exe_docker ]; then
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
		in="${file/%.out/.in}"
		echo $'\e[95mINPUT:\e[0m\t'$(basename $in)
		cat $in
		echo
		cp $file $(pwd)/$(basename $dir)
		echo $'\e[94mRESULT:\e[0m\t'$(basename $file)
		cat $file
		echo
		echo
	done
done

rm -rf ${RESOURCE_PWD}/files/*
