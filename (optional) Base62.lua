--keyless
--try to integrate this yourself
local Base62 = {}
local CHARS = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"

function Base62.Encrypt(text)
	local bytes = {}
	for i = 1, #text do table.insert(bytes, string.byte(text:sub(i,i))) end
	local num = 0
	for _, b in ipairs(bytes) do num = num * 256 + b end
	local result = ""
	while num > 0 do
		local rem = num % 62
		result = CHARS:sub(rem + 1, rem + 1) .. result
		num = math.floor(num / 62)
	end
	return result == "" and "0" or result
end

function Base62.Decrypt(text)
	local num = 0
	for i = 1, #text do
		local val = CHARS:find(text:sub(i,i), 1, true)
		if val then num = num * 62 + (val - 1) end
	end
	local bytes = {}
	while num > 0 do
		table.insert(bytes, 1, num % 256)
		num = math.floor(num / 256)
	end
	local result = ""
	for _, b in ipairs(bytes) do result = result .. string.char(b) end
	return result
end

return Base62
