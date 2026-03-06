# -*- mode: sh; eval: (sh-set-shell "zsh") -*-
#
# @name getopt
# @brief Zsh plugin to set the correct path for get-opt installed via Homebrew.
# @repository https://github.com/johnstonskj/zsh-getopt-plugin
#

getopt_plugin_init() {
    builtin emulate -L zsh

    @zplugins_add_to_path getopt "$(homebrew_formula_prefix gnu-getopt)/bin"
}
