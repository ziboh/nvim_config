local ls = require "luasnip"
local s = ls.snippet
local sn = ls.snippet_node
local isn = ls.indent_snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local events = require "luasnip.util.events"
local ai = require "luasnip.nodes.absolute_indexer"
local extras = require "luasnip.extras"
local fmt = extras.fmt
local m = extras.m
local l = extras.l
local postfix = require("luasnip.extras.postfix").postfix
ls.add_snippets("rust", {
  s("tokiomain", {
    -- equivalent to "${1:cond} ? ${2:then} : ${3:else}"
    t "#[tokio::main]",
    t { "", "async fn main() {", "\t" },
    i(1, "todo!()"),
    t { "", "}" },
  }),
  s("trig", {
    i(1),
    f(
      function(args, snip, user_arg_1) return user_arg_1 .. args[1][1] end,
      { 1 },
      { user_args = { "Will be appended to text from i(0)" } }
    ),
    i(0),
  }),
})
