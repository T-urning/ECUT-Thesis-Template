%% This program is a LaTeX class file for bachelor thesis template
%% of East China University of Technology
%%
%% Copyright (c) 2019 -- 2021 WHUTUG <https://github.com/whutug>
%%
%% This project uses the MIT License, see LICENSE for more details.
%% ----------------------------------------------------------------------

\NeedsTeXFormat{LaTeX2e}
\RequirePackage{expl3 , xparse , l3keys2e}
\ProvidesExplClass{ecut-thesis}{2021/05/20}{0.6d}
  {East China University of Technology Thesis Template}

\msg_new:nnn { ecut-thesis } { 引擎不支持 }
  {
    ecut-thesis ~ 不支持 ~ #1 ~ 引擎。\\\\

    请使用 ~ XeLaTeX ~ 或 ~ LuaLaTeX ~ 进行编译！
  }

\sys_if_engine_xetex:F
  {
    \sys_if_engine_luatex:F
      {
        \msg_fatal:nnx { ecut-thesis } { 引擎不支持 }
          { \c_sys_engine_str }
      }
  }

% 函数变体声明
\cs_generate_variant:Nn \tl_map_inline:nn { x n }
\cs_generate_variant:Nn \file_input:n { V }

%%% ---- 文档选项 ----- %%%
\tl_new:N \g__ecut_option_type_tl
\tl_new:N \g__ecut_option_class_tl
\tl_new:N \g__ecut_option_punct_tl

\bool_new:N \g__ecut_option_draft_bool
\bool_new:N \g__ecut_option_twoside_bool

\clist_new:N \g__ecut_option_to_class_clist
\clist_gset:Nn \g__ecut_option_to_class_clist
  { a4paper , zihao = -4 , fontset = none , sub4section }

\keys_define:nn { ecut / option }
  {
    type .value_required:n = true,
    type .choices:nn       =
      { doctor , master , bachelor , opening }
      { \tl_gset_eq:NN \g__ecut_option_type_tl \l_keys_choice_tl },
    type .initial:n        = doctor,
    % 学位，默认本科生

    class .value_required:n = true,
    class .choices:nn       =
      { academic , professional , paper , design }
      { \tl_gset_eq:NN \g__ecut_option_class_tl \l_keys_choice_tl },
    % 文档类型

    draft         .choice:,
    draft / true  .code:n    =
      {
        \bool_gset_true:N    \g__ecut_draft_bool
        \clist_gput_right:Nn \g__ecut_option_to_class_clist { draft }
      },
    draft / false .code:n    =
      {
        \bool_gset_false:N   \g__ecut_draft_bool
      },
    draft         .default:n = true,
    draft         .initial:n = false,
    % 草稿模式，默认关闭

    oneside .value_forbidden:n = true,
    twoside .value_forbidden:n = true,
    oneside .code:n            =
      {
        \bool_gset_false:N   \g__ecut_option_twoside_bool
        \clist_gput_right:Nn \g__ecut_option_to_class_clist { oneside }
      },
    twoside .code:n            =
      {
        \bool_gset_true:N    \g__ecut_option_twoside_bool
        \clist_gput_right:Nn \g__ecut_option_to_class_clist { twoside }
      },
    % 单双页模式

    punct .value_required:n = true,
    punct .choices:nn       =
      { quanjiao , banjiao , kaiming }
      { \tl_gset_eq:NN \g__ecut_option_punct_tl \l_keys_choice_tl },
    punct .initial:n        = quanjiao,
    % 标点格式
  }
\ProcessKeysOptions { ecut / option }

\tl_if_eq:NnT \g__ecut_option_type_tl { master }
  {
    \keys_define:nn { ecut / option }
      {
        class .initial:n = academic
      }
  }
\tl_if_eq:NnT \g__ecut_option_type_tl { bachelor }
  {
    \keys_define:nn { ecut / option }
      {
        class .initial:n = paper
      }
  }

\sys_if_engine_luatex:TF
  {
    \clist_gput_right:Nn \g__ecut_option_to_class_clist
      { punct = zh_CN / \g__ecut_option_punct_tl }
  }
  {
    \clist_gput_right:Nn \g__ecut_option_to_class_clist
      { punct = \g__ecut_option_punct_tl }
  }
% 判断是否有 chinese-jfm，若有则使用 chinese-jfm

\sys_if_engine_xetex:T { \RequirePackage { etoolbox } }
% 在载入文档类之前引入 etoolbox

%%% ---- 载入 Class ----- %%%
\PassOptionsToPackage { no-math } { fontspec }

% 开题报告使用 ctexart，论文使用 ctexbook，书脊使用 ltjtarticle
\tl_if_eq:NnTF \g__ecut_option_type_tl { opening }
  {
    \PassOptionsToClass { \g__ecut_option_to_class_clist } { ctexart }
    \LoadClass { ctexart }
  }
  {
    \PassOptionsToClass { \g__ecut_option_to_class_clist } { ctexbook }
    \LoadClass { ctexbook }
    \bool_gset_true:N \g__ecut_option_twoside_bool
  }
\ProcessKeysOptions { ecut / option }

\sys_if_engine_luatex:T { \RequirePackage { luatexja-adjust } }

\tl_if_eq:NnT \g__ecut_option_type_tl { doctor }
  {
    \tl_const:Nn \c__ecut_heading_tl
      { \__ecut_spread_with:nn { 博士学位论文 } { \quad } }
    \tl_set:Nn \bibname { \zihao { 4 } \textbf { 参考文献 } }
    \tl_set:Nn \bibliographytypesize { \zihao { 5 } }
  }

\tl_if_eq:NnT \g__ecut_option_type_tl { master }
  {
    \tl_if_eq:NnT \g__ecut_option_class_tl { academic }
      {
        \tl_const:Nn \c__ecut_heading_tl
          { \__ecut_spread_with:nn { 硕士学位论文 } { \quad } }
      }
    \tl_if_eq:NnT \g__ecut_option_class_tl { professional }
      {
        \tl_const:Nn \c__ecut_heading_tl
          { \__ecut_spread_with:nn { 硕士专业学位论文 } { \enskip } }
      }
    \tl_set:Nn \bibname {  参考文献 }
    \tl_set:Nn \bibliographytypesize { \zihao { 5 } }
  }

\tl_if_eq:NnT \g__ecut_option_type_tl { bachelor }
  {
    \tl_if_eq:NnT \g__ecut_option_class_tl { paper }
      { \tl_const:Nn \c__ecut_heading_tl { 东华理工大学本科毕业论文 } }
    \tl_if_eq:NnT \g__ecut_option_class_tl { design }
      { \tl_const:Nn \c__ecut_heading_tl { 东华理工大学本科毕业设计 } }
  }

\tl_if_eq:NnT \g__ecut_option_type_tl { opening }
  {
    \tl_const:Nn \c__ecut_heading_tl
      { 东华理工大学本科毕业论文（设计） \\ 开　题　报　告 }
    \tl_set:Nn \bibname { 参考文献 }
    \RequirePackage { needspace }
  }

%%% ---- 引入宏包 ----- %%%
\RequirePackage { amsmath , amssymb , amsthm , mathtools }

\RequirePackage { tikz, pgfplots } % 绘图
\pgfplotsset { compat = 1.17 }

\RequirePackage [ normalem ] { ulem }
\RequirePackage [ normalem ] { CJKulem }

\RequirePackage { physics }
\RequirePackage { siunitx }

\RequirePackage { algorithm2e }     % 算法代码
\tl_set:Nn \algorithmcfname { 算法 }
\SetAlCapSty {}
\SetAlCapFnt {}
\box_new:N \l__ecut_space_box
\hbox_set:Nn \l__ecut_space_box { \nobreakspace }
\SetAlgoCaptionSeparator
  { \hbox_to_wd:nn { 1 em - \box_wd:N \l__ecut_space_box } {} }
% 算法标题后会跟一个不间断空格 ~，这里将其宽度减掉

%%% ---- 定义页面样式 ----- %%%
\RequirePackage { geometry }
\clist_if_in:nVTF { bachelor , opening } \g__ecut_option_type_tl
  { \geometry { hmargin = 3 cm , top = 2.5 cm , bottom = 2 cm , ignoreall } }
  { \geometry { margin = 2.5 cm , ignoreall } }
% 本科、开题报告左右边距 3 cm，上边距 2.5 cm，下边距 2 cm
% 硕博边距 2.5 cm。

\bool_if:NT \g__ecut_draft_bool
  {
    \sys_if_engine_luatex:T
      { \RequirePackage { lua-visual-debug } }
    \sys_if_engine_xetex:T
      { \geometry { showframe } }
  }
% 草稿模式下，显示边框

