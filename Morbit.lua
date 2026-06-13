-- ModuleScript: Morbit Cipher
-- Key must be exactly 9 unique characters (no repeats)
-- Maps morse code pairs (.., .-, .-,  -., --, to key characters)
local Morbit = {}

local morseTable = {
	A=".-", B="-...", C="-.-.", D="-..", E=".", F="..-.", G="--.",
	H="....", I="..", J=".---", K="-.-", L=".-..", M="--", N="-.",
	O="---", P=".--.", Q="--.-", R=".-.", S="...", T="-", U="..-",
	V="...-", W=".--", X="-..-", Y="-.--", Z="--..",
	["0"]="-----", ["1"]=".----", ["2"]="..---", ["3"]="...--",
	["4"]="....-", ["5"]=".....", ["6"]="-...." , ["7"]="--...",
	["8"]="---..", ["9"]="----."
}

local reverseMorse = {}
for k, v in pairs(morseTable) do
	reverseMorse[v] = k
end

-- Morbit pairs: index 1-9 maps to dot-dot, dot-dash, dot-x, dash-dot, dash-dash, dash-x, x-dot, x-dash, x-x
-- x = letter separator
local PAIRS = {"..", ".-", ".X", "-.", "--", "-X", "X.", "X-", "XX"}

local function isValidKey(key)
	if not key or #key ~= 9 then return false end
	local seen = {}
	for i = 1, 9 do
		local c = key:sub(i,i)
		if seen[c] then return false end
		seen[c] = true
	end
	return true
end

function Morbit.Encrypt(text, key)
	if not isValidKey(key) then return nil, true end
	key = key:upper()
	text = text:upper()

	-- build pair->keychar map
	local pairToKey = {}
	for i, pair in ipairs(PAIRS) do
		pairToKey[pair] = key:sub(i, i)
	end

	local result = ""
	for i = 1, #text do
		local c = text:sub(i, i)
		if morseTable[c] then
			local morse = morseTable[c]
			-- pad to even length with X separator
			local padded = morse .. "X"
			for j = 1, #padded, 2 do
				local pair = padded:sub(j, j+1)
				result = result .. (pairToKey[pair] or "?")
			end
		elseif c == " " then
			result = result .. " "
		end
	end
	return result, false
end

function Morbit.Decrypt(text, key)
	if not isValidKey(key) then return nil, true end
	key = key:upper()
	text = text:upper()

	-- build keychar->pair map
	local keyToPair = {}
	for i, pair in ipairs(PAIRS) do
		keyToPair[key:sub(i,i)] = pair
	end

	local result = ""
	local morseBuffer = ""

	for i = 1, #text do
		local c = text:sub(i, i)
		if c == " " then
			result = result .. " "
		else
			local pair = keyToPair[c]
			if not pair then return nil, true end
			morseBuffer = morseBuffer .. pair
		end
	end

	-- decode morse buffer
	local decoded = ""
	local current = ""
	for i = 1, #morseBuffer do
		local ch = morseBuffer:sub(i,i)
		if ch == "X" then
			if reverseMorse[current] then
				decoded = decoded .. reverseMorse[current]
			end
			current = ""
		else
			current = current .. ch
		end
	end
	if reverseMorse[current] then
		decoded = decoded .. reverseMorse[current]
	end

	return decoded, false
end

return Morbit
