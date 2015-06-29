#!/bin/bash

# Git script to make life easier ~~ <3
# by pezon_v


NB_PARAM=$#
LOGIN="pezon_v" #Change it for your <blih> cmd
MOULINETTE="ramassage-tek"

print_usage()
{
    echo
    figlet "GIT SCRIPT"
    echo
    echo "./gitsh
	   -c(clone) [login] <repository>
	   -p(push) <commit>
	   -g(pull)
	   -m(merge) <commit>
	   -i(init) <repo>
	   -l(blih list)
	   -s(acl) <repo> <user> [acl]
	   -gs(getacl) <repo>";
    echo
}

verify_param()
{
    if [ "$NB_PARAM" = "0" ];then
	print_usage
	exit 1
    fi
}

_err()
{
    print_usage
    echo
    echo "Error : <$1> missing arguement."
    exit 1
}

me_clone()
{
    if [ "$#" == "2" ];
    then
	if [ "$1" == "" ];then
	    _err "clone"
	fi
	if [ "$2" == "" ];then
	    git clone $LOGIN@git.epitech.eu:/$LOGIN/$1
	    echo "Clone done"
	    return 0
	fi
	git clone $LOGIN@git.epitech.eu:/$1/$2
	echo "Clone done"
	return 0
    fi
    _err "clone"
}

me_push()
{
    if [ "$1" == "" ];then
	_err "push"
    fi
    git add -A
    git commit -m "$1"
    git pull
    git push origin master
    echo "Push done"
    return 0
}

me_pull()
{
    git pull origin master
    echo "Pull done"
}

me_list()
{
    blih -u $LOGIN -u repository list
    echo "Pull done"
}

me_merge()
{
    if [ "$1" == "" ];then
	_err "merge"
    fi 
    git add -A
    git commit -m "$1"
    git pull origin master
    echo -n "Pull ok ?"
    echo -n " y/n : "
    read on
    case "$on" in
	y | Y ) git push;echo "Commit done";;
	n | N ) echo "Try again";;
	* ) echo "Retry ;)";;
    esac
    return 0
}

me_setacl()
{
    if [ "$1" == "" ];then
	_err "setacl"
    fi
    if [ "$2" == "" ];then
	_err "setacl"
    fi
    if [ "$3" == "" ];then
	blih -u $LOGIN repository setacl $1 $2 "rw"
	echo "Setacl done"
	blih -u $LOGIN repository getacl $1
	return 0
    fi
    blih -u $LOGIN repository setacl $1 $2 $3
    echo "Setacl done"
    blih -u $LOGIN repository getacl $1
}

me_delete()
{
    if [ "$1" == "" ];then
	_err "delete"
    fi
    echo -n "Etes-vous sure de supprimer $1 ?"
    echo -n " y/n : "
    read on
    case "$on" in
	y | Y ) blih -u $LOGIN repository delete "$1";echo "Delete done";;
	n | N ) echo "Delete failed";;
	* ) echo "Retry ;)";;
    esac
    return 0
}

me_getacl()
{
    if [ "$1" == "" ];then
	_err "getacl"
    fi
    blih -u $LOGIN repository getacl "$1"
    return 0
}

me_init()
{
    if [ "$1" == "" ];then
	_err "init"
    fi
    git init &&
    blih -u $LOGIN repository create "$1"
    git remote add origin "$LOGIN@git.epitech.eu:/$LOGIN/$1"
    blih -u $LOGIN repository setacl "$1" "$MOULINETTE" "r"
    blih -u $LOGIN repository list
    blih -u $LOGIN repository getacl "$1"
    touch first_commit
    me_push "First commit"
    echo
    echo "Repository $1 created."
    return 0
}

parse_param()
{
    for opt in "$@"
    do
	if [ "$opt" == "-c" ];then
	    shift
	    arg1=$1
	    shift
	    arg2=$1
	    me_clone "$arg1" "$arg2"
	elif [ "$opt" == '-p' ]; then
	    shift
	    arg1=$1
	    me_push "$arg1"
	elif [ "$opt" == '-g' ]; then
	    me_pull
	elif [ "$opt" == '-l' ]; then
	    me_list
	elif [ "$opt" == '-m' ]; then
	    shift
	    arg1=$1
	    me_merge "$arg1"
	elif [ "$opt" == '-d' ]; then
	    shift
	    arg1=$1
	    me_delete "$arg1"
	elif [ "$opt" == '-i' ]; then
	    shift
	    arg1=$1
	    me_init "$1"
	elif [ "$opt" == '-s' ]; then
	    shift
	    arg1=$1
	    shift
	    arg2=$1
	    shift
	    arg3=$1
	    me_setacl "$arg1" "$arg2" "$arg3"
	elif [ "$opt" == '-gs' ]; then
	    shift
	    arg1=$1
	    me_getacl "$arg1"
	fi
	shift
    done
    exit 0
}

main()
{
    verify_param
    parse_param "$@"
    echo $NB_PARAM
}

main "$@"
