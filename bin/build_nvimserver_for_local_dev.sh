#!/bin/bash
# Executing this script will replace the download step of pre-built NvimServer.
set -Eeuo pipefail

readonly clean=${clean:?"true or false: when true, xcodebuild clean for NvimServer and make distclean for libnvim"}
readonly build_libnvim=${build_libnvim:?"true or false: when true, libnvim will be built"}
readonly build_deps=${build_deps:?"true or false: when true, eg libintl will be built"}

readonly build_dir_name="build"
readonly build_dir_path="./${build_dir_name}"
readonly nvimview_dir_path="./NvimView/Sources/NvimView/"

build_for_local_dev() {
  local -r nvimserver_path="./NvimServer"

  pushd ${nvimserver_path} >/dev/null
    if ${clean} ; then
      ./NvimServer/bin/clean_all.sh
    fi

    local -r -x build_dir="${build_dir_path}"
    ./NvimServer/bin/build_nvimserver.sh
  popd >/dev/null

  cp -r "./NvimServer/runtime" ${nvimview_dir_path}
  cp "./NvimServer/${build_dir_path}/Build/Products/Release/NvimServer" ${nvimview_dir_path}
  cp "${nvimview_dir_path}/com.qvacua.NvimView.vim" "${nvimview_dir_path}/runtime/plugin"
}


main() {
  echo "### Building for local dev"
  # This script is located in /NvimServer/bin and we have to go to /
  pushd "$(dirname "${BASH_SOURCE[0]}")/.." >/dev/null

  build_for_local_dev

  echo "### Built for local dev"
  popd >/dev/null
}

main
