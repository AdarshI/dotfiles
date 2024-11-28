local ls = require("luasnip")
-- some shorthands...
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local l = require("luasnip.extras").lambda
local rep = require("luasnip.extras").rep
local p = require("luasnip.extras").partial
local m = require("luasnip.extras").match
local n = require("luasnip.extras").nonempty
local dl = require("luasnip.extras").dynamic_lambda
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local types = require("luasnip.util.types")
local conds = require("luasnip.extras.expand_conditions")
local postfix = require("luasnip.extras.postfix").postfix

local function is_math()
  return vim.fn["vimtex#syntax#in_mathzone"]() == 1
end

local parse_snippet = ls.extend_decorator.apply(ls.parser.parse_snippet, {wordTrig = false, condition = is_math})

local rec_ls
rec_ls = function()
	return sn(nil, {
		c(1, {
			-- important!! Having the sn(...) as the first choice will cause infinite recursion.
			t({""}),
			-- The same dynamicNode as in the snippet (also note: self reference).
			sn(nil, {t({"", "\t\\item "}), i(1), d(2, rec_ls, {})}),
		}),
	});
end

-- generating function
local mat = function(args, snip)
	local rows = tonumber(snip.captures[2])
	local cols = tonumber(snip.captures[3])
	local nodes = {}
	local ins_indx = 1
	for j = 1, rows do
		table.insert(nodes, r(ins_indx, tostring(j) .. "x1", i(1)))
		ins_indx = ins_indx + 1
		for k = 2, cols do
			table.insert(nodes, t(" & "))
			table.insert(nodes, r(ins_indx, tostring(j) .. "x" .. tostring(k), i(1)))
			ins_indx = ins_indx + 1
		end
		table.insert(nodes, t({ " \\\\", "" }))
	end
	-- fix last node.
	nodes[#nodes] = t(" \\\\")
	return sn(nil, nodes)
end

ls.add_snippets(nil, {
  tex = {
	------------------------------------------------------------
	-----------------------Math Environments--------------------
	------------------------------------------------------------
	s({ trig = 'mk', name = "Math", snippetType = "autosnippet"},
		fmta("\\( <> \\)", {i(1)})),

	s({ trig = 'dm', name = "Block Math" , snippetType = "autosnippet"},
		fmta([[
		\[
			<>
		.\]
		]], {i(1)})),

	s({ trig = 'ali', name="Align" },
		fmta([[
		\begin{align*}
			<>
		\end{align*}
		]], {i(1)})),

	s({ trig = 'gat', name="Gather" },
		fmta([[
		\begin{gather*}
			<>
		\end{gather*}
		]], {i(1)})),

	s({ trig = 'beg', name = "begin / end"},
		fmta([[
		\begin{<>}
			<>
		\end{<>}
		]], {i(1), i(2), rep(1)})),

	s({ trig = 'case', name='Cases' },
		fmta([[
		\begin{cases}
			<>
		\end{cases}
		]], i(1))),

	s({ trig = "bigfun", name = "Big function" },
		fmta([[
		\begin{align*}
			<> : <> &\longrightarrow <> \\
			    <> &\longmapsto <>(<>) = <>
		.\end{align*}
		]], {
			i(1, "f"),
			i(2, "A"),
			i(3, "B"),
			i(4, "x"),
			rep(1),
			rep(4),
			i(5, "rule")
		})),

	------------------------------------------------------------
	---------------------------Headers--------------------------
	------------------------------------------------------------

	--homework
	s('homework', fmta([[
		\documentclass[12pt,letterpaper]{article}
		\input{../../preamble.tex}
		\usepackage{tcolorbox}
		%https://osl.ugr.es/CTAN/macros/latex/contrib/tcolorbox/tcolorbox.pdf
		\tcbuselibrary{breakable}
		\tcbset{%any default parameters
			width=0.7\textwidth,
			halign=justify,
			center,
			breakable,
			colback=white,
			parbox=false
		}

		\fancypagestyle{homework_template}{
			\fancyhf{}
			\lhead{\large
				Adarsh Iyer \\
				<>
			}
			\cfoot{\large\thepage\\}
			\rhead{\large
				<> \\
				<>
			}
			\renewcommand{\headrulewidth}{4pt}% 2pt header rule
		}
		\pagestyle{homework_template}
		\setlength{\parindent}{0pt}

		\renewenvironment{problem}[1]{\textbf{\Large #1}\par\nobreak\ignorespaces}{}
		\newenvironment{solution}{\textbf{Solution}}{}

		\onehalfspacing
		\begin{document}
		<>

		\end{document}
	]], {
		i(1, "Date"),
		i(2, "Course"),
		i(3, "Assignment"),
		i(0)
	})),

	--title
	s('title', fmta([[
	\title{\textbf{<>: <>}}
	\author{Professor: <>\\ Adarsh Iyer}
	\date{<>, <>}
	\pagebreak
	]], {
		i(1, "Course Number"),
		i(2, "Course Title"),
		i(3),
		i(4, "Semester"),
		i(5, "University of Berkeley-California")
	})),

	---------------------------------------------------------
	-------------------------Blocks--------------------------
	---------------------------------------------------------

	s("itemize::", {
      t({"\\begin{"}),
      c(1, {t"itemize", t"enumerate"}),
      t{"}", ""},
      t({"\t\\item "}), i(2), d(2, rec_ls, {}),
      t({"", "\\end{"}),
      rep(1),
      t("}"),
      i(0)
    }),

		s({ trig = "([bBpvV])mat(%d+)x(%d+)([ar])", regTrig = true, name = "matrix", dscr = "matrix trigger lets go", hidden = true },
		fmt([[
		\begin{<>}<>
		<>
		\end{<>}]],
		{f(function(_, snip)
			return snip.captures[1] .. "matrix" -- captures matrix type
		end),
		f(function(_, snip)
			if snip.captures[4] == "a" then
				local out = string.rep("c", tonumber(snip.captures[3]) - 1) -- array for augment
				return "[" .. out .. "|c]"
			end
			return "" -- otherwise return nothing
		end),
		d(1, mat),
		f(function(_, snip)
			return snip.captures[1] .. "matrix" -- i think i could probably use a repeat node but whatever
		end),},
		{ delimiters = "<>" }),
		{ condition = is_math, show_condition = is_math }
		),


	s({trig = "mcal",	wordTrig = false, name = "mathcal",			snippetType="autosnippet"}, fmta("\\mathcal{<>}", {i(1)}),	{condition = is_math}),
	s({trig = "mbb",	wordTrig = false, name = "mathbb",			snippetType="autosnippet"}, fmta("\\mathbb{<>}", {i(1)}),	{condition = is_math}),
	s({trig = "mbf",	wordTrig = false, name = "mathbf",			snippetType="autosnippet"}, t"\\mathbf",	{condition = is_math}),
	s({trig = "mfrk",	wordTrig = false, name = "mathfrak",			snippetType="autosnippet"}, fmta("\\mathfrak{<>}", {i(1)}),	{condition = is_math}),

	s({trig = "ooo",	wordTrig = false, name = "infinity",		snippetType="autosnippet"}, t"\\infty",	{condition = is_math}),
	s({trig = "cinf",	wordTrig = false, name = "C infinity",		snippetType="autosnippet"}, fmta("C^\\infty(<>)", {i(1)}),	{condition = is_math}),

  parse_snippet({trig = "rij",	name = "mrij" }, "(${1:x}_${2:n})_{${3:$2}\\in${4:\\N}}$0"),

	s({trig = "//",	 	wordTrig = false, name = "fraction",		snippetType="autosnippet"}, fmta("\\frac{<>}{<>}", {i(1), i(2)}), {condition = is_math}),
	s({trig = "??",	 	wordTrig = false, name = "display fraction",		snippetType="autosnippet"}, fmta("\\dfrac{<>}{<>}", {i(1), i(2)}), {condition = is_math}),

	s({trig = "))",  	wordTrig = false, name = "parenthesis",		snippetType="autosnippet"}, fmta("\\left( <> \\right)",   {i(1)}),	{condition = is_math}),

	s({trig = "simp", 	wordTrig = false, name = "short implies",			snippetType="autosnippet"}, t"\\Rightarrow",		{condition = is_math}),
	s({trig = "imp", 	wordTrig = false, name = "implies",			snippetType="autosnippet"}, t"\\implies",		{condition = is_math}),

	s({trig = "stt", 	wordTrig = false, name = "text subscript",	snippetType="autosnippet"}, fmta("_\\text{<>}", {i(1)}),	{condition = is_math}),
	s({trig = "tt",  	wordTrig = false, name = "text",		snippetType="autosnippet"}, fmta("\\text{<>}", {i(1)}),	{condition = is_math}),

	s({trig = "XX",  	wordTrig = false, name = "cross",		snippetType="autosnippet"}, t"\\times",	{condition = is_math}),
	s({trig = "**",  	wordTrig = false, name = "cdot",		snippetType="autosnippet"}, t"\\cdot",	{condition = is_math}),
	s({trig = "...",  	wordTrig = false, name = "ldots",		snippetType="autosnippet"}, t"\\ldots",	{condition = is_math}),

	s({trig = "inn", 	wordTrig = false, name = "in",			snippetType="autosnippet"}, t"\\in",		{condition = is_math}),
	s({trig = "notin", 	wordTrig = false, name = "not in",		snippetType="autosnippet"}, t"\\notin", {condition = is_math}),

	s({trig = "EE",  	wordTrig = false, name = "there exists",	snippetType="autosnippet"}, t"\\exists",	{condition = is_math}),
	s({trig = "AA",  	wordTrig = false, name = "for all",		snippetType="autosnippet"}, t"\\forall",	{condition = is_math}),

	s({trig = "ZZ",  	wordTrig = false, name = "Integers",		snippetType="autosnippet"}, t"\\mathbb{Z}",	{condition = is_math}),
	s({trig = "QQ",  	wordTrig = false, name = "Rationals",		snippetType="autosnippet"}, t"\\mathbb{Q}",	{condition = is_math}),
	s({trig = "RR",  	wordTrig = false, name = "Reals",		snippetType="autosnippet"}, t"\\mathbb{R}",	{condition = is_math}),
	s({trig = "CC",  	wordTrig = false, name = "Complex",		snippetType="autosnippet"}, t"\\mathbb{C}",	{condition = is_math}),
	s({trig = "PP",  	wordTrig = false, name = "Projective Space",		snippetType="autosnippet"}, t"\\mathbb{P}",	{condition = is_math}),

	s({trig = "dint",		wordTrig = false, name = "integral", snippetType="autosnippet"},
			fmta("\\int_{<>}^{<>} <> \\,\\dd <>", {i(1, "-\\infty"), i(2, "\\infty"), i(4), i(3, 'x')}), {condition = is_math}),

	s({trig = "UUU",  	wordTrig = false, name = "big union",		snippetType="autosnippet"},
			fmta("\\bigcup_{<>}^{<>}", {i(1, "i=1"), i(2, "n")}),	{condition = is_math}),
	s({trig = "NNN",  	wordTrig = false, name = "big intersection",	snippetType="autosnippet"},
			fmta("\\bigcap_{<>}^{<>}", {i(1, "i=1"), i(2, "n")}),	{condition = is_math}),

	s({trig = "UN",  	wordTrig = false, name = "set union",		snippetType="autosnippet"}, t"\\cup",	{condition = is_math}),
	s({trig = "IN",  	wordTrig = false, name = "set intersection",	snippetType="autosnippet"}, t"\\cap",	{condition = is_math}),

	s({trig = "sst", 	wordTrig = false, name = "subset",		snippetType="autosnippet"}, t"\\subset",	{condition = is_math}),
	s({trig = "cnn", 	wordTrig = false, name = "contains",		snippetType="autosnippet"}, t"\\supset",	{condition = is_math}),

	s({trig = "td",  	wordTrig = false, name = "to the _ power",	snippetType="autosnippet"}, fmta("^{<>}",   {i(1)}),	{condition = is_math}),
	s({trig = "rd",  	wordTrig = false, name = "(_) derivative",	snippetType="autosnippet"}, fmta("^{(<>)}", {i(1)}),	{condition = is_math}),
	s({trig = "__",  	wordTrig = false, name = "subscript",		snippetType="autosnippet"}, fmta("_{<>}",   {i(1)}),	{condition = is_math}),
	s({trig = "sqrt", 	wordTrig = false, name = "square root",	snippetType="autosnippet"}, fmta("\\sqrt{<>}", {i(1)}),	{condition = is_math}),
	s({trig = "nrt", 	wordTrig = false, name = "nth root",	snippetType="autosnippet"}, fmta("\\sqrt[<>]{<>}", {i(1, 'n'), i(2)}),	{condition = is_math}),
	s({trig = "lim", 	wordTrig = false, name = "limit",	snippetType="autosnippet"}, fmta("\\lim_{<> \\to <>}", {i(1, "x"), i(2, "infinity")}),	{condition = is_math}),

	s({trig = "xnn", wordTrig = false, name = "x sub n", snippetType="autosnippet"}, t"x_n", {condition = is_math}),
	s({trig = "ynn", wordTrig = false, name = "y sub n", snippetType="autosnippet"}, t"y_n", {condition = is_math}),
	s({trig = "xmm", wordTrig = false, name = "x sub m", snippetType="autosnippet"}, t"x_m", {condition = is_math}),
	s({trig = "ymm", wordTrig = false, name = "y sub m", snippetType="autosnippet"}, t"y_m", {condition = is_math}),

	s({trig = "sr",  	wordTrig = false, name = "squared",		snippetType="autosnippet"}, t"^2",	  {condition = is_math}),
	s({trig = "cb",  	wordTrig = false, name = "cubed",		snippetType="autosnippet"}, t"^3",	  {condition = is_math}),
	s({trig = "invs", 	wordTrig = false, name = "inverse",		snippetType="autosnippet"}, t"^{-1}", {condition = is_math}),
	s({trig = "comp", 	wordTrig = false, name = "set complement",	snippetType="autosnippet"}, t"^{c}",	{condition = is_math}),
	s({trig = "trn", 	wordTrig = false, name = "transpose",		snippetType="autosnippet"}, t"^T", {condition = is_math}),

	s({trig = ">=",  	wordTrig = false, name = "greater equal",	snippetType="autosnippet"}, t"\\geq", {condition = is_math}),
	s({trig = "<=",  	wordTrig = false, name = "lesser equal",	snippetType="autosnippet"}, t"\\leq", {condition = is_math}),
	s({trig = "<<",  	wordTrig = false, name = "much less",		snippetType="autosnippet"}, t"\\ll",  {condition = is_math}),
	s({trig = ">>",  	wordTrig = false, name = "much greater",	snippetType="autosnippet"}, t"\\gg",  {condition = is_math}),
	s({trig = "~~",  	wordTrig = false, name = "similar",			snippetType="autosnippet"}, t"\\sim", {condition = is_math}),
	s({trig = "~=",  	wordTrig = false, name = "approximately equal",			snippetType="autosnippet"}, t"\\approx", {condition = is_math}),

  }
})
