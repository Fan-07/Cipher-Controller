-- ModuleScript: Vigenere Autokey Cipher
local VigenereAutokey = {}

local function isValidKey(key)
	return key ~= nil and #key > 0 and key:match("^[a-zA-Z]+$") ~= nil
end

function VigenereAutokey.Encrypt(text, key)
	if not isValidKey(key) then return nil, true end
	key = key:upper()
	-- extend key with plaintext letters
	local fullKey = key
	for i = 1, #text do
		local c = text:sub(i, i)
		if c:match("[a-zA-Z]") then
			fullKey = fullKey .. c:upper()
		end
	end
	local result = ""
	local ki = 1
	for i = 1, #text do
		local c = text:sub(i, i)
		local b = string.byte(c)
		if b >= 65 and b <= 90 then
			local k = string.byte(fullKey:sub(ki, ki)) - 65
			result = result .. string.char((b - 65 + k) % 26 + 65)
			ki = ki + 1
		elseif b >= 97 and b <= 122 then
			local k = string.byte(fullKey:sub(ki, ki)) - 65
			result = result .. string.char((b - 97 + k) % 26 + 97)
			ki = ki + 1
		else
			result = result .. c
		end
	end
	return result, false
end

function VigenereAutokey.Decrypt(text, key)
	if not isValidKey(key) then return nil, true end
	key = key:upper()
	local result = ""
	local fullKey = key
	local ki = 1
	for i = 1, #text do
		local c = text:sub(i, i)
		local b = string.byte(c)
		if b >= 65 and b <= 90 then
			local k = string.byte(fullKey:sub(ki, ki)) - 65
			local p = (b - 65 - k + 26) % 26
			local decChar = string.char(p + 65)
			result = result .. decChar
			fullKey = fullKey .. decChar
			ki = ki + 1
		elseif b >= 97 and b <= 122 then
			local k = string.byte(fullKey:sub(ki, ki)) - 65
			local p = (b - 97 - k + 26) % 26
			local decChar = string.char(p + 97)
			result = result .. decChar
			fullKey = fullKey .. string.char(p + 65)
			ki = ki + 1
		else
			result = result .. c
		end
	end
	return result, false
end

return VigenereAutokey
