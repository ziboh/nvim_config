
local M = {}

--- Adds autocmds to a specific buffer if they don't already exist.
---
--- @param augroup string       The name of the autocmd group to which the autocmds belong.
--- @param bufnr number         The buffer number to which the autocmds should be applied.
--- @param autocmds table|any  A table or a single autocmd definition containing the autocmds to add.
function M.add_autocmds_to_buffer(augroup, bufnr, autocmds)
  -- Check if autocmds is a list, if not convert it to a list
  if not vim.islist(autocmds) then autocmds = { autocmds } end

  -- Attempt to retrieve existing autocmds associated with the specified augroup and bufnr
  local cmds_found, cmds = pcall(vim.api.nvim_get_autocmds, { group = augroup, buffer = bufnr })

  -- If no existing autocmds are found or the cmds_found call fails
  if not cmds_found or vim.tbl_isempty(cmds) then
    -- Create a new augroup if it doesn't already exist
    vim.api.nvim_create_augroup(augroup, { clear = false })

    -- Iterate over each autocmd provided
    for _, autocmd in ipairs(autocmds) do
      -- Extract the events from the autocmd and remove the events key
      local events = autocmd.events
      autocmd.events = nil

      -- Set the group and buffer keys for the autocmd
      autocmd.group = augroup
      autocmd.buffer = bufnr

      -- Create the autocmd
      vim.api.nvim_create_autocmd(events, autocmd)
    end
  end
end

--- Deletes autocmds associated with a specific buffer and autocmd group.
---
--- @param augroup string  The name of the autocmd group from which the autocmds should be removed.
--- @param bufnr number    The buffer number from which the autocmds should be removed.
function M.del_autocmds_from_buffer(augroup, bufnr)
  -- Attempt to retrieve existing autocmds associated with the specified augroup and bufnr
  local cmds_found, cmds = pcall(vim.api.nvim_get_autocmds, { group = augroup, buffer = bufnr })

  -- If retrieval was successful
  if cmds_found then
    -- Map over each retrieved autocmd and delete it
    vim.tbl_map(function(cmd) vim.api.nvim_del_autocmd(cmd.id) end, cmds)
  end
end

--- Get an icon from `lspkind` if it is available and return it.
---@param kind string The kind of icon in `lspkind` to retrieve.
---@return string icon.
function M.get_icon(kind, padding, no_fallback)
  if not vim.g.icons_enabled and no_fallback then return "" end
  local icon_pack = vim.g.icons_enabled and "icons" or "text_icons"
  if not M[icon_pack] then
    M.icons = require "icons.nerd_font"
    M.text_icons = require "icons.text"
  end
  local icon = M[icon_pack] and M[icon_pack][kind]
  return icon and icon .. string.rep(" ", padding or 0) or ""
end

--- Get an empty table of mappings with a key for each map mode.
---@return table<string,table> # a table with entries for each map mode.
function M.get_mappings_template()
  local maps = {}
  for _, mode in ipairs { "", "n", "v", "x", "s", "o", "!", "i", "l", "c", "t" } do
    maps[mode] = {}
  end
  if vim.fn.has "nvim-0.10.0" == 1 then
    for _, abbr_mode in ipairs { "ia", "ca", "!a" } do
      maps[abbr_mode] = {}
    end
  end
  return maps
end

--- Check if a plugin is defined in lazy. Useful with lazy loading
--- when a plugin is not necessarily loaded yet.
---@param plugin string The plugin to search for.
---@return boolean available # Whether the plugin is available.
function M.is_available(plugin)
  local lazy_config_avail, lazy_config = pcall(require, "lazy.core.config")
  return lazy_config_avail and lazy_config.spec.plugins[plugin] ~= nil
end

--- Returns true if the file is considered a big file,
--- according to the criteria defined in `vim.g.big_file`.
---@param bufnr number|nil buffer number. 0 by default, which means current buf.
---@return boolean is_big_file true or false.
function M.is_big_file(bufnr)
  if bufnr == nil then bufnr = 0 end
  local filesize = vim.fn.getfsize(vim.api.nvim_buf_get_name(bufnr))
  local nlines = vim.api.nvim_buf_line_count(bufnr)
  local is_big_file = (filesize > vim.g.big_file.size) or (nlines > vim.g.big_file.lines)
  return is_big_file
end

--- Sends a notification with 'Neovim' as default title.
--- Same as using vim.notify, but it saves us typing the title every time.
---@param msg string The notification body.
---@param type number|nil The type of the notification (:help vim.log.levels).
---@param opts? table The nvim-notify options to use (:help notify-options).
function M.notify(msg, type, opts)
  vim.schedule(function() vim.notify(msg, type, vim.tbl_deep_extend("force", { title = "Neovim" }, opts or {})) end)
