--keyless
--try to integrate this yourself
local Base32 = {}
local CHARS = "ABCDEFGHIJKLMNOPQRSTUVWXYZ234567"

function Base32.Encrypt(text)
	local result = ""
	local buffer, bitsLeft = 0, 0
	for i = 1, #text do
		buffer = buffer * 256 + string.byte(text:sub(i, i))
		bitsLeft = bitsLeft + 8
		while bitsLeft >= 5 do
			bitsLeft = bitsLeft - 5
			local index = math.floor(buffer / 2^bitsLeft) % 32
			result = result .. CHARS:sub(index + 1, index + 1)
		end
	end
	if bitsLeft > 0 then
		local index = (buffer * 2^(5 - bitsLeft)) % 32
		result = result .. CHARS:sub(index + 1, index + 1)
	end
	return result
end

function Base32.Decrypt(text)
	text = text:upper():gsub("=", "")
	local result = ""
	local buffer, bitsLeft = 0, 0
	for i = 1, #text do
		local val = CHARS:find(text:sub(i, i), 1, true)
		if val then
			buffer = buffer * 32 + (val - 1)
			bitsLeft = bitsLeft + 5
			if bitsLeft >= 8 then
				bitsLeft = bitsLeft - 8
				result = result .. string.char(math.floor(buffer / 2^bitsLeft) % 256)
			end
		end
	end
	return result
end

return Base32
