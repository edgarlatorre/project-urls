test:
	nvim --headless -c 'PlenaryBustedDirectory lua/project-urls/test/'

lint:
	luacheck lua
