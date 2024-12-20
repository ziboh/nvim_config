local files = require "overseer.files"
local overseer = require "overseer"

---@type overseer.TemplateFileDefinition
local tmpl = {
  priority = 60,
  params = {
    args = { optional = true, type = "list", delimiter = " " },
    cwd = { optional = true },
    bin = { optional = true, type = "string" },
  },
  builder = function(params)
    return {
      cmd = { params.bin },
      args = params.args,
      cwd = params.cwd,
    }
  end,
}

---@param opts overseer.SearchParams
local function get_candidate_pyproject_files(opts)
  local matches = vim.fs.find("pyproject.toml", {
    upward = true,
    type = "file",
    path = opts.dir,
    stop = vim.fn.getcwd() .. "/..",
    limit = math.huge,
  })
  if #matches > 0 then return matches end
  return vim.fs.find("pyproject.toml", {
    upward = true,
    type = "file",
    path = vim.fn.getcwd(),
  })
end

---@param opts overseer.SearchParams
---@return string|nil
local function get_pyproject_file(opts)
  local candidate_files = get_candidate_pyproject_files(opts)
  for _, pyproject in ipairs(candidate_files) do
    if files.exists(pyproject) then return pyproject end
  end
  return nil
end

-- 解析 pyproject.toml 中的脚本
local function get_scripts_from_pyproject(pyproject_file)
  local scripts = {}
  local in_scripts_section = false

  for line in io.lines(pyproject_file) do
    if line:match "^%[project%.scripts%]" then
      in_scripts_section = true
    elseif line:match "^%[" then
      in_scripts_section = false
    elseif in_scripts_section then
      local script_name = line:match "^(%w+)%s*="
      if script_name then table.insert(scripts, script_name) end
    end
  end

  return scripts
end

return {
  cache_key = function(opts) return get_pyproject_file(opts) end,
  condition = {
    callback = function(opts)
      local pyproject_file = get_pyproject_file(opts)
      if not pyproject_file then return false, "No pyproject.toml file found" end
      if vim.fn.executable "rye" == 0 then return false, "Could not find command 'rye'" end
      return true
    end,
  },
  generator = function(opts, cb)
    local pyproject = get_pyproject_file(opts)
    if not pyproject then
      cb {}
      return
    end

    local scripts = get_scripts_from_pyproject(pyproject)
    local ret = {}

    for _, script_name in ipairs(scripts) do
      table.insert(
        ret,
        overseer.wrap_template(
          tmpl,
          { name = string.format("rye run %s", script_name) },
          { args = { "run", script_name }, bin = "rye", cwd = vim.fs.dirname(pyproject) }
        )
      )
    end

    cb(ret)
  end,
}
