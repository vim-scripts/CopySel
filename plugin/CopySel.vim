"$Id: CopySel.vim, v1 2014-01-25_05:08:03
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Name:		      CopySel
" Description:	Copies only found patterns to workfile
" Author:	      Ing.Michael Fitz; Hainburg(A) <MikeTheGuru@gmx.at>
" Maintainer:	   -- '' -- 
" Version:      1.1 
"
"
" Do ':call CopySel()' and enter a pattern to search something - defaulted to last search-pattern. 
" If you don't like the q-register (it is on the same keyboard-position as '@' and therefore the default) use another.
"
" A workwindow is opened and you are positioned on the first occurence of the pattern.
" Executing the macro @q the found pattern is copied into the workwindow and your file positioned at the next position
" of the pattern.
"
" Repeat @q oder press n if you don't want that pattern copied.
"
" After done you can save the workwindow or do whatever you want with it.
"
" Example:
" Assume you have a C-proggie and want to track any printf-formatstring you've coded
" Enter the pattern 'printf\s*(\s*"\zs.*\ze"'
" Don't forget to limit the pattern with \zs and \ze!
"
" History:
" Vers 1.1 2014-01-29_18:33:03
"   Sometimes missed the very first selection
"   Space after :com resultng in E488
"   Parameter to switch with/without VDLGBX


function! CopySel(qDLL)
if(a:qDLL)  
  let Z1 = 
        \"!TITLE=CopySel - Extract patterns\n" .
        \"$E:vSEL:Selection-Pattern=".@/."\n" .
        \"$E:vReg:Register (1 small letter)=q\n" 
  let Z1=libcall("VDLGBX","BOX",Z1)
  exec Z1
  if(VDLGBXRETURN!="OK")
    echo VDLGBXRETURN 
    return
  endif
  if(strlen(VDLGBX_vSEL)==0)
    call confirm('Selection-Pattern must be present','','','E')
    return
  endif
  if(strlen(VDLGBX_vReg)!=1)
    call confirm('Register must be 1 character','','','E')
    return
  elseif(VDLGBX_vReg<'a' || VDLGBX_vReg>'z') 
    call confirm('Register must be a small letter','','','E')
    return
  endif
  exec 'let @'.VDLGBX_vReg.'="v//e+1y//spp€kh€kDop"' 
else
  exec 'let @q="v//e+1y//spp€kh€kDop"' 
endif
let  @/=VDLGBX_vSEL
exec "normal s"
:only
:new
exec "normal p"
"exec 'normal 0gon'
exec 'normal  €ýXn'
endfun

" with VDLGBX: CopySel(1); without: CopySel(0) 
:com CopySel :call CopySel(1)
