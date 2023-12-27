#!/bin/bash

ask()
{
    while read -n 1 answer; do
        echo
        case $answer in
            [Yy]) return 0 ;;
            [Nn]) return 1 ;;
        esac
    done
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

export RESOURCE_PWD=${HOME}/boj/resource

printf "Your Current Path: \e[93m\'%s\'\e[0m\n\n" $(pwd)
for dir in */; do
	printf "\e[93m\'$(basename $dir)\'\e[0m: Do you want append input file? (Y/N)\n\n"
	ask
	if [ $? -eq 0 ]; then
		echo
		echo "Please Type Infile's Number."
		echo $'If you done, type n\n'
		while read target; do
			if [[ $target =~ ^[0-9]+$ ]]; then
				echo
				echo "You choose '$target.'"
				echo "Type all input and press cntl+d."
				echo $'\e[93mWarning: \e[0m'The values you type now will replace the existing inputs
				echo
				cat > ${dir}${target}.in
				echo
				echo $'\e[92mInFile creation success: \e[0m'${dir}${target}.in
				echo
			elif [ $target = 'n' ]; then
				break
			else
				echo "Input must be a number."
			fi
			echo "Please Type Infile's Number."
			echo $'If you done, type n\n'
		done
	fi
	printf "\n\e[93m\'$(basename $dir)\'\e[0m: input file setting done.\n\n"
done

cp -r $(pwd) ${RESOURCE_PWD}/files
if [ $? -ne 0 ]; then
	echo $'\e[91mError: \e[0m copy to '${RESOURCE_PWD}/files failed.
	exit 1
fi

type gcc > /dev/null
if [ $? -ne 0 ]; then
	compileInDocker
else
	gcc --version | grep -w clang > /dev/null
	if [ $? -eq 0 ]; then
		compileInDocker
	else
		echo $'\n\e[92mCompile now...\e[0m\n'
		${RESOURCE_PWD}/tools/run.sh
	fi
fi

echo
for dir in ${RESOURCE_PWD}/files/*/; do
	printf "\e[92m========== RESULT FOR %s ==========\e[0m\n\n" $(basename $dir)
	if compgen -G ${dir}error > /dev/null; then
		cp ${dir}error $(pwd)/$(basename $dir)
		echo $'\e[91mCompile Error:\e[0m '$(basename $dir)
		echo
		cat ${dir}error
		continue 
	fi
	for file in ${dir}*.out; do
		cp $file $(pwd)/$(basename $dir)
		echo $'\e[95mresult: \e[0m'$(basename $file)
		cat $file
		echo
		echo
	done
done

rm -r ${RESOURCE_PWD}/files
