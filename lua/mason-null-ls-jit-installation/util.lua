local function formatted_message(message)
  return "[mason-null-ls-jit-installation] " .. message
end

local function mason_null_ls()
  local is_loaded, lib = pcall(require, "mason-null-ls")

  if not is_loaded then
    error(formatted_message("mason-null-ls is not available"))
  end

  return lib
end

local function verify_source_is_available(source)
  if not vim.tbl_contains(mason_null_ls().get_available_sources(), source) then
    print(formatted_message("invalid mason-null-ls source specified: " .. source))
  end
end

local function is_source_installed(source)
  return vim.tbl_contains(mason_null_ls().get_installed_sources(), source)
end

local function install_source(source)
  verify_source_is_available(source)

  if is_source_installed(source) then
    return
  end

  vim.cmd("MasonInstall " .. source)
end

local function create_autocommand(source, languages)
  verify_source_is_available(source)

  vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("mason-null-ls-jit-installation-" .. source, { clear = true }),
    callback = function(event)
      if vim.tbl_contains(languages, event.match) then
        install_source(source)
      end
    end,
  })

  -- if the current buffer is a match, install the source because the autocmd isn't going to trigger
  if vim.tbl_contains(languages, vim.bo.filetype) then
    install_source(source)
  end
end

local function find_invalid_sources(sources)
  local invalid_sources = {}

  for key, value in pairs(sources) do
    local source = type(value) == "string" and value or key

    if not vim.tbl_contains(mason_null_ls().get_available_sources(), source) then
      table.insert(invalid_sources, source)
    end
  end

  return invalid_sources
end

local function any_sources_defined(opts)
  local count = 0

  for _ in pairs(opts.sources) do
    count = count + 1
  end

  return count > 0
end

local function create_autocommands(sources)
  local invalid_sources = find_invalid_sources(sources)

  if #invalid_sources > 0 then
    print(formatted_message("invalid mason-null-ls sources specified: " .. table.concat(invalid_sources, ", ")))
    return
  end

  for key, value in pairs(sources) do
    if type(value) == "string" then
      install_source(value)
    else
      create_autocommand(key, value)
    end
  end
end

return {
  any_sources_defined = any_sources_defined,
  create_autocommands = create_autocommands,
  formatted_message = formatted_message,
}
