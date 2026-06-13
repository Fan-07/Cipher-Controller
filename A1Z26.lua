local A1Z26 = {}

function A1Z26.Encrypt(text)
	local result = {}
	for i = 1, #text do
		local c = text:sub(i, i)
		local b = string.byte(c)
		if b >= 65 and b <= 90 then
			table.insert(result, tostring(b - 64))
		elseif b >= 97 and b <= 122 then
			table.insert(result, tostring(b - 96))
		else
			table.insert(result, c)
		end
	end
	return table.concat(result, " ")
end

function A1Z26.Decrypt(text)
	local result = ""
	for word in text:gmatch("%S+") do
		local n = tonumber(word)
		if n and n >= 1 and n <= 26 then
			result = result .. string.char(n + 64)
		else
			result = result .. word
		end
	end
	return result
end

return A1Z26
