--keyless
--try to integrate this yourself
local Base100 = {}

function Base100.Encrypt(text)
	local result = {}
	for i = 1, #text do
		table.insert(result, "[" .. string.byte(text:sub(i,i)) .. "]")
	end
	return table.concat(result, "")
end

function Base100.Decrypt(text)
	local result = ""
	for num in text:gmatch("%[(%d+)%]") do
		local n = tonumber(num)
		if n then result = result .. string.char(n) end
	end
	return result
end

return Base100
