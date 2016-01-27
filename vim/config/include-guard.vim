" Function that creates an include guard for me.
" The format of the guard is as follows:
"
"   #ifndef SV_<path>_<file>
"
" Where:
"   <path> is the uppercase path after 'support', 'application', or 'include'
"          with slashes replaced with underscores.
"
"          ie. fw/application/wdtm/spam becomes WDTM_SPAM
"          ie. fw/include/policyVariant/stubs becomes POLICYVARIANT_STUBS
"
"   <file> is the uppercase filename, with dots replaced by underscores
"
"          ie. t_PolicyVariant.h becomes T_POLICYVARIANT_H
function! IncludeGuard()

    " Build up the directory portion, one part at a time

    " 'dir' will be what we eventually put into the include guard
    let dir = ""

    " dirExpr is the expression passed to 'expand' to strip down the current
    " path to the portion we're interested about
    let dirExpr = "%:p:h"

    " The current directory for consideration
    let curDir = toupper(expand(expand(dirExpr . ":t")))

    " Stop when we find 'support', 'application', or 'include'
    "   (or 'fw' or root for protection against infinite looping)
    while curDir != "SUPPORT" && curDir != "APPLICATION" && curDir != "INCLUDE" && curDir != "FW" && curDir != ""
        let dir = curDir . "_" . dir

        " Strip one more directory off the path, and continune looping
        let dirExpr = dirExpr . ":h"
        let curDir = toupper(expand(expand(dirExpr . ":t")))
    endwhile

    let curFile = substitute(toupper(expand("%:t")), "\\.", "_", "g")
    let gatename = "SV_" . dir . curFile

    set paste

    execute "normal! 1G"
    execute "normal! O#ifndef " . gatename
    execute "normal! o#define " . gatename
    execute "normal! Go#endif //" . gatename
    execute "normal! Go"

    set nopaste
endfunction

command! -nargs=0 IG :call IncludeGuard()

