" Vim syntax file
" Language:             Effekt
" Maintainer:           Marius Müller
" URL:                  https://github.com/effekt-lang/effekt-neovim
" License:              Same as Vim
" Last Change:          29 October 2022
" ----------------------------------------------------------------------------

if !exists('main_syntax')
  " quit when a syntax file was already loaded
  if exists("b:current_syntax")
    finish
  endif
  let main_syntax = 'effekt'
endif

scriptencoding utf-8

let b:current_syntax = "effekt"

" Allows for embedding, see #59; main_syntax convention instead? Refactor TOP
"
" The @Spell here is a weird hack, it means *exclude* if the first group is
" TOP. Otherwise we get spelling errors highlighted on code elements that
" match effektBlock, even with `syn spell notoplevel`.
function! s:ContainedGroup()
  try
    silent syn list @effekt
    return '@effekt,@NoSpell'
  catch /E392/
    return 'TOP,@Spell'
  endtry
endfunction

unlet! b:current_syntax

syn case match
syn sync minlines=200 maxlines=1000

syn keyword effektKeyword do else if resume return
syn keyword effektKeyword box in match region try unbox while
syn keyword effektKeyword effect extends record with nextgroup=effektInstanceDeclaration skipwhite
syn keyword effektKeyword case nextgroup=effektKeyword,effektCaseFollowing skipwhite
syn keyword effektKeyword val nextgroup=effektNameDefinition,effektQuasiQuotes skipwhite
syn keyword effektKeyword def fun var nextgroup=effektNameDefinition skipwhite
hi def link effektKeyword Keyword

exe 'syn region effektBlock start=/{/ end=/}/ contains=' . s:ContainedGroup() . ' fold'

"syn keyword effektAkkaSpecialWord when goto using startWith initialize onTransition stay become unbecome
"hi def link effektAkkaSpecialWord PreProc
"
"syn keyword effekttestSpecialWord shouldBe
"syn match effekttestShouldDSLA /^\s\+\zsit should/
"syn match effekttestShouldDSLB /\<should\>/
"hi def link effekttestSpecialWord PreProc
"hi def link effekttestShouldDSLA PreProc
"hi def link effekttestShouldDSLB PreProc

syn match effektSymbol /'[_A-Za-z0-9$]\+/
hi def link effektSymbol Number