end

--- Convert a path to the path format of the current operative system.
--- It converts 'slash' to 'inverted slash' if on windows, and vice versa on UNIX.
---@param path string A path string.
---@return string|nil,nil path A path string formatted for the current OS.
function M.os_path(path)
  if path == nil then return nil end
  -- Get the platform-specific path separator
  local separator = string.sub(package.config, 1, 1)
  return string.gsub(path, "[/\\]", separator)
end

--- Get the options of a plugin managed by lazy.
---@param plugin string The plugin to get options from
---@return table opts # The plugin options, or empty table if no plugin.
function M.get_plugin_opts(plugin)
  local lazy_config_avail, lazy_config = pcall(require, "lazy.core.config")
  local lazy_plugin_avail, lazy_plugin = pcall(require, "lazy.core.plugin")
  local opts = {}
  if lazy_config_avail and lazy_plugin_avail then
    local spec = lazy_config.spec.plugins[plugin]
    if spec then opts = lazy_plugin.values(spec, "opts") end
  end
  return opts
end

--- Set a table of mappings.
---
--- This wrapper prevents a  boilerplate code, and takes care of `whichkey.nvim`.
---@param map_table table A nested table where the first key is the vim mode,
---                       the second key is the key to map, and the value is
---                       the function to set the mapping to.
---@param base? table A base set of options to set on every keybinding.
function M.set_mappings(map_table, base)
  -- iterate over the first keys for each mode
  base = base or {}
  for mode, maps in pairs(map_table) do
    -- iterate over each keybinding set in the current mode
    for keymap, options in pairs(maps) do
      -- build the options for the command accordingly
      if options then
        local cmd = options
        local keymap_opts = base
        if type(options) == "table" then
          cmd = options[1]
          keymap_opts = vim.tbl_deep_extend("force", keymap_opts, options)
          keymap_opts[1] = nil
        end
        if not cmd or keymap_opts.name then -- if which-key mapping, queue it
          if not keymap_opts.name then keymap_opts.name = keymap_opts.desc end
          if not M.which_key_queue then M.which_key_queue = {} end
          if not M.which_key_queue[mode] then M.which_key_queue[mode] = {} end
          M.which_key_queue[mode][keymap] = keymap_opts
        else -- if not which-key mapping, set it
          vim.keymap.set(mode, keymap, cmd, keymap_opts)
        end
      end
    end
  end
  -- if which-key is loaded already, register
  if package.loaded["which-key"] then M.which_key_register() end
end

--- Convenient wapper to save code when we Trigger events.
--- To listen for a event triggered by this function you can use `autocmd`.
---@param event string Name of the event.
---@param is_urgent boolean|nil If true, trigger directly instead of scheduling. Useful for startup events.
-- @usage To run a User event:   `trigger_event("User MyUserEvent")`
-- @usage To run a Neovim event: `trigger_event("BufEnter")
function M.trigger_event(event, is_urgent)
  -- define behavior
  local function trigger()
    local is_user_event = string.match(event, "^User ") ~= nil
    if is_user_event then
      event = event:gsub("^User ", "")
      vim.api.nvim_exec_autocmds("User", { pattern = event, modeline = false })
    else
      vim.api.nvim_exec_autocmds(event, { modeline = false })
    end
  end

  -- execute
  if is_urgent then
    trigger()
  else
    vim.schedule(trigger)
  end
end

--- Register queued which-key mappings.
function M.which_key_register()
  if M.which_key_queue then
    local wk_avail, wk = pcall(require, "which-key")
    if wk_avail then
      for mode, registration in pairs(M.which_key_queue) do
        wk.register(registration, { mode = mode })
      end
      M.which_key_queue = nil
    end
  end
end

function M.on_load(plugins, load_op)
  local lazy_config_avail, lazy_config = pcall(require, "lazy.core.config")
  if lazy_config_avail then
    if type(plugins) == "string" then plugins = { plugins } end
    if type(load_op) ~= "function" then
      local to_load = type(load_op) == "string" and { load_op } or load_op --[=[@as string[]]=]
      load_op = function() require("lazy").load { plugins = to_load } end
    end

    for _, plugin in ipairs(plugins) do
      if vim.tbl_get(lazy_config.plugins, plugin, "_", "loaded") then
        vim.schedule(load_op)
        return
      end
    end

    vim.api.nvim_create_autocmd("User", {
      pattern = "LazyLoad",
      desc = ("A function to be ran when one of these plugins runs: %s"):format(vim.inspect(plugins)),
      callback = function(args)
        if vim.tbl_contains(plugins, args.data) then
          load_op()
          return true
        end
      end,
    })
  end
end

return M
