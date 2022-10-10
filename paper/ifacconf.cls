%%
%% This is file `ifacconf.cls',
%% generated with the docstrip utility.
%%
%% The original source files were:
%%
%% pergamon.dtx  (with options: `oxford,ifacmtg,cep,uppercasesection,uppercasetitle,specialfront')
%% 
%% IMPORTANT NOTICE:
%% 
%% For the copyright see the source file.
%% 
%% You are *not* allowed to modify this file.
%% 
%% You are *not* allowed to distribute this file.
%% For distribution of the original source see the terms
%% for copying and modification in the file pergamon.dtx.
%% 
\def\filedate{2008/04/14}
\def\fileversion{3.2ModD}
\def\@journal{IFAC conferences}
\def\@shortjnl{ifacconf}
\def\@issn{}
\def\@shortjid{ifacconf}
\def\@company{IFAC}
\NeedsTeXFormat{LaTeX2e}[1995/12/01]
\ProvidesClass{\@shortjid}
[\filedate, \fileversion: \@journal]
\DeclareOption{a4paper}
   {\setlength\paperheight {297mm}%
    \setlength\paperwidth  {210mm}}
\DeclareOption{letterpaper}
   {\setlength\paperheight {11in}%
    \setlength\paperwidth  {8.5in}}
\ExecuteOptions{a4paper}
\ProcessOptions
%%
%% This is file `public.cls',
%% generated with the docstrip utility.
%%
%% The original source files were:
%%
%% esl.dtx  (with options: `package,bare,pergamon,PUBLIC,SL5,TWOCOL,QUOTEABS,MCS,NOTEFIRSTPAGE')
%% 
%% IMPORTANT NOTICE:
%% 
%% For the copyright see the source file.
%% 
%% You are *not* allowed to modify this file.
%% 
%% You are *not* allowed to distribute this file.
%% For distribution of the original source see the terms
%% for copying and modification in the file esl.dtx.
%% 
\def\esp@fileversion{2.16}
\def\esp@filedate{1998/12/16}
%% esl.dtx Copyright (C) 1994-1998 Elsevier Science
\def\@shortjnl{\relax}
%% \typeout{}
%% \typeout{}
%% \typeout{** IMPORTANT NOTICE:}
%% \typeout{** This is modified version on ifacmtg.cls}
%% \typeout{** All future IFAC meetings must use this class}
%% \typeout{** to prepare papers for Elsevier.}
%% \typeout{** Original notice: The TeX code in this package}
%% \typeout{** is NOT being placed in the public domain.}
%% \typeout{** Copyright 1995 Elsevier Science Ltd}
%% \typeout{}
\typeout{}

\newif\if@TwoColumn
\newif\if@seceqn
\newif\if@secthm
\newif\if@nameyear
\newif\if@Elproofing
\@Elproofingfalse
\def\@pagenumprefix{}
\def\author@font{}
\def\partname{Part}
\def\appendixname{Appendix}
\def\contentsname{Contents}
\def\listfigurename{List of Figures}
\def\listtablename{List of Tables}
\def\refname{References}
\def\indexname{Index}
\def\figurename{Fig.}
\def\tablename{Table}
\def\abstractname{}
\lineskip 1\p@
\normallineskip 1\p@
\def\baselinestretch{1}
\frenchspacing
\def\@xiiipt{12}
\newdimen\@frontmatterwidth
\def\@overtitleskip{0\p@}  % WAS 69 PMISRA
\def\@overhistoryskip{\z@}
\def\@undertitleskip{\z@}
\def\@overkeywordskip{6\p@}  % WAS 12 PMISRA 2007-05-30
\def\@overabstractskip{6\p@}
\def\@overcaptionskip{8\p@}
\def\@preabstractskip{4\p@ \@plus 2\p@ \@minus 2\p@} %WAS 24 PMISRA
\def\@belowfmskip{6\p@}  % WAS 12 PMISRA 2007-05-30
\def\@bibliosize{\small}
\def\@historysize{\small}
\def\@keywordsize{\small}
\def\@overaddressskip{2pt}
\def\@titlesize{\Large}
\def\@authorsize{\large}
\def\@keywordheading{{\it Key words: \ }}
\def\@addressstyle{\small\itshape}
\def\@captionsize{\small}
\def\@tablecaptionsize{\@captionsize}
\def\@figurecaptionsize{\@captionsize}
\def\captionwidth{.8\linewidth}
\def\@tablesize{\small}
\def\@keywordwidth{.8\textwidth}
\def\@abstractwidth{.8\textwidth}
\def\@fignumfont#1{#1}
% SP 2001/08/07 subsections with italic numbers
\def\@secnumfont#1{\ifcase#1\upshape\or\upshape\else\itshape\fi}
\def\@catchlinesize{\footnotesize}
\def\@pergamonsize{\@catchlinesize}
\def\@runheadsize{\normalsize}
\def\etal{et al.}
\def\AND{\&}
\def\@Colofonheight{1cm}
%% \def\@abstractsize{\fontsize{\@ixpt}{11pt}\selectfont}
%% \def\@articletypesize{\fontsize{\@xiiipt}{13pt}\selectfont}
%% \def\normalsize{\@setfontsize\normalsize\@xpt{12}%
%% \abovedisplayskip 5.75\p@ \@plus 2\p@ \@minus 2\p@%
%% \belowdisplayskip \abovedisplayskip
%% \abovedisplayshortskip \z@ \@plus 2\p@%
%% \belowdisplayshortskip 3.5\p@ \@plus 2\p@ \@minus 2\p@
%% \let\@listi\@listI}
%% \def\small{\@setfontsize\small\@viiipt{10}%
%% \abovedisplayskip 7\p@ \@plus 2\p@ \@minus 4\p@%
%% \belowdisplayskip \abovedisplayskip
%% \abovedisplayshortskip \z@ \@plus 1\p@%
%% \belowdisplayshortskip 3\p@ \@plus 1\p@ \@minus 2\p@
%% \def\@listi{\topsep 0.5\@bls \parsep\z@ \itemsep\parsep}}
%% \let\footnotesize=\small
%% \let\@xviiipt\@xviipt
%% \def\scriptsize{\@setfontsize\scriptsize\@viipt{8}}
%% \def\tiny{\@setfontsize\tiny\@vipt{7}}
%% \def\large{\@setfontsize\large\@xiiipt{14}}
%% \def\Large{\@setfontsize\Large\@xviipt{20}}
%% \def\LARGE{\@setfontsize\LARGE\@xviiipt{22}}
%% \def\huge{\@setfontsize\huge\@xxpt{22}}
%% \def\Huge{\@setfontsize\Huge\@xxvpt{27}}
%% \def\baselinestretch{1}
%% \normalsize                                % Choose the normalsize font.

\def\@abstractsize{\fontsize{\@ixpt}{10pt}\selectfont}
\def\@articletypesize{\fontsize{\@xiiipt}{13pt}\selectfont}
\def\normalsize{\@setfontsize\normalsize\@xpt{10}%
\abovedisplayskip 3\p@ \@plus 1\p@ \@minus 1\p@%
\belowdisplayskip \abovedisplayskip
\abovedisplayshortskip \z@ \@plus 2\p@%
\belowdisplayshortskip 2\p@ \@plus 1\p@ \@minus 1\p@
\let\@listi\@listI}
\def\small{\@setfontsize\small\@viiipt{9}%
\abovedisplayskip 4\p@ \@plus 1\p@ \@minus 1\p@%
\belowdisplayskip \abovedisplayskip
\abovedisplayshortskip \z@ \@plus 1\p@%
\belowdisplayshortskip 3\p@ \@plus 1\p@ \@minus 1\p@
\def\@listi{\topsep 0.5\@bls \parsep\z@ \itemsep\parsep}}
\let\footnotesize=\small
\let\@xviiipt\@xviipt
\def\scriptsize{\@setfontsize\scriptsize\@viipt{8}}
\def\tiny{\@setfontsize\tiny\@vipt{7}}
\def\large{\@setfontsize\large\@xiiipt{14}}
\def\Large{\@setfontsize\Large\@xviipt{20}}
\def\LARGE{\@setfontsize\LARGE\@xviiipt{22}}
\def\huge{\@setfontsize\huge\@xxpt{22}}
\def\Huge{\@setfontsize\Huge\@xxvpt{27}}
\def\baselinestretch{1.1}
\normalsize                                % Choose the normalsize font.

\newdimen\@bls                              % Several dimensions are
\@bls=\baselineskip                         % expressed in terms of this.
%\if@twoside
%   \oddsidemargin    \z@		% Commented out 2007-05-30 PMISRA
%   \evensidemargin   \z@		% Commented out 2007-05-30 PMISRA
%   \marginparwidth  10\p@		% Commented out 2007-05-30 PMISRA
%\else					% Commented out 2007-05-30 PMISRA
%   \oddsidemargin    \z@		% Commented out 2007-05-30 PMISRA
%   \evensidemargin   \z@		% Commented out 2007-05-30 PMISRA
%   \marginparwidth   2pc		% Commented out 2007-05-30 PMISRA
%\fi

\if@twoside                 % Values for two-sided printing:             % Added
   \oddsidemargin   -11mm    %   Left margin on odd-numbered pages.       % by PMISRA
   \evensidemargin  -11mm    %   Left margin on even-numbered pages.      % 2007-05-30
   \marginparwidth  1pc     %   \@Width of marginal notes.               %
\else                       % Values for one-sided printing:             %
   \oddsidemargin   -11mm    %   Left margin on odd-numbered pages.       %
   \evensidemargin  -11mm    %   Left margin on even-numbered pages.      %
   \marginparwidth  1pc
\fi

\marginparsep 10\p@		% Horizontal space between outer margin and WAS 20 PMISRA
				% marginal note
\topmargin 2mm			%    Nominal distance from top of page to top of
				%    box containing running head.
\headheight 10\p@		%
 \headsep    20\p@  %
 \footskip 10\p@		% Changed to 10 from 23 PMISRA 2007-05-30
\bigskipamount=\@bls \@plus 0.3\@bls \@minus 0.3\@bls % 1/1 line
\medskipamount=0.5\bigskipamount                  % 1/2 line
\smallskipamount=0.25\bigskipamount               % 1/4 line
\textheight 54\baselineskip  % \@Height of text (incl. footnotes and figures,
\advance\textheight\topskip  % excl. running head and foot).
\textwidth 180mm              % \@Width of text line.
                             % For two-column mode:
\columnsep 5mm               %   Space between columns
\columnseprule \z@           %   \@Width of rule between columns.
 \footnotesep 6.65\p@
\skip\footins 6\p@ \@plus  8\p@          % Space between last line of text and % was 12 PMISRA 2007-05-30
                                      % top of first footnote.
\floatsep 8\p@ \@plus 4\p@ \@minus 2\p@ % Space between adjacent floats moved
                                         % to top or bottom of text page.
\textfloatsep 8\p@ \@plus 4\p@ \@minus 2\p@ % Space between main text and floats
                                         % at top or bottom of page.
\intextsep 8\p@ \@plus 4\p@ \@minus 2\p@ % Space between in-text figures and
                                         % text.
