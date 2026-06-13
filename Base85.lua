-- ModuleScript: Base85
local Base85 = {}

local chars = {}
for i = 0, 84 do
	chars[i] = string.char(i + 33)
end

local lookup = {}
for i, c in pairs(chars) do
	lookup[c] = i
end

function Base85.Encrypt(text)
	if not text or #text == 0 then return nil, true end

	local result = ""
	local padding = (4 - #text % 4) % 4
	local padded = text .. string.rep("\0", padding)

	for i = 1, #padded, 4 do
		local b1 = string.byte(padded:sub(i,   i))
		local b2 = string.byte(padded:sub(i+1, i+1))
		local b3 = string.byte(padded:sub(i+2, i+2))
		local b4 = string.byte(padded:sub(i+3, i+3))

		local n = b1 * 16777216 + b2 * 65536 + b3 * 256 + b4

		local c5 = n % 85            n = math.floor(n / 85)
		local c4 = n % 85            n = math.floor(n / 85)
		local c3 = n % 85            n = math.floor(n / 85)
		local c2 = n % 85            n = math.floor(n / 85)
		local c1 = n % 85

		result = result .. chars[c1] .. chars[c2] .. chars[c3] .. chars[c4] .. chars[c5]
	end

	-- trim padding characters from end
	if padding > 0 then
		result = result:sub(1, #result - padding)
	end

	return result, false
end

function Base85.Decrypt(text)
	if not text or #text == 0 then return nil, true end

	-- validate characters
	for i = 1, #text do
		local c = text:sub(i, i)
		if lookup[c] == nil then return nil, true end
	end

	local padding = (5 - #text % 5) % 5
	local padded = text .. string.rep(chars[84], padding)

	local result = ""

	for i = 1, #padded, 5 do
		local c1 = lookup[padded:sub(i,   i)]
		local c2 = lookup[padded:sub(i+1, i+1)]
		local c3 = lookup[padded:sub(i+2, i+2)]
		local c4 = lookup[padded:sub(i+3, i+3)]
		local c5 = lookup[padded:sub(i+4, i+4)]

		local n = ((((c1 * 85 + c2) * 85 + c3) * 85 + c4) * 85 + c5)

		local b4 = n % 256            n = math.floor(n / 256)
		local b3 = n % 256            n = math.floor(n / 256)
		local b2 = n % 256            n = math.floor(n / 256)
		local b1 = n % 256

		result = result .. string.char(b1) .. string.char(b2) .. string.char(b3) .. string.char(b4)
	end

	-- trim padding bytes from end
	if padding > 0 then
		result = result:sub(1, #result - padding)
	end

	return result, false
end

return Base85
