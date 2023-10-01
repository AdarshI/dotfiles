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

	s({trig = "mcal",	wordTrig = false, name = "mathcal",			snippetType="autosnippet"}, fmta("\\mathcal{<>}", {i(1)}),	{condition = is_math}),

	s({trig = "ooo",	wordTrig = false, name = "infinity",		snippetType="autosnippet"}, t"\\infty",	{condition = is_math}),

	s({trig = "//",	 	wordTrig = false, name = "fraction",		snippetType="autosnippet"}, fmta("\\frac{<>}{<>}", {i(1), i(2)}), {condition = is_math}),

	s({trig = "))",  	wordTrig = false, name = "parenthesis",		snippetType="autosnippet"}, fmta("\\left( <> \\right)",   {i(1)}),	{condition = is_math}),

	s({trig = "stt", 	wordTrig = false, name = "text subscript",	snippetType="autosnippet"}, fmta("_\\text{<>}", {i(1)}),	{condition = is_math}),
	s({trig = "tt",  	wordTrig = false, name = "text",		snippetType="autosnippet"}, fmta("\\text{<>}", {i(1)}),	{condition = is_math}),

	s({trig = "xx",  	wordTrig = false, name = "cross",		snippetType="autosnippet"}, t"\\times",	{condition = is_math}),
	s({trig = "**",  	wordTrig = false, name = "cdot",		snippetType="autosnippet"}, t"\\cdot",	{condition = is_math}),
	s({trig = "...",  	wordTrig = false, name = "ldots",		snippetType="autosnippet"}, t"\\ldots",	{condition = is_math}),

	s({trig = "inn", 	wordTrig = false, name = "in",			snippetType="autosnippet"}, t"\\in",		{condition = is_math}),
	s({trig = "notin", 	wordTrig = false, name = "not in",		snippetType="autosnippet"}, t"\\notin", {condition = is_math}),

	s({trig = "EE",  	wordTrig = false, name = "there exists",	snippetType="autosnippet"}, t"\\exists",	{condition = is_math}),
	s({trig = "AA",  	wordTrig = false, name = "for all",		snippetType="autosnippet"}, t"\\forall",	{condition = is_math}),

	s({trig = "UU",  	wordTrig = false, name = "big union",		snippetType="autosnippet"}, fmta("\\bigcup_{<>}^{<>}", {i(1, "i=1"), i(2, "n")}),	{condition = is_math}),
	s({trig = "NN",  	wordTrig = false, name = "big intersection",	snippetType="autosnippet"}, fmta("\\bigcap_{<>}^{<>}", {i(1, "i=1"), i(2, "n")}),	{condition = is_math}),

	s({trig = "UN",  	wordTrig = false, name = "set union",		snippetType="autosnippet"}, t"\\cup",	{condition = is_math}),
	s({trig = "IN",  	wordTrig = false, name = "set intersection",	snippetType="autosnippet"}, t"\\cap",	{condition = is_math}),
	s({trig = "cc", 	wordTrig = false, name = "set complement",	snippetType="autosnippet"}, t"^{c}",	{condition = is_math}),

	s({trig = "sbst", 	wordTrig = false, name = "subset",		snippetType="autosnippet"}, t"\\subset",	{condition = is_math}),
	s({trig = "cont", 	wordTrig = false, name = "contains",		snippetType="autosnippet"}, t"\\supset",	{condition = is_math}),

	s({trig = "td",  	wordTrig = false, name = "to the _ power",	snippetType="autosnippet"}, fmta("^{<>}",   {i(1)}),	{condition = is_math}),
	s({trig = "rd",  	wordTrig = false, name = "to the _ power",	snippetType="autosnippet"}, fmta("^{(<>)}", {i(1)}),	{condition = is_math}),
	s({trig = "__",  	wordTrig = false, name = "subscript",		snippetType="autosnippet"}, fmta("_{<>}",   {i(1)}),	{condition = is_math}),
	s({trig = "sr",  	wordTrig = false, name = "squared",		snippetType="autosnippet"}, t"^2",	  {condition = is_math}),
	s({trig = "cb",  	wordTrig = false, name = "cubed",		snippetType="autosnippet"}, t"^3",	  {condition = is_math}),
	s({trig = "invs", 	wordTrig = false, name = "inverse",		snippetType="autosnippet"}, t"^{-1}", {condition = is_math}),

	s({trig = ">=",  	wordTrig = false, name = "greater equal",	snippetType="autosnippet"}, t"\\geq", {condition = is_math}),
	s({trig = "<=",  	wordTrig = false, name = "lesser equal",	snippetType="autosnippet"}, t"\\leq", {condition = is_math}),
	s({trig = "<<",  	wordTrig = false, name = "much less",		snippetType="autosnippet"}, t"\\ll",  {condition = is_math}),
	s({trig = ">>",  	wordTrig = false, name = "much greater",	snippetType="autosnippet"}, t"\\gg",  {condition = is_math}),
	s({trig = "~~",  	wordTrig = false, name = "similar",			snippetType="autosnippet"}, t"\\sim", {condition = is_math}),
  }
})
