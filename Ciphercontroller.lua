print("CipherController loaded!")

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local CipherModules = ReplicatedStorage:WaitForChild("CipherModules")
local Ciphers = {
	-- Keyless Ciphers
	Base85              = require(CipherModules:WaitForChild("Base85")),
	MorseCode           = require(CipherModules:WaitForChild("MorseCode")),
	-- add your keyless cipher here in the same format with name
	-- Keyed
	Caesar              = require(CipherModules:WaitForChild("Caesar")),
	BeaufortAutokey     = require(CipherModules:WaitForChild("BeaufortAutokey")),
	ColumnarTransposition = require(CipherModules:WaitForChild("ColumnarTransposition")),
	DRYAD               = require(CipherModules:WaitForChild("DRYAD")),
	Morbit              = require(CipherModules:WaitForChild("Morbit")),
	Vigenere            = require(CipherModules:WaitForChild("Vigenere")),
	VigenereAutokey     = require(CipherModules:WaitForChild("VigenereAutokey")),
		-- add your keyed cipher here in the same format with name
}

-- ScreenGuis
local AllGUI     = playerGui:WaitForChild("AllGUI") -- Gui containing buttons for your ciphers
local ModeGUI    = playerGui:WaitForChild("ModeGUI") -- Gui containing buttons for (encrypt or decrypt) modes
local Cipher1GUI = playerGui:WaitForChild("Cipher1GUI") -- Gui for keyless ciphers (should contain 2 textboxes InputBox and OutputBox for input and output)
local Cipher2GUI = playerGui:WaitForChild("Cipher2GUI") -- Gui for keyed ciphers (should contain 3 textboxses InputBox, OutBox and KeyBox)

-- Frames
local AllFrame        = AllGUI:WaitForChild("MainFrame") -- Frame who parents The CipherGUIs under AllGUI
local ModeFrame       = ModeGUI:WaitForChild("MainFrame") --Frame who parents the buttons for ModeGUI
local C1Main          = Cipher1GUI:WaitForChild("MainFrame") -- "  "  for Cipher1GUI
local EncryptFrame    = C1Main:WaitForChild("EncryptFrame") -- the frame u are taken to containing the Input and Output boxes for keyless Ciphers for encryption
local DecryptFrame    = C1Main:WaitForChild("DecryptFrame") -- " " " for decryption
local C2Main          = Cipher2GUI:WaitForChild("MainFrame") -- Frame who parents button for Cipher2GUI
local EncryptFrame2   = C2Main:WaitForChild("EncryptFrame") -- the frame u are taken to containing the Input and Output boxes for keyless Ciphers for encryption for keyed Ciphers
local DecryptFrame2   = C2Main:WaitForChild("DecryptFrame") -- " "  for decryption for keyed ciphers


-- AllGUI Buttons (keyless)
local Base85Button    = AllFrame:WaitForChild("Base85Button")
local MorseButton     = AllFrame:WaitForChild("MorseButton")
	-- add your keyless cipher here in the same format with name

-- AllGUI Buttons (keyed)
local CaesarButton              = AllFrame:WaitForChild("CaesarButton")
local BeaufortAutokeyButton     = AllFrame:WaitForChild("BeaufortAutokeyButton")
local ColumnarButton            = AllFrame:WaitForChild("ColumnarTranspositionButton")
local DRYADButton               = AllFrame:WaitForChild("DRYADButton")
local MorbitButton              = AllFrame:WaitForChild("MorbitButton")
local VigenereButton            = AllFrame:WaitForChild("VigenereButton")
local VigenereAutokeyButton     = AllFrame:WaitForChild("VigenereAutokeyButton")
	-- add your keyed cipher here in the same format with name

-- ModeGUI Buttons
local EncryptButton = ModeFrame:WaitForChild("EncryptButton")
local DecryptButton = ModeFrame:WaitForChild("DecryptButton")
local ModeBack      = ModeFrame:WaitForChild("BackButton")

-- Cipher1GUI (keyless) Elements
local eInput  = EncryptFrame:WaitForChild("InputBox")
local eOutput = EncryptFrame:WaitForChild("OutputBox")
local eRun    = EncryptFrame:WaitForChild("RunButton")
local eBack   = EncryptFrame:WaitForChild("BackButton")
local dInput  = DecryptFrame:WaitForChild("InputBox")
local dOutput = DecryptFrame:WaitForChild("OutputBox")
local dRun    = DecryptFrame:WaitForChild("RunButton")
local dBack   = DecryptFrame:WaitForChild("BackButton")