\dblfloatsep      8\p@ \@plus 4\p@ \@minus 4\p@ % Same as \floatsep for double-column
                                         % figures in two-column mode.
\dbltextfloatsep 12\p@ \@plus 4\p@ \@minus 4\p@ % \textfloatsep for double-column
                                         % floats.
\@fptop \z@ \@plus 1fil    % Stretch at top of float page/column. (Must be
                         % \z@ \@plus ...)
\@fpsep 8\p@ \@plus 2fil    % Space between floats on float page/column.
\@fpbot \z@ \@plus 1fil    % Stretch at bottom of float page/column. (Must be
                         % \z@ \@plus ... )
\@dblfptop \z@ \@plus 1fil % Stretch at top of float page. (Must be \z@ \@plus ...)
\@dblfpsep 8\p@ \@plus 2fil % Space between floats on float page.
\@dblfpbot \z@ \@plus 1fil % Stretch at bottom of float page. (Must be
                         % \z@ \@plus ... )
\marginparpush 5\p@       % Minimum vertical separation between two marginal
                         % notes.
\parskip \z@
\parindent 1em
\newskip\eqntopsep                    % Extra vertical space, in addition to
 \eqntopsep 4\p@ \@plus 2\p@ \@minus 2\p@ %\parskip, added above and below  % WAS 8 PMISRA 2007-05-30
\newdimen\eqnarraycolsep            % Half the space between columns
\eqnarraycolsep 1\p@                 % in an \eqnarray.
\@lowpenalty   51      % Produced by \nopagebreak[1] or \nolinebreak[1]
\@medpenalty  151      % Produced by \nopagebreak[2] or \nolinebreak[2]
\@highpenalty 301      % Produced by \nopagebreak[3] or \nolinebreak[3]
\@beginparpenalty -\@lowpenalty    % Before a list or paragraph environment.
\@endparpenalty   -\@lowpenalty    % After a list or paragraph environment.
\@itempenalty     -\@lowpenalty    % Between list items.
\def\part{\@startsection{part}{1}{\z@}{0.8\@bls \@plus
  0.4\@bls}{\@bls}{\normalsize}}
\def\partmark#1{}
\def\section{\@startsection{section}{1}{\z@}{0.5\@bls
   \@plus .2\@bls \@minus .1\@bls}{0.5\@bls}{\normalsize\bfseries
 \boldmath}}								% WAS 1.8\@bls PMISRA 2007-05-30
\def\subsection{\@startsection{subsection}{2}{\z@}{0.3\@bls
  \@plus .2\@bls \@minus .1\@bls}{0.3\@bls}{\normalsize\itshape}}		% WAS \@bls and .3\@bls PMISRA 2007-05-30
\def\subsubsection{\@startsection{subsubsection}{3}{\z@}{0.3\@bls
  \@plus .1\@bls}{0.0001pt}{\normalsize\itshape}}			% WAS \@bls PMISRA 2007-05-30 
\def\paragraph{\@startsection{paragraph}{4}{\z@}{3.25ex \@plus
  2ex \@minus 0.2ex}{-1em}{\normalfont\normalsize\itshape}}
\def\subparagraph{\@startsection{subparagraph}{5}{1em}{3.25ex \@plus
  2ex \@minus 0.2ex}{-1em}{\normalfont\normalsize\itshape}}
\setcounter{secnumdepth}{4}
\def\half@em{\hskip 0.5em}
\def\lb@part{PART \thepart.\half@em}
  \def\lb@empty@part{PART \thepart}
\def\lb@section{\thesection.\half@em}
  \def\lb@empty@section{\thesection}
\def\lb@subsection{\thesubsection.\half@em}
  \def\lb@empty@subsection{\thesubsection}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The point of this change is to make tertiary section numbers go away.
%\def\lb@subsubsection{\thesubsubsection.\half@em}
%  \def\lb@empty@subsubsection{\thesubsubsection}
\def\lb@subsubsection{}
  \def\lb@empty@subsubsection{}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\def\lb@paragraph{\theparagraph.\half@em}
  \def\lb@empty@paragraph{\theparagraph}
\def\lb@subparagraph{\thesubparagraph.\half@em}
  \def\lb@empty@subparagraph{\thesubparagraph}
\def\head@format#1#2{#2}
\def\head@style{\interlinepenalty\@M
  \hyphenpenalty\@M \exhyphenpenalty\@M
  \rightskip \z@ \@plus 0.5\hsize \relax
  }
