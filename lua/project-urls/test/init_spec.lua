describe("project-urls", function()
	it("open menu populates content table", function()
		local plugin = require("project-urls")
		plugin.open_menu()
		assert.is_table(plugin.current_content())
		assert.are.same({ "https://github.com/edgarlatorre/project-urls" }, plugin.current_content())
	end)
end)
