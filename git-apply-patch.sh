#!/bin/bash
PATCH_DIR="/c/work/code/git/patch/patches-20191212-1-test"
APPLIED_DIR="${PATCH_DIR}/applied"
APPLY_ERROR_DIR="${PATCH_DIR}/apply-error"

function create_dir() {
  if [ ! -d "${1}" ]; then
    mkdir -p "${1}"
  fi
}

function git_apply() {
  create_dir "${APPLIED_DIR}"
  create_dir "${APPLY_ERROR_DIR}"
  for patch_file in `ls $PATCH_DIR/*.patch`; do
    echo "$patch_file"
    git apply --check $patch_file
    RESULT=$?
    if [ $RESULT -eq 0 ]; then
	  #echo "git am --signoff $patch_file"
	  git am --signoff $patch_file
	  mv "$patch_file" "$APPLIED_DIR/"
    else 
      echo "this patch file $patch_file can not to apply -- \033[31mFAILED\033[0m"
	  mv "$patch_file" "$APPLY_ERROR_DIR/"
    fi
  done
}

git_apply