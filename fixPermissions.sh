#!/bin/bash
# With this script you can copy 
# the files'/dirs' permissions
# from a source path to a destination path

usage() {
    echo "Usage: $0 [-h] [-t] [-r] source_abs_path dest_abs_path"
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

check_args() {
    if [ $# -ne 2 ] ; then
        usage
    elif [[ -z $1 || -z $2 ]]; then
        usage
    fi
}

main() {
    check_args

    # source_path=$1
    # dest_path=$2
    # current_path=`pwd`
    # echo "Current path: $currnet_path \n"

    # echo "Source Permissions"
    # tree -p $source_path

    # touch $current_path/temp_acl

    # cd $source_path
    # getfacl -R . | tee $current_path/temp_acl

    # cd $dest_path
}

rmtemp() {
    rm -f $current_path/temp_acl
}

dry() {
    echo "DRY"

    main
    
    setfacl -t --restore=$current_path/temp_acl

    rmtemp
    
}

run() {
    echo "RUN"
    
    main

    setfacl --restore=$current_path/temp_acl

    rmtemp

    echo "Destination Permissions"
    tree -p $dest_path
}

while getopts ":htr" option; do
   case $option in
    h ) # display Help
        help
        ;;
    t ) # dry run
        dry
        ;; 
    r ) #run
        run
        ;;
    * ) # display usage
        echo "Illegal options \n"
        usage
        exit 1
        ;;
   esac
done

shift $((OPTIND -1))

