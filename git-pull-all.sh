#########################################################################
# File Name: git-pull-all.sh
# Author: chaofei
# mail: chaofeibest@163.com
# Created Time: 2022-12-15 13:59:40
#########################################################################
#!/bin/bash

WORKDIR=$(cd $(dirname ${0});pwd)
GIT_BRANCH="fitstor6.2-dev"
GIT_WORK_BRANCH="cf-${GIT_BRANCH}"
EXCLUDE_REPOS="ceph-deploy|ceph-exporter|rtslib_fb|ceph_iscsi_config"

get_all_dirs() {
    ls -al "${WORKDIR}" | grep "^d" | awk '{print $NF}' | grep -v "^\." | grep -E -v "${EXCLUDE_REPOS}"
}

git_pull_args() {
    git_dir="${1}"
    git_branch="${2}"
    git_work_branch="${3}"
    #if [ -e "${git_dir}" ] && [ -n "${git_branch}" ] && [ -n "${git_work_branch}" ]; then
    if [ -e "${git_dir}" ] && [ -n "${git_branch}" ] && [ -n "${git_work_branch}" ]; then
        pushd "${git_dir}"
        git checkout "${git_branch}"
        git stash clear
        git stash
        git pull
        git checkout -b "${git_work_branch}" || git checkout "${git_work_branch}"
        git rebase "${git_branch}"
        git stash apply stash@{0}
        popd
    fi
}

git_pull_all() {
    all_git_dirs=$(get_all_dirs)
    for  repo_dir in ${all_git_dirs}; do
        git_pull_args "${repo_dir}" "${GIT_BRANCH}" "${GIT_WORK_BRANCH}"
    done
}

main() {
    pushd "${WORKDIR}"
    git_pull_all
    popd
}

main $*
