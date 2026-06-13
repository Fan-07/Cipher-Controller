--keyless
--try to integrate this yourself
local Base58 = {}
local CHARS = "123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz"

function Base58.Encrypt(text)
	local bytes = {}
	for i = 1, #text do table.insert(bytes, string.byte(text:sub(i,i))) end
	local num = 0
	for _, b in ipairs(bytes) do num = num * 256 + b end
	local result = ""
	while num > 0 do
		local rem = num % 58
		result = CHARS:sub(rem + 1, rem + 1) .. result
		num = math.floor(num / 58)
	end
	for _, b in ipairs(bytes) do
		if b == 0 then result = "1" .. result else break end
	end
	return result
end

function Base58.Decrypt(text)
	local num = 0
	for i = 1, #text do
		local val = CHARS:find(text:sub(i,i), 1, true)
		if val then num = num * 58 + (val - 1) end
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

return Base58
