# -*- mode: sh; eval: (sh-set-shell "zsh") -*-
#
# @name: getopt
# @brief: Set the correct path for `get-opt` installed via Homebrew.
# @repository: https://github.com/johnstonskj/zsh-getopt-plugin
# @version: 0.1.1
# @license: MIT AND Apache-2.0
#

############################################################################
# @section Lifecycle
# @description Plugin lifecycle functions.
#

#
# @description Add the Homebrew version of getopt to the path.
#
# @noargs
#
getopt_plugin_init() {
    builtin emulate -L zsh

    local getopt_path="$(homebrew_formula_prefix gnu-getopt)"
    if [[ -z "${getopt_path}" || $? -ne 0 ]]; then
        log_error "zsh-getopt: cannot get homebrew path for 'gnu-getopt' package."
    else
        @zplugins_add_to_path getopt "${getopt_path}/bin"
    fi
}
