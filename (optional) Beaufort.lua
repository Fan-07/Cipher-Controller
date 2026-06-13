--keyed
--try to integrate this yourself
local Beaufort = {}

local function isValidKey(key)
	return key ~= nil and #key > 0 and key:match("^[a-zA-Z]+$") ~= nil
end

function Beaufort.Encrypt(text, key)
	if not isValidKey(key) then return nil, true end
	key = key:upper()
	local result = ""
	local ki = 1
	for i = 1, #text do
		local c = text:sub(i, i)
		local b = string.byte(c:upper())
		if b >= 65 and b <= 90 then
			local k = string.byte(key:sub(ki, ki)) - 65
			local p = b - 65
			result = result .. string.char((k - p + 26) % 26 + 65)
			ki = (ki % #key) + 1
		else
			result = result .. c
		end
	end
	return result, false
end

function Beaufort.Decrypt(text, key)
	-- beaufort is its own inverse
	return Beaufort.Encrypt(text, key)
end

return Beaufort
