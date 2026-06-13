local BeaufortAutokey = {}

local function isValidKey(key)
	return key ~= nil and #key > 0 and key:match("^[a-zA-Z]+$") ~= nil
end

function BeaufortAutokey.Encrypt(text, key)
	if not isValidKey(key) then return nil, true end
	key = key:upper()
	local result = ""
	local fullKey = key
	-- extend key with plaintext letters
	for i = 1, #text do
		local c = text:sub(i, i)
		if c:match("[a-zA-Z]") then
			fullKey = fullKey .. c:upper()
		end
	end
	local ki = 1
	for i = 1, #text do
		local c = text:sub(i, i)
		local b = string.byte(c:upper())
		if b >= 65 and b <= 90 then
			local k = string.byte(fullKey:sub(ki, ki)) - 65
			local p = b - 65
			result = result .. string.char((k - p + 26) % 26 + 65)
			ki = ki + 1
		else
			result = result .. c
		end
	end
	return result, false
end

function BeaufortAutokey.Decrypt(text, key)
	if not isValidKey(key) then return nil, true end
	key = key:upper()
	local result = ""
	local fullKey = key
	local ki = 1
	for i = 1, #text do
		local c = text:sub(i, i)
		local b = string.byte(c:upper())
		if b >= 65 and b <= 90 then
			local k = string.byte(fullKey:sub(ki, ki)) - 65
			local ct = b - 65
			local p = (k - ct + 26) % 26
			local decChar = string.char(p + 65)
			result = result .. decChar
			fullKey = fullKey .. decChar
			ki = ki + 1
		else
			result = result .. c
		end
	end
	return result, false
end

return BeaufortAutokey
