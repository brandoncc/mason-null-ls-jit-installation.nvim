local util = require("mason-null-ls-jit-installation.util")

M = {}

function M.setup(opts)
  opts = opts or {}
  opts.sources = opts.sources or {}

  if not util.any_sources_defined(opts) then
    print(util.formatted_message("No sources specified, nothing to do."))

    return
  end

  util.create_autocommands(opts.sources)
end

return M