syn match effektChar /'.'/
syn match effektChar /'\\[\\"'ntbrf]'/ contains=effektEscapedChar
syn match effektChar /'\\u[A-Fa-f0-9]\{4}'/ contains=effektUnicodeChar
syn match effektEscapedChar /\\[\\"'ntbrf]/
syn match effektUnicodeChar /\\u[A-Fa-f0-9]\{4}/
hi def link effektChar Character
hi def link effektEscapedChar Special
hi def link effektUnicodeChar Special

syn match effektOperator "||"
syn match effektOperator "&&"
syn match effektOperator "|"
syn match effektOperator "&"
hi def link effektOperator Special

syn match effektNameDefinition /\<[_A-Za-z0-9$]\+\>/ contained nextgroup=effektPostNameDefinition,effektVariableDeclarationList
syn match effektNameDefinition /`[^`]\+`/ contained nextgroup=effektPostNameDefinition
syn match effektVariableDeclarationList /\s*,\s*/ contained nextgroup=effektNameDefinition
syn match effektPostNameDefinition /\_s*:\_s*/ contained nextgroup=effektTypeDeclaration
hi def link effektNameDefinition Function

syn match effektInstanceDeclaration /\<[_\.A-Za-z0-9$]\+\>/ contained nextgroup=effektInstanceHash
syn match effektInstanceDeclaration /`[^`]\+`/ contained
syn match effektInstanceHash /#/ contained nextgroup=effektInstanceDeclaration
hi def link effektInstanceDeclaration Special
hi def link effektInstanceHash Type

syn match effektUnimplemented /???/
hi def link effektUnimplemented ERROR

syn match effektCapitalWord /\<[A-Z][A-Za-z0-9$]*\>/
hi def link effektCapitalWord Special

" Handle type declarations specially
syn region effektTypeStatement matchgroup=Keyword start=/\<type\_s\+\ze/ end=/$/ contains=effektTypeTypeDeclaration,effektSquareBrackets,effektTypeTypeEquals,effektTypeStatement

" Ugh... duplication of all the effektType* stuff to handle special highlighting
" of `type X =` declarations
syn match effektTypeTypeDeclaration /(/ contained nextgroup=effektTypeTypeExtension,effektTypeTypeEquals contains=effektRoundBrackets skipwhite
syn match effektTypeTypeDeclaration /\%(⇒\|=>\)\ze/ contained nextgroup=effektTypeTypeDeclaration contains=effektTypeTypeExtension skipwhite
syn match effektTypeTypeDeclaration /\<[_\.A-Za-z0-9$]\+\>/ contained nextgroup=effektTypeTypeExtension,effektTypeTypeEquals skipwhite
syn match effektTypeTypeEquals /=\ze[^>]/ contained nextgroup=effektTypeTypePostDeclaration skipwhite
syn match effektTypeTypeExtension /)\?\_s*\zs\%(⇒\|=>\|<:\|:>\|=:=\|::\|#\)/ contained contains=effektTypeOperator nextgroup=effektTypeTypeDeclaration skipwhite
syn match effektTypeTypePostDeclaration /\<[_\.A-Za-z0-9$]\+\>/ contained nextgroup=effektTypeTypePostExtension skipwhite
syn match effektTypeTypePostExtension /\%(⇒\|=>\|<:\|:>\|=:=\|::\)/ contained contains=effektTypeOperator nextgroup=effektTypeTypePostDeclaration skipwhite
hi def link effektTypeTypeDeclaration Type
hi def link effektTypeTypeExtension Keyword
hi def link effektTypeTypePostDeclaration Special
hi def link effektTypeTypePostExtension Keyword

syn match effektTypeDeclaration /(/ contained nextgroup=effektTypeExtension contains=effektRoundBrackets skipwhite
syn match effektTypeDeclaration /\%(⇒\|=>\)\ze/ contained nextgroup=effektTypeDeclaration contains=effektTypeExtension skipwhite
syn match effektTypeDeclaration /\<[_\.A-Za-z0-9$]\+\>/ contained nextgroup=effektTypeExtension skipwhite
syn match effektTypeExtension /)\?\_s*\zs\%(⇒\|=>\|<:\|:>\|=:=\|::\|#\)/ contained contains=effektTypeOperator nextgroup=effektTypeDeclaration skipwhite
hi def link effektTypeDeclaration Type
hi def link effektTypeExtension Keyword
hi def link effektTypePostExtension Keyword

syn match effektTypeAnnotation /\%([_a-zA-Z0-9$\s]:\_s*\)\ze[_=(\.A-Za-z0-9$]\+/ skipwhite nextgroup=effektTypeDeclaration contains=effektRoundBrackets
syn match effektTypeAnnotation /)\_s*:\_s*\ze[_=(\.A-Za-z0-9$]\+/ skipwhite nextgroup=effektTypeDeclaration
hi clear effektTypeAnnotation

syn match effektCaseFollowing /\<[_\.A-Za-z0-9$]\+\>/ contained contains=effektCapitalWord
syn match effektCaseFollowing /`[^`]\+`/ contained contains=effektCapitalWord
hi def link effektCaseFollowing Special

"syn keyword effektKeywordModifier abstract override final lazy implicit private protected sealed null super
"syn keyword effektSpecialFunction implicitly require
"hi def link effektKeywordModifier Function
"hi def link effektSpecialFunction Function

syn keyword effektSpecial true false
syn keyword effektSpecial new nextgroup=effektInstanceDeclaration skipwhite
syn match effektSpecial "\%(=>\|⇒\|<-\|←\|->\|→\)"
syn match effektSpecial /`[^`]\+`/  " Backtick literals
hi def link effektSpecial PreProc

syn keyword effektExternal import module extern include
hi def link effektExternal Include

syn match effektStringEmbeddedQuote /\\"/ contained
syn region effektString start=/"/ end=/"/ contains=effektStringEmbeddedQuote,effektEscapedChar,effektUnicodeChar
hi def link effektString String
hi def link effektStringEmbeddedQuote String

syn region effektIString matchgroup=effektInterpolationBrackets start=/\<[a-zA-Z][a-zA-Z0-9_]*"/ skip=/\\"/ end=/"/ contains=effektInterpolation,effektInterpolationB,effektEscapedChar,effektUnicodeChar
syn region effektTripleIString matchgroup=effektInterpolationBrackets start=/\<[a-zA-Z][a-zA-Z0-9_]*"""/ end=/"""\ze\%([^"]\|$\)/ contains=effektInterpolation,effektInterpolationB,effektEscapedChar,effektUnicodeChar
hi def link effektIString String
hi def link effektTripleIString String

syn match effektInterpolation /\$[a-zA-Z0-9_$]\+/ contained
exe 'syn region effektInterpolationB matchgroup=effektInterpolationBoundary start=/\${/ end=/}/ contained contains=' . s:ContainedGroup()
hi def link effektInterpolation Function
hi clear effektInterpolationB

syn region effektFString matchgroup=effektInterpolationBrackets start=/f"/ skip=/\\"/ end=/"/ contains=effektFInterpolation,effektFInterpolationB,effektEscapedChar,effektUnicodeChar
syn match effektFInterpolation /\$[a-zA-Z0-9_$]\+\(%[-A-Za-z0-9\.]\+\)\?/ contained
exe 'syn region effektFInterpolationB matchgroup=effektInterpolationBoundary start=/${/ end=/}\(%[-A-Za-z0-9\.]\+\)\?/ contained contains=' . s:ContainedGroup()
hi def link effektFString String
hi def link effektFInterpolation Function
hi clear effektFInterpolationB

syn region effektTripleString start=/"""/ end=/"""\%([^"]\|$\)/ contains=effektEscapedChar,effektUnicodeChar
syn region effektTripleFString matchgroup=effektInterpolationBrackets start=/f"""/ end=/"""\%([^"]\|$\)/ contains=effektFInterpolation,effektFInterpolationB,effektEscapedChar,effektUnicodeChar
hi def link effektTripleString String
hi def link effektTripleFString String

hi def link effektInterpolationBrackets Special
hi def link effektInterpolationBoundary Function

syn match effektNumber /\<0[dDfFlL]\?\>/ " Just a bare 0
syn match effektNumber /\<[1-9]\d*[dDfFlL]\?\>/  " A multi-digit number
syn match effektNumber /\<0[xX][0-9a-fA-F]\+[dDfFlL]\?\>/ " Hex number
syn match effektNumber /\%(\<\d\+\.\d*\|\.\d\+\)\%([eE][-+]\=\d\+\)\=[fFdD]\=/ " exponential notation 1
syn match effektNumber /\<\d\+[eE][-+]\=\d\+[fFdD]\=\>/ " exponential notation 2
syn match effektNumber /\<\d\+\%([eE][-+]\=\d\+\)\=[fFdD]\>/ " exponential notation 3
hi def link effektNumber Number

syn region effektRoundBrackets start="(" end=")" skipwhite contained contains=effektTypeDeclaration,effektSquareBrackets,effektRoundBrackets

syn region effektSquareBrackets matchgroup=effektSquareBracketsBrackets start="\[" end="\]" skipwhite nextgroup=effektTypeExtension contains=effektTypeDeclaration,effektSquareBrackets,effektTypeOperator,effektTypeAnnotationParameter
syn match effektTypeOperator /[-+=:<>]\+/ contained
syn match effektTypeAnnotationParameter /@\<[`_A-Za-z0-9$]\+\>/ contained
hi def link effektSquareBracketsBrackets Type
hi def link effektTypeOperator Keyword
hi def link effektTypeAnnotationParameter Function

syn match effektShebang "\%^#!.*" display
"syn region effektMultilineComment start="/\*" end="\*/" contains=effektMultilineComment,effektDocLinks,effektParameterAnnotation,effektCommentAnnotation,effektTodo,effektCommentCodeBlock,@Spell keepend fold
syn match effektCommentAnnotation "@[_A-Za-z0-9$]\+" contained
syn match effektParameterAnnotation "\%(@tparam\|@param\|@see\)" nextgroup=effektParamAnnotationValue skipwhite contained
syn match effektParamAnnotationValue /[.`_A-Za-z0-9$]\+/ contained
syn region effektDocLinks start="\[\[" end="\]\]" contained
syn region effektCommentCodeBlock matchgroup=Keyword start="{{{" end="}}}" contained
syn match effektTodo "\vTODO|FIXME|XXX" contained
hi def link effektShebang Comment
hi def link effektMultilineComment Comment
hi def link effektDocLinks Function
hi def link effektParameterAnnotation Function
hi def link effektParamAnnotationValue Keyword
hi def link effektCommentAnnotation Function
hi def link effektCommentCodeBlock String
hi def link effektTodo Todo

syn match effektAnnotation /@\<[`_A-Za-z0-9$]\+\>/
hi def link effektAnnotation PreProc

syn match effektTrailingComment "//.*$" contains=effektTodo,@Spell
hi def link effektTrailingComment Comment

"syn match effektAkkaFSM /goto([^)]*)\_s\+\<using\>/ contains=effektAkkaFSMGotoUsing
"syn match effektAkkaFSM /stay\_s\+using/
"syn match effektAkkaFSM /^\s*stay\s*$/
"syn match effektAkkaFSM /when\ze([^)]*)/
"syn match effektAkkaFSM /startWith\ze([^)]*)/
"syn match effektAkkaFSM /initialize\ze()/
"syn match effektAkkaFSM /onTransition/
"syn match effektAkkaFSM /onTermination/
"syn match effektAkkaFSM /whenUnhandled/
"syn match effektAkkaFSMGotoUsing /\<using\>/
"syn match effektAkkaFSMGotoUsing /\<goto\>/
"hi def link effektAkkaFSM PreProc
"hi def link effektAkkaFSMGotoUsing PreProc

let b:current_syntax = 'effekt'

if main_syntax ==# 'effekt'
  unlet main_syntax
endif

" vim:set sw=2 sts=2 ts=8 et:
