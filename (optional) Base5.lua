local Base5 = {}

function Base5.Encrypt(text)
	local out = {}
	for i = 1, #text do
		local n = string.byte(text:sub(i, i))
		local b5 = ""
		repeat
			b5 = tostring(n % 5) .. b5
			n = math.floor(n / 5)
		until n == 0
		table.insert(out, b5)
	end
	return table.concat(out, " ")
end

function Base5.Decrypt(text)
	local result = ""
	for word in text:gmatch("%S+") do
		local n = tonumber(word, 5)
		if n then
			result = result .. string.char(n)
		end
	end
	return result
end

return Base5
