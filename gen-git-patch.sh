#########################################################################
# File Name: gen-git-patch.sh
# Author: chaofei
# mail: chaofeibest@163.com
# Created Time: 2019-12-23 10:21:51
#########################################################################
#!/bin/bash

if [ "${DEBUG}" == "true" ]; then
  set -x
fi

function convert_relative_path_to_absolute_path() {
  this="${0}"
  bin=`dirname "${this}"`
  script=`basename "${this}"`
  bin=`cd "${bin}"; pwd`
  this="${bin}/${script}"
}

function create_dir() {
  if [ ! -d "${1}" ]; then
    mkdir -p "${1}"
  fi
}

function get_current_time() {
  CURRENT_TIME=`date +"%Y-%m-%d %H:%M:%S"`
  echo "${CURRENT_TIME}"
}

function get_current_user() {
  CURRENT_USER=`whoami`
  echo "${CURRENT_USER}"
}

function usage() {
 echo "Usage: ${this} [-p|--patch]
Examples:
${this} -p HEAD^              # Last Modify patch
${this} -p HEAD^^^^           # Last 4 Modify patches
${this} -p a283e10..74fac6c   # Modify patches between a283e10 and 74fac6c
${this} -p a283e10..HEAD      # Modify patches between a283e10 and current HEAD
${this} -p a283e10..HEAD^     # Modify patches between a283e10 and current HEAD^
${this} -p --root             # All patches
 " 
}

function check_args() {
  if [ $# -eq 0 ]; then
    usage
    exit 1
  fi
  case "${1}" in
    -p|-P|--patch|--Patch|--PATCH)
    SOFT_PATCH="true"
	shift
	if [ -z "${1}" ]; then
	  usage
	  exit 1
	fi
	while [ $# -gt 0 ]; do 
      if [ -z "${ARGS_PATCH_CMD}" ]; then
        ARGS_PATCH_CMD="${1}"
	  else
		ARGS_PATCH_CMD="${ARGS_PATCH_CMD} ${1}"
      fi
	  shift
    done
	;;
    *)
      echo "${this} invalid option [${1}]"
      usage
      exit 1
  esac
}

function generate_default_patch_name() {
  if [ -z "${SOFT_NAME}" ]; then
    SOFT_NAME="${script}"
	SOFT_NAME=`echo ${SOFT_NAME} | sed 's|.sh||g'`
  fi
  if [ -z "${PATCHES_NAME}" ]; then
    PATCHES_NAME="${SOFT_NAME}"
  fi
  echo "${PATCHES_NAME}"
}

function init_patch_dir() {
  if [ -z "${PATCHES_DIR}" ]; then
    SOFT_HOME="${bin}"
    PATCHES_DIR="${SOFT_HOME}/patches"
  fi
  if [ -z "${PATCHES_NAME}" ]; then
    PATCHES_NAME=`generate_default_patch_name`
  fi
  CURRENT_YMD_TIME=`date +"%Y-%m-%d-%H%M%S"`
  CURRENT_USER=`get_current_user`
  PATCHES_DIR=$PATCHES_DIR-$CURRENT_USER-$CURRENT_YMD_TIME-$ARGS_PATCH_CMD
  echo $PATCHES_DIR
  create_dir "${PATCHES_DIR}"
}

function gen_git_patches() {
  if [ ${SOFT_PATCH}=="true" ]; then
    if [ -n "${ARGS_PATCH_CMD}" ]; then
	  echo git format-patch $ARGS_PATCH_CMD -o $PATCHES_DIR
	  git format-patch $ARGS_PATCH_CMD -o $PATCHES_DIR
	fi
  fi
}

function main_action() {
  convert_relative_path_to_absolute_path
  check_args $*
  init_patch_dir
  gen_git_patches
}

main_action $*