\RequirePackage { fancyhdr }        % 页眉页脚宏包
\tl_set:Nn \headrulewidth { 0.5 pt }  % 页眉线宽
\tl_set:Nn \footrulewidth { \c_zero_dim }  % 页脚线宽
\renewcommand{\chaptermark}[1]{\markboth{#1}{}} % 仅保留章名，去掉章节前面的数字序号
% 页眉，页脚
\setlength{\headheight}{15mm}
\setlength{\footskip}{15mm}

\AtEndPreamble
  {
    \tl_new:N \g__ecut_head_odd_tl
    \tl_new:N \g__ecut_head_even_tl
    \tl_if_eq:NnT \g__ecut_option_type_tl { doctor }
      {
        \tl_gset_eq:NN \g__ecut_head_odd_tl \g__ecut_info_title_tl
        \tl_gremove_all:Nn \g__ecut_head_odd_tl { \\ }
        \tl_gset:Nn \g__ecut_head_even_tl { 东华理工大学博士学位论文 }
      }
    \tl_if_eq:NnT \g__ecut_option_type_tl { master }
      {
        \tl_gset_eq:NN \g__ecut_head_odd_tl \leftmark
        \tl_gremove_all:Nn \g__ecut_head_odd_tl { \\ }
        \tl_gset:Nn \g__ecut_head_even_tl { 东华理工大学硕士学位论文 }
      }

    % 默认页面页眉页脚样式
    \clist_if_in:nVTF { doctor , master } \g__ecut_option_type_tl
      {
        \fancypagestyle { plain }
          {
            \fancyhf {}
            \fancyfoot [ C ]   { \zihao { 5 } \thepage }
            \fancyhead [ O C ] { \zihao { 5 } \g__ecut_head_odd_tl }
            \fancyhead [ E C ] { \zihao { 5 } \g__ecut_head_even_tl }
          }
      }
      {
        \fancypagestyle { plain }
          {
            \fancyhf {}
            \fancyfoot [ C ] { \zihao { 5 } \thepage }
          }
      }
  }

%%% ---- 定义标题和段落样式 ----- %%%
\ctexset
  {
    section        =
      {
        format     = { \heiti \zihao { 3 }       },
        beforeskip = { 0.5 \c__ecut_baseline_skip },
        afterskip  = { 0.5 \c__ecut_baseline_skip },
      },  % 一级标题 黑体 3 号
    subsection     =
      {
        format     = { \heiti \zihao { -3 }      },
        beforeskip = { 0.5 \c__ecut_baseline_skip },
        afterskip  = { 0.5 \c__ecut_baseline_skip },
      },  % 二级标题 黑体小 3 号
    subsubsection  =
      {
        format     = { \heiti \zihao { 4 }      },
        beforeskip = { 0.5 \c__ecut_baseline_skip },
        afterskip  = { 0.5 \c__ecut_baseline_skip },
      },  % 三级标题 黑体 4号
    paragraph      =
      {
        format     = { \heiti \zihao { -4 }       },
        number     = { （ \arabic { paragraph } ）},
        aftername  = { \hbox:n {}                 },
        beforeskip = { 0.5 \c__ecut_baseline_skip  },
        afterskip  = { 0.5 \c__ecut_baseline_skip  },
      },
    subparagraph   =
      {
        format     = { \heiti \zihao { -4 }                  },
        number     = { \circled { \arabic { subparagraph } } },
        aftername  = { \quad                                 },
        beforeskip = { 0.5 \c__ecut_baseline_skip             },
        afterskip  = { 0.5 \c__ecut_baseline_skip             },
      },
    tocdepth       = 2,  % 目录层级数
    secnumdepth    = 5,  % 标题层级数
  }
\tl_if_eq:NnF \g__ecut_option_type_tl { opening }
  {
    \ctexset
      {
        chapter        =
          {
            format     = { \centering \heiti \zihao { -2 } },
            number     = { \arabic { chapter }             },
            name       = { ,                               },
            beforeskip = { 0.8 \c__ecut_baseline_skip       },
            afterskip  = { 0.5 \c__ecut_baseline_skip       },
          }  % 各章标题 黑体小 2 号
      }
  }

%%% ---- 目录样式设置 ----- %%%
\RequirePackage { tocloft }
\clist_map_inline:nn { toc , lof , lot }
  {
    \tl_set:cn { cft #1 title font } { \hfil \heiti \zihao { -2 } }
    % 目录标题 黑体小 2 号
    \clist_map_inline:nn { before , after }
      { \skip_zero:c { cft ##1 #1 title skip } }
  }
\skip_set:Nn \cftaftertoctitleskip { 0.5 \baselineskip }

\clist_map_inline:nn { doctor , bachelor }
  {
    \tl_if_eq:NnT \g__ecut_option_type_tl {#1}
      { \tocloftpagestyle { empty } }
  }

\tl_set:Nn \contentsname   { 目录 }
\tl_set:Nn \listfigurename { 图目录 }
\tl_set:Nn \listtablename  { 表目录  }
\renewcommand{\cftfigpresnum}{图}
\renewcommand{\cfttabpresnum}{表}
\newlength{\mylen}
\settowidth{\mylen}{\cftfigpresnum\cftfigaftersnum\quad}
\addtolength{\cftfignumwidth}{\mylen}
\addtolength{\cfttabnumwidth}{\mylen}

\tl_set:Nn \cftdot { \raisebox { 0.3 em } { \normalfont . } }
\tl_set:Nn \cftdotsep { \c_one_int }
% 点间距

\clist_map_inline:nn { sec , subsec , subsubsec }
  {
    \tl_set:cn { cft #1 font } { \zihao { -4 } }

    \tl_if_eq:NnF \g__ecut_option_type_tl { doctor }
      { \tl_set:cn  { cft #1 page font } { \zihao { 5 } } }

    %\dim_set:cn { cft #1 indent } { \parindent }
  }

% \setlength{\cftsubsecindent}{ \parindent }
% \setlength{\cftsubsubsecindent}{ \parindent }

\dim_zero:N \cftfigindent
\dim_zero:N \cfttabindent

\tl_if_eq:NnF \g__ecut_option_type_tl { opening }
  {
    \tl_set:Nn \cftchapdotsep { \c_one_int }
    \tl_if_eq:NnTF \g__ecut_option_type_tl { doctor }
      {
        \tl_set:Nn \cftchapfont { \bfseries \zihao { -4 } }
        \tl_set:Nn \cftchappagefont { \zihao { -4 } }
        \skip_zero:N \cftbeforechapskip
      }
      {
        \tl_set:Nn \cftchapfont { \heiti \zihao { 4 } }
        \tl_set:Nn \cftchappagefont { \zihao { 5 } }
      }
  }

%%% ---- 图表标题 ----- %%%
\RequirePackage { subcaption }
% 图表标题设置
\RequirePackage [labelsep=quad] { caption } % 序号之后空一格写标题
\RequirePackage[list = off] { bicaption }[2020/10/25 v1.3] % 双语图表标题， list = off 设置图表目录中只显示第一种语言的标题内容
\captionsetup[bi-second]{listtype+=Eng}
\captionsetup[figure][bi-second]{name=Figure} %设置图的英文编号前缀
\captionsetup[table][bi-second]{name=Table} %设置表的英文编号前缀
\RequirePackage { newfloat }
\DeclareFloatingEnvironment[fileext=lof2]{figureEng}[Figure][List\ of\ Figures]
\DeclareFloatingEnvironment[fileext=lot2]{tableEng}[Table][List\ of\ Tables]
% 设置表格标题字体为黑体, 设置图标题字体为宋体
\DeclareCaptionFont { ecuttablecap  }
  { \heiti \addCJKfontfeatures { BoldFont = * } \bfseries \zihao { 5 } }
\DeclareCaptionFont { ecutfigurecap }
  { \heiti \addCJKfontfeatures { BoldFont = * } \bfseries \zihao { 5 } }
\captionsetup [ table ]
  {
    name = 表,
    font = ecuttablecap
  }
\captionsetup [ figure ]
  {
    name = 图,
    font = ecutfigurecap
  }



\RequirePackage { graphicx }
\AtEndPreamble
  { \exp_args:NV \graphicspath \g__ecut_style_graphics_path_tl }
% 图片文件路径

% 使用 tabularx 创建占满宽度的表格
\RequirePackage { tabularx, array }
\newcolumntype { L } { > { \raggedright \arraybackslash } X }
\newcolumntype { C } { > { \centering   \arraybackslash } X }
\newcolumntype { R } { > { \raggedleft  \arraybackslash } X }

\ProvideDocumentCommand { \tabularxcolumn } { m }
  { m { #1 } }  % 使表格内容垂向居中

\RequirePackage
  {
    xltabular, % 长表格
    booktabs,  % 三线表
    makecell,
    multirow,  % 跨行表格
    diagbox    % 斜线表头
  }
\RequirePackage{ longtable }[ 2021/05/07 v4.16 ]

\cs_new_protected:Npn \__ecut_set_table_font:
  {
    \clist_map_inline:nn { tabular , tabularx , longtable , xltabular }
      { \AtBeginEnvironment {##1} { \zihao { 5 } } }
  }
% 将表格内容字体设为五号

% 列表样式
\RequirePackage [ inline ] { enumitem }
\setlist { nosep }

% 修改脚注
\RequirePackage [ perpage ] { footmisc }
% 每面更新序号

\tl_set:Nn \@makefnmark
  {
    \kern \c_zero_dim \textsuperscript { \circled { \@thefnmark } }
  }

\RenewDocumentCommand { \@makefntext } { m }
  {
    \noindent \hangindent 1 em \circled { \@thefnmark } #1 \hangafter 1
  }

\skip_set_eq:NN \headheight \baselineskip
\skip_set_eq:NN \footskip   \baselineskip

\dim_set:Nn \footnotesep { 6 pt }
\setlength { \skip \footins } { \skip_eval:n { 2 \baselineskip } plus 1 fill }
\tl_set:Nn \footnotesize { \songti \zihao { 5 } }
\tl_set:Nn \footnoterule
  { \noindent \rule [ 1 pt ] { 0.3 \columnwidth } { 1 pt } }

\NewDocumentCommand { \circled } { m }
  {
    \resizebox { 1 em } { ! }
      {
        \tikz [ baseline = ( char.base ) ]
          {
            \node [ shape = circle , draw , inner ~ sep = \c_zero_dim ,
              minimum ~ size = 1 em ] ( char ) {#1};
          } % 圆圈数字①
      }
  }

%%% ---- 定义字体 ----- %%%
\RequirePackage { unicode-math }

\cs_new_protected:Npn \__ecut_fontset:n #1
  { \cs_gset_eq:Nc \__ecut_set_font: { __ecut_set_font_ #1 : } }
\cs_new_protected:Npn \__ecut_cjk_fontset:n #1
  { \cs_gset_eq:Nc \__ecut_set_cjk_font: { __ecut_set_cjk_font_ #1 : } }
\cs_new_protected:Npn \__ecut_math_fontset:n #1
  { \cs_gset_eq:Nc \__ecut_set_math_font: { __ecut_set_math_font_ #1 : } }

\keys_define:nn { ecut / style }
  {
    font .choices:nn =
      { times , xits , termes , none }
      { \__ecut_fontset:n { \l_keys_choice_tl } },
    % 西文字体

    math-font .choices:nn =
      { xits , termes , none }
      { \__ecut_math_fontset:n { \l_keys_choice_tl } },
    % 数学字体

    cjk-font .choices:nn =
      { windows , mac , fandol , overleaf , none }
      { \__ecut_cjk_fontset:n { \l_keys_choice_tl } },
    % 中文字体
  }

% 西文字体
\cs_new_protected:Npn \__ecut_set_font_times:
  { \setmainfont { Times ~ New ~ Roman } [ Ligatures = Rare ] }

% XITS % 字体安装在 TeX 发行版下，必须使用文件名调用
\cs_new_protected:Npn \__ecut_set_font_xits:
  {
    \setmainfont { XITS }
      [
        Extension      = .otf,
        UprightFont    = * - Regular,
        BoldFont       = * - Bold,
        ItalicFont     = * - Italic,
        BoldItalicFont = * - BoldItalic
      ]
  }

\cs_new_protected:Npn \__ecut_set_font_termes:
  {
    \setmainfont { texgyretermes }
      [
        Extension      = .otf,
        UprightFont    = * - regular,
        BoldFont       = * - bold,
        ItalicFont     = * - italic,
        BoldItalicFont = * - bolditalic
      ]
  }

\cs_new_protected:Npn \__ecut_set_font_none: {}

% 中文字体
\cs_new_protected:Npn \__ecut_set_cjk_font_song:nn #1#2
  {
    \setCJKmainfont {#1} [#2]
    \newCJKfontfamily { \songti } {#1} [#2]
  }
\cs_new_protected:Npn \__ecut_set_cjk_font_hei:nn #1#2
  {
    \setCJKsansfont {#1} [#2]
    \newCJKfontfamily { \heiti } {#1} [#2]
  }
\cs_new_protected:Npn \__ecut_set_cjk_font_fang:nn #1#2
  {
    \setCJKmonofont {#1} [#2]
    \newCJKfontfamily { \fangsong } {#1} [#2]
    \cs_new:Npn \__ecut_set_spine_font:
      {
        \exp_not:N \setmainjfont {#1}
          [
            #2 , TateFeatures =
              {
                JFM = zh_CN / { \exp_not:o \g__ecut_option_punct_tl , vert }
              }
          ]
      }
  }
\cs_new_protected:Npn \__ecut_set_cjk_font_kai:nn #1#2
  {
    \newCJKfontfamily { \kaishu } {#1} [#2]
  }

\cs_new_protected:Npn \__ecut_set_cjk_font_windows:
  {
    \__ecut_set_cjk_font_song:nn { SimSun }
      { AutoFakeBold = 4 , AutoFakeSlant = 0.167 }
    \__ecut_set_cjk_font_hei:nn { SimHei }
      { AutoFakeBold = 4 , AutoFakeSlant = 0.167 }
    \__ecut_set_cjk_font_fang:nn { FangSong }
      { AutoFakeBold = 4 , AutoFakeSlant = 0.167 }
    \__ecut_set_cjk_font_kai:nn { KaiTi }
      { AutoFakeBold = 4 , AutoFakeSlant = 0.167 }
  }

\cs_new_protected:Npn \__ecut_set_cjk_font_mac:
  {
    \__ecut_set_cjk_font_song:nn { Songti ~ SC ~ Light }
      {
        BoldFont           = Songti ~ SC ~ Bold,
        AutoFakeSlant      = 0.167,
        BoldItalicFont     = Songti ~ SC ~ Bold,
        BoldItalicFeatures = { FakeSlant = 0.167 }
      }
    \__ecut_set_cjk_font_hei:nn { Heiti ~ SC ~ Light }
      {
        BoldFont           = Heiti ~ SC ~ Medium,
        AutoFakeSlant      = 0.167,
        BoldItalicFont     = Heiti ~ SC ~ Medium,
        BoldItalicFeatures = { FakeSlant = 0.167 }
      }
    \__ecut_set_cjk_font_fang:nn { STFangsong }
      { AutoFakeBold = 4 , AutoFakeSlant = 0.167 }
    \__ecut_set_cjk_font_kai:nn { Kaiti ~ SC ~ Regular }
      {
        BoldFont           = Kaiti ~ SC ~ Bold,
        AutoFakeSlant      = 0.167,
        BoldItalicFont     = Kaiti ~ SC ~ Bold,
        BoldItalicFeatures = { FakeSlant = 0.167 }
      }
  }

% fandol 同理
\cs_new_protected:Npn \__ecut_set_cjk_font_fandol:
  {
    \__ecut_set_cjk_font_song:nn { FandolSong-Regular.otf }
      {
        BoldFont           = FandolSong-Bold.otf,
        AutoFakeSlant      = 0.167,
        BoldItalicFont     = FandolSong-Bold.otf,
        BoldItalicFeatures = { FakeSlant = 0.167 }
      }
    \__ecut_set_cjk_font_hei:nn { FandolHei- Regular.otf }
      {
        BoldFont           = FandolHei-Bold.otf,
        AutoFakeSlant      = 0.167,
        BoldItalicFont     = FandolHei-Bold.otf,
        BoldItalicFeatures = { FakeSlant = 0.167 }
      }
    \__ecut_set_cjk_font_fang:nn { FandolFang-Regular.otf }
      {
        AutoFakeBold  = 4,
        AutoFakeSlant = 0.167
      }
    \__ecut_set_cjk_font_kai:nn { FandolKai-Regular.otf }
      {
        AutoFakeBold  = 4,
        AutoFakeSlant = 0.167
      }
  }

% overleaf 调用目录字体需要使用文件名
\cs_new_protected:Npn \__ecut_set_cjk_font_overleaf:
  {
    \__ecut_set_cjk_font_song:nn { simsun.ttc }
      { AutoFakeBold = 4 , AutoFakeSlant = 0.167 }
    \__ecut_set_cjk_font_hei:nn { simhei.ttf }
      { AutoFakeBold = 4 , AutoFakeSlant = 0.167 }
    \__ecut_set_cjk_font_fang:nn { simfang.ttf }
      { AutoFakeBold = 4 , AutoFakeSlant = 0.167 }
    \__ecut_set_cjk_font_kai:nn { simkai.ttf }
      { AutoFakeBold = 4 , AutoFakeSlant = 0.167 }
  }

\cs_new_protected:Npn \__ecut_set_cjk_font_none: {}

% 数学字体
\cs_new_protected:Npn \__ecut_set_math_font_xits:
  {
    \setmathfont { XITSMath-Regular.otf }
      [ BoldFont = XITSMath-Bold.otf ]
  }

\cs_new_protected:Npn \__ecut_set_math_font_termes:
  {
    \setmathfont { texgyretermes-math.otf }
  }

\cs_new_protected:Npn \__ecut_set_math_font_none: {}

% 根据系统判断调用字体
\sys_if_platform_windows:TF
  {
    \keys_define:nn { ecut / style }
      {
        font      .initial:n = times,
        math-font .initial:n = xits,
        cjk-font  .initial:n = windows,
      }
  }
  {
    \file_if_exist:nTF { /System/Library/Fonts/Menlo.ttc }
    % 使用 menlo 判断 mac，来自 ctex
      {
        \keys_define:nn { ecut / style }
          {
            font      .initial:n = times,
            math-font .initial:n = xits,
            cjk-font  .initial:n = mac,
          }
      }
      {
        \keys_define:nn { ecut / style }
          {
            font      .initial:n = xits,
            math-font .initial:n = xits,
            cjk-font  .initial:n = fandol,
          }
      }
  }

% 在导言区末加载字体，不被用户配置覆盖
\AtEndPreamble
  {
    \__ecut_set_font:
    \__ecut_set_cjk_font:
    \__ecut_set_math_font:
  }

%%% ---- 数学定理样式 ----- %%%
\newtheoremstyle { ecut }
  { \c_zero_dim } { \c_zero_dim } % 上下间距
  { \songti }                     % 正文字体
  { 2 em }                        % 缩进距离
  { \heiti }                      % 标题字体
  { \hbox:n {} ： \hbox:n {} }    % 结束标记
  { \c_zero_dim }                 % 结束间隔
  {}
\theoremstyle { ecut }

\newtheorem { theorem     } { 定理 } [ section ]
\newtheorem { definition  } { 定义 } [ section ]
\newtheorem { lemma       } { 引理 } [ section ]
\newtheorem { corollary   } { 推论 } [ section ]
\newtheorem { proposition } { 性质 } [ section ]
\newtheorem { example     } { 例   } [ section ]
\newtheorem { remark      } { 注   } [ section ]

\RenewDocumentEnvironment { proof } { O { 证明 } + b }
  { \pushQED { \qed } { \heiti #1： } #2 }
  { \popQED }

\RenewDocumentCommand { \eqref } { m }
  { \textup { { \normalfont （ \ref {#1} ） \normalfont } } }
% 公式引用使用中文括号

% 清除公式上下间距
\skip_set:Nn \abovedisplayskip      { 6 pt }
\skip_set:Nn \belowdisplayskip      { 6 pt }
\skip_set:Nn \abovedisplayshortskip { 0 pt }
\skip_set:Nn \belowdisplayshortskip { 0 pt }

% 最后引入 hyperref 包
\AtEndPreamble
  {
    \RequirePackage { hyperref }
    \hypersetup { hidelinks }
    \urlstyle { rm }

    \hypersetup
      {
        pdftitle  = \g__ecut_info_title_tl,
        pdfauthor = \g__ecut_info_author_tl
      }

    \tl_set_eq:NN \figureautorefname \figurename
    \tl_set_eq:NN \tableautorefname  \tablename
  }

\cs_new_protected:Npn \__ecut_new_chapter_page:
  {
    \bool_if:NTF \g__ecut_option_twoside_bool
      { \cleardoublepage }
      { \clearpage }
  }

\cs_new_protected:Npn \__ecut_date_parse:n #1
  { \__ecut_date_parse_aux:w #1 \q_stop }
\cs_new_protected:Npn \__ecut_date_parse_aux:w #1 / #2 / #3 \q_stop 
  { #1 年 #2 月 #3 日 }
  %{ \zhdigits {#1} 年 \zhnumber {#2} 月 \zhnumber {#3} 日 }
\cs_generate_variant:Nn \__ecut_date_parse:n { V }

\tl_if_eq:NnTF \g__ecut_option_type_tl { bachelor }
  { \skip_const:Nn \c__ecut_baseline_skip { 23 pt } }
  {
    \tl_if_eq:NnTF \g__ecut_option_type_tl { opening }
      { \skip_const:Nn \c__ecut_baseline_skip { 23 pt } }
      { \skip_const:Nn \c__ecut_baseline_skip { 20 pt } }
  }
% 本科行距 23 pt，硕博行距 20 pt
\cs_new_protected:Npn \__ecut_set_baseline_skip:
  {
    \skip_set_eq:NN \baselineskip \c__ecut_baseline_skip
    \skip_zero:N    \parskip
  }

%%% ---- 文档接口 ----- %%%
\NewDocumentCommand { \ecutsetup } { m }
  { \keys_set:nn { ecut } {#1} }

\tl_new:N \g__ecut_info_clc_tl
\tl_new:N \g__ecut_info_udc_tl
\tl_new:N \g__ecut_info_secret_level_tl
\tl_new:N \g__ecut_info_school_number_tl
\tl_new:N \g__ecut_info_paper_number_tl
\tl_new:N \g__ecut_info_session_tl
\tl_new:N \g__ecut_info_category_tl
\tl_new:N \g__ecut_info_category_en_tl
\tl_new:N \g__ecut_info_title_tl
\tl_new:N \g__ecut_info_title_en_tl
\tl_new:N \g__ecut_info_author_tl
\tl_new:N \g__ecut_info_author_en_tl
\tl_new:N \g__ecut_info_student_number_tl
\tl_new:N \g__ecut_info_school_tl
\tl_new:N \g__ecut_info_subject_tl
\tl_new:N \g__ecut_info_major_tl
\tl_new:N \g__ecut_info_major_en_tl
\tl_new:N \g__ecut_info_direction_tl
\tl_new:N \g__ecut_info_direction_en_tl
\tl_new:N \g__ecut_info_date_tl
\tl_new:N \g__ecut_info_advisor_en_tl
\tl_new:N \g__ecut_info_advisor_outside_tl
\clist_new:N \g__ecut_info_advisor_clist
\clist_new:N \g__ecut_info_keywords_clist
\clist_new:N \g__ecut_info_keywords_en_clist

\keys_define:nn { ecut / info }
  {
    clc            .tl_gset:N    = \g__ecut_info_clc_tl,
    udc            .tl_gset:N    = \g__ecut_info_udc_tl,
    secret-level   .tl_gset:N    = \g__ecut_info_secret_level_tl,
    school-number  .tl_gset:N    = \g__ecut_info_school_number_tl,
    paper-number   .tl_gset:N    = \g__ecut_info_paper_number_tl,
    session        .tl_gset:N    = \g__ecut_info_session_tl,
    category       .tl_gset:N    = \g__ecut_info_category_tl,
    category*      .tl_gset:N    = \g__ecut_info_category_en_tl,
    student-number .tl_gset:N    = \g__ecut_info_student_number_tl,
    title          .tl_gset:N    = \g__ecut_info_title_tl,
    title *        .tl_gset:N    = \g__ecut_info_title_en_tl,
    author         .tl_gset:N    = \g__ecut_info_author_tl,
    author *       .tl_gset:N    = \g__ecut_info_author_en_tl,
    school         .tl_gset:N    = \g__ecut_info_school_tl,
    subject        .tl_gset:N    = \g__ecut_info_subject_tl,
    major          .tl_gset:N    = \g__ecut_info_major_tl,
    major*         .tl_gset:N    = \g__ecut_info_major_en_tl,
    direction      .tl_gset:N    = \g__ecut_info_direction_tl,
    direction*     .tl_gset:N    = \g__ecut_info_direction_en_tl,
    date           .tl_gset:N    = \g__ecut_info_date_tl,
    advisor*       .tl_gset:N    = \g__ecut_info_advisor_en_tl,
    advisor-outside .tl_gset:N   = \g__ecut_info_advisor_outside_tl,
    advisor        .clist_gset:N = \g__ecut_info_advisor_clist,
    keywords       .clist_gset:N = \g__ecut_info_keywords_clist,
    keywords *     .clist_gset:N = \g__ecut_info_keywords_en_clist,

    %school-number  .initial:n    = { 10486 },
    date           .initial:n    =
      { \int_use:N \c_sys_year_int / \int_use:N \c_sys_month_int / \int_use:N \c_sys_day_int}
  }

\tl_new:N \g__ecut_element_innovation_tl
\tl_new:N \g__ecut_element_abstract_tl
\tl_new:N \g__ecut_element_abstract_en_tl
\tl_new:N \g__ecut_element_thanks_tl
\clist_new:N \g__ecut_element_bibliography_clist
\clist_new:N \g__ecut_element_appendix_clist

\keys_define:nn { ecut / element }
  {
    innovation   .tl_gset:N    = \g__ecut_element_innovation_tl,
    abstract     .tl_gset:N    = \g__ecut_element_abstract_tl,
    abstract *   .tl_gset:N    = \g__ecut_element_abstract_en_tl,
    achievements .tl_gset:N    = \g__ecut_element_achievements_tl,
    thanks       .tl_gset:N    = \g__ecut_element_thanks_tl,
    bibliography .clist_gset:N = \g__ecut_element_bibliography_clist,
    appendix     .clist_gset:N = \g__ecut_element_appendix_clist,
  }

\tl_new:N \g__ecut_style_graphics_path_tl
\tl_new:N \g__ecut_style_bib_style_tl
\tl_new:N \g__ecut_style_cite_style_tl

\bool_new:N \g__ecut_style_bib_backend_bibtex_bool
\bool_new:N \g__ecut_style_list_of_figures_bool
\bool_new:N \g__ecut_style_list_of_tables_bool

\keys_define:nn { ecut / style }
  {
    % 图片文件路径，传给 \graphicspath
    graphics-path .tl_gset:N = \g__ecut_style_graphics_path_tl,

    % 参考文献后端
    bib-backend            .value_required:n = true,
    bib-backend            .choice:,
    bib-backend / bibtex   .code:n =
      { \bool_gset_true:N  \g__ecut_style_bib_backend_bibtex_bool },
    bib-backend / biblatex .code:n =
      { \bool_gset_false:N \g__ecut_style_bib_backend_bibtex_bool },
    bib-backend            .initial:n = bibtex,

    % 参考文献样式
    bib-style .value_required:n = true,
    bib-style .choices:nn =
      { numerical , author-year , author-year-numbered , unknown }
      { \tl_gset_eq:NN \g__ecut_style_bib_style_tl \l_keys_choice_tl },

    % 引用样式
    cite-style .value_required:n = true,
    cite-style .choices:nn =
      { numerical-super , numerical-inline , author-year , unknown }
      { \tl_gset_eq:NN \g__ecut_style_cite_style_tl \l_keys_choice_tl },

    list-of-figures         .choice:,
    list-of-figures / true  .code:n =
      { \bool_gset_true:N  \g__ecut_style_list_of_figures_bool },
    list-of-figures / false .code:n =
      { \bool_gset_false:N \g__ecut_style_list_of_figures_bool },
    list-of-figures         .default:n = true,
    list-of-figures         .initial:n = false,

    list-of-tables         .choice:,
    list-of-tables / true  .code:n =
      { \bool_gset_true:N  \g__ecut_style_list_of_tables_bool },
    list-of-tables / false .code:n =
      { \bool_gset_false:N \g__ecut_style_list_of_tables_bool },
    list-of-tables         .default:n = true,
    list-of-tables         .initial:n = false,

    fullwidth-stop         .choice:,
    fullwidth-stop / true  .code:n =
      {
        \tl_const:Nn \c__ecut_fullwidth_full_stop_tl { ． }
        \char_set_catcode_active:n { `。 }
        \char_set_active_eq:nN { `。 } \c__ecut_fullwidth_full_stop_tl
      },
    fullwidth-stop / false .code:n = {},
    fullwidth-stop         .default:n = true,
    fullwidth-stop         .initial:n = false
  }

%%% ---- 参考文献设置 ----- %%%
\clist_if_in:nVTF { doctor , master } \g__ecut_option_type_tl
  {
    \keys_define:nn { ecut / style }
      {
        bib-style  .initial:n = numerical,
        cite-style .initial:n = numerical-super
        % bib-style  .initial:n = author-year,
        % cite-style .initial:n = author-year
      }
  }
  {
    \keys_define:nn { ecut / style }
      {
        bib-style  .initial:n = numerical,
        cite-style .initial:n = numerical-super
      }
  }

\BeforeBeginEnvironment { document }
  {
    \bool_if:NTF \g__ecut_style_bib_backend_bibtex_bool
      {
        \RequirePackage [ sort & compress ] { natbib }
        \__ecut_bibtex_setup:
      }
      {
        \__ecut_biblatex_pre_setup:
        \RequirePackage [ backend = biber , doi = false ] { biblatex }
        \__ecut_biblatex_post_setup:
      }
  }

\msg_new:nnn { ecut-thesis } { cite-style 无效 }
  {
    bib-backend = bibtex 下，\\
    cite-style = #1 不能与 bib-style = #2 搭配使用！\\
    
    请更改 bib-style 或 cite-style，或使用 biblatex！
  }
\cs_new_protected:Npn \__ecut_invalid_cite_style:
  {
    \msg_warning:nnxx { ecut-thesis } { cite-style 无效 }
      { \g__ecut_style_cite_style_tl }
      { \g__ecut_style_bib_style_tl }
  }

\cs_new_protected:Npn \__ecut_bibtex_setup:
  {
    \skip_zero:N \bibsep % 参考文献间距设为 0
    \tl_if_eq:NnT \g__ecut_style_bib_style_tl { numerical }
      {
        \bibliographystyle { data / gbt7714-2005-numerical }
        % \bibliographystyle { data / gbt7714-2005-ecut-numerical }

        \NAT@numberstrue
        \clist_if_in:nVTF { numerical-super , numerical-inline }
          \g__ecut_style_cite_style_tl
          {
            \tl_if_eq:NnT \g__ecut_style_cite_style_tl { numerical-super }
              { \NAT@supertrue }
          }
          { \__ecut_invalid_cite_style: }
        \tl_set:Nn \NAT@open  { [ }
        \tl_set:Nn \NAT@close { ] }
        \tl_set:Nn \NAT@sep   { , ~ }
      }

    \clist_if_in:nVT { author-year , author-year-numbered }
      \g__ecut_style_bib_style_tl
      {
        \bibliographystyle { data / gbt7714-2005-author-year }
        \tl_if_eq:NnF \g__ecut_style_cite_style_tl { author-year }
          { \__ecut_invalid_cite_style: }
      }

    \tl_if_eq:NnT \g__ecut_option_type_tl { opening }
      { \RequirePackage [ numbib ] { tocbibind } }
  }

\cs_new_protected:Npn \__ecut_biblatex_pre_setup:
  {
    \clist_if_in:nVTF { numerical , author-year , author-year-numbered }
      \g__ecut_style_bib_style_tl
      {
        \tl_if_eq:NnTF \g__ecut_style_bib_style_tl { numerical }
          { \PassOptionsToPackage { bibstyle = gb7714-2015   } { biblatex } }
          { \PassOptionsToPackage { bibstyle = gb7714-2015ay } { biblatex } }
      }
      {
        \PassOptionsToPackage { bibstyle = \g__ecut_style_bib_style_tl }
          { biblatex }
      }
    \clist_if_in:nVTF { numerical-super , numerical-inline , author-year }
      \g__ecut_style_cite_style_tl
      {
        \tl_if_eq:NnT \g__ecut_style_cite_style_tl { numerical-inline }
          { \PassOptionsToPackage { citestyle = numeric-comp  } { biblatex } }
        \tl_if_eq:NnT \g__ecut_style_cite_style_tl { numerical-super  }
          { \PassOptionsToPackage { citestyle = gb7714-2015   } { biblatex } }
        \tl_if_eq:NnT \g__ecut_style_cite_style_tl { author-year }
          { \PassOptionsToPackage { citestyle = gb7714-2015ay } { biblatex } }
      }
      {
        \PassOptionsToPackage { citestyle = \g__ecut_style_cite_style_tl }
          { biblatex }
      }
  }

\cs_new_protected:Npn \__ecut_biblatex_post_setup:
  {
    \skip_zero:N \bibitemsep % 参考文献间距设为 0
    \clist_if_empty:NF \g__ecut_element_bibliography_clist
      { 
        \clist_map_function:NN \g__ecut_element_bibliography_clist 
          \addbibresource
      }
  }

\keys_define:nn { ecut }
  {
    info    .meta:nn = { ecut / info    } {#1},
    element .meta:nn = { ecut / element } {#1},
    style   .meta:nn = { ecut / style   } {#1}
  }

% 分散函数
\cs_new_protected:Npn \__ecut_spread_with:nn #1#2
  { \tl_map_inline:nn {#1} { ##1 #2 } \unskip }

%%% ---- 论文前言 ----- %%%
% 前言包括中英文封面、郑重声明、摘要与目录
\AtBeginDocument
  {
    \use:c { __ecut_make_front_matter_ \g__ecut_option_type_tl : }
  }

\cs_new_protected:Npn \__ecut_make_front_matter_doctor:
  {
    \__ecut_make_cover_master_doctor:
    \__ecut_make_title_en:
    \__ecut_make_statesment_master_doctor:
    \__ecut_make_authorization:
    \__ecut_make_innovation:
    \__ecut_make_contents:

    \pagestyle { plain }
    \pagenumbering { Roman }
    \__ecut_make_abstract:

    \pagenumbering { arabic }
    \__ecut_set_baseline_skip:
    \raggedbottom
    \__ecut_set_table_font:
  }

\cs_new_protected:Npn \__ecut_make_front_matter_master:
  {
    \__ecut_make_cover_master_doctor:
    \__ecut_make_statesment_master_doctor:
    \__ecut_make_authorization:
    \__ecut_make_title_en:

    \pagestyle { plain }
    \pagenumbering { Roman }
    \__ecut_make_abstract:
    \__ecut_make_contents:

    \pagenumbering { arabic }
    \__ecut_set_baseline_skip:
    \raggedbottom
    \__ecut_set_table_font:
  }

\cs_new_protected:Npn \__ecut_make_front_matter_bachelor:
  {
    \__ecut_make_cover_bachelor:
    \__ecut_make_statesment_bachelor:
    \__ecut_make_abstract:
    \__ecut_make_contents:

    \pagestyle { plain }
    \pagenumbering { arabic }
    \__ecut_set_baseline_skip:
    \raggedbottom
    \__ecut_set_table_font:
  }

\cs_new_protected:Npn \__ecut_make_front_matter_opening:
  {
    \pagestyle { plain }
    \begin { center }
      \zihao { -2 } \heiti \c__ecut_heading_tl
    \end { center }

    \__ecut_set_baseline_skip:

    \noindent
    \begin { minipage } { \textwidth }
      \__ecut_set_baseline_skip:
      毕业论文（设计）题目： \uline { \hfill \g__ecut_info_title_tl \hfill } \\
      学院： \uline { \hfill \g__ecut_info_school_tl \hfill } \hfill \hfill
      学号： \uline { \hfill \g__ecut_info_student_number_tl \hfill } \hfill
      \hfill 姓名： \uline { \hfill \g__ecut_info_author_tl \hfill }
    \end { minipage }
    \par \skip_vertical:n { 10 pt }
    \raggedbottom
    \__ecut_set_table_font:
  }
%\raggedright \arraybackslash 
\newcolumntype { J }[1] { > { \bfseries \raggedright \arraybackslash} p{#1} }
%%%% ---- 论文封面 ---- %%%%
\cs_new_protected:Npn \__ecut_make_cover_bachelor:
  {
    \pagestyle { empty }
    \__ecut_set_baseline_skip:
    \begin { center }
      \group_begin:
        \heiti \zihao { 5 } \hfill
        \begin { minipage } [ t ] { 5 cm }
          \__ecut_set_baseline_skip:
          学号 \uline
            {
              \hbox_to_wd:nn { 3 cm }
                { \hfill \g__ecut_info_student_number_tl \hfill }
            } \\
          密级 \uline
            {
              \hbox_to_wd:nn { 3 cm }
                { \hfill \g__ecut_info_secret_level_tl \hfill }
            }
        \end { minipage }
      \group_end:
      \par \skip_vertical:n { 6 em }
      { \zihao { 1 } \c__ecut_heading_tl }
      \par \skip_vertical:n { 6 em }
      \begin { minipage } [ c ] [ 6 cm ] { \textwidth }
        \skip_set:Nn \baselineskip { 32 pt }
        \centering { \heiti \zihao { 2 } \g__ecut_info_title_tl }
      \end { minipage }
      \par \skip_vertical:n { 6 em }
      \group_begin:
        \zihao { -3 }
        \begin { tabular } { p { 7 em } @ { ： \hbox:n {} } l }
          \__ecut_spread_with:nn
            {
              院 { \hbox_overlap_left:n { （ } 系 \hbox_overlap_right:n { ） } }
              名称
            }
            { \hfill } & \g__ecut_info_school_tl \\ [ 0.5 em ]
          \__ecut_spread_with:nn { 专业名称 } { \hfill }
            & \g__ecut_info_major_tl \\ [ 0.5 em ]
          \__ecut_spread_with:nn { 学生姓名 } { \hfill }
            & \g__ecut_info_author_tl \\ [ 0.5 em ]
          \__ecut_spread_with:nn { 指导教师 } { \hfill } & \clist_use:Nn
            \g__ecut_info_advisor_clist { \quad } \\ [ 0.5 em ]
        \end { tabular }
      \group_end:
      \vfill
      { \songti \zihao { -2 } \__ecut_date_parse:V { \g__ecut_info_date_tl } }
    \end { center }
    \__ecut_new_chapter_page:
  }


  \cs_new_protected:Npn \__ecut_make_cover_master_doctor:
  {
    \pagestyle { empty }
    \__ecut_set_baseline_skip:
    \begin { center }
      \begin { minipage } [ c ] [ 2.5 cm ] { \textwidth }
        \songti \bfseries \zihao { 4 } \mode_leave_vertical:
        \hbox_to_wd:nn { 2 cm } { \__ecut_spread_with:nn { 论文编号： } { \hfill } }
        \hbox_to_wd:nn { 4 cm } { \hfill \g__ecut_info_paper_number_tl \hfill }
        
      \end { minipage }
      \par \skip_vertical:n { 0.5 cm }
      \includegraphics [ width = 12.5 cm ] { data / ecut.png } % width = 5.5 cm
      \par \skip_vertical:n { 2.5 cm }
      { \kaishu \zihao { 1 } \bfseries \g__ecut_info_category_tl }
      \par \skip_vertical:n { 3 cm }
      % \begin { minipage } [ t ] [ 5 cm ] { \textwidth }
      %   \skip_set:Nn \baselineskip { 40 pt }
      %   \centering { \kaishu \zihao { 1 } \g__ecut_info_title_tl }
      % \end { minipage } \par
      \group_begin:
        \kaishu
        \zihao { 3 }
        \begin { tabular } { J{6em} @ { \quad \hbox:n {} } c @ { } m { 0pt } @ { }}
        \tl_if_eq:NnTF \g__ecut_option_type_tl { doctor }
          {
            \__ecut_spread_with:nn { 研究生姓名 } { \hfill } &
            \__ecut_spread_with:nn
              { \g__ecut_info_author_tl } { \hfill } & \\ [ 0.5 em ]
            \__ecut_spread_with:nn { 指导教师姓名、职称 } { \hfill } &
            \__ecut_spread_with:nn
              { \clist_use:Nn \g__ecut_info_advisor_clist { \quad } }
              { \hfill } & \\ [ 0.5 em ]
            \__ecut_spread_with:nn { 学科、专业名称 } { \hfill } &
            \__ecut_spread_with:nn
              { \g__ecut_info_subject_tl 、 \g__ecut_info_major_tl }
              { \hfill } & \\ [ 0.5 em ]
            \__ecut_spread_with:nn { 研究方向 } { \hfill } &
            \__ecut_spread_with:nn
              { \g__ecut_info_direction_tl } { \hfill } & \\ [ 0.5 em ]
          }
          { % 这里 硕士论文
            
            % 判断论文题目的长度是否超出给定宽度 \tl_count:N \g__ecut_info_title_tl
            \int_compare:nNnTF { \tl_count:N  \g__ecut_info_title_tl } > { 15 }
              {
                \__ecut_spread_with:nn { 论文题目 } { \hfill } &
                { \tl_range:Nnn \g__ecut_info_title_tl {1}{15} } & \\ \cline{2-2}
                \\ [ -1 em ]
                \__ecut_spread_with:nn { } { \hfill } &
                { \tl_range:Nnn \g__ecut_info_title_tl {16}{-1} } & \\ \cline{2-2}
              }
              {
                \__ecut_spread_with:nn { 论文题目 } { \hfill } &
                { \g__ecut_info_title_tl } & \\ \cline{2-2}
              }
            \\ [ -1 em ]
            %\__ecut_spread_with:nn { \bfseries  } { \hfill } & \\ \cline{2-2}
            \__ecut_spread_with:nn { 学位申请人 } { \hfill } &
            { \g__ecut_info_author_tl } & \\ \cline{2-2}
            \\ [ -1 em ]
            \__ecut_spread_with:nn { 专业领域 } { \hfill } &
            { \g__ecut_info_major_tl } & \\ \cline{2-2}
            \\ [ -1 em ]
            \tl_if_eq:NnTF \g__ecut_option_class_tl { professional }
              {
                \__ecut_spread_with:nn { 研究方向 } { \hfill } &
                { \g__ecut_info_direction_tl } & \\ \cline{2-2}
                \\ [ -1 em ]
                \__ecut_spread_with:nn { 校内导师 } { \hfill } &
                { \clist_item:Nn \g__ecut_info_advisor_clist {1} } & \\ \cline{2-2}
                \\ [ -1 em ]
                \__ecut_spread_with:nn { 校外导师 } { \hfill } &
                { \g__ecut_info_advisor_outside_tl } & \\ \cline{2-2}
                \\ [ -1 em ]
              }
              {
                \__ecut_spread_with:nn { 专业类别 { （领 } { 域） } } { \hfill }
                & \g__ecut_info_major_tl & \\ [ 0.5 em ]
              }
          }
        \end { tabular }
      \group_end:
      \par \vfill
      { \kaishu \bfseries \zihao { 4 } \__ecut_date_parse:V { \g__ecut_info_date_tl } }
    \end { center }
    \__ecut_new_chapter_page:
  }

%%%% ---- 英文标题 ---- %%%%
\cs_new_protected:Npn \__ecut_make_title_en:
  {
    \__ecut_new_chapter_page:
    \pagestyle { empty }
    \__ecut_set_baseline_skip:
    \begin { center }
      \skip_vertical:n { 1.5 cm }
      \includegraphics [ width = 12.5 cm ] { data / ecut.png } % width = 5.5 cm
      \par \skip_vertical:n { 1.5 cm }
      { \zihao { 1 } \bfseries \g__ecut_info_category_en_tl }
    \end { center }
    \par \skip_vertical:n { 2 cm }

    \group_begin:
      \zihao{3} \setlength{\parindent}{0pt} \skip_set:Nn \baselineskip { 36 pt } 
      THESIS: \quad \g__ecut_info_title_en_tl \par
      SPECIALIZATION: \qquad \g__ecut_info_major_en_tl \par
      RESEARCH DIRECTION: \qquad \g__ecut_info_direction_en_tl \par
      POSTGRADUATE: \qquad \g__ecut_info_author_en_tl \par
      MENTOR: \qquad \g__ecut_info_advisor_en_tl\par
    \group_end:
    \vfill
    \begin { center }
      \zihao { 4 } \g__ecut_info_date_tl
    \end { center }
    \__ecut_new_chapter_page:
  }

%%%% ---- 郑重声明 ---- %%%%
\cs_new_protected:Npn \__ecut_make_statesment_bachelor:
  {
    \__ecut_new_chapter_page:
    \mode_leave_vertical: \skip_vertical:n { 44 pt }
    \noindent \hfil { \zihao { 2 } \textbf { \__ecut_spread_with:nn
      { 郑重声明 } { \enskip } } }
    \par \skip_vertical:n { 20 pt }
    \group_begin:
      \zihao { 4 }
      本人呈交的学位论文，是在导师的指导下，独立进行研究工作所取得的成果，所有数
      据、图片资料真实可靠。尽我所知，除文中已经注明引用的内容外，本学位论文的研
      究成果不包含他人享有著作权的内容。对本论文所涉及的研究工作做出贡献的其他个
      人和集体，均已在文中以明确的方式标明。本学位论文的知识产权归属于培养单位。
      \par \skip_vertical:n { 88 pt }
      本人签名： \uline { \hbox_to_wd:nn { 4 cm } {} }
      \hfill 日期： \uline { \hbox_to_wd:nn { 4 cm } {} }
    \group_end:
    \__ecut_new_chapter_page:
  }

\cs_new_protected:Npn \__ecut_make_statesment_master_doctor:
  {
    \__ecut_new_chapter_page:
    %\mode_leave_vertical: \skip_vertical:n { 2 \baselineskip }
    \noindent \hfil { \zihao { -2 } \songti \bfseries 独创性声明 }
    \par \skip_vertical:n { 1 \baselineskip }
    \group_begin:
      \zihao { 4 } \skip_set:Nn \baselineskip { 32 pt } % 28pt
      \tl_if_eq:NnTF \g__ecut_option_type_tl { doctor }
        {
          本人郑重声明：所呈交的学位论文，是本人在导师指导下，独立进行研究工作所
          取得的研究成果。除文中已经标明引用的内容外，本论文不包含任何其他个人或
          集体已发表或撰写的研究成果。对本文的研究做出贡献的个人和集体，均已在文
          中以明确方式标明。本声明的法律结果由本人承担。
        }
        {
          本人声明所呈交的学位论文是本人在导师指导下进行的研究工作及取得的研究成果，尽我所知，除了文中特别加以标注和致谢的地方外，论文中不包含其他人已经发表或撰写过的研究成果，也不包含本人为获得其它教育机构的学位或证书而使用过的材料。与我一同工作的同志对本研究所做的任何贡献均已在论文中作了明确的说明并表示感谢。
        }
      \par \skip_vertical:N \baselineskip
      作者签名：\uline{ \hbox_to_wd:nn { 3 cm } {}} \hbox_to_wd:nn { 1.5 cm } {} % \hfill  \rule{3cm}{0.4pt}
      %\par \skip_vertical:N \baselineskip
        日期：\hbox_to_wd:nn { 2 cm } {} 年 \qquad 月 \qquad 日
    \group_end:

    \mode_leave_vertical: \skip_vertical:n { 4 \baselineskip }
    \noindent \hfil { \zihao { -2 } \songti \bfseries 承\ 诺\ 书 }
    \par \skip_vertical:n { 1 \baselineskip }
    \group_begin:
      \zihao { 4 } \skip_set:Nn \baselineskip { 32 pt } % 28pt
      \tl_if_eq:NnTF \g__ecut_option_type_tl { doctor }
        {
          
        }
        {
          本人郑重承诺: \par
          我撰写的论文 “ \uline{ \hbox_to_wd:nn { 11 cm } {}} ” \\
          是在指导教师指导下独立完成的，不存在学术不端行为。论文写作过程中不存在学位论文作假行为（购买、出售学位论文或者组织学位论文买卖的; 由他人代写、为他人代写学位论文或者组织学位论文代写的;剽窃他人作品和学术成果的;伪造数据的;有其他严重学位论文作假行为的）。我的学位论文如果存在学位论文作假行为、存在学术不端行为，愿意承担一切责任。 
        }
      \par 
      \setlength\parindent{20em}承诺人：\par%\hbox_to_wd:nn { 5 cm } {} % 
      \skip_vertical:n { 0.5 \baselineskip }

      年 \qquad 月 \qquad 日
    \group_end:

    %\__ecut_new_chapter_page:
  }

%%%% ---- 使用授权书 ---- %%%%
\cs_new_protected:Npn \__ecut_make_authorization:
  {
    %\__ecut_new_chapter_page:
    \newpage
    %\mode_leave_vertical: \skip_vertical:N \baselineskip
    \noindent \hfil
    { \zihao { -2 } \songti \bfseries { 关于学位论文使用授权的说明 } }
    \par \skip_vertical:n { 1 \baselineskip }
    \group_begin:
      \zihao { -3 } \songti \skip_set:Nn \baselineskip { 32 pt }
      本学位论文作者完全了解东华理工大学有关保留、使用学位论文的规定：东华理工大学有权保留并向国家有关部门或机构送交论文的复印件和磁盘，允许论文被查阅和借阅，可以将学位论文的全部或部分内容编入有关数据库进行检索，可以采用影印、缩印或扫描等复制手段保存、汇编学位论文，并且本人电子文档的内容和纸质论文的内容相一致。\par
      保密的学位论文在解密后也遵守此规定。 \par
      
      \par \skip_vertical:n { 2 \baselineskip }
        
      作者签名： \uline {  \hbox_to_wd:nn { 5 cm } {} } 
      \par \skip_vertical:n { 1 \baselineskip }
      日期： \qquad \qquad 年 \qquad 月 \qquad 日 \par
      \par \skip_vertical:n { 2 \baselineskip }

      导师签名： \uline {  \hbox_to_wd:nn { 5 cm } {} } 
      \par \skip_vertical:n { 1 \baselineskip }
      日期： \qquad \qquad 年 \qquad 月 \qquad 日 \par
      \par \skip_vertical:n { 2 \baselineskip }
      
      论文答辩日期： \qquad \qquad 年 \qquad 月 \qquad 日
    \group_end:
    \__ecut_new_chapter_page:
  }

%%% ---- 创新 ----- %%%
\cs_new_protected:Npn \__ecut_make_innovation:
  {
    \tl_if_empty:NF \g__ecut_element_innovation_tl
      {
        \chapter * { 博士生自认为的论文创新点 }
        \thispagestyle { empty }
        \file_input:V \g__ecut_element_innovation_tl
      }
    \__ecut_new_chapter_page:
  }

%%% ---- 目录 ----- %%%
\cs_new_protected:Npn \__ecut_make_contents:
  {
    \__ecut_new_chapter_page:
    \tableofcontents
    \addcontentsline { toc } { chapter } { \contentsname } % 将目录页本身加入到目录中
    \__ecut_new_chapter_page:

    \bool_if:NT \g__ecut_style_list_of_figures_bool
      {
        \listoffigures
        %\listoffigureEnges % 中英文图表标题分开制作目录
        \addcontentsline { toc } { chapter } { \listfigurename } % 将图目录的位置信息加入到主目录中
        
        \__ecut_new_chapter_page:
        
      }

    \bool_if:NT \g__ecut_style_list_of_tables_bool
      {
        %\renewcommand{\cleardoublepage}{}
        %\renewcommand{\clearpage}{}
        \listoftables
        %\listoftableEnges % 中英文图表标题分开制作目录
        \addcontentsline { toc } { chapter } { \listtablename }
        \__ecut_new_chapter_page:
      }
  }

%%% ---- 摘要 ----- %%%
% 关键词悬挂
\box_new:N \l__ecut_keywords_box
\cs_new_protected:Npn \__ecut_put_keywords:nn #1#2
  {
    \hbox_set:Nn \l__ecut_keywords_box {#1}
    \noindent \hangindent \box_wd:N \l__ecut_keywords_box \hangafter 1
    \box_use_drop:N \l__ecut_keywords_box #2 \par
  }

\newcommand{\longunderline}[1]{\uline{#1\hfill\mbox{}}}
% 生成摘要
\cs_new_protected:Npn \__ecut_make_abstract:
  {
    % 中文摘要
    \tl_if_empty:NF \g__ecut_element_abstract_tl
      {
        \noindent \hfil
        { \kaishu \zihao{3} \bfseries \uline{\uline{东华理工大学硕士学位论文中文摘要首页用纸}} } \par
        \group_begin:
          \kaishu \zihao{4} \setlength{\parindent}{0pt} \skip_set:Nn \baselineskip { 32 pt } 
          毕业论文题目： \longunderline{ \quad \g__ecut_info_title_tl}  \par
          \uline {  \quad \g__ecut_info_major_tl \quad } 专业 \uline { \quad \g__ecut_info_session_tl \quad }级硕士生姓名：\longunderline{ \qquad \g__ecut_info_author_tl } \par 
          指导教师（姓名、职称）：\longunderline{ \quad \clist_use:Nn \g__ecut_info_advisor_clist { \quad } } \par
        \group_end:

        \group_begin:
          \renewcommand{\cleardoublepage}{} % 消除 Abstract 章另起一页的操作
          \renewcommand{\clearpage}{}
          \chapter * { 摘要 }
          \phantomsection \markboth{摘要}{} % \markboth 用于指定该章页眉显示的内容
          \clist_map_inline:nn { doctor , master }
            {
              \tl_if_eq:NnT \g__ecut_option_type_tl {##1}
                { \addcontentsline { toc } { chapter } { 摘要 } } % 把该章加入到目录中去
            }
          \tl_if_eq:NnT \g__ecut_option_type_tl { bachelor }
            { \thispagestyle { empty } }
          \__ecut_set_baseline_skip:

          \file_input:V \g__ecut_element_abstract_tl

          \skip_vertical:N \c__ecut_baseline_skip \par
          \__ecut_put_keywords:nn
            { \heiti \zihao { -4 } 关键词：\hbox:n {} }
            { \clist_use:Nn \g__ecut_info_keywords_clist { ； } }
        \group_end:
      }
    \__ecut_new_chapter_page:
    % 英文摘要
    \tl_if_empty:NF \g__ecut_element_abstract_en_tl
      {
        \noindent \hfil
        { \kaishu \zihao{3} \bfseries \uline{\uline{东华理工大学硕士学位论文英文摘要首页用纸}} } \par
        \group_begin:
          \zihao{4} \setlength{\parindent}{0pt} \skip_set:Nn \baselineskip { 32 pt } 
          THESIS: \quad \g__ecut_info_title_en_tl \par
          SPECIALIZATION: \qquad \g__ecut_info_major_en_tl \par 
          POSTGRADUATE: \qquad \g__ecut_info_author_en_tl \par
          MENTOR: \qquad \g__ecut_info_advisor_en_tl\par
        \group_end:
        \group_begin:
          \renewcommand{\cleardoublepage}{}
          \renewcommand{\clearpage}{}
          \chapter * { ABSTRACT }
          \phantomsection \markboth{ABSTRACT}{}
          \clist_map_inline:nn { doctor , master }
            {
              \tl_if_eq:NnT \g__ecut_option_type_tl {##1}
                { \addcontentsline { toc } { chapter } { ABSTRACT } }
            }
          \tl_if_eq:NnT \g__ecut_option_type_tl { bachelor }
            { \thispagestyle { empty } }
          \__ecut_set_baseline_skip:
          \file_input:V \g__ecut_element_abstract_en_tl
          \skip_vertical:N \c__ecut_baseline_skip \par
          \__ecut_put_keywords:nn
            { \bfseries \zihao { -4 } Key ~ words: ~ }
            { \clist_use:Nn \g__ecut_info_keywords_en_clist { ; ~ } }
        \group_end:
      }
    \__ecut_new_chapter_page:
  }

%%%% ---- 论文结语 ---- %%%%
% 结语包括参考文献、致谢与附录
\AtEndDocument
  {
    \use:c { __ecut_make_back_matter_ \g__ecut_option_type_tl : }
  }

\cs_new_protected:Npn \__ecut_make_back_matter_doctor:
  {
    \__ecut_make_bibliography:
    \__ecut_make_achievements:
    \__ecut_make_thanks:
    \__ecut_make_appendix:
    \__ecut_make_spine:
  }

\cs_new_protected:Npn \__ecut_make_back_matter_master:
  {
    \__ecut_make_thanks:
    \__ecut_make_achievements:
    \__ecut_make_bibliography:
    \__ecut_make_appendix:
  }

\cs_new_protected:Npn \__ecut_make_back_matter_bachelor:
  {
    \__ecut_make_bibliography:
    \__ecut_make_thanks:
    \__ecut_make_appendix:
  }

\cs_new_protected:Npn \__ecut_make_back_matter_opening:
  {
    \__ecut_make_bibliography:

    \skip_vertical:n { 2 \c__ecut_baseline_skip }
    \needspace { 0.3 \textheight }
    指导老师意见：
    \vfill
    \hfill 指导老师（签名）： \hbox_to_wd:nn { 4 cm } {} \par
    \skip_vertical:N \c__ecut_baseline_skip
    \hfill 年 \qquad 月 \qquad 日
  }

%%%% ---- 参考文献 ---- %%%%
\cs_new_protected:Npn \__ecut_make_bibliography:
  {
    \clist_if_empty:NF \g__ecut_element_bibliography_clist
      {
        \tl_if_eq:NnTF \g__ecut_option_type_tl { opening }
          {
            \bool_if:NTF \g__ecut_style_bib_backend_bibtex_bool
              {
                \tl_if_eq:NnT \g__ecut_style_bib_style_tl
                  { author-year-numbered }
                  { \setcitestyle { numbers } }
                \exp_args:NV \bibliography \g__ecut_element_bibliography_clist
              }
              {
                \tl_if_eq:NnTF \g__ecut_style_bib_style_tl
                  { author-year-numbered }
                  {
                    \printbibliography
                      [ heading = bibnumbered , env = numerical ]
                  }
                  { \printbibliography [ heading = bibnumbered ] }
              }
          }
          {
            \__ecut_new_chapter_page:
            %\chapter * { 参考文献 }
            \phantomsection
            \addcontentsline { toc } { chapter } { 参考文献 }
            \bool_if:NTF \g__ecut_style_bib_backend_bibtex_bool
              {
                \tl_if_eq:NnT \g__ecut_style_bib_style_tl
                  { author-year-numbered }
                  { \setcitestyle { numbers } }
                \exp_args:NV \bibliography \g__ecut_element_bibliography_clist
              }
              {
                \tl_if_eq:NnTF \g__ecut_style_bib_style_tl
                  { author-year-numbered }
                  { \printbibliography [ env = numerical ] }
                  { \printbibliography }
              }
          }
      }
  }

%%%% ---- 攻博期间发表的科研成果目录 ---- %%%%
\cs_new_protected:Npn \__ecut_make_achievements:
  {
    \tl_if_empty:NF \g__ecut_element_achievements_tl
      {
        \chapter * { 在攻读学位期间取得的科研成果 }
        \phantomsection \markboth{在攻读学位期间取得的科研成果}{} % 
        \addcontentsline { toc } { chapter } { 在攻读学位期间取得的科研成果 }
        \tl_if_eq:NnTF \g__ecut_style_bib_style_tl { author-year }
          {
            \begin { enumerate } [ label = {} , left = 0 pt .. 0 pt ]
              \file_input:V \g__ecut_element_achievements_tl
            \end { enumerate }
          }
          {
            \begin { enumerate } [ label = { [ } \arabic* { ] } ]
              \file_input:V \g__ecut_element_achievements_tl
            \end { enumerate }
          }
      }
  }

%%%% ---- 致谢 ---- %%%%
\cs_new_protected:Npn \__ecut_make_thanks:
  {
    \tl_if_empty:NF \g__ecut_element_thanks_tl
      {
        \chapter * { 致谢 }
        \phantomsection \markboth{致谢}{}
        \addcontentsline { toc } { chapter } { 致谢 }
        \file_input:V \g__ecut_element_thanks_tl
      }
  }

%%%% ---- 附录 ---- %%%%
\cs_new_protected:Npn \__ecut_make_appendix:
  {
    \clist_if_empty:NF \g__ecut_element_appendix_clist
      {
        \appendix
        \clist_map_function:NN \g__ecut_element_appendix_clist \file_input:n
      }
  }

%%%% ---- 书脊 ---- %%%%
\cs_new_protected:Npn \__ecut_make_spine:
  {
    \file_if_exist:nF { \c_sys_jobname_str - spine.pdf }
      {
        \iow_new:N \g__ecut_spine_iow
        \iow_open:Nn \g__ecut_spine_iow { \c_sys_jobname_str - spine.tex }
        \iow_now:Nx \g__ecut_spine_iow
          {
            \tl_to_str:n
              {
                \documentclass { ltjtarticle }
                \usepackage { ctexsize }
                \usepackage { geometry }
                \geometry { margin = 2.5 cm , ignoreall }
                \usepackage { luatexja-fontspec }
                \ExplSyntaxOn
              }
            \__ecut_set_spine_font:
            \tl_to_str:n
              {
                \begin { document }
                \pagestyle { empty } 
                \mode_leave_vertical: \vfil \noindent
              }
            \tl_to_str:n { \zihao { 4 } } \exp_not:o \g__ecut_head_odd_tl
            \tl_to_str:n { \hfill } \exp_not:o \g__ecut_info_author_tl
            \tl_to_str:n { \end { document } }
          }
        \iow_close:N \g__ecut_spine_iow
        \__ecut_compile_spine:
      }
  }

\cs_new_protected:Npn \__ecut_compile_spine:
  {
    \sys_shell_now:x { lualatex ~ \c_sys_jobname_str - spine }
    \sys_shell_now:x { latexmk ~ -c ~ \c_sys_jobname_str - spine }
    \sys_if_platform_windows:TF
      { \sys_shell_now:x { del ~ \c_sys_jobname_str - spine.tex } }
      { \sys_shell_now:x { rm ~ \c_sys_jobname_str - spine.tex } }
  }