" Name:    Firewatch duotone vim colorscheme
" Author:  Ramzi Akremi
" License: MIT
" Version: 1.0.0
scriptencoding utf-8

" Global setup =============================================================={{{

hi clear
syntax reset

" To switch properly between light and dark.
let g:colors_name = 'two-firewatch'

" Default options.
if !exists('g:two_firewatch_italics')
  let g:two_firewatch_italics = 0
endif
" }}}

  " Color definition --------------------------------------------------------{{{

  " Diff colors.
  let s:color_diff_change            = 
  let s:color_diff_delete            =
  let s:color_diff_add               =
  let s:color_diff_text              = 

  " @see https://www.google.com/search?q=color+picker for conversion rgb->hsv
  if &background ==? 'light'
    " {{{ Light
    " }}}
  else
    " {{{ Dark
    " First color.
    let s:uno_1 = '#d6e9ff' " 212°, 16%, 100%
    let s:uno_2 = '#abb2bf' " 219°, 10%, 75%
    let s:uno_3 = '#6e88a6' " 212°, 34%, 65%
    let s:uno_4 = '#7a8799' " 215°, 20%, 70

    " Second color.
    let s:duo_1 = '#c8ae9d' " 24°, 22%, 78%
    let s:duo_2 = '#e06c75' " 355°, 52%, 88%
    let s:duo_3 = '#dd672c' " 20°, 80%, 87%

    let s:syntax_fg               = s:uno_2
    let s:syntax_bg               = '#23272e' " 218°, 24%, 18%

    "
    let s:syntax_error            = '#cc3d3d'

    let s:syntax_accent           = '#56b6c2'
    let s:syntax_selection        = '#3e4452'
    let s:syntax_signcolumn       = '#55606d' " 213°, 22%, 43%
    let s:syntax_fold_bg          = '#5c6370'
    let s:syntax_cursor_line      = '#2c323c'
    " }}}
  endif

  " Terminal colors {{{
  let g:terminal_color_0  = ''
  let g:terminal_color_8  = ''
  let g:terminal_color_1  = '#e06c75'
  let g:terminal_color_9  = '#e06c75'
  let g:terminal_color_2  = '#98c379'
  let g:terminal_color_10 = '#98c379'
  let g:terminal_color_3  = '#e5c07b'
  let g:terminal_color_11 = '#e5c07b'
  let g:terminal_color_4  = '#61afef'
  let g:terminal_color_12 = '#61afef'
  let g:terminal_color_5  = '#c678dd'
  let g:terminal_color_13 = '#c678dd'
  let g:terminal_color_6  = '#56b6c2'
  let g:terminal_color_14 = '#56b6c2'
  let g:terminal_color_7  = ''
  let g:terminal_color_15 = ''

  if &background ==? 'light'
    let g:terminal_color_0  = '#282c34'
    let g:terminal_color_8  = '#4d4d4d'
    let g:terminal_color_7  = '#737780'
    let g:terminal_color_15 = '#a1a7b3'
  else " Dark
    let g:terminal_color_0  = '#000000'
    let g:terminal_color_8  = '#4d4d4d'
    let g:terminal_color_7  = '#737780'
    let g:terminal_color_15 = '#a1a7b3'
  endif
  " }}}

