# -*- mode: sh; eval: (sh-set-shell "zsh") -*-
#
# Plugin Name: getopt
# Repository: https://github.com/johnstonskj/zsh-getopt-plugin
#
# Description:
#
#   Set path for GNU-compatible getopt command line option parser.
#
# Public variables:
#
# * `GETOPT`; plugin-defined global associative array with the following keys:
#   * \`_FUNCTIONS\`; a list of all functions defined by the plugin.
#   * \`_PLUGIN_DIR\`; the directory the plugin is sourced from.
#

############################################################################
# Standard Setup Behavior
############################################################################

# See https://wiki.zshell.dev/community/zsh_plugin_standard#zero-handling
0="${ZERO:-${${0:#$ZSH_ARGZERO}:-${(%):-%N}}}"
0="${${(M)0:#/*}:-$PWD/$0}"

# See https://wiki.zshell.dev/community/zsh_plugin_standard#standard-plugins-hash
declare -gA GETOPT
GETOPT[_PLUGIN_DIR]="${0:h}"
GETOPT[_FUNCTIONS]=""

# Set the path for any custom directories here.
GETOPT[_PATH]="$(homebrew_formula_prefix gnu-getopt)/bin"

############################################################################
# Internal Support Functions
############################################################################

#
# This function will add to the `GETOPT[_FUNCTIONS]` list which is
# used at unload time to `unfunction` plugin-defined functions.
#
# See https://wiki.zshell.dev/community/zsh_plugin_standard#unload-function
# See https://wiki.zshell.dev/community/zsh_plugin_standard#the-proposed-function-name-prefixes
#
.getopt_remember_fn() {
    builtin emulate -L zsh

    local fn_name="${1}"
    if [[ -z "${GETOPT[_FUNCTIONS]}" ]]; then
        GETOPT[_FUNCTIONS]="${fn_name}"
    elif [[ ",${GETOPT[_FUNCTIONS]}," != *",${fn_name},"* ]]; then
        GETOPT[_FUNCTIONS]="${GETOPT[_FUNCTIONS]},${fn_name}"
    fi
}
.getopt_remember_fn .getopt_remember_fn

#
# This function does the initialization of variables in the global variable
# `GETOPT`. It also adds to `path` and `fpath` as necessary.
#
getopt_plugin_init() {
    builtin emulate -L zsh
    builtin setopt extended_glob warn_create_global typeset_silent no_short_loops rc_quotes no_auto_pushd

    path+=( "${GETOPT[_PATH]}" )
}
.getopt_remember_fn getopt_plugin_init

############################################################################
# Plugin Unload Function
############################################################################

# See https://wiki.zshell.dev/community/zsh_plugin_standard#unload-function
getopt_plugin_unload() {
    builtin emulate -L zsh

    # Remove all remembered functions.
    local plugin_fns
    IFS=',' read -r -A plugin_fns <<< "${GETOPT[_FUNCTIONS]}"
    local fn
    for fn in ${plugin_fns[@]}; do
        whence -w "${fn}" &> /dev/null && unfunction "${fn}"
    done

    path=( "${(@)path:#${GETOPT[_PATH]}}" )
    
    # Remove the global data variable.
    unset GETOPT

    # Remove this function.
    unfunction getopt_plugin_unload
}

############################################################################
# Initialize Plugin
############################################################################

getopt_plugin_init

true
