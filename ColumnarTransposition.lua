local Columnar = {}

local function isValidKey(key)
	return key ~= nil and #key > 0 and key:match("^[a-zA-Z]+$") ~= nil
end

local function getOrder(key)
	key = key:upper()
	local chars = {}
	for i = 1, #key do
		table.insert(chars, {char = key:sub(i,i), index = i})
	end
	table.sort(chars, function(a, b)
		if a.char == b.char then return a.index < b.index end
		return a.char < b.char
	end)
	local order = {}
	for rank, v in ipairs(chars) do
		order[v.index] = rank
	end
	return order
end

function Columnar.Encrypt(text, key)
	if not isValidKey(key) then return nil, true end
	local cols = #key
	local rows = math.ceil(#text / cols)
	local padded = text .. string.rep("X", rows * cols - #text)
	local grid = {}
	for r = 1, rows do
		grid[r] = {}
		for c = 1, cols do
			grid[r][c] = padded:sub((r-1)*cols + c, (r-1)*cols + c)
		end
	end
	local order = getOrder(key)
	local result = ""
	for col = 1, cols do
		local origCol
		for k, v in pairs(order) do
			if v == col then origCol = k break end
		end
		for r = 1, rows do
			result = result .. grid[r][origCol]
		end
	end
	return result, false
end

function Columnar.Decrypt(text, key)
	if not isValidKey(key) then return nil, true end
	local cols = #key
	local rows = math.ceil(#text / cols)
	if #text ~= rows * cols then return nil, true end
	local order = getOrder(key)
	local columns = {}
	local pos = 1
	for col = 1, cols do
		local origCol
		for k, v in pairs(order) do
			if v == col then origCol = k break end
		end
		columns[origCol] = {}
		for r = 1, rows do
			columns[origCol][r] = text:sub(pos, pos)
			pos = pos + 1
		end
	end
	local result = ""
	for r = 1, rows do
		for c = 1, cols do
			result = result .. columns[c][r]
		end
	end
	return result, false
end

return Columnar
