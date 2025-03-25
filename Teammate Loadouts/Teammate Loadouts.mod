return {
	run = function()
		fassert(rawget(_G, "new_mod"), "`Teammate Loadouts` encountered an error loading the Darktide Mod Framework.")

		new_mod("Teammate Loadouts", {
			mod_script       = "Teammate Loadouts/scripts/mods/Teammate Loadouts/Teammate Loadouts",
			mod_data         = "Teammate Loadouts/scripts/mods/Teammate Loadouts/Teammate Loadouts_data",
			mod_localization = "Teammate Loadouts/scripts/mods/Teammate Loadouts/Teammate Loadouts_localization",
		})
	end,
	packages = {},
}
