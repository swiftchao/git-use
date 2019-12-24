#########################################################################
# File Name: git-apply-patch.sh
# Author: chaofei
# mail: chaofeibest@163.com
# Created Time: 2019-12-24 10:13:51
#########################################################################
#!/bin/bash
PATCH_DIRS="/e/work/patch/patches-20191210-3,/e/work/patch/patches-20191212-1,patches-chaofei-2019-12-23-174126-21b25097..b27c3de6"

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

function get_current_time() {
  CURRENT_TIME=`date +"%Y-%m-%d %H:%M:%S"`
  echo "${CURRENT_TIME}"
}

function usage() {
 echo "Usage: ${this} [-p|--patch]
Examples:
${this} -p patches-chaofei-2019-12-23-174126-21b25097..b27c3de6                                   # apply one patch_dir
${this} -p /e/work/patch/patches-20191212-1 patches-chaofei-2019-12-23-174126-21b25097..b27c3de6  # apply more patch_dirs
${this} -p                                                                                        # apply patches by edit PATCH_DIRS var in ${this} file
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
	# if [ -z "${1}" ]; then
	  # usage
	  # #exit 1
	# fi
	while [ $# -gt 0 ]; do 
      if [ -z "${ARGS_PATCH_CMD}" ]; then
        ARGS_PATCH_CMD="${1}"
	  else
		ARGS_PATCH_CMD="${ARGS_PATCH_CMD},${1}"
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

function create_dir() {
  if [ ! -d "${1}" ]; then
    mkdir -p "${1}"
  fi
}

function git_one_patch_dir_apply() {
  ARGS_PATCH_DIR=${1}
  if [ -n "${ARGS_PATCH_DIR}" ] && [ -d "${ARGS_PATCH_DIR}" ]; then
	ls $ARGS_PATCH_DIR/*.patch > /dev/null 2>&1
	IS_HAVA_PATCH=$?
    if [ "${IS_HAVA_PATCH}" -eq 0 ]; then
	  ARGS_APPLIED_DIR="${ARGS_PATCH_DIR}/applied"
      ARGS_APPLY_ERROR_DIR="${ARGS_PATCH_DIR}/apply-error"
      create_dir "${ARGS_APPLIED_DIR}"
      create_dir "${ARGS_APPLY_ERROR_DIR}"
	  IFS="${OLD_IFS}"
      for patch_file in `ls $ARGS_PATCH_DIR/*.patch | sort`; do
        # echo "$patch_file"
        git apply --check $patch_file
        RESULT=$?
        if [ $RESULT -eq 0 ]; then
	      #echo "git am --signoff $patch_file"
	      git am --signoff $patch_file
	      GIT_APPLY_RESULT=$?
          if [ "${GIT_APPLY_RESULT}" -eq 0 ]; then
		    mv "$patch_file" "$ARGS_APPLIED_DIR/"
	        echo -e "`get_current_time` git apply file $patch_file -- \033[32mOK\033[0m"
	      else 
            mv "$patch_file" "$ARGS_APPLY_ERROR_DIR/"
			echo -e "`get_current_time` git apply file $patch_file -- \033[31mFAILED\033[0m"
	      fi
        else 
	      mv "$patch_file" "$ARGS_APPLY_ERROR_DIR/"
		  echo -e "`get_current_time` this patch file $patch_file can not to apply -- \033[31mFAILED\033[0m"
        fi
      done  
	else
	  echo -e "`get_current_time` ${ARGS_PATCH_DIR} has not any patch file -- \033[31mFAILED\033[0m"
	fi
  else
    echo -e "`get_current_time` ${ARGS_PATCH_DIR} is not exist -- \033[31mFAILED\033[0m!"
  fi
}

function git_apply() {
  if [ -z "${ARGS_PATCH_CMD}" ]; then
    ARGS_PATCH_CMD="${PATCH_DIRS}"
  fi
  OLD_IFS="${IFS}"
  IFS=",${now},"
  if [ -n "${ARGS_PATCH_CMD}" ]; then
    for TMP_PATCH_DIR in ${ARGS_PATCH_CMD}; do
	  echo git_one_patch_dir_apply "${TMP_PATCH_DIR}"
	  git_one_patch_dir_apply "${TMP_PATCH_DIR}"
	done
  fi
  IFS="${OLD_IFS}"
}

function main_action() {
  convert_relative_path_to_absolute_path
  check_args $*
  git_apply
}

main_action $*