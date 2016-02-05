" Generate c++11 default ctors and such
function! GenerateClass()
    let classname = substitute(expand("%:t"), "\\.h$", "", "g")
    set paste

    execute "normal! 1iclass " . classname
    execute "normal! o{"
    execute "normal! opublic:"
    execute "normal! o    " . classname . "();"
    execute "normal! o    " . classname . "( const " . classname . "& other);"
    execute "normal! o    " . classname . "(" . classname . "&& other);"
    execute "normal! o    " . classname . "& operator=(const " . classname . "& other);"
    execute "normal! o    " . classname . "& operator=(" . classname . "&& other);"
    execute "normal! o    ~" . classname . "();"
    execute "normal! o};"
    set nopaste
endfunction

command! -nargs=0 GC :call GenerateClass()

" Generate c++11 default ctors and but delete everything possible
function! GenerateClassDelete()
    let classname = substitute(expand("%:t"), "\\.h$", "", "g")
    set paste

    execute "normal! 1iclass " . classname
    execute "normal! o{"
    execute "normal! opublic:"
    execute "normal! o    " . classname . "() = delete;"
    execute "normal! o    " . classname . "(const " . classname . "& other) = delete;"
    execute "normal! o    " . classname . "(" . classname . "&& other) = delete;"
    execute "normal! o    " . classname . "& operator=(const " . classname . "& other) = delete;"
    execute "normal! o    " . classname . "& operator=(" . classname . "&& other) = delete;"
    execute "normal! o    ~" . classname . "();"
    execute "normal! o};"
    set nopaste
endfunction

command! -nargs=0 GCD :call GenerateClassDelete()

" Generate an initial testcase stub
function! GenerateTestcase()
    let testname = substitute(expand("%:t:r"), "^t_", "", "g")

    set paste

    execute "normal! 1Gi#include <cxxtest/TestSuite.h>"
    execute "normal! o"
    execute "normal! oclass " . testname . "Test : public CxxTest::TestSuite"
    execute "normal! o{"
    execute "normal! opublic:"
    execute "normal! o    void setUp();"
    execute "normal! o    void tearDown();"
    execute "normal! o"
    execute "normal! o    void TestXXX();"
    execute "normal! o};"
    execute "normal! o"

    set nopaste
endfunction

command! -nargs=0 GT :call GenerateTestcase()
