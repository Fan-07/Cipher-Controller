-- ModuleScript: DRYAD Cipher
-- DRYAD is a military number-to-letter cipher using a 10-column key word/phrase
-- Key must be exactly 10 unique letters representing digits 0-9
local DRYAD = {}

local function isValidKey(key)
	if not key or #key ~= 10 then return false end
	key = key:upper()
	if not key:match("^[A-Z]+$") then return false end
	local seen = {}
	for i = 1, #key do
		local c = key:sub(i,i)
		if seen[c] then return false end
		seen[c] = true
	end
	return true
end

function DRYAD.Encrypt(text, key)
	if not isValidKey(key) then return nil, true end
	key = key:upper()
	local result = ""
	for i = 1, #text do
		local c = text:sub(i, i)
		local d = tonumber(c)
		if d ~= nil then
			result = result .. key:sub(d + 1, d + 1)
		else
			result = result .. c
		end
	end
	return result, false
end

function DRYAD.Decrypt(text, key)
	if not isValidKey(key) then return nil, true end
	key = key:upper()
	local result = ""
	for i = 1, #text do
		local c = text:sub(i, i):upper()
		local pos = key:find(c, 1, true)
		if pos then
			result = result .. tostring(pos - 1)
		else
			result = result .. c
		end
	end
	return result, false
end

return DRYAD
