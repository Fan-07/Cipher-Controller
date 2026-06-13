local Base64 = {}
local CHARS = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"

function Base64.Encrypt(text)
	local result = ""
	local padding = (3 - #text % 3) % 3
	text = text .. string.rep("\0", padding)
	for i = 1, #text, 3 do
		local a = string.byte(text:sub(i,i))
		local b = string.byte(text:sub(i+1,i+1))
		local c = string.byte(text:sub(i+2,i+2))
		local n = a * 65536 + b * 256 + c
		result = result
			.. CHARS:sub(math.floor(n/262144)%64+1, math.floor(n/262144)%64+1)
			.. CHARS:sub(math.floor(n/4096)%64+1,   math.floor(n/4096)%64+1)
			.. CHARS:sub(math.floor(n/64)%64+1,     math.floor(n/64)%64+1)
			.. CHARS:sub(n%64+1, n%64+1)
	end
	return result:sub(1, #result - padding) .. string.rep("=", padding)
end

function Base64.Decrypt(text)
	local lookup = {}
	for i = 1, #CHARS do lookup[CHARS:sub(i,i)] = i - 1 end
	text = text:gsub("=", "")
	local result = ""
	for i = 1, #text, 4 do
		local a = lookup[text:sub(i,i)] or 0
		local b = lookup[text:sub(i+1,i+1)] or 0
		local c = lookup[text:sub(i+2,i+2)] or 0
		local d = lookup[text:sub(i+3,i+3)] or 0
		local n = a*262144 + b*4096 + c*64 + d
		result = result .. string.char(math.floor(n/65536)%256)
		if text:sub(i+2,i+2) ~= "" then result = result .. string.char(math.floor(n/256)%256) end
		if text:sub(i+3,i+3) ~= "" then result = result .. string.char(n%256) end
	end
	return result
end

return Base64
