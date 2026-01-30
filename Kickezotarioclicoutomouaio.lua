-- Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer

-- CONFIG
local NORMAL_SIZE = UDim2.new(0, 120, 0, 45)
local CLICK_SIZE  = UDim2.new(0, 108, 0, 40)
local NORMAL_TEXT = 22
local CLICK_TEXT  = 18
local DRAG_LIMIT  = 6

local gui, frame, button
local dragging, moved, dragStart, startPos = false, false, nil, nil

-- ===== FUNÇÃO DE CRIAÇÃO =====
local function createGui()
	if gui and gui.Parent then return end

	gui = Instance.new("ScreenGui")
	gui.Name = "MiniKickGui"
	gui.ResetOnSpawn = false
	gui.Parent = player:WaitForChild("PlayerGui")

	frame = Instance.new("Frame")
	frame.Parent = gui
	frame.Size = UDim2.new(0, 0, 0, 0)
	frame.Position = UDim2.new(0.5, -60, 0.5, -22)
	frame.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
	frame.BorderColor3 = Color3.new(0,0,0)
	frame.BorderSizePixel = 2
	frame.Active = true

	button = Instance.new("TextButton")
	button.Parent = frame
	button.Size = UDim2.new(1, 0, 1, 0)
	button.BackgroundTransparency = 1
	button.AutoButtonColor = false
	button.Text = "KICK"
	button.TextSize = NORMAL_TEXT
	button.Font = Enum.Font.GothamBlack
	button.TextColor3 = Color3.new(1,1,1)

	local by = Instance.new("TextLabel")
	by.Parent = frame
	by.Size = UDim2.new(1, 0, 0.3, 0)
	by.Position = UDim2.new(0, 0, 0.7, 0)
	by.Text = "By olhadinhaso"
	by.TextSize = 12
	by.Font = Enum.Font.Gotham
	by.TextColor3 = Color3.fromRGB(230,230,230)
	by.BackgroundTransparency = 1

	-- Animação de aparecer
	TweenService:Create(
		frame,
		TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
		{ Size = NORMAL_SIZE }
	):Play()

	-- ===== DRAG =====
	local function startInput(input)
		dragging = true
		moved = false
		dragStart = input.Position
		startPos = frame.Position
	end

	local function updateInput(input)
		if not dragging then return end
		local delta = input.Position - dragStart

		if math.abs(delta.X) > DRAG_LIMIT or math.abs(delta.Y) > DRAG_LIMIT then
			moved = true
		end

		frame.Position = startPos + UDim2.fromOffset(delta.X, delta.Y)
	end

	frame.InputBegan:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 then
			startInput(i)
		end
	end)

	button.InputBegan:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 then
			startInput(i)
		end
	end)

	UserInputService.InputChanged:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseMovement then
			updateInput(i)
		end
	end)

	UserInputService.InputEnded:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = false
		end
	end)

	-- ===== CLIQUE =====
	button.MouseButton1Down:Connect(function()
		TweenService:Create(frame, TweenInfo.new(0.06), { Size = CLICK_SIZE }):Play()
		TweenService:Create(button, TweenInfo.new(0.06), { TextSize = CLICK_TEXT }):Play()
	end)

	button.MouseButton1Up:Connect(function()
		TweenService:Create(frame, TweenInfo.new(0.06), { Size = NORMAL_SIZE }):Play()
		TweenService:Create(button, TweenInfo.new(0.06), { TextSize = NORMAL_TEXT }):Play()

		if moved then return end
		player:Kick("FILHA DA PUTA VOCÊ CLICKOU NA PORRA DO KICK E TOMOU PORRA DE KICK CARAI")
	end)
end

-- ===== GARANTE QUE SEMPRE EXISTA =====
createGui()

player.CharacterAdded:Connect(function()
	task.wait(0.2)
	createGui()
end)