\def\@sect#1#2#3#4#5#6[#7]#8{%
  \ifnum #2>\c@secnumdepth
    \let\@svsec\@empty
  \else
    \refstepcounter{#1}\def\@tempa{#8}%
    \ifx\@tempa\@empty
      \edef\@svsec{\csname lb@empty@#1\endcsname}%
    \else
      \edef\@svsec{\csname lb@#1\endcsname}\fi\fi
  \@tempskipa #5\relax
  \ifdim \@tempskipa>\z@
    \begingroup #6\relax
\noindent \hskip #3\relax{\@secnumfont{#2}\@svsec}%
 {\head@style\head@format{#2}{#8}\par}%
    \endgroup
    \csname #1mark\endcsname{#7}%
    \addcontentsline{toc}{#1}{\ifnum #2>\c@secnumdepth \else
     \protect\numberline{\csname the#1\endcsname}\fi #7}%
  \else
    \def\@svsechd{#6\hskip #3\relax {\@secnumfont{#2}\@svsec }%
      {\head@style\head@format{#2}{#8}}\csname #1mark\endcsname{#7}%
    \addcontentsline{toc}{#1}{\ifnum #2>\c@secnumdepth \else
       \protect\numberline{\csname the#1\endcsname}\fi #7}}%
  \fi
  \@xsect{#5}}
\def\@ssect#1#2#3#4#5#6{%
  \@tempskipa #4\relax
  \ifdim \@tempskipa>\z@
    \begingroup
      #5{%
        \@hangfrom{\hskip #2}%
          \interlinepenalty \@M \head@format{#1}{#6}\@@par}%
    \endgroup
  \else
    \def\@svsechd{#5{\hskip #2\relax \head@format{#1}{#6}}}%
  \fi
  \@xsect{#4}}
\def\@startsection#1#2#3#4#5#6{%
  \if@noskipsec \leavevmode \fi
  \par
  \@tempskipa #4\relax
  \@afterindenttrue
  \ifdim \@tempskipa <\z@
    \@tempskipa -\@tempskipa \@afterindentfalse
  \fi
  \if@nobreak
    \everypar{}%
  \else
    \addpenalty\@secpenalty\addvspace\@tempskipa
  \fi
  \@ifstar
    {\@ssect{#2}{#3}{#4}{#5}{#6}}%
    {\@dblarg{\@sect{#1}{#2}{#3}{#4}{#5}{#6}}}}

\def\app@number#1{\setcounter{#1}{0}%
  \@addtoreset{#1}{section}%
  \@namedef{the#1}{\thesection.\arabic{#1}}}
\def\appendix{\@ifstar{\appendix@star}{\appendix@nostar}}
\def\appendix@nostar{%
  \def\lb@section{\appendixname\ \thesection.\half@em}
  \def\lb@empty@section{\appendixname\ \thesection}
  \setcounter{section}{0}\def\thesection{\Alph{section}}%
  \setcounter{subsection}{0}%
  \setcounter{subsubsection}{0}%
  \setcounter{paragraph}{0}%
  \app@number{equation}\app@number{figure}\app@number{table}}
\def\appendix@star{%
  \def\lb@section{\appendixname}\let\lb@empty@section\lb@section
  \setcounter{section}{0}\def\thesection{\Alph{section}}%
  \setcounter{subsection}{0}%
  \setcounter{subsubsection}{0}%
  \setcounter{paragraph}{0}%
  \app@number{equation}\app@number{figure}\app@number{table}}
\def\ack{\section*{Acknowledgements}%
  \addtocontents{toc}{\protect\vspace{6pt}}%
  \addcontentsline{toc}{section}{Acknowledgements}%
}
\@namedef{ack*}{\par\vskip 3.0ex \@plus 1.0ex \@minus 1.0ex}
\let\endack\par
\@namedef{endack*}{\par}
\newdimen\labelwidthi
\newdimen\labelwidthii
\newdimen\labelwidthiii
\newdimen\labelwidthiv
\def\normal@labelsep{0.5em}
\labelsep\normal@labelsep
\settowidth{\labelwidthi}{(iii)}
\settowidth{\labelwidthii}{(d)}
\settowidth{\labelwidthiii}{(iii)}
\settowidth{\labelwidthiv}{(M)}
\leftmargini\labelwidthi    \advance\leftmargini\labelsep
\leftmarginii\labelwidthii  \advance\leftmarginii\labelsep
\leftmarginiii\labelwidthiii \advance\leftmarginiii\labelsep
\leftmarginiv\labelwidthiv  \advance\leftmarginiv\labelsep
\def\setleftmargin#1#2{\settowidth{\@tempdima}{#2}\labelsep\normal@labelsep
  \csname labelwidth#1\endcsname\@tempdima
  \@tempdimb\@tempdima \advance\@tempdimb\labelsep
  \csname leftmargin#1\endcsname\@tempdimb}
\def\@listI{\leftmargin\leftmargini
  \labelwidth\labelwidthi \labelsep\normal@labelsep
  \topsep \z@ \partopsep\z@ \parsep\z@ \itemsep\z@
  \listparindent 1em}
\def\@listii{\leftmargin\leftmarginii
  \labelwidth\labelwidthii \labelsep\normal@labelsep
  \topsep\z@ \partopsep\z@ \parsep\z@ \itemsep\z@
  \listparindent 1em}
\def\@listiii{\leftmargin\leftmarginiii
  \labelwidth\labelwidthiii \labelsep\normal@labelsep
  \topsep\z@ \partopsep\z@ \parsep\z@ \itemsep\z@
  \listparindent 1em}
\def\@listiv{\leftmargin\leftmarginiv
  \labelwidth\labelwidthiv \labelsep\normal@labelsep
  \topsep\z@ \partopsep\z@ \parsep\z@ \itemsep\z@
  \listparindent 1em}
\let\@listi\@listI
\@listi
\def\left@label#1{{#1}\hss}
\def\right@label#1{\hss\llap{#1}}
\def\thick@label#1{\hspace\labelsep #1}
\newcount\@maxlistdepth
\@maxlistdepth=4
\def\labelitemi{$\bullet$}          \def\labelitemii{$\cdot$}
\def\labelenumi{(\theenumi)}        \def\theenumi{\arabic{enumi}}
\def\labelenumii{(\alph{enumii})}   \def\theenumii{\theenumi\alph{enumii}}
\def\labelenumiii{(\roman{enumiii})}\def\theenumiii{\theenumii.\roman{enumiii}}
\def\labelenumiv{(\Alph{enumiv})}   \def\theenumiv{\theenumiii.\Alph{enumiv}}
\def\enumerate{%
  \ifnum \@enumdepth >\@maxlistdepth
    \@toodeep
  \else
    \advance\@enumdepth \@ne
    \edef\@enumctr{enum\romannumeral\the\@enumdepth}%
    \list{\csname label\@enumctr\endcsname}%
       {\usecounter{\@enumctr}
       \let\makelabel=\right@label}
  \fi}
\def\itemize{%
  \ifnum \@itemdepth >\@maxlistdepth
    \@toodeep
  \else
    \advance\@itemdepth \@ne
    \edef\@itemitem{labelitem\romannumeral\the\@itemdepth}%
    \list{\csname\@itemitem\endcsname}%
       {\let\makelabel\right@label}
  \fi}
\def\verse{\let\\=\@centercr
  \list{}{\itemsep\z@
  \itemindent \z@
  \listparindent\z@
  \rightmargin 1em
  \leftmargin \rightmargin}\item[]}
\let\endverse\endlist
\def\quotation{\list{}{\itemindent\z@
 \leftmargin 4em \rightmargin 1em
  \parsep \z@ \@plus 1pt}\item[]}
\let\endquotation=\endlist
\def\quote{\list{}{\itemindent\z@
    \@topsep \eqntopsep
    \leftmargin 4em \rightmargin 1em}%
\item[]}
\let\endquote=\endlist
\def\descriptionlabel#1{\hspace\labelsep \bfseries #1}
\def\description{\list{}{\labelwidth\z@
  \leftmargin 1em \itemindent-\leftmargin
  \let\makelabel\descriptionlabel}}
\let\enddescription\endlist
\def\@atfmtname{atlplain}
\ifx\fmtname\@atfmtname
 \def\neq{\not\nobreak\mkern -2mu =}%
 \let\ne\neq
\fi
\def\operatorname#1{\mathop{\mathrm{#1}}\nolimits}
\def\lefteqn#1{\hbox to\z@{$\displaystyle {#1}$\hss}}
\def\newdelim{\delimiterfactor=750 \delimitershortfall=7pt}
\def\olddelim{\delimiterfactor=901 \delimitershortfall=0pt}
\newskip\eqnbaselineskip % Standard interline spacing in an {eqnarray}
\jot=2\p@
\newskip\eqnlineskip     % Minimal space between the bottom of
                         % a line and the top of the next line.
\eqnbaselineskip=14\p@  \eqnlineskip=2\p@
\newdimen\mathindent
\if@TwoColumn
  \mathindent 0em
\else
  \mathindent 2em
\fi
\def\[{\relax\ifmmode\@badmath
  \else%\bgroup removed on request from BW (1993-05-17)
  \@beginparpenalty\predisplaypenalty
  \@endparpenalty\postdisplaypenalty
  \begin{trivlist}\@topsep \eqntopsep       % used by first \item
   \@topsepadd \eqntopsep                   % used by \@endparenv
  \item[]\leavevmode
   \hbox to\linewidth\bgroup\hfil $ \displaystyle
  \hskip\mathindent\bgroup\fi}
\def\]{\relax\ifmmode \egroup $\hfil \egroup
  \end{trivlist}% \egroup removed on request from BW (1993-05-17)
  \else \@badmath \fi}
\def\equation{\@beginparpenalty\predisplaypenalty
  \@endparpenalty\postdisplaypenalty
\refstepcounter{equation}\trivlist
   \@topsep \eqntopsep                      % used by first \item
   \@topsepadd \eqntopsep                   % used by \@endparenv
   \item[]\leavevmode
   \hbox to\linewidth\bgroup \hfil $ \displaystyle \hskip\mathindent\bgroup}
\def\endequation{\egroup$\hfil \displaywidth\linewidth
  \@eqnnum\egroup \endtrivlist}
\def\eqnarray{%
  \par                                               %BW
  \noindent                                          %BW
  \baselineskip\eqnbaselineskip\lineskip\eqnlineskip %BW
  \lineskiplimit\eqnlineskip                         %BW
  \stepcounter{equation}%
  \let\@currentlabel=\theequation
  \global\@eqnswtrue
  \global\@eqcnt\z@
  \tabskip\@centering
  \let\\=\@eqncr
  \abovedisplayskip\eqntopsep\ifvmode\advance\abovedisplayskip\partopsep\fi
  \belowdisplayskip\abovedisplayskip
  \belowdisplayshortskip\abovedisplayskip
  \abovedisplayshortskip\abovedisplayskip
  $$\halign to \displaywidth\bgroup\@eqnsel
    \pre@coli$\displaystyle\tabskip\z@{##}$\post@coli
    &\global\@eqcnt\@ne
    \pre@colii$\displaystyle{##}$\post@colii
    &\global\@eqcnt\tw@
    \pre@coliii $\displaystyle\tabskip\z@{##}$\post@coliii
    \tabskip\@centering&\llap{##}\tabskip\z@\cr
}
\def\endeqnarray{\@@eqncr\egroup
 \global\advance\c@equation\m@ne$$\global\@ignoretrue }
\def\pre@coli{\hskip\@centering}              \def\post@coli{}
\def\pre@colii{\hskip 2\eqnarraycolsep \hfil} \def\post@colii{\hfil}
\def\pre@coliii{\hskip 2\eqnarraycolsep}      \def\post@coliii{\hfil}
\arraycolsep 2\p@         % Half the space between columns in array environment.
 \tabcolsep 6\p@           % idem in tabular environment.
\arrayrulewidth 0.4\p@    % \@Width of rules and space between adjacent
\doublerulesep 2\p@       % rules in any of these two environments.
\def\@arrayclassz{\ifcase \@lastchclass \@acolampacol \or \@ampacol \or
  \or \or \@addamp \or \@acolampacol \or \@firstampfalse \@acol \fi
  \edef\@preamble{\@preamble
  \ifcase \@chnum
    \hfil$\relax\displaystyle\@sharp$\hfil \or
    $\relax\displaystyle\@sharp$\hfil      \or
    \hfil$\relax\displaystyle\@sharp$\fi}}
\newdimen\rulepreskip \newdimen\rulepostskip
\rulepreskip=4\p@      \rulepostskip=6\p@
\newdimen\Arrayrulewidth \Arrayrulewidth=1.0\p@
\def\Hline{\noalign{\ifnum0=`}\fi\hrule \@height \Arrayrulewidth \futurelet
   \@tempa\@xhline}
\newdimen\crulepostskip \crulepostskip -7\p@
\def\ccline#1{%
  \noalign{\vskip\rulepreskip}%
  \do@ccline(#1,1-0)\cr
  \noalign{\vskip\crulepostskip}}
\def\do@ccline(#1-#2,#3){%
  \ifnum#1>#2\else\@cline[#1-#2]\do@ccline(#3,1-0)\fi
  \ignorespaces}
\newdimen\@Ldec \newdimen\@Rdec
\def\dec #1.#2 {\hbox to\@Ldec{\hss#1}\def\@tempb{#2}%
\ifx\@tempb\empty\hbox to\@Rdec{\hfill}\else\hbox to\@Rdec{.#2\hss}\fi}
\def\setdec #1.#2 {\relax
  \bgroup
    \setbox0\hbox{\kern1pt\relax#1}\setbox1\hbox{\kern1pt\relax#2}%
    \global\@Ldec\wd0\global\@Rdec\wd1
  \egroup}
\setdec 000.000 % default 3 digits on each side
\newdimen\@Lpmdec \newdimen\@Rpmdec
\def\pmdec #1.#2 {\hbox to\@Lpmdec{\hss#1}\def\@tempb{#2}%
\ifx\@tempb\empty\hbox to\@Rpmdec{\hfill}\else\hbox to\@Rpmdec{.#2\hss}\fi}
\def\setpmdec #1.#2 {\relax
  \bgroup
    \setbox0\hbox{\kern1pt\relax#1}\setbox1\hbox{\kern1pt\relax#2}%
    \global\@Lpmdec\wd0\global\@Rpmdec\wd1
  \egroup}
\setpmdec 0.0 % default 1 digit on each side
\tabbingsep \labelsep   % Space used by the \' command.  (See LaTeX{} manual.)
\skip\@mpfootins = 6\p@ \@plus 2\p@   % Space between last line of text and
                                  % top of first footnote.
\fboxsep = 7\p@    % Space left between box and text by \fbox and \framebox.
\fboxrule = 0.4\p@ % \@Width of rules in box made by \fbox and \framebox.
\newcounter{section}
\newcounter{subsection}[section]
\newcounter{subsubsection}[subsection]
\newcounter{paragraph}[subsubsection]
\newcounter{subparagraph}[paragraph]
\if@seceqn
 \@addtoreset{equation}{section}
 \def\theequation{\arabic{section}.\arabic{equation}}
\else
  \def\theequation{\arabic{equation}}
\fi
\def\thesection      {\arabic{section}}
\def\thesubsection   {\thesection.\arabic{subsection}}
\def\thesubsubsection{\thesubsection.\arabic{subsubsection}}
\def\theparagraph    {\thesubsubsection.\arabic{paragraph}}
\def\thesubparagraph {\theparagraph.\arabic{subparagraph}}
\@addtoreset{section}{part} % reset section numbers at beginning of part

 \RequirePackage{theorem}
 \RequirePackage{newlfont}
\DeclareOldFontCommand{\rm}{\normalfont\rmfamily}{\mathrm}
\DeclareOldFontCommand{\sf}{\normalfont\sffamily}{\mathsf}
\DeclareOldFontCommand{\tt}{\normalfont\ttfamily}{\mathtt}
\DeclareOldFontCommand{\bf}{\normalfont\bfseries}{\mathbf}
\DeclareOldFontCommand{\it}{\normalfont\itshape}{\mathit}
\DeclareOldFontCommand{\sl}{\normalfont\slshape}{\@nomath\sl}
\DeclareOldFontCommand{\sc}{\normalfont\scshape}{\@nomath\sc}
\def\qed{\relax\ifmmode\hskip2em \Box\else\unskip\nobreak\hskip1em $\Box$\fi}
\def\proof@headerfont{\upshape\bfseries}
 \gdef\th@plain{\itshape
  \def\@begintheorem##1##2{\item[\hskip\labelsep
    {\theorem@headerfont ##1\ ##2.}]}%
  \def\@opargbegintheorem##1##2##3{\item[\hskip\labelsep
    {\theorem@headerfont ##1\ ##2}\ {\upshape (##3).}]}}
\gdef\th@definition{\upshape
  \def\@begintheorem##1##2{\item[\hskip\labelsep
    {\theorem@headerfont ##1\ ##2.}]}%
  \def\@opargbegintheorem##1##2##3{\item[\hskip\labelsep
    {\theorem@headerfont ##1\ ##2}\ {\upshape(}{\it ##3\/}{\upshape).}]}}
\gdef\theorem@headerfont{\itshape}
\gdef\th@plain{\upshape
  \def\@begintheorem##1##2{\item[\hskip\labelsep
    {\theorem@headerfont ##1\ ##2.}]}%
  \def\@opargbegintheorem##1##2##3{\item[\hskip\labelsep
    {\theorem@headerfont ##1\ ##2.}\ {\upshape (##3).}]}}
\gdef\th@definition{\upshape
  \def\@begintheorem##1##2{\item[\hskip\labelsep
    {\theorem@headerfont ##1\ ##2.}]}%
  \def\@opargbegintheorem##1##2##3{\item[\hskip\labelsep
    {\theorem@headerfont ##1\ ##2.}\ {\upshape (##3).}]}}

\def\rom#1{\leavevmode\skip@\lastskip\unskip\/%
        \ifdim\skip@=\z@\else\hskip\skip@\fi
   {\upshape#1}}
\theorempreskipamount=3\p@  \@minus 1\p@   % WAS 12 PMISRA 2007-05-30
\theorempostskipamount=\theorempreskipamount
\newenvironment{pf}%
  {\par\addvspace{\theorempreskipamount}\noindent
   {\proof@headerfont\Elproofname}\enspace\ignorespaces}%
  {\par\addvspace{\theorempreskipamount}}
\def\Elproofname{Proof.}
\@namedef{pf*}#1{\par\begingroup\def\Elproofname{#1}\pf\endgroup\ignorespaces}
\expandafter\let\csname endpf*\endcsname=\endpf
 \theoremstyle{plain}
\if@secthm
  \newtheorem{thm}{Theorem}[section]
  \@addtoreset{thm}{section}
\else
  \newtheorem{thm}{Theorem}
\fi
\newtheorem{cor}[thm]{Corollary}
\newtheorem{lem}[thm]{Lemma}
\newtheorem{claim}[thm]{Claim}
\newtheorem{axiom}[thm]{Axiom}
\newtheorem{conj}[thm]{Conjecture}
\newtheorem{fact}[thm]{Fact}
\newtheorem{hypo}[thm]{Hypothesis}
\newtheorem{assum}[thm]{Assumption}
\newtheorem{prop}[thm]{Proposition}
\newtheorem{crit}[thm]{Criterion}
 \theoremstyle{definition}
\newtheorem{defn}[thm]{Definition}
\newtheorem{exmp}[thm]{Example}
\newtheorem{rem}[thm]{Remark}
\newtheorem{prob}[thm]{Problem}
\newtheorem{prin}[thm]{Principle}
\newtheorem{alg}{Algorithm}
\long\def\@makealgocaption#1#2{\vskip 2ex \small
  \hbox to \hsize{\parbox[t]{\hsize}{{\bfseries #1.} #2}}}
\newcounter{algorithm}
\def\thealgorithm{\@arabic\c@algorithm}
\def\fps@algorithm{tbp}
\def\ftype@algorithm{4}
\def\ext@algorithm{lof}
\def\fnum@algorithm{Algorithm \thealgorithm}
\def\algorithm{\let\@makecaption\@makealgocaption\@float{algorithm}}
\let\endalgorithm\end@float
\newtheorem{note}{Note}
\newtheorem{summ}{Summary}
\newtheorem{case}{Case}
\def\@pnumwidth{2.55em}
\def\@tocrmarg{2.55em \@plus 5em}
\def\@dotsep{-2.5}
\setcounter{tocdepth}{2}
\newcommand\listoffigures{%
    \section*{\listfigurename
      \@mkboth{\MakeUppercase\listfigurename}%
              {\MakeUppercase\listfigurename}}%
    \@starttoc{lof}%
    }
\newcommand*\l@figure{\@dottedtocline{1}{1.5em}{2.3em}}
\newcommand\listoftables{%
    \section*{\listtablename
      \@mkboth{%
          \MakeUppercase\listtablename}{\MakeUppercase\listtablename}}%
    \@starttoc{lot}%
    }
\let\l@table\l@figure
\def\tableofcontents{%
  \begin{small}
  \leftline {{\bfseries \contentsname\/}}
  \setcounter{secnumdepth}{4}%
  \setcounter{tocdepth}{2}%
  {\@starttoc{toc}}%
\end{small}
}
\newcommand*\l@section{\@dottedtocline{1}{1.5em}{2.3em}}
\newcommand*\l@subsection{\@dottedtocline{2}{1.5em}{2.3em}}
\newcommand*\l@subsubsection{\@dottedtocline{3}{3.8em}{3.2em}}
\newcommand*\l@paragraph{\@dottedtocline{4}{7.0em}{4.1em}}
\newcommand*\l@subparagraph{\@dottedtocline{5}{10em}{5em}}
\def\@dotsep{2000}
\def\thebibliography{%
\section*{\refname}
  \@thebibliography}
\let\endthebibliography=\endlist
\def\@thebibliography#1{\@bibliosize
  \list{\@biblabel{\arabic{enumiv}}}{\settowidth\labelwidth{\@biblabel{#1}}
  \if@nameyear
    \labelwidth\z@ \labelsep\z@ \leftmargin\parindent
    \itemindent-\parindent
  \else
    \labelsep 3\p@ \itemindent\z@
    \leftmargin\labelwidth \advance\leftmargin\labelsep
\fi
      \itemsep \z@ \@plus 0.5\p@ \@minus 0.5\p@
    \usecounter{enumiv}\let\p@enumiv\@empty
    \def\theenumiv{\arabic{enumiv}}}%
    \tolerance\@M
    \hyphenpenalty=50
     \hbadness5000 \sfcode`\.=1000\relax}
\newcommand\newblock{\hskip .11em\@plus.33em\@minus.07em}
\@namedef{thebibliography*}{\section*{}\@thebibliography}
\@namedef{endthebibliography*}{\endlist}
\if@nameyear
  \def\@biblabel#1{}
\else
 \def\@biblabel#1{[#1]\hskip \z@ \@plus 1filll}
\fi
\newcount\@tempcntc
\def\@citex[#1]#2{\if@filesw\immediate\write\@auxout{\string\citation{#2}}\fi
 \@tempcnta\z@\@tempcntb\m@ne\def\@citea{}\@cite{\@for\@citeb:=#2\do
  {\@ifundefined
   {b@\@citeb}{\@citeo\@tempcntb\m@ne\@citea\def\@citea{,}{\bfseries ?}\@warning
   {Citation `\@citeb' on page \thepage \space undefined}}%
  {\setbox\z@\hbox{\global\@tempcntc0\csname b@\@citeb\endcsname\relax}%
   \ifnum\@tempcntc=\z@ \@citeo\@tempcntb\m@ne
    \@citea\def\@citea{,}\hbox{\csname b@\@citeb\endcsname}%
   \else
    \advance\@tempcntb\@ne
    \ifnum\@tempcntb=\@tempcntc
    \else\advance\@tempcntb\m@ne\@citeo
    \@tempcnta\@tempcntc\@tempcntb\@tempcntc\fi\fi}}\@citeo}{#1}}
\def\@citeo{\ifnum\@tempcnta>\@tempcntb\else\@citea\def\@citea{,}%
 \ifnum\@tempcnta=\@tempcntb\the\@tempcnta\else
  {\advance\@tempcnta\@ne\ifnum\@tempcnta=\@tempcntb \else \def\@citea{--}\fi
   \advance\@tempcnta\m@ne\the\@tempcnta\@citea\the\@tempcntb}\fi\fi}
\@namedef{cv*}{\section*{Curriculum Vitae}\cv}
 \def\cv{\hangindent=7pc \hangafter=-12 \parskip\bigskipamount \small}
\def\footnote{\@ifnextchar[{\@xfootnote}{\refstepcounter
   {\@mpfn}\protected@xdef\@thefnmark{\thempfn}\@footnotemark\@footnotetext}}
\def\footnotemark{\@ifnextchar[{\@xfootnotemark
    }{\refstepcounter{footnote}\xdef\@thefnmark{\thefootnote}\@footnotemark}}
\def\footnoterule{\kern-3\p@
  \hrule \@width 3pc               % The \hrule has default \@height of 0.4pt.
  \kern 2.6\p@}
\def\thempfootnote{\fnsymbol{mpfootnote}}
\def\mpfootnotemark{%
  \@ifnextchar[{\@xmpfootnotemark}{\stepcounter{mpfootnote}%
  \begingroup
    \let\protect\noexpand
    \xdef\@thefnmark{\thempfootnote}%
  \endgroup
  \@footnotemark}}
\def\@xmpfootnotemark[#1]{%
  \begingroup
    \c@mpfootnote #1\relax
    \let\protect\noexpand
    \xdef\@thefnmark{\thempfootnote}%
  \endgroup
  \@footnotemark}
\def\@mpmakefnmark{\,\hbox{$^{\mathrm{\@thefnmark}}$}}
\long\def\@mpmakefntext#1{\noindent
                     \hbox{$^{\mathrm{\@thefnmark}}$} #1}
\def\@iiiminipage#1#2[#3]#4{%
  \leavevmode
  \@pboxswfalse
  \setlength\@tempdima{#4}%
  \def\@mpargs{{#1}{#2}[#3]{#4}}%
  \setbox\@tempboxa\vbox\bgroup
    \color@begingroup
      \hsize\@tempdima
      \textwidth\hsize \columnwidth\hsize
      \@parboxrestore
      \def\@mpfn{mpfootnote}\def\thempfn{\thempfootnote}\c@mpfootnote\z@
      \let\@footnotetext\@mpfootnotetext
      \let\@makefntext\@mpmakefntext
      \let\@makefnmark\@mpmakefnmark
      \let\@listdepth\@mplistdepth \@mplistdepth\z@
      \@minipagerestore\global\@minipagetrue %% \global added 24 May 89
      \everypar{\global\@minipagefalse\everypar{}}}
\def\fn@presym{}
\long\def\@makefntext#1{\noindent\hbox to 1em
  {$^{\fn@presym\mathrm{\@thefnmark}}$\hss}#1}
\def\@makefnmark{\,\hbox{$^{\fn@presym\mathrm{\@thefnmark}}$}\,}
\def\patched@end@dblfloat{%
  \if@twocolumn
      \par\vskip\z@skip      %% \par\vskip\z@ added 15 Dec 87
      \global\@minipagefalse
      \outer@nobreak
    \egroup                  %% end of vbox
    \color@endbox
    \ifnum\@floatpenalty <\z@
      \@largefloatcheck
      \@cons\@dbldeferlist\@currbox
    \fi
    \ifnum \@floatpenalty =-\@Mii \@Esphack\fi
  \else
    \end@float
  \fi
}
\setcounter{topnumber}{5}
\def\topfraction{0.99}
\def\textfraction{0.05}
\def\floatpagefraction{0.9}
\setcounter{bottomnumber}{5}
\def\bottomfraction{0.99}
\setcounter{totalnumber}{10}
\def\dbltopfraction{0.99}
\def\dblfloatpagefraction{0.8}
\setcounter{dbltopnumber}{5}
\long\def\@maketablecaption#1#2{\@tablecaptionsize
    \global \@minipagefalse
    \hbox to \hsize{\parbox[t]{\hsize}{#1 \\ #2}}}
\long\def\@makefigurecaption#1#2{\@figurecaptionsize
  \vskip \@overcaptionskip
  \setbox\@tempboxa\hbox{#1. #2}
  \ifdim \wd\@tempboxa >\hsize              % IF longer than one line THEN
    \unhbox\@tempboxa\par                   %   set as justified paragraph
  \else                                     % ELSE
    \global \@minipagefalse
    \hbox to\hsize{\hfil\box\@tempboxa\hfil}%   center single line.
  \fi}
\def\@makecaption{\@makefigurecaption}
\def\conttablecaption{\par \begingroup \@parboxrestore \normalsize
  \@makecaption{\fnum@table\,---\,continued}{}\par
  \vskip-1pc \endgroup}
\def\contfigurecaption{\vskip-1pc \par \begingroup \@parboxrestore
  \@captionsize
  \@makecaption{\fnum@figure\,---\,continued}{}\par
  \endgroup}
\newcounter{figure}
\def\thefigure{\@arabic\c@figure}
\def\fps@figure{tbp}
\def\ftype@figure{1}
\def\ext@figure{lof}
\def\fnum@figure{\figurename~\thefigure}
\def\figure{%
 \let\@makecaption\@makefigurecaption
  \let\contcaption\contfigurecaption \@float{figure}}
\let\endfigure\end@float
\@namedef{figure*}{%
 \let\@makecaption\@makefigurecaption
  \let\contcaption\contfigurecaption \@dblfloat{figure}}
\@namedef{endfigure*}{\end@dblfloat}
\newcounter{table}
\def\thetable{\@arabic\c@table}
\def\fps@table{tbp}
\def\ftype@table{2}
\def\ext@table{lot}
\def\fnum@table{\tablename~\thetable}
\let\old@floatboxreset\@floatboxreset
\def\table{%
\let\@makecaption\@maketablecaption
\def\@floatboxreset{%
 \old@floatboxreset
 \@tablesize
}%
  \let\footnoterule\relax
  \let\contcaption\conttablecaption \@float{table}}
\let\endtable\end@float
\@namedef{table*}{%
\let\@makecaption\@maketablecaption
\def\@floatboxreset{%
 \old@floatboxreset
 \@tablesize
}%
  \let\footnoterule\relax
  \let\contcaption\conttablecaption \@dblfloat{table}}
\@namedef{endtable*}{\end@dblfloat}
\newtoks\t@glob@notes             % List of all notes
\newtoks\t@loc@notes              % List of notes for one element
\newcount\note@cnt                % Number of notes per element
\newcounter{author}               % Author counter
\newcount\n@author                % Total number of authors
\def\n@author@{1}                  % idem, read from .aux file
\newcounter{collab}               % Collaboration counter
\newcount\n@collab                % Total number of collaborations
\def\n@collab@{}                  % idem, read from .aux file
\newcounter{address}              % Address counter
\def\theHaddress{\arabic{address}}% for hyperref
\newdimen\sv@mathsurround         % Dimen register to save \mathsurround
\newcount\sv@hyphenpenalty        % Count register to save \hyphenpenalty
\newcount\prev@elem \prev@elem=0  % Variables to keep track of
\newcount\cur@elem  \cur@elem=0   % types of elements that are processed
\chardef\e@title=1
\chardef\e@subtitle=1
\chardef\e@author=2
\chardef\e@collab=3
\chardef\e@address=4
\newif\if@newelem                 % Switch to new type of element?
\newif\if@firstauthor             % First author or collaboration?
\newif\if@preface                 % If preface: omit history and abstract
\newif\if@hasabstract             % If abstract / keywords: do not omit rules
\newif\if@haskeywords             % If abstract / keywords: do not omit rules
\newbox\fm@box                    % Box for collected front matter
\newdimen\fm@size                 % Total height of \fm@box
\newbox\t@abstract                % Box for abstract
\newbox\t@keyword                 % Box for keyword abstract
\newcount\rep@mod \rep@mod=10
\def\report@elt#1{%
}
\def\add@tok#1#2{\global#1\expandafter{\the#1#2}}
\def\add@xtok#1#2{\begingroup
  \no@harm
  \xdef\@act{\global\noexpand#1{\the#1#2}}\@act
\endgroup}
\def\beg@elem{\global\t@loc@notes={}\global\note@cnt\z@}
\def\@xnamedef#1{\expandafter\xdef\csname #1\endcsname}
\def\no@harm{%
  \let\\=\relax  \let\rm\relax
  \let\ss=\relax \let\ae=\relax \let\oe=\relax
  \let\AE=\relax \let\OE=\relax
  \let\o=\relax  \let\O=\relax
  \let\i=\relax  \let\j=\relax
  \let\aa=\relax \let\AA=\relax
  \let\l=\relax  \let\L=\relax
  \let\d=\relax  \let\b=\relax \let\c=\relax
  \let\bar=\relax
  \def\protect{\noexpand\protect\noexpand}}
\def\proc@elem#1#2{\begingroup
    \no@harm                             % make a few instructions harmless
    \let\thanksref\@gobble               % remove \thanksref from element
    \@xnamedef{@#1}{#2}%                 % and store as \@#1
  \endgroup
  \prev@elem=\cur@elem                   % keep track of type of previous
  \cur@elem=\csname e@#1\endcsname       % and current element
  \expandafter\elem@nothanksref#2\thanksref\relax}
\def\elem@nothanksref#1\thanksref{\futurelet\@peektok\elem@thanksref}
\def\elem@thanksref{\ifx\@peektok\relax  % No more \thanksref, so now exit
  \else \expandafter\elem@morethanksref \fi}
\def\elem@morethanksref#1{\add@thanksref{#1}\elem@nothanksref}
\def\add@thanksref#1{%
  \global\advance\note@cnt\@ne
  \def\@tempa{*}\def\@tempb{#1}%
  \ifx\@tempa\@tempb
    \ifnum\note@cnt>\@ne \add@xtok\t@loc@notes{\note@sep}\fi
    \add@tok\t@loc@notes{*}%
  \else
    \ifnum\note@cnt>\@ne \add@xtok\t@loc@notes{\note@sep}\fi
    \add@tok\t@loc@notes{%
    \if@Elproofing#1\else\ref{#1}\fi
    }%
  \fi}
\def\note@sep{,}
\def\thanks{\@ifnextchar[{\@tempswatrue
  \thanks@optarg}{\@tempswafalse\thanks@optarg[]}}
\def\thanks@optarg[#1]#2{%
  \def\@tempa{*}\def\@tempb{#1}%
  \ifx\@tempa\@tempb
    \@tempcnta=\c@footnote \c@footnote=-1 \label{#1}\c@footnote=\@tempcnta
    \gdef\@corresp@note{\footnotetext[-1]{#2}}%
  \else
    \add@tok\t@glob@notes{\footnotetext}%
    \refstepcounter{footnote}%
    \if@Elproofing\else\if@tempswa\label{#1}\else\relax\fi\fi
    \add@xtok\t@glob@notes{[\the\c@footnote]}%
    \add@tok\t@glob@notes{{#2}}%
  \fi}
\let\real@refstepcounter\refstepcounter
\def\footnote{\@ifnextchar[{\@xfootnote}{\real@refstepcounter
   {\@mpfn}\protected@xdef\@thefnmark{\thempfn}\@footnotemark\@footnotetext}}
\def\footnotemark{\@ifnextchar[{\@xfootnotemark
    }{\real@refstepcounter{footnote}\xdef\@thefnmark{\thefootnote}\@footnotemark}}
\def\footnoterule{\kern-3\p@
  \hrule \@width 3pc               % The \hrule has default \@height of 0.4pt.
  \kern 2.6\p@}
\newenvironment{NoHyper}{}{}
\def\frontmatter{%
  \NoHyper
  \let\@corresp@note\relax
  \global\t@glob@notes={}\global\c@author\z@
  \global\c@collab\z@ \global\c@address\z@
  \sv@mathsurround\mathsurround \m@th
  \global\n@author=0\n@author@\relax
  \global\n@collab=0\n@collab@\relax
  \global\advance\n@author\m@ne   % In comparisons later on we need
  \global\advance\n@collab\m@ne   % n@author-1 and n@collab-1
  \global\@firstauthortrue        % set to false by first \author or \collab
  \global\@hasabstractfalse       % Default:  no abstract or keywords
  \global\@haskeywordsfalse       % Default:  no abstract or keywords
  \global\@prefacefalse           %           not preface
  \ifnum\c@firstpage=\c@lastpage
    \gdef\@pagerange{\@pagenumprefix\ESpagenumber{firstpage}}
  \else
    \gdef\@pagerange{\@pagenumprefix
   \ESpagenumber{firstpage}--\@pagenumprefix\ESpagenumber{lastpage}}%
  \fi
  \@ifundefined{RIfM@}{\global\let\vec\@bfvec}{\undo@AMS}%
  \open@fm \ignorespaces}
\def\preface{\@prefacetrue}
\def\endfrontmatter{%
  \ifx\@runauthor\relax
   \global\let\@runauthor\@runningauthor
  \fi
  \global\n@author=\c@author
  \global\n@collab=\c@collab \@writecount
  \global\@topnum\z@
  \thispagestyle{copyright}%            % Format rest of front matter:
  \if@preface \else                     % IF not preface THEN
  \vskip \@overhistoryskip
  \history@fmt                          % print history (received, ...)
  \newcount\c@sv@footnote
  \global\c@sv@footnote=\c@footnote     % save current footnote number
\if@TwoColumn\else
    \output@glob@notes                  % Put notes at bottom of 1st page
\fi


  \if@hasabstract                       % IF abstract/ keywords THEN
   \vskip \@preabstractskip     % Space above rule
   \nointerlineskip
   \moveright 0.1\textwidth \vbox{\hrule width 0.8\textwidth height 0.4\p@}                 % Rule above abstract/keywords
    \nointerlineskip
    \vskip 8\p@
    \unvbox\t@abstract                  % print abstract, if any
  \fi
  \if@haskeywords                       % IF keywords THEN
    \vskip \@overkeywordskip
    \unvbox\t@keyword                   % Keyword abstract, if any
  \fi                                   % FI
   \vskip \@preabstractskip     % Space above rule
   \nointerlineskip
   \moveright 0.1\textwidth \vbox{\hrule width 0.8\textwidth height 0.4\p@}                 % Rule above abstract/keywords
    \nointerlineskip
  \dedicated@fmt                        % print dedication
  \vskip \@belowfmskip                  % Vertical space below frontmatter
\fi                                   % FI
  \close@fm                             % Close front matter material.
  \if@TwoColumn
    \output@glob@notes                  % Put notes at bottom of 1st page
  \fi
  \global\c@footnote=\c@sv@footnote     % restore footnote number
  \global\@prefacefalse
  \global\leftskip\z@                   % Restore the normal values of
  \global\@rightskip\z@                 % \leftskip,
  \global\rightskip\@rightskip          % \rightskip and
  \global\mathsurround\sv@mathsurround  % \mathsurround.
  \let\title\relax       \let\author\relax
  \let\collab\relax      \let\address\relax
  \let\frontmatter\relax \let\endfrontmatter\relax
  \let\@maketitle\relax  \let\@@maketitle\relax
  \normal@text
}
\let\maketitle\relax
\newdimen\t@xtheight
\t@xtheight\textheight \advance\t@xtheight-\splittopskip
\def\open@fm{\global\setbox\fm@box=\vbox\bgroup
  \hsize=\@frontmatterwidth                 % Front matter is page-wide by default
  \centering                                % and centered
  \sv@hyphenpenalty\hyphenpenalty           % (save \hyphenpenalty)
  \hyphenpenalty\@M}                        % and not hyphenated
\def\close@fm{\egroup                       % close \vbox (\fm@box)
  \fm@size=\dp\fm@box \advance\fm@size by \ht\fm@box
  \@whiledim\fm@size>\t@xtheight \do{%
    \global\setbox\@tempboxa=\vsplit\fm@box to \t@xtheight
    \unvbox\@tempboxa \newpage
    \fm@size=\dp\fm@box \advance\fm@size by \ht\fm@box}
  \if@TwoColumn
    \emergencystretch=1pc \twocolumn[\unvbox\fm@box]
  \else
    \unvbox\fm@box
  \fi}
\def\output@glob@notes{\bgroup
  \the\t@glob@notes
  \egroup}
\def\justify@off{\let\\=\@normalcr
  \leftskip\z@ \@rightskip\@flushglue \rightskip\@rightskip}
\def\justify@on{\let\\=\@normalcr
  \leftskip\z@ \@rightskip\z@ \rightskip\@rightskip}
\def\normal@text{\global\let\\=\@normalcr
  \global\leftskip\z@ \global\@rightskip\z@ \global\rightskip\@rightskip
  \global\parfillskip\@flushglue}
\def\@writecount{\write\@mainaux{\string\global
  \string\@namedef{n@author@}{\the\n@author}}%
  \write\@mainaux{\string\global\string
  \@namedef{n@collab@}{\the\n@collab}}}
\def\title#1{%
  \beg@elem
  \title@note@fmt                      % formatting instruction
  \add@tok\t@glob@notes                % for \thanks commands
    {\title@note@fmt}%
  \proc@elem{title}{#1}%
  \def\title@notes{\the\t@loc@notes}%  % store the notes of the title,
  \title@fmt{\@title}{\title@notes}%   % print the title
  \ignorespaces}
\def\subtitle#1{%
  \beg@elem
  \proc@elem{subtitle}{#1}%
  \def\title@notes{\the\t@loc@notes}%  % store the notes of the title,
  \subtitle@fmt{\@subtitle}{\title@notes}% print the title
  \ignorespaces}
\newdimen \@logoheight \@logoheight 5pc
\def\@Lhook{\vrule \@height \@logoheight \@width \z@ \vrule \@height 10\p@ \@width 0.2\p@ \vrule \@height 0.2\p@ \@width 10pt}
\def\@Rhook{\vrule \@height 0.2\p@ \@width 10\p@ \vrule \@height 10\p@ \@width 0.2\p@ \vrule \@height \@logoheight \@width \z@}
\def\title@fmt#1#2{%
\@ifundefined{@runtitle}{\global\def\@runtitle{#1}}{}%
 %\vspace*{\@overtitleskip} % Vertical space above article type,
  \@articletypesize                  % Size for article type
  \leavevmode\vphantom{Aye!}
  \@articletype
  \vskip12\p@
  {\@titlesize #1\,\hbox{$^{#2}$}\par}%
  \vskip\@undertitleskip
  }
\def\subtitle@fmt#1#2{%               % No vertical space above sub-title
  {\@titlesize #1\,\hbox{$^{#2}$}}\par}
\def\title@note@fmt{\def\thefootnote{\fnstar{footnote}}}
\def\author{\@ifnextchar[{\author@optarg}{\author@optarg[]}}
\def\author@optarg[#1]#2{\stepcounter{author}%
  \beg@elem
  \@for\@tempa:=#1\do{\expandafter\add@thanksref\expandafter{\@tempa}}%
  \report@elt{author}\proc@elem{author}{#2}%
  \ifnum0\n@collab@=\z@ \runningauthor@fmt \fi
  \author@fmt{\the\c@author}{\the\t@loc@notes}{\@author}%
}
\def\runningauthor@fmt{%
  \begingroup\no@harm
    \if@firstauthor
      \ifnum0\n@author@ > 2
        \global\edef\@runningauthor{\@author\ et al.}%
      \else
        \global\let\@runningauthor\@author%
      \fi
    \else % \c@author > 1
      \ifnum0\n@author@ = 2
        \global\edef\@runningauthor{\@runningauthor\ \& \noexpand\@author}%
      \fi
    \fi
  \endgroup
}
\def\author@fmt#1#2#3{\@newelemtrue
  \if@firstauthor
  \first@author \global\@firstauthorfalse \fi
  \ifnum\prev@elem=\e@author \global\@newelemfalse \fi
  \if@newelem \author@fmt@init \fi
  \edef\@tempb{#2}\ifx\@tempb\@empty
    \hbox{{\author@font #3}}\else
    \hbox{{\author@font #3}\,$^{\mathrm{#2}}$}%
  \fi}
\def\first@author{\author@note@fmt  % re-define \thefootnote as
                                    % appropriate for author/address
  \add@tok\t@glob@notes
    {\author@note@fmt\@corresp@note}}%
\def\author@fmt@init{%
  \par
  \vskip 8\p@ \@plus 4\p@ \@minus 2\p@
  \@authorsize
  \leavevmode}                        % Vertical space above author list
 \let\and\relax \let\And\and
\def\collab{\@ifstar{\collab@arg}{\collab@arg}}
\let\collaboration=\collab
\def\collab@arg#1{\stepcounter{collab}%
  \if@firstauthor \first@collab \global\@firstauthorfalse \fi
  \gdef\@runningauthor{#1}%
  \beg@elem
  \proc@elem{collab}{#1}%
  \collab@fmt{\the\c@collab}{\the\t@loc@notes}{\@collab}%
  \ignorespaces}
\def\collab@fmt#1#2#3{\@newelemtrue
  \ifnum\prev@elem=\e@collab \global\@newelemfalse \fi
  \if@newelem \collab@fmt@init \fi
  \par                                 % Start new paragraph
  {\large #3\,$^{\mathrm{#2}}$}}
\def\first@collab{
  \collab@note@fmt                     % re-define \thefootnote as
  \add@tok\t@glob@notes                % appropriate for collab/address
    {\collab@note@fmt}}%
\def\collab@fmt@init{\vskip 1em}       % Vertical space above list
\def\author@note@fmt{\setcounter{footnote}{0}%
  \def\thefootnote{\xarabic{footnote}}}
\let\collab@note@fmt=\author@note@fmt
\def\xarabic#1{%
  \expandafter\expandafter\expandafter\ifnum\expandafter\the\@nameuse{c@#1}<0
  *\else\arabic{#1} \fi}
\def\xalph#1{%
  \expandafter\expandafter\expandafter\ifnum\expandafter\the\@nameuse{c@#1}<0
  *\else\alph{#1} \fi}
\def\xfnsymbol#1{%
  \expandafter\expandafter\expandafter\ifnum\expandafter\the\@nameuse{c@#1}<0
  *\else\fnsymbol{#1} \fi}
\def\address{\@ifstar{\address@star}%
  {\@ifnextchar[{\address@optarg}{\address@noptarg}}}
\def\address@optarg[#1]#2{\real@refstepcounter{address}%
  \beg@elem
  \report@elt{address}\proc@elem{address}{#2}%
  \address@fmt{\c@address}{\the\t@loc@notes}{\@address}{#1}%
  \if@Elproofing\else\label{#1}\fi
  \ignorespaces}
\def\address@noptarg#1{\real@refstepcounter{address}%
  \beg@elem
  \proc@elem{address}{#1}%
  \address@fmt{\z@}{\the\t@loc@notes}{\@address}{\theaddress}%
  \ignorespaces}
\def\address@star#1{%
  \beg@elem
  \proc@elem{address}{#1}%
  \address@fmt{\m@ne}{\the\t@loc@notes}{\@address}{*}%
  \ignorespaces}
\def\theaddress{\fnsymbol{address}}
\def\address@fmt#1#2#3#4{\@newelemtrue
  \if@Elproofing\def\@eltag{#4}\else\def\@eltag{\theaddress}\fi
  \ifnum\prev@elem=\e@address \@newelemfalse \fi
  \if@newelem \address@fmt@init \fi
  \noindent \bgroup \@addressstyle
  \ifnum#1=\z@
    #3\,$^{\mathrm{#2}}$\space%
  \else
    \ifnum#1=\m@ne
      $^{\phantom{\mathrm{\@eltag}}}$\space #3\,$^{\mathrm{#2}}$%
    \else
      $^{\mathrm{\@eltag}}\,$#3\,$^{\mathrm{#2}}$%
    \fi
  \fi
  \par \egroup}
\def\address@fmt@init{%
  \par                                % Start new paragraph
  \vskip \@overaddressskip}               % Vertical space before addresses
\def\abstract{\@ifnextchar[{\@abstract}{\@abstract[]}}
\def\@abstract[#1]{%
  \global\@hasabstracttrue
  \hyphenpenalty\sv@hyphenpenalty     % restore \hyphenpenalty
  \global\setbox\t@abstract=\vbox\bgroup
   \@abstractsize                      % Text in 9/11
   \hbox to \textwidth\bgroup\hfill\begin{minipage}{\@abstractwidth}
 \abstractname
\noindent\ignorespaces
}
 \def\endabstract{\end{minipage}\hfill\egroup\egroup}
\def\keyword{%
  \global\@haskeywordstrue             % Implies rules are to be printed
  \hyphenpenalty\sv@hyphenpenalty      % restore \hyphenpenalty
  \def\sep{\unskip, }                  % separator for multiple keywords
  \def\MSC{\par\leavevmode\hbox {\it 1991 MSC:\ }}%
  \def\PACS{\par\leavevmode\hbox {\it PACS:\ }}%
  \global\setbox\t@keyword=\vbox\bgroup
   \hbox to \textwidth\bgroup\hfill\begin{minipage}{\@keywordwidth}
  \@keywordsize
  \parskip\z@
  \vskip 10\p@ \@plus 2\p@ \@minus 2\p@       % One line of space above keywords.
  \noindent\@keywordheading
  \justify@off                         % Keywords are not justified.
  \ignorespaces}
 \def\endkeyword{\end{minipage}\hfill\egroup\egroup}
\def\runtitle#1{\gdef\@runtitle{#1}}
\def\runauthor#1{\gdef\@runauthor{#1}}
\let\@runauthor\relax
\let\@runtitle\relax
\let\@runningauthor\relax
\def\RUNDATE{}
\def\RUNJNL{}
\def\RUNART{}
\def\volume#1{\gdef\@volume{#1}}       \def\@volume{0}
\def\issn#1{\gdef\@issn{#1}}           % defined earlier in this file
\def\issue#1{\gdef\@issue{#1}}         \def\@issue{0}
\newcount\@pubyear
\@pubyear=\number\year
\def\company#1{\def\@company{#1}}
\def\@copyrightyear{\number\year}
\def\@shortenyear#1#2#3#4\\{\global\def\@shortyear{#3#4}}
\expandafter\@shortenyear\the\@pubyear\\
\def\pubyear#1{\global\@pubyear#1
 \expandafter\@shortenyear\the\@pubyear\\%
  \ignorespaces}
\def\copyear#1{%
  \gdef\@copyrightyear{#1}%
  \ignorespaces}
\let\copyrightyear\copyear
\newcounter{firstpage}
\newcounter{lastpage}
\let\ESpagenumber\arabic
\def\firstpage#1{\def\@tempa{#1}\ifx\@tempa\@empty\else
  \setcounter{firstpage}{#1}%
  \global\c@page=#1 \ignorespaces\fi}
\setcounter{firstpage}{1}
\let\realpageref\pageref
\setcounter{lastpage}{0}
\def\lastpage#1{\def\@tempa{#1}\ifx\@tempa\@empty\else
  \setcounter{lastpage}{#1}\ignorespaces\fi
  }
\AtEndDocument{%
   \clearpage
   \addtocounter{page}{-1}%
   \immediate\write\@auxout{%
   \string\global\string\c@lastpage=\the\c@page}%
   \addtocounter{page}{1}%
}
 \def\price#1{\gdef\@price{#1}}
 \def\@price{ - see front matter} %
\def\ssdi#1#2{%
 \gdef\@piiname{PII }%
 \gdef\@pubid{S\expandafter\@@ssdi\@issn(#1)#2\end}%
}
\def\SSDI#1{\gdef\@pubid{\@@ssdi#1\end}}
\def\@@ssdi#1{\ifx#1\end \let\next=\relax
              \else#1\hskip 1\p@ \let\next=\@@ssdi\fi \next}
\def\@pubid{\relax}
\def\PII#1{%
 \gdef\@piiname{PII: }%
 \gdef\@piinum{\@@pii#1\end}}
\def\pii#1#2{%
 \gdef\@piiname{PII: }%
 \gdef\@piinum{S\@issn(#1)#2}%
}
\def\piitrail{\@piiname: \@piinum}
\def\piiname#1{%
 \gdef\spaced@piiname{\protect\letterspace to 1.2\naturalwidth{#1}}%
 \gdef\@piiname{#1}}
\def\piinum#1{%
 \gdef\spaced@piinum{\protect\letterspace to 1.2\naturalwidth{#1}}%
 \gdef\@piinum{#1}}
\def\@piiname{}
\def\@piinum{}
\def\@pubid{\piitrail}
\let\corresp\@gobble
\def\jid#1{%
 \def\@tempa{#1}%
  \ifx\@tempa\@empty
  \else
     \gdef\@jid{#1}%
  \fi
}
\def\@jid{\relax}
\def\convertas#1#2{#2}
\def\aid#1{\def\@tempa{#1}\ifx\@tempa\@empty\else\gdef\@aid{#1}\fi}
  \def\@aid{\relax}
\def\received#1{\def\@tempa{#1}\ifx\@tempa\@empty\else\gdef\@received{#1}\fi}
  \def\@received{\relax}
\def\revised#1{\def\@tempa{#1}\ifx\@tempa\@empty\else\gdef\@revised{#1}\fi}
  \def\@revised{\relax}
\def\accepted#1{\def\@tempa{#1}\ifx\@tempa\@empty\else\gdef\@accepted{#1}\fi}
  \def\@accepted{\relax}
\def\communicated#1{\def\@tempa{#1}\ifx\@tempa\@empty\else\gdef\@communicated{#1}\fi}
  \def\@communicated{\relax}
\def\dedicated#1{\def\@tempa{#1}\ifx\@tempa\@empty\else\gdef\@dedicated{#1}\fi}
  \def\@dedicated{\relax}
\def\presented#1{\def\@tempa{#1}\ifx\@tempa\@empty\else\gdef\@presented{#1}\fi}
  \def\@presented{\relax}
\def\articletype#1{\gdef\@articletype{#1}}
  \@ifundefined{@articletype}{\def\@articletype{}}{}
\def\received@prefix{Received~}
\def\revised@prefix{; revised~}
\def\accepted@prefix{; accepted~}
\def\communicated@prefix{; communicated~by~}
\def\history@prefix{}
\def\received@postfix{}
\def\revised@postfix{}
\def\accepted@postfix{}
\def\communicated@postfix{}
\def\history@postfix{}
\def\receivedprefix#1{\gdef\received@prefix{#1}}
\def\revisedprefix#1{\gdef\revised@prefix{#1}}
\def\acceptedprefix#1{\gdef\accepted@prefix{#1}}
\def\communicatedprefix#1{\gdef\communicated@prefix{#1}}
\def\historyprefix#1{\gdef\history@prefix{#1}}
\def\receivedpostfix#1{\gdef\received@postfix{#1}}
\def\revisedpostfix#1{\gdef\revised@postfix{#1}}
\def\acceptedpostfix#1{\gdef\accepted@postfix{#1}}
\def\communicatedpostfix#1{\gdef\communicated@postfix{#1}}
\def\historypostfix#1{\gdef\history@postfix{#1}}
\def\empty@data{\relax}
\def\history@fmt{%
  \bgroup
  \@historysize
  \vskip 6\p@ \@plus 2\p@ \@minus 1\p@         % Vertical space above history
  \ifx\@received\empty@data \else       % If there is no \received,
                                        % do not print anything
    \leavevmode
    \history@prefix
    \received@prefix\@received \received@postfix%
    \ifx\@revised\empty@data \else
      \revised@prefix\@revised \revised@postfix%
    \fi
    \ifx\@accepted\empty@data \else
      \accepted@prefix\@accepted \accepted@postfix%
    \fi
    \ifx\@communicated\empty@data \else
      \communicated@prefix\@communicated \communicated@postfix%
    \fi
    \history@postfix
  \fi
  \par \egroup}
\def\dedicated@fmt{%
  \ifx\@dedicated\empty@data \else
    \vskip 4\p@ \@plus 3\p@
    \normalsize\it\centering \@dedicated
    \fi}
\def\@alph#1{\ifcase#1\or a\or b\or c\or d\or e\or f\or g\or h\or i\or j\or
k\or \ell\or m\or n\or o\or p\or q\or r\or s\or t\or u\or v\or w\or x\or
y\or z\or aa\or ab\or ac\or ad\or ae\or af\or ag\or ah\or ai\or aj\or
ak\or a\ell\or am\or an\or ao\or ap\or aq\or ar\or as\or at\or au\or av\or
aw\or ay\or az\or ba\or bb\or bc\or bd\or be\or bf\or bg\or bh\or bi\or
bj\or bk\or b\ell\or bm\or bn\or bo\or bp\or bq\or br\or bs\or bt\or
bu\or bw\or bx\or by\or bz\or ca\or cb\or cc\or cd\or ce\or cf\or cg\or
ch\or ci\or cj\or ck\or c\ell\or cm\or cn\or co\or cp\or cq\or cr\or
cs\or ct\or cu\or cw\or cx\or cy\or cz\or da\or db\or dc\or dd\or de\or df\or dg\or dh\or di\or dj\or dk\or
d\ell\or dm\or dn\or do\or dp\or dq\or dr\or ds\or dt\or du\or dw\or
dx\or dy\or dz\or ea\or eb\or ec\or ed\or ee\or ef\or eg\or eh\or
ei\or ej\or ek\or e\ell\or em\or en\or eo\or ep\or eq\or er\or es\or
et\or eu\or ew\or ex\or ey\or ez\else\@ctrerr\fi}
\def\fnstar#1{\@fnstar{\@nameuse{c@#1}}}
\def\@fnstar#1{\ifcase#1\or
    \hbox{$\star$}\or
    \hbox{$\star\star$}\or
    \hbox{$\star\star\star$}\or
    \hbox{$\star\star\star\star$}\or
    \hbox{$\star\star\star\star\star$}\or
    \hbox{$\star\star\star\star\star\star$}
  \else
    \@ctrerr
  \fi
  \relax}
\mark{{}{}}   % Initializes TeX's marks
\def\ps@plain{\let\@mkboth\@gobbletwo
 \def\@oddhead{}%
 \def\@evenhead{}%
 \def\@oddfoot{\hfil {\rmfamily\thepage} \hfil}%
 \let\@evenfoot\@oddfoot}
\def\@triple#1#2#3{\vtop{%
  \hbox to \textwidth{\strut \rlap{#1} \hfil {#2} \hfil \llap{#3}}}}
\def\@nonuple#1#2#3#4#5#6#7#8#9{\vtop{%
  \hbox to \textwidth{\strut \rlap{#1} \hfil {#2} \hfil \llap{#3}}%
  \hbox to \textwidth{\strut \rlap{#4} \hfil {#5} \hfil \llap{#6}}%
  \hbox to \textwidth{\strut \rlap{#7} \hfil {#8} \hfil \llap{#9}}}}
\def\@copyright{\@issn/\@shortyear/\$\@price\ $\copyright$\ \the\@pubyear\
  \@company{} All  rights reserved}
\def\@jou@vol@pag{\@journal\ \@volume\ (\the\@pubyear)\ \@pagerange}
\def\sectionmark#1{}
\def\subsectionmark#1{}
\let\@j@v@p\@jou@vol@pag    % long journal title appears in reprint line
\let\@@j@v@p\@jou@vol@pag   % long journal title appears in running headline
\def\sectionmark#1{}
\def\subsectionmark#1{}
\def\ps@headings{%
 \let\@mkboth\@gobbletwo
 \def\@oddhead{\hfill \@runtitle \hfill \thepage}%
 \def\@evenhead{\thepage\hfill \@runauthor\hfill}%
 \def\@oddfoot{}%
 \def\@evenfoot{}}
\def\ps@copyright{\let\@mkboth\@gobbletwo
  \def\@oddhead{\@logohead}
  \let\@evenhead\@oddhead
  \def\@oddfoot{\hfill{\fontsize{8}{9\p@}\selectfont\@pagenumprefix\thepage}\hfill}
  \let\@evenfoot\@oddfoot
}
\def\@logohead{%
\bgroup
\@catchlinesize
\savebox{\@tempboxa}{\vbox {%
\hbox to \textwidth{\hfill
\emph{\@shortjnl}, Vol.\  \@volume, No.\ \@issue,
 pp.\ \@pagerange, \the\@pubyear}%
\hbox to \textwidth{\hspace{1.5cm}{\@pergamonsize\textbf{Pergamon}}
\hfill \FullCopyrightText}%
\hbox to \textwidth{%
\raisebox{0pt}[0pt][0pt]{\includegraphics[height=\@Colofonheight]{colofon}}%
\hfill Printed in Great Britain}%
\hbox to \textwidth{\hfill {\small\bfseries
 \@pubid \hfill}\llap{\@issn/\@shortyear\ \$\@price}}%
}}%
\box\@tempboxa
\egroup
}
\def\ps@pergamon{%
 \let\@mkboth\@gobbletwo
 \def\@oddhead{{\@runheadsize\hfill \@runtitle \hfill \thepage}}%
 \def\@evenhead{{\@runheadsize\thepage\hfill \@runauthor \hfill}}%
 \def\@oddfoot{}%
 \def\@evenfoot{}}
\pagestyle{pergamon}
\def\today{\number\day\space\ifcase\month\or
  January\or February\or March\or April\or May\or June\or
  July\or August\or September\or October\or November\or December\fi
  \space\number\year}
\def\nuc#1#2{\relax\ifmmode{}^{#1}{\protect\text{#2}}\else${}^{#1}$#2\fi}
\def\itnuc#1#2{\setbox\@tempboxa=\hbox{\scriptsize\it #1}
  \def\@tempa{{}^{\box\@tempboxa}\!\protect\text{\it #2}}\relax
  \ifmmode \@tempa \else $\@tempa$\fi}
\let\old@vec\vec % save old definition of \vec
\def\pol#1{\old@vec{#1}}
\def\@bfvec#1{\boldsymbol{#1}}
\def\@pmbfvec#1{\pmb{#1}}
\def\undo@AMS{\global\let\vec\@bfvec}
\def\half{{\textstyle\frac{1}{2}}}
\def\threehalf{{\textstyle\frac{3}{2}}}
\def\quart{{\textstyle\frac{1}{4}}}
 \def\espfrac#1#2{\frac{\displaystyle #1}{\displaystyle #2}}
\def\d{\,\mathrm{d}}
\def\e{\mathop{\mathrm{e}}\nolimits}
\def\int{\intop}
\def\oint{\ointop}
\newbox\slashbox \setbox\slashbox=\hbox{$/$}
\newbox\Slashbox \setbox\Slashbox=\hbox{\large$/$}
\def\pFMslash#1{\setbox\@tempboxa=\hbox{$#1$}
  \@tempdima=0.5\wd\slashbox \advance\@tempdima 0.5\wd\@tempboxa
  \copy\slashbox \kern-\@tempdima \box\@tempboxa}
\def\pFMSlash#1{\setbox\@tempboxa=\hbox{$#1$}
  \@tempdima=0.5\wd\Slashbox \advance\@tempdima 0.5\wd\@tempboxa
  \copy\Slashbox \kern-\@tempdima \box\@tempboxa}
\def\FMslash{\protect\pFMslash}
\def\FMSlash{\protect\pFMSlash}
  \def\Cset{\mathbb{C}}
  \def\Hset{\mathbb{H}}
  \def\Nset{\mathbb{N}}
  \def\Qset{\mathbb{Q}}
  \def\Rset{\mathbb{R}}
  \def\Zset{\mathbb{Z}}
\if@TwoColumn
  \adjdemerits=100
  \linepenalty=100
  \doublehyphendemerits=5000        % experimental (1993-12-14)
  \emergencystretch=1.6pc
  \spaceskip=0.3em \@plus 0.17em \@minus 0.12em
\fi
\binoppenalty=300
\relpenalty=100
\clubpenalty=5000                % 'Club line'  at bottom of page.
\widowpenalty=2000               % 'Widow line' at top of page.
\displaywidowpenalty=1000        % Math display widow line.
\predisplaypenalty=150           % Breaking before a math display.
\postdisplaypenalty=50           % Breaking after a math display.
\hfuzz=1\p@
\hbadness=3000
\@frontmatterwidth\textwidth
 \let\pldots\dots
\ps@headings                                % 'headings' page style
\pagenumbering{arabic}                      % Arabic page numbers
\def\thepage{\@pagenumprefix\ESpagenumber{page}}  % preceded by \@pagenumprefix
\InputIfFileExists{\@shortjid.cfg}{}{}
%%
%% End of file `public.cls'.
\setcounter{secnumdepth}{5}
\pretolerance=700
\tolerance=2000
\hbadness=4000
\vbadness=4000
\hyphenpenalty=400
\relpenalty=500
\widowpenalty=10000
\clubpenalty=10000
\def\@Point#1#2{%
 \fontsize{#1}{#2\p@}\selectfont
}
\long\def\@maketablecaption#1#2{\@tablecaptionsize
  \sbox\@tempboxa{\@fignumfont{#1}. #2}%
  \ifdim \wd\@tempboxa > \captionwidth
    \begin{center}
    \begin{minipage}{\captionwidth}
    \leftskip    0pt plus  0.5fil
    \rightskip   0pt plus -0.5fil
    \parfillskip 0pt plus  1fil
    \@fignumfont{#1}. #2\par
    \end{minipage}
    \end{center}
  \else
    \hbox to\hsize{\hfil\box\@tempboxa\hfil}%
  \fi
  \vskip8\p@
}
\long\def\@makefigurecaption#1#2{\@figurecaptionsize
  \vskip \@overcaptionskip
  \sbox\@tempboxa{\@fignumfont{#1}. #2}%
  \ifdim \wd\@tempboxa > \captionwidth
    \begin{center}
    \begin{minipage}{\captionwidth}
    \leftskip    0pt plus  0.5fil
    \rightskip   0pt plus -0.5fil
    \parfillskip 0pt plus  1fil
    \@fignumfont{#1}. #2\par
    \end{minipage}
    \end{center}
  \else
    \hbox to\hsize{\hfil\box\@tempboxa\hfil}%
  \fi
  \vskip8\p@
}
\def\AND{ \& }
\def\author@mark#1{$^{\mathrm{#1}}$}
\def\author@fudge#1{#1}
\def\etal{et al.}
\def\l@paragraph{\@dottedtocline{4}{4.0em}{3.5em}}
\def\l@subparagraph{\@dottedtocline{5}{5em}{3.5em}}
\def\@dotsep{2000}
\def\@fnsymbol#1{\ifcase#1\or *\or \dagger\or \ddagger\or
   \mathchar "278\or \mathchar "27B\or \|\or **\or \dagger\dagger
   \or \ddagger\ddagger \else\@ctrerr\fi}
\def\newblock{}
\let\printhistory\relax
\textwidth182mm                % WAS 159 PMISRA
\textheight245mm               % WAS 252 PMISRA
% SP 2001/08/07 text vertically centered on the page
\voffset=-12.5mm               % VOFFSET
% SP 2001/08/07 new value: 125mm
%\def\@abstractwidth{146mm}     % WAS 125 PMISRA
\def\@abstractwidth{.8\textwidth}
\@frontmatterwidth\@abstractwidth
\def\@keywordwidth{\@abstractwidth}
\columnsep5mm                % WAS .3 IN PMISRA
\def\@captionsize{\normalsize}
\def\@abstractsize{\normalsize}
\def\@articletypesize{\normalsize}
\def\@historysize{\normalsize}
\def\@keywordsize{\normalsize}
\def\@keywordheading{{\itshape Keywords: }}
\def\abstractname{{\bfseries {Abstract: }}}  % Abstract Bold PMISRA 2007-05-30
\def\@bibliosize{\normalsize}
\historyprefix{(\bgroup \itshape}
\historypostfix{\egroup)}
\def\@titlesize{\@Point{14}{16}\bfseries}
\def\@addressstyle{\normalsize\itshape}
\def\@authorsize{\normalsize}
\def\author@font{\upshape\bfseries}
\def\@overtitleskip{0in}	% WAS 1IN PMISRA
% SP 2001/08/07 new value: 4\@bls - 10\p@ + 4\p@
\def\@belowfmskip{12\p@}   %WAS 42 PMISRA 2007-05-30
% SP 2001/08/07 new value: 1\@bls - 10\p@ + 4\p@
\def\@overkeywordskip{6pt}
\def\subsubsection{\@startsection{subsubsection}{3}{\z@}{0.3\@bls
  \@plus .2\@bls}{-1em}{\normalsize\itshape}}	% WAS \@bls PMISRA 2007-05-30
\def\section{\@startsection{section}{1}{\z@}
 {6\p@ \@plus 0.5\@bls \@minus 4\p@}		% WAS 18 PMISRA 2007-05-30
 {6\p@ \@plus 1\p@ \@minus 2\p@}
 {\centering}}
\def\subsection{\@startsection{subsection}{2}{\z@}
 {6\p@ \@plus 0.5\@bls \@minus 4\p@}		% WAS 18 PMISRA 2007-05-30
 {6\p@ \@plus 1\p@ \@minus 2\p@}
 {\itshape}}
\parindent0em
\parskip 6pt
\def\head@style{\interlinepenalty\@M
  \hyphenpenalty\@M \exhyphenpenalty\@M
  }
% SP 2001/08/07 use the previous definition
% \def\thebibliography{\section{REFERENCES}\@thebibliography}
\long\def\@makefigurecaption#1#2{%
  \vskip 8\p@
   \par\hangindent2em\@fignumfont{#1}. #2\par
}
\def\lb@subsection{\thesubsection\half@em}
\def\@fnsymbol#1{\ifcase#1\or *\or **\or *** \or **** \or \dagger\or \ddagger
\or\S\or| \or \ddagger\ddagger \else\@ctrerr\fi\relax}
\def\@price{09.50  $+$ 0.00}
\def\footnoterule{\kern-3\p@
  \hrule \@width 2in
  \kern 3\p@}			% WAS 12 PMISRA 2007-05-30
\let\oldaddress@fmt\address@fmt
\def\address@fmt#1#2#3#4{%
\bgroup
\parskip\z@
\oldaddress@fmt{#1}{#2}{#3}{#4}%
\egroup
}
\def\address@fmt@init{%
 \par
 \vskip 12\p@}  %WAS 24 PMISRA
\advance\topskip by -8mm
\@twocolumntrue\@TwoColumntrue
% SP 2002/04/18 set the mathindent right after specifying twocolumn output
\mathindent=0em
\def\ps@ifacconf{%
 \let\@mkboth\@gobbletwo
 \def\@oddhead{}%
 \def\@evenhead{}%
 \def\@oddfoot{}%
 \def\@evenfoot{}}
\pagestyle{ifacconf}
\def\ps@copyright{\let\@mkboth\@gobbletwo
  \def\@oddhead{\@logohead}
  \let\@evenhead\@oddhead
  \def\@oddfoot{}\let\@evenfoot\@oddfoot
}
\newif\ifNAT@numbers
\AtBeginDocument{%
\@ifpackageloaded{harvard}{}{
  \RequirePackage{natbib}
  %\bibliographystyle{plainnat}
  \bibliographystyle{ifacconf}
}}
\@bsphack
\AtEndDocument
  {\immediate\write\@auxout{\string\global\string\NAT@numbersfalse}}
\def\@logohead{%
\bgroup
\footnotesize
\savebox{\@tempboxa}{\vtop {%
\hbox to \textwidth{}%
\hbox to \textwidth{}%
\hbox to \textwidth{}%
\hbox to \textwidth{}%
\hbox to \textwidth{}%
}}%
\box\@tempboxa
\egroup
}
\let\oldtitle@fmt\title@fmt
\def\title@fmt#1#2{%
 % SP 2000/03/16 use LaTeX's \MakeUppercase
 % \oldtitle@fmt{\MakeUppercase{#1}}{#2}%
 \oldtitle@fmt{#1}{#2}%
}
\def\head@format#1#2{%
 % SP 2000/03/16 use LaTeX's \MakeUppercase
 \ifnum #1>1 #2 \else \MakeUppercase{#2}\fi
}
\newdimen\@frontindent
\@frontindent\textwidth
\advance\@frontindent by -\@frontmatterwidth
\def\open@fm{%
\global\setbox\fm@box=\vbox\bgroup
  \centering
  \leftskip\@frontindent \@plus 1fil
  \hsize\@frontmatterwidth
  \sv@hyphenpenalty\hyphenpenalty           % (save \hyphenpenalty)
  \hyphenpenalty\@M}                        % and not hyphenated
% SP 2001/08/07 Removed the new definition of \close@fm
\endinput
%%
%% End of file `ifacconf.cls'.
