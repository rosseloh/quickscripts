require("jjjLib1")

local tickle_cubemaps = jjjLib1.findDataRef("sim/private/controls/render/tickle_cubemaps")


function tickleIt()
	print("rosseloh/tickle_cubemaps command was triggered")
	jjjLib1.setDataRef_f(tickle_cubemaps, 1.0)
end

create_command("rosseloh/tickle_cubemaps","Set tickle_cubemaps to 1 momentarily","tickleIt()","","")

