#!/bin/bash
# With this script you can copy 
# the files'/dirs' permissions
# from a source path to a destination path
# notes: all args ${@}, num of args ${#}

usage() {
    echo -e "Usage: $0 [-h] [-t] [-r] source_abs_path dest_abs_path\n"
}

help() {
    echo "Use this script to copy acl" 
    echo "from an absolute path to an absolute path"
    echo
    echo "Syntax: $0 [-r] [-t] source_abs_path dest_abs_path"
    echo
    echo "options:"
    echo "-h Print help"
    echo "-t Dry RUN"
    echo "-r RUN"
}

while getopts ":htr" option; do
   case $option in
    h) # display Help
        help
        ;;
    t) # dry run
        dry
        ;; 
    r) #run
            source_path=$2
        dest_path=$3
        run
        ;;
    *) # display usage
        echo -e "\nIllegal options  -${OPTARG}\n"
        usage
        exit 1
        ;;
   esac
done

if [[ ${#} -eq 0 ]] || [[ ${#} -ne 3 ]]; then
   usage
else
    flag=$1
    source_path=$2
    dest_path=$3

    echo -e "Source path is $source_path \n"
    echo -e "Destination path is $dest_path \n"

    current_path=`pwd`
    echo -e "Current path: $current_path \n"

    echo "Source Permissions"
    tree -p $source_path

    touch $current_path/temp_acl

    cd $source_path
    getfacl -R . | tee $current_path/temp_acl

    cd $dest_path

    if [[ $flag -eq "r" ]]; then
        setfacl --restore=$current_path/temp_acl
    elif [[ $flag -eq "t" ]]; then
        setfacl -t --restore=$current_path/temp_acl
    fi

    echo "Destination Permissions"
    tree -p $dest_path

    rm -f $current_path/temp_acl
fi