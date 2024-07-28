local ls = require "luasnip"
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
ls.add_snippets("rust", {
  s("tokiomain", {
    -- equivalent to "${1:cond} ? ${2:then} : ${3:else}"
    t "#[tokio::main]",
    t { "", "async fn main() {", "\t" },
    i(1, "todo!()"),
    t { "", "}" },
  }),
})
