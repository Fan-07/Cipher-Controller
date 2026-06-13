local Caesar = {}

local function isValidShift(key)
	local n = tonumber(key)
	return n ~= nil
end

function Caesar.Encrypt(text, key)
	if not isValidShift(key) then return nil, true end
	local shift = tonumber(key) % 26
	local result = ""
	for i = 1, #text do
		local c = text:sub(i, i)
		local b = string.byte(c)
		if b >= 65 and b <= 90 then
			result = result .. string.char((b - 65 + shift) % 26 + 65)
		elseif b >= 97 and b <= 122 then
			result = result .. string.char((b - 97 + shift) % 26 + 97)
		else
			result = result .. c
		end
	end
	return result, false
end

function Caesar.Decrypt(text, key)
	if not isValidShift(key) then return nil, true end
	local shift = tonumber(key) % 26
	return Caesar.Encrypt(text, tostring(26 - shift)), false
end

return Caesar
