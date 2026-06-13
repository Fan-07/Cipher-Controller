local A0Z25 = {}

function A0Z25.Encrypt(text)
	local result = {}
	for i = 1, #text do
		local c = text:sub(i, i)
		local b = string.byte(c)
		if b >= 65 and b <= 90 then
			table.insert(result, tostring(b - 65))
		elseif b >= 97 and b <= 122 then
			table.insert(result, tostring(b - 97))
		else
			table.insert(result, c)
		end
	end
	return table.concat(result, " ")
end

function A0Z25.Decrypt(text)
	local result = ""
	for word in text:gmatch("%S+") do
		local n = tonumber(word)
		if n and n >= 0 and n <= 25 then
			result = result .. string.char(n + 65)
		else
			result = result .. word
		end
	end
	return result
end

return A0Z25
