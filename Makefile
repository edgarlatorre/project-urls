test:
	nvim --headless -c "PlenaryBustedDirectory lua/project-urls/test/ {minimal_init = 'lua/project-urls/test/minimal_init.lua'}"

lint:
	luacheck lua