-- Cipher2GUI (keyed) Elements
local e2Input  = EncryptFrame2:WaitForChild("InputBox")
local e2Output = EncryptFrame2:WaitForChild("OutputBox")
local e2Key    = EncryptFrame2:WaitForChild("KeyBox")
local e2Run    = EncryptFrame2:WaitForChild("RunButton")
local e2Back   = EncryptFrame2:WaitForChild("BackButton")
local d2Input  = DecryptFrame2:WaitForChild("InputBox")
local d2Output = DecryptFrame2:WaitForChild("OutputBox")
local d2Key    = DecryptFrame2:WaitForChild("KeyBox")
local d2Run    = DecryptFrame2:WaitForChild("RunButton")
local d2Back   = DecryptFrame2:WaitForChild("BackButton")

-- Keyed ciphers list
local keyedCiphers = {
	Caesar                = true,
	BeaufortAutokey       = true,
	ColumnarTransposition = true,
	DRYAD                 = true,
	Morbit                = true,
	Vigenere              = true,
	VigenereAutokey       = true,
	--add keyed cipher list here in the same format
}

-- Button map for highlight
local CipherButtons = {
	Base85                = Base85Button,
	MorseCode             = MorseButton,
	Caesar                = CaesarButton,
	BeaufortAutokey       = BeaufortAutokeyButton,
	ColumnarTransposition = ColumnarButton,
	DRYAD                 = DRYADButton,
	Morbit                = MorbitButton,
	Vigenere              = VigenereButton,
	VigenereAutokey       = VigenereAutokeyButton,
	--every cipher list here in the same format
}

-- State
local selectedCipher = nil
local tweening = false

-- Tween settings
local TWEEN_IN  = TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local TWEEN_OUT = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.In)

-- Initial state
AllGUI.Enabled        = false
ModeGUI.Enabled       = false
Cipher1GUI.Enabled    = false
Cipher2GUI.Enabled    = false
EncryptFrame.Visible  = false
DecryptFrame.Visible  = false
EncryptFrame2.Visible = false
DecryptFrame2.Visible = false

for _, frame in ipairs({AllFrame, ModeFrame, EncryptFrame, DecryptFrame, EncryptFrame2, DecryptFrame2}) do
	frame.AnchorPoint = Vector2.new(0.5, 0.5)
	frame.Position    = UDim2.new(0.5, 0, 0.5, 0)
end

-- to highlight the last selected cipher button

local function setHighlight(cipherName)
	for _, btn in pairs(CipherButtons) do
		local stroke = btn:FindFirstChildOfClass("UIStroke")
		if stroke then stroke:Destroy() end
	end
	if cipherName and CipherButtons[cipherName] then
		local stroke = Instance.new("UIStroke")
		stroke.Thickness = 1
		stroke.Color = Color3.fromRGB(81, 23, 24)
		stroke.Parent = CipherButtons[cipherName]
	end
end

-- tween anims for Ui

local function slideIn(gui, frame)
	gui.Enabled    = true
	frame.Visible  = true
	frame.Position = UDim2.new(0.5, 0, -0.5, 0)
	local tween = TweenService:Create(frame, TWEEN_IN, {
		Position = UDim2.new(0.5, 0, 0.5, 0)
	})
	tween:Play()
	tween.Completed:Once(function()
		tweening = false
	end)
end

local function slideOut(gui, frame, callback)
	tweening = true
	local tween = TweenService:Create(frame, TWEEN_OUT, {
		Position = UDim2.new(0.5, 0, 1.5, 0)
	})
	tween:Play()
	tween.Completed:Once(function()
		gui.Enabled    = false
		frame.Visible  = false
		frame.Position = UDim2.new(0.5, 0, 0.5, 0)
		if callback then callback() end
	end)
end

local function transition(fromGui, fromFrame, toGui, toFrame)
	if tweening then return end
	slideOut(fromGui, fromFrame, function()
		slideIn(toGui, toFrame)
	end)
end

-- output helper
local function setOutput(outputBox, text, isError)
	if isError then
		outputBox.TextColor3 = Color3.fromRGB(80, 140, 255)
		outputBox.Text = "Wrong format entered"
	else
		outputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
		outputBox.Text = text
	end
end

