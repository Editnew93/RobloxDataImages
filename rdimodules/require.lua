-- 1. Store the original global require
local oldRequire = require

-- 2. Define whether we want the "Enhanced" require active
local useEnhancedRequire = true 

print("[RDI]: Module Require [@rdimodules/require.lua] is loading.")

-- 3. Create the new function
local function customRequire(target)
	-- Check if we are in "Enhanced" mode and if the input is a string starting with @
	if useEnhancedRequire and type(target) == "string" and target:sub(1, 1) == "@" then
		local loc = target:sub(2)
		local scr = game:HttpGet("https://github.com/Editnew93/RobloxDataImages/tree/main/rdimodules/" .. loc)
		if scr == "404: Not Found" then error("[ERROR] [Require Plugin] [RDI]: While loading module, the module source returned with 404 (Not Found). Please check the repo Editnew93/RobloxDataImages and the folder rdimodules in the repo to find your script.") end
		print("[Require Plugin] [RDI]: Loading RDI module [".. target .."]")
		
		return loadstring(scr)()

	else
		-- Fall back to standard Roblox behavior
		return oldRequire(target)
	end
end
print("[Require Plugin] [RDI]: Loaded!")
-- 4. Apply the hook to the environment
return customRequire
