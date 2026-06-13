--keyless
--try to integrate this yourself
local Base16 = {}

function Base16.Encrypt(text)
	local result = {}
	for i = 1, #text do
		table.insert(result, string.format("%02X", string.byte(text:sub(i, i))))
	end
	return table.concat(result, " ")
end

function Base16.Decrypt(text)
	local result = ""
	for word in text:gmatch("%S+") do
		local n = tonumber(word, 16)
		if n then
			result = result .. string.char(n)
		end
	end
	return result
end

return Base16
