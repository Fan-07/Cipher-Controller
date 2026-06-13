local Vigenere = {}

local function isValidKey(key)
	return key ~= nil and #key > 0 and key:match("^[a-zA-Z]+$") ~= nil
end

function Vigenere.Encrypt(text, key)
	if not isValidKey(key) then return nil, true end
	key = key:upper()
	local result = ""
	local ki = 1
	for i = 1, #text do
		local c = text:sub(i, i)
		local b = string.byte(c)
		if b >= 65 and b <= 90 then
			local k = string.byte(key:sub(ki, ki)) - 65
			result = result .. string.char((b - 65 + k) % 26 + 65)
			ki = (ki % #key) + 1
		elseif b >= 97 and b <= 122 then
			local k = string.byte(key:sub(ki, ki)) - 65
			result = result .. string.char((b - 97 + k) % 26 + 97)
			ki = (ki % #key) + 1
		else
			result = result .. c
		end
	end
	return result, false
end

function Vigenere.Decrypt(text, key)
	if not isValidKey(key) then return nil, true end
	key = key:upper()
	local result = ""
	local ki = 1
	for i = 1, #text do
		local c = text:sub(i, i)
		local b = string.byte(c)
		if b >= 65 and b <= 90 then
			local k = string.byte(key:sub(ki, ki)) - 65
			result = result .. string.char((b - 65 - k + 26) % 26 + 65)
			ki = (ki % #key) + 1
		elseif b >= 97 and b <= 122 then
			local k = string.byte(key:sub(ki, ki)) - 65
			result = result .. string.char((b - 97 - k + 26) % 26 + 97)
			ki = (ki % #key) + 1
		else
			result = result .. c
		end
	end
	return result, false
end

return Vigenere
