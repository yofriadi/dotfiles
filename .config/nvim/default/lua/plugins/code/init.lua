return {
  {"m-demare/hlargs.nvim"},
  {
    "nat-418/boole.nvim",
    event = "BufRead",
    config = function ()
      require('boole').setup({
        mappings = {
          increment = '<c-a>', -- TODO: map to a proper key, because CTRL-A is mapped to TMUX
          decrement = '<c-x>'
        },
        -- User defined loops
        additions = {
          {'Foo', 'Bar'},
          {'tic', 'tac', 'toe'}
        },
        allow_caps_additions = {
          {'enable', 'disable'}
          -- enable → disable
          -- Enable → Disable
          -- ENABLE → DISABLE
        }
      })
    end
  },
  {
    "williamboman/mason.nvim",
    cmd = {
      "Mason",
      "MasonInstall",
      "MasonUninstall",
      "MasonUninstallAll",
      "MasonLog",
      "MasonUpdate",
      "MasonUpdateAll",
    },
    build = ":MasonUpdate",
    config = function ()
      require("mason").setup({
        ui = {
          icons = {
            package_installed = "✓",
            package_uninstalled = "✗",
            package_pending = "⟳",
          },
        },
      })

      local notif = require("utils.notif")
      local cmd = vim.api.nvim_create_user_command
      cmd("MasonUpdate", function(options)
        --require("astronvim.utils.mason").update(options.fargs)
        local pkg_names = options.fargs
        if type(pkg_names) == "string" then pkg_names = { pkg_names } end
        local auto_install = true
        local registry_avail, registry = pcall(require, "mason-registry")
        if not registry_avail then
          vim.api.nvim_err_writeln "Unable to access mason registry"
          return
        end

        registry.update(vim.schedule_wrap(function(success, updated_registries)
          if success then
            local count = #updated_registries
            if vim.tbl_count(pkg_names) == 0 then
              notif.notify(("Successfully updated %d %s."):format(count, count == 1 and "registry" or "registries"),
                { title = "Mason"})
            end
            for _, pkg_name in ipairs(pkg_names) do
              local pkg_avail, pkg = pcall(registry.get_package, pkg_name)
              if not pkg_avail then
                notif.notify(("`%s` is not available"):format(pkg_name), { title = "Mason", level = vim.log.levels.ERROR })
              else
                if not pkg:is_installed() then
                  if auto_install then
                    notif.notify(("Installing `%s`"):format(pkg.name))
                    pkg:install()
                  else
                    notif.notify(("`%s` not installed"):format(pkg.name), { title = "Mason", level = vim.log.levels.WARN })
                  end
                else
                  pkg:check_new_version(function(update_available, version)
                    if update_available then
                      notif.notify(("Updating `%s` to %s"):format(pkg.name, version.latest_version), { title = "Mason" })
                      pkg:install():on("closed", function() notif.notify(("Updated %s"):format(pkg.name), { title = "Mason" }) end)
                    else
                      notif.notify(("No updates available for `%s`"):format(pkg.name), { title = "Mason" })
                    end
                  end)
                end
              end
            end
          else
            notif.notify(("Failed to update registries: %s"):format(updated_registries), { title = "Mason", level = vim.log.levels.ERROR })
          end
        end))
      end, {
        nargs = "*",
        desc = "Update Mason Package",
        complete = function(arg_lead)
          local _ = require("mason-core.functional")
          return _.sort_by(_.identity, _.filter(_.starts_with(arg_lead), require("mason-registry").get_installed_package_names())
          )
        end,
      })

      cmd(
        "MasonUpdateAll",
        function()
          local registry_avail, registry = pcall(require, "mason-registry")
          if not registry_avail then
            vim.api.nvim_err_writeln("Unable to access mason registry")
            return
          end

          notif.notify("Checking for package updates...", { title = "Mason" })
          registry.update(vim.schedule_wrap(function(success, updated_registries)
            if success then
              local installed_pkgs = registry.get_installed_packages()
              local running = #installed_pkgs
              local no_pkgs = running == 0

              if no_pkgs then
                notif.notify("No updates available", { title = "Mason" })
              else
                local updated = false
                for _, pkg in ipairs(installed_pkgs) do
                  pkg:check_new_version(function(update_available, version)
                    if update_available then
                      updated = true
                      notif.notify(("Updating `%s` to %s"):format(pkg.name, version.latest_version))
                      pkg:install():on("closed", function()
                        running = running - 1
                        if running == 0 then
                          notif.notify "Update Complete"
                        end
                      end)
                    else
                      running = running - 1
                      if running == 0 then
                        if updated then
                          notif.notify("Update Complete", { title = "Mason" })
                        else
                          notif.notify("No updates available", { title = "Mason" })
                        end
                      end
                    end
                  end)
                end
              end
            else
              notif.notify(("Failed to update registries: %s"):format(updated_registries),
                { title = "Mason", level = vim.log.levels.ERROR })
            end
          end))
        end,
        { desc = "Update Mason Packages" }
      )
    end
  },
}