"}}} color definition

  " Vim editor color --------------------------------------------------------{{{
  "            group          fg                bg                    attr
  ('bold',         '',               '',                   'bold')
  ('ColorColumn',  '',               s:syntax_cursor_line, '')
  ('Conceal',      '',               '',                   '')
  ('Cursor',       s:syntax_bg,      s:syntax_accent,      '')
  ('CursorIM',     '',               '',                   '')
  ('CursorColumn', '',               s:syntax_cursor_line, '')
  ('CursorLine',   '',               s:syntax_cursor_line, '')
  ('Directory',    s:uno_1,          '',                   '')
  ('ErrorMsg',     s:syntax_error,   s:syntax_bg,          'none')
  ('VertSplit',    s:syntax_fold_bg, '',                   'none')
  ('Folded',       s:uno_1,          s:syntax_fold_bg,     '')
  ('FoldColumn',   s:uno_3,          s:syntax_cursor_line, '')
  ('IncSearch',    s:syntax_bg,      s:uno_4,              '')
  ('LineNr',       s:syntax_fold_bg, '',                   '')
  ('CursorLineNr', s:uno_2,          '',                   'none')
  ('MatchParen',   s:syntax_accent,  s:syntax_bg,          'bold')
  ('Italic',       '',               '',                   'italic')
  ('ModeMsg',      s:color_diff_add, '',                   '')
  ('MoreMsg',      s:syntax_fg,      '',                   '')
  ('NonText',      s:syntax_signcolumn, '',                '')
  ('EndOfBuffer',  s:syntax_bg,      '',                   '')
  ('PMenu',        '',               s:syntax_selection,   '')
  ('PMenuSel',     '',               s:syntax_bg,          '')
  ('PMenuSbar',    '',               s:syntax_bg,          '')
  ('PMenuThumb',   '',               s:uno_1,              '')
  ('Question',     s:syntax_accent,  '',                   '')
  ('Search',       s:syntax_bg,      s:uno_4,              '')
  ('SpecialKey',   s:syntax_fold_bg, '',                   '')
  ('StatusLine',   s:syntax_fg,      s:syntax_cursor_line, 'none')
  ('StatusLineNC', s:uno_4,          '',                   '')
  ('TabLine',      s:uno_4,          '',                   '')
  ('TabLineFill',  '',               '',                   'none')
  ('TabLineSel',   s:syntax_fg,      '',                   '')
  ('Title',        s:duo_2,          '',                   'bold')
  ('Visual',       '',               s:syntax_selection,   '')
  ('VisualNOS',    '',               s:syntax_selection,   '')
  ('WarningMsg',   s:syntax_accent,  '',                   '')
  ('TooLong',      s:syntax_accent,  '',                   '')
  ('WildMenu',     s:syntax_fg,      s:uno_4,              '')
  ('Normal',       s:syntax_fg,      s:syntax_bg,          '')
  ('SignColumn',   '',               s:syntax_signcolumn,  '')
  ('Special',      s:duo_2,          '',                   '')
  " }}}

  " Standard syntax highlighting --------------------------------------------{{{
  ('Comment',        s:uno_4,                '',          'italic')
  ('Constant',       s:duo_2,                '',          '')
  ('String',         s:duo_1,                '',          '')
  ('Character',      s:duo_2,                '',          '')
  ('Number',         s:duo_2,                '',          '')
  ('Boolean',        s:duo_2,                '',          '')
  ('Float',          s:duo_2,                '',          '')
  ('Identifier',     s:uno_3,                '',          'none')
  ('Function',       s:uno_2,                '',          '')
  ('Statement',      s:duo_1,                '',          'none')
  ('Conditional',    s:syntax_accent,        '',          '')
  ('Repeat',         s:duo_2,                '',          '')
  ('Label',          s:uno_1,                '',          '')
  ('Operator',       s:syntax_accent,        '',          'none')
  ('Keyword',        s:uno_1,                '',          '')
  ('Exception',      s:uno_1,                '',          '')
  ('PreProc',        s:uno_1,                '',          '')
  "('Include',        s:duo_2,                '',          '')
  "('Define',         s:duo_2,                '',          'none')
  "('Macro',          s:uno_3,                '',          '')
  "('PreCondit',      'ff0000',               '',          '')
  ('Type',           s:duo_1,                '',          'none')
  ('StorageClass',   s:duo_2,                '',          '')
  ('Structure',      s:uno_1,                '',          '')
  ('Typedef',        s:uno_1,                '',          '')
  ('Special',        s:uno_3,                '',          '')
  ('SpecialChar',    '',                     '',          '')
  ('Tag',            '',                     '',          '')
  ('Delimiter',      s:uno_4,                '',          '')
  ('SpecialComment', '',                     '',          '')
  ('Debug',          '',                     '',          '')
  ('Underlined',     s:duo_1,                '',          'underline')
  ('Ignore',         '',                     '',          '')
  ('Error',          s:syntax_error,         s:syntax_bg, 'bold')
  ('Todo',           s:duo_1,                s:syntax_bg, '')
  " }}}

  " Asciidoc highlighting ---------------------------------------------------{{{
  ('asciidocListingBlock',   s:uno_2,  '', '')
  " }}}

  " Cucumber highlighting ---------------------------------------------------{{{
  ('cucumberGiven',           s:duo_2,         '', '')
  ('cucumberWhen',            s:duo_2,         '', '')
  ('cucumberWhenAnd',         s:duo_2,         '', '')
  ('cucumberThen',            s:duo_2,         '', '')
  ('cucumberThenAnd',         s:duo_2,         '', '')
  ('cucumberUnparsed',        s:duo_1,         '', '')
  ('cucumberFeature',         s:syntax_accent, '', 'bold')
  ('cucumberBackground',      s:duo_2,         '', 'bold')
  ('cucumberScenario',        s:duo_2,         '', 'bold')
  ('cucumberScenarioOutline', s:duo_2,         '', 'bold')
  ('cucumberTags',            s:uno_4,         '', 'bold')
  ('cucumberDelimiter',       s:uno_4,         '', 'bold')
  " }}}

  " fugitive.vim
  ('diffAdded',   g:terminal_color_2,      '', '')
  ('diffRemoved', g:terminal_color_1,   '', '')
  " }}}

  " C/C++ and other languages like that -------------------------------------{{{
  "('cCustomParen',           s:uno_4,         '', '')
  " }}}

  " CSS/Sass highlighting ---------------------------------------------------{{{
  ('cssAttrComma',           s:duo_3,         '', '')
  ('cssAttributeSelector',   s:duo_2,         '', '')
  ('cssBraces',              s:uno_4,         '', '')
  ('cssClassName',           s:uno_1,         '', '')
  ('cssClassNameDot',        s:uno_1,         '', '')
  ('cssDefinition',          s:duo_3,         '', '')
  ('cssFlexibleBoxAttr',     s:duo_1,         '', '')
  ('cssBorderAttr',          s:duo_1,         '', '')
  ('cssPositioningAttr',     s:duo_1,         '', '')
  ('cssTransitionAttr',      s:duo_1,         '', '')
  ('cssCommonAttr',          s:duo_1,         '', '')
  ('cssBoxAttr',             s:duo_1,         '', '')
  ('cssFontAttr',            s:duo_1,         '', '')
  ('cssTextAttr',            s:duo_1,         '', '')
  ('cssFontDescriptor',      s:uno_1,         '', '')
  ('cssFunctionName',        s:uno_3,         '', '')
  ('cssIdentifier',          s:duo_1,         '', '')
  ('cssImportant',           s:duo_1,         '', '')
  ('cssUnitDecorators',      s:duo_2,         '', '')
  ('cssInclude',             s:uno_1,         '', '')
  ('cssIncludeKeyword',      s:duo_3,         '', '')
  ('cssMediaType',           s:uno_1,         '', '')
  ('cssProp',                s:uno_3,         '', '')
  ('cssPseudoClassId',       s:uno_1,         '', '')
  ('cssSelectorOp',          s:duo_3,         '', '')
  ('cssSelectorOp2',         s:duo_3,         '', '')
  ('cssStringQ',             s:duo_1,         '', '')
  ('cssStringQQ',            s:duo_1,         '', '')
  ('cssTagName',             s:uno_1,         '', '')
  ('cssClassNameDot',        s:uno_4,         '', '')
  ('cssValueNumber',         s:duo_1,         '', '')

  ('sassAmpersand',          s:syntax_accent, '', '')
  ('sassClass',              s:uno_1,         '', '')
  ('sassControl',            s:duo_3,         '', '')
  ('sassExtend',             s:duo_3,         '', '')
  ('sassFor',                s:uno_1,         '', '')
  ('sassProperty',           s:uno_3,         '', '')
  ('sassFunction',           s:duo_1,         '', '')
  ('sassId',                 s:duo_2,         '', '')
  ('sassInclude',            s:uno_1,         '', '')
  ('sassMedia',              s:duo_3,         '', '')
  ('sassMediaOperators',     s:uno_1,         '', '')
  ('sassMixin',              s:duo_3,         '', '')
  ('sassMixinName',          s:duo_2,         '', '')
  ('sassMixing',             s:duo_3,         '', '')
  ('sassVariable',           s:uno_2,         '', '')
  ('sassVariableAssignment', s:uno_4,         '', '')
  " }}}

  " Elixir highlighting------------------------------------------------------{{{
  "('elixirAtom',              s:syntax_accent, '', '')
  "('elixirAlias',             s:duo_1,         '', '')
  ('elixirBlock',             s:uno_3,         '', '')
  "('elixirBlockDefinition',   s:duo_2,         '', '')
  "('elixirInclude',           s:duo_2,         '', '')
  ('elixirId',                s:uno_2,         '', '')
  ('elixirModuleDeclaration', s:uno_1,         '', '')
  "('elixirModuleDefine',      s:duo_2,         '', '')
  "('elixirOperator',          s:uno_3,         '', '')
  "('elixirSigil',             s:uno_4,         '', '')
  "('elixirVariable',          s:duo_2,         '', '')
  " }}}

  " Go highlighting ---------------------------------------------------------{{{
  ('goDeclaration',         s:duo_3, '', '')
  " }}}

  " Git and git related plugins highlighting --------------------------------{{{
  ('gitcommitComment',       s:uno_4,         '', '')
  ('gitcommitUnmerged',      s:duo_2,         '', '')
  ('gitcommitOnBranch',      '',              '', '')
  ('gitcommitBranch',        s:duo_3,         '', '')
  ('gitcommitDiscardedType', s:syntax_accent, '', '')
  ('gitcommitSelectedType',  s:duo_2,         '', '')
  ('gitcommitHeader',        '',              '', '')
  ('gitcommitUntrackedFile', s:duo_2,         '', '')
  ('gitcommitDiscardedFile', s:syntax_accent, '', '')
  ('gitcommitSelectedFile',  s:duo_2,         '', '')
  ('gitcommitUnmergedFile',  s:uno_1,         '', '')
  ('gitcommitFile',          '',              '', '')
  hi link gitcommitNoBranch       gitcommitBranch
  hi link gitcommitUntracked      gitcommitComment
  hi link gitcommitDiscarded      gitcommitComment
  hi link gitcommitSelected       gitcommitComment
  hi link gitcommitDiscardedArrow gitcommitDiscardedFile
  hi link gitcommitSelectedArrow  gitcommitSelectedFile
  hi link gitcommitUnmergedArrow  gitcommitUnmergedFile

  ('SignifySignAdd',    s:duo_2,         '', '')
  ('SignifySignChange', s:uno_1,         '', '')
  ('SignifySignDelete', s:syntax_accent, '', '')
  hi link GitGutterAdd    SignifySignAdd
  hi link GitGutterChange SignifySignChange
  hi link GitGutterDelete SignifySignDelete
  " }}}

  " HTML highlighting -------------------------------------------------------{{{
  ('htmlArg',            s:uno_2, '', '')
  ('htmlTagName',        s:uno_1, '', '')
  ('htmlSpecialTagName', s:uno_1, '', '')
  ('htmlTag',            s:uno_3, '', '')

  ('liquidDelimiter',    s:uno_4, '', '')
  ('liquidKeyword',      s:uno_3, '', '')
  " }}}

  " JavaScript highlighting -------------------------------------------------{{{
  ('coffeeString',           s:duo_2,         '', '')

  ('javaScriptBraces',       s:uno_3,         '', '')
  ('javaScriptFunction',     s:duo_3,         '', '')
  ('javaScriptIdentifier',   s:duo_3,         '', '')
  ('javaScriptNull',         s:uno_1,         '', '')
  ('javaScriptNumber',       s:uno_1,         '', '')
  ('javaScriptRequire',      s:duo_2,         '', '')
  ('javaScriptReserved',     s:duo_3,         '', '')
  " https://github.com/pangloss/vim-javascript
  ('jsArrowFunction',        s:duo_3,         '', '')
  ('jsClassKeywords',        s:duo_3,         '', '')
  ('jsDocParam',             s:duo_2,         '', '')
  ('jsDocTags',              s:duo_3,         '', '')
  ('jsFuncCall',             s:uno_1,         '', '')
  ('jsFunction',             s:duo_3,         '', '')
  ('jsGlobalObjects',        s:uno_1,         '', '')
  ('jsModuleWords',          s:duo_3,         '', '')
  ('jsModules',              s:duo_3,         '', '')
  ('jsNoise',                s:uno_3,         '', '')
  ('jsNull',                 s:uno_1,         '', '')
  ('jsOperator',             s:duo_2,         '', '')
  ('jsObjectBraces',         s:uno_3,         '', '')
  ('jsBrackets',             s:uno_3,         '', '')
  ('jsParens',               s:uno_3,         '', '')
  ('jsStorageClass',         s:duo_1,         '', '')
  ('jsTemplateBraces',       s:syntax_accent, '', '')
  ('jsTemplateVar',          s:duo_2,         '', '')
  ('jsThis',                 s:syntax_accent, '', '')
  ('jsUndefined',            s:uno_1,         '', '')
  " https://github.com/othree/yajs.vim
  ('javascriptArrowFunc',    s:duo_3,         '', '')
  ('javascriptClassExtends', s:duo_3,         '', '')
  ('javascriptClassKeyword', s:duo_3,         '', '')
  ('javascriptDocNotation',  s:duo_3,         '', '')
  ('javascriptDocParamName', s:duo_2,         '', '')
  ('javascriptDocTags',      s:duo_3,         '', '')
  ('javascriptEndColons',    s:uno_3,         '', '')
  ('javascriptExport',       s:duo_3,         '', '')
  ('javascriptFuncArg',      s:uno_1,         '', '')
  ('javascriptFuncKeyword',  s:duo_3,         '', '')
  ('javascriptIdentifier',   s:syntax_accent, '', '')
  ('javascriptImport',       s:duo_3,         '', '')
  ('javascriptObjectLabel',  s:uno_1,         '', '')
  ('javascriptOpSymbol',     s:duo_2,         '', '')
  ('javascriptOpSymbols',    s:duo_2,         '', '')
  ('javascriptPropertyName', s:duo_2,         '', '')
  ('javascriptTemplateSB',   s:syntax_accent, '', '')
  ('javascriptVariable',     s:duo_3,         '', '')
  " }}}

  " JSON highlighting -------------------------------------------------------{{{
  ('jsonCommentError',      s:uno_1,         '', ''        )
  ('jsonKeyword',           s:duo_2,         '', ''        )
  ('jsonQuote',             s:uno_3,         '', ''        )
  ('jsonMissingCommaError', s:syntax_accent, '', 'reverse' )
  ('jsonNoQuotesError',     s:syntax_accent, '', 'reverse' )
  ('jsonNumError',          s:syntax_accent, '', 'reverse' )
  ('jsonString',            s:duo_1,         '', ''        )
  ('jsonStringSQError',     s:syntax_accent, '', 'reverse' )
  ('jsonSemicolonError',    s:syntax_accent, '', 'reverse' )
  " }}}

  " Markdown highlighting ---------------------------------------------------{{{
  ('markdownUrl',              s:duo_3, '', '')
  ('markdownCode',             s:duo_1, '', '')
  ('markdownHeadingDelimiter', s:duo_3, '', '')
  ('markdownListMarker',       s:duo_3, '', '')

  ('mkdCode',                  s:duo_1, '', '')
  ('mkdDelimiter',             s:uno_3, '', '')
  ('mkdLink',                  s:duo_1, '', '')
  ('mkdLinkDef',               s:duo_1, '', '')
  ('mkdLinkDefTarget',         s:duo_1, '', 'underline')
  ('mkdURL',                   s:duo_1, '', 'underline')

  ('htmlBold',                 s:uno_2, '', 'bold')
  ('htmlItalic',               s:uno_2, '', 'italic')
  " }}}

  " NERDTree highlighting ---------------------------------------------------{{{
  ('NERDTreeExecFile',      s:duo_1, '', '')
  " }}}

  " Ruby highlighting -------------------------------------------------------{{{
  ('rubyBlock',                     s:uno_2,         '', '')
  ('rubyBlockParameter',            s:uno_2,         '', '')
  ('rubyBlockParameterList',        s:uno_3,         '', '')
  ('rubyCapitalizedMethod',         s:duo_2,         '', '')
  ('rubyClass',                     s:duo_2,         '', '')
  ('rubyConstant',                  s:uno_3,         '', '')
  ('rubyControl',                   s:duo_2,         '', '')
  ('rubyConditionalModifier',       s:syntax_accent, '', '')
  ('rubyCurlyBlockDelimiter',       s:uno_4,         '', '')
  ('rubyDefine',                    s:duo_2,         '', '')
  ('rubyEscape',                    s:syntax_accent, '', '')
  ('rubyFunction',                  s:uno_1,         '', '')
  ('rubyGlobalVariable',            s:syntax_accent, '', '')
  ('rubyInclude',                   s:duo_2,         '', '')
  ('rubyIncluderubyGlobalVariable', s:syntax_accent, '', '')
  ('rubyInstanceVariable',          s:syntax_accent, '', '')
  ('rubyInterpolation',             s:duo_2,         '', '')
  ('rubyInterpolationDelimiter',    s:uno_4,         '', '')
  ('rubyModule',                    s:duo_2,         '', '')
  ('rubyRegexp',                    s:duo_1,         '', '')
  ('rubyRegexpDelimiter',           s:uno_4,         '', '')
  ('rubyStringDelimiter',           s:duo_3,         '', '')
  ('rubySymbol',                    s:duo_1,         '', '')
  " }}}

  " Spelling highlighting ---------------------------------------------------{{{
  ('SpellBad',     '', s:syntax_bg, 'undercurl')
  ('SpellLocal',   '', s:syntax_bg, 'undercurl')
  ('SpellCap',     '', s:syntax_bg, 'undercurl')
  ('SpellRare',    '', s:syntax_bg, 'undercurl')
  " }}}

  " Vim highlighting --------------------------------------------------------{{{
  "('vimCommentTitle', s:uno_4, '', 'bold')
  ('vimCommand',      s:uno_1, '', '')
  ('vimVar',          s:duo_2, '', '')
  ('vimEnvVar',       s:duo_3, '', '')

  " Vim Help highlights
  ('helpHyperTextJump', s:duo_1, '', '')
  ('helpSpecial',       s:duo_2, '', '')

  " }}}

  " XML highlighting --------------------------------------------------------{{{
  ('xmlAttrib',  s:uno_1,         '', '')
  ('xmlEndTag',  s:syntax_accent, '', '')
  ('xmlTag',     s:syntax_accent, '', '')
  ('xmlTagName', s:syntax_accent, '', '')
  " }}}

  " YAML highlighting -------------------------------------------------------{{{
  ('yamlKey',         s:duo_2, '', '')
  ('yamlOperator',    s:uno_4, '', '')

  ('liquidDelimiter', s:uno_4, '', '')
  ('liquidKeyword',   s:uno_3, '', '')
  " }}}

" Delete functions =========================================================={{{
  delf <SID>X
"}}}


" vim: set fdl=0 fdm=marker:
