-- ModuleScript: Morse Code (keyless)
local MorseCode = {}

local morseTable = {
	A=".-", B="-...", C="-.-.", D="-..", E=".", F="..-.", G="--.",
	H="....", I="..", J=".---", K="-.-", L=".-..", M="--", N="-.",
	O="---", P=".--.", Q="--.-", R=".-.", S="...", T="-", U="..-",
	V="...-", W=".--", X="-..-", Y="-.--", Z="--..",
	["0"]="-----", ["1"]=".----", ["2"]="..---", ["3"]="...--",
	["4"]="....-", ["5"]=".....", ["6"]="-...." , ["7"]="--...",
	["8"]="---..", ["9"]="----.",
	[" "]="/"
}

local reverseMorse = {}
for k, v in pairs(morseTable) do
	reverseMorse[v] = k
end

function MorseCode.Encrypt(text)
	if not text or #text == 0 then return nil, true end
	text = text:upper()
	local result = {}
	for i = 1, #text do
		local c = text:sub(i, i)
		if morseTable[c] then
			table.insert(result, morseTable[c])
		end
	end
	if #result == 0 then return nil, true end
	return table.concat(result, " "), false
end

function MorseCode.Decrypt(text)
	if not text or #text == 0 then return nil, true end
	local result = ""
	for word in (text .. " "):gmatch("([^%s]*) ") do
		if word == "/" then
			result = result .. " "
		elseif reverseMorse[word] then
			result = result .. reverseMorse[word]
		elseif word ~= "" then
			return nil, true
		end
	end
	if #result == 0 then return nil, true end
	return result, false
end

return MorseCode
