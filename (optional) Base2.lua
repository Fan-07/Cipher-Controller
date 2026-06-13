--keyless
--try to integrate this yourself
local Base2 = {}

function Base2.Encrypt(text)
	local result = {}
	for i = 1, #text do
		local b = string.byte(text:sub(i, i))
		local bin = ""
		for j = 7, 0, -1 do
			bin = bin .. (math.floor(b / 2^j) % 2)
		end
		table.insert(result, bin)
	end
	return table.concat(result, " ")
end

function Base2.Decrypt(text)
	local result = ""
	for word in text:gmatch("%S+") do
		local n = tonumber(word, 2)
		if n then
			result = result .. string.char(n)
		end
	end
	return result
end

return Base2