-- nav
local function goToMode(cipherName)
	setHighlight(nil)
	selectedCipher = cipherName
	transition(AllGUI, AllFrame, ModeGUI, ModeFrame)
end

-- Keyless
Base85Button.MouseButton1Click:Connect(function()  goToMode("Base85")    end)
MorseButton.MouseButton1Click:Connect(function()   goToMode("MorseCode") end)

-- Keyed
CaesarButton.MouseButton1Click:Connect(function()          goToMode("Caesar")                end)
BeaufortAutokeyButton.MouseButton1Click:Connect(function() goToMode("BeaufortAutokey")       end)
ColumnarButton.MouseButton1Click:Connect(function()        goToMode("ColumnarTransposition") end)
DRYADButton.MouseButton1Click:Connect(function()           goToMode("DRYAD")                 end)
MorbitButton.MouseButton1Click:Connect(function()          goToMode("Morbit")                end)
VigenereButton.MouseButton1Click:Connect(function()        goToMode("Vigenere")              end)
VigenereAutokeyButton.MouseButton1Click:Connect(function() goToMode("VigenereAutokey")       end)

-- ModeGUI -> correct CipherGUI
EncryptButton.MouseButton1Click:Connect(function()
	if keyedCiphers[selectedCipher] then
		EncryptFrame2.Visible = true
		DecryptFrame2.Visible = false
		transition(ModeGUI, ModeFrame, Cipher2GUI, EncryptFrame2)
	else
		EncryptFrame.Visible = true
		DecryptFrame.Visible = false
		transition(ModeGUI, ModeFrame, Cipher1GUI, EncryptFrame)
	end
end)

DecryptButton.MouseButton1Click:Connect(function()
	if keyedCiphers[selectedCipher] then
		DecryptFrame2.Visible = true
		EncryptFrame2.Visible = false
		transition(ModeGUI, ModeFrame, Cipher2GUI, DecryptFrame2)
	else
		DecryptFrame.Visible = true
		EncryptFrame.Visible = false
		transition(ModeGUI, ModeFrame, Cipher1GUI, DecryptFrame)
	end
end)

-- ModeBack -> AllGUI
ModeBack.MouseButton1Click:Connect(function()
	setHighlight(selectedCipher)
	transition(ModeGUI, ModeFrame, AllGUI, AllFrame)
	selectedCipher = nil
end)

-- Cipher1 (keyless)

eRun.MouseButton1Click:Connect(function()
	local result, err = Ciphers[selectedCipher].Encrypt(eInput.Text)
	local isEmpty = result == nil or result:gsub("%s", "") == ""
	setOutput(eOutput, result, isEmpty or err)
end)

eBack.MouseButton1Click:Connect(function()
	eInput.Text  = ""
	eOutput.Text = ""
	transition(Cipher1GUI, EncryptFrame, ModeGUI, ModeFrame)
end)

dRun.MouseButton1Click:Connect(function()
	local result, err = Ciphers[selectedCipher].Decrypt(dInput.Text)
	local isEmpty = result == nil or result:gsub("%s", "") == ""
	setOutput(dOutput, result, isEmpty or err)
end)

dBack.MouseButton1Click:Connect(function()
	dInput.Text  = ""
	dOutput.Text = ""
	transition(Cipher1GUI, DecryptFrame, ModeGUI, ModeFrame)
end)

-- cipher2 (keyed)

e2Run.MouseButton1Click:Connect(function()
	local result, err = Ciphers[selectedCipher].Encrypt(e2Input.Text, e2Key.Text)
	local isEmpty = result == nil or result:gsub("%s", "") == ""
	setOutput(e2Output, result, isEmpty or err)
end)

e2Back.MouseButton1Click:Connect(function()
	e2Input.Text  = ""
	e2Output.Text = ""
	e2Key.Text    = ""
	transition(Cipher2GUI, EncryptFrame2, ModeGUI, ModeFrame)
end)

d2Run.MouseButton1Click:Connect(function()
	local result, err = Ciphers[selectedCipher].Decrypt(d2Input.Text, d2Key.Text)
	local isEmpty = result == nil or result:gsub("%s", "") == ""
	setOutput(d2Output, result, isEmpty or err)
end)

d2Back.MouseButton1Click:Connect(function()
	d2Input.Text  = ""
	d2Output.Text = ""
	d2Key.Text    = ""
	transition(Cipher2GUI, DecryptFrame2, ModeGUI, ModeFrame)
end)
