local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")

-- الإعدادات الافتراضية
local AimPart = "HumanoidRootPart"
local PredictAmount = 15
local IsAiming = false
local AimStrength = 1
local AimZoneRadius = 100
local MaxDistance = 1000
local CurrentTarget = nil
local ESPDrawings, BoxAdorns = {}, {}

-- قائمة تجاهل اللاعبين (Ignore List)
local IgnoreList = {}

-- دائرة FOV
local FOVCircle = Drawing.new("Circle")
FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
FOVCircle.Radius = AimZoneRadius
FOVCircle.Thickness = 1
FOVCircle.Color = Color3.fromRGB(255,255,255)
FOVCircle.Transparency = 0.4
FOVCircle.Filled = false
FOVCircle.Visible = true

-- تنظيف البوكسات القديمة
local function ClearBoxes()
	for _, b in pairs(BoxAdorns) do b:Destroy() end
	BoxAdorns = {}
end

-- رسم بوكس حول اللاعب (BoxHandleAdornment)
local function DrawBox(player, isIgnored)
	local char = player.Character
	if not char then return end
	local boxSize = Vector3.new(3, 6, 2)
	local adorn = Instance.new("BoxHandleAdornment")
	adorn.Name = "DevAnwar_Box"
	adorn.Adornee = char:FindFirstChild("HumanoidRootPart")
	adorn.AlwaysOnTop = true
	adorn.ZIndex = 1
	adorn.Size = boxSize
	adorn.Transparency = 0.7
	if isIgnored then
		adorn.Color3 = Color3.fromRGB(0, 255, 0) -- أخضر للمتجاهلين
	else
		adorn.Color3 = player.TeamColor.Color
	end
	adorn.Parent = char
	table.insert(BoxAdorns, adorn)
end

-- تحديث ESP
local function UpdateESP()
	for _, d in pairs(ESPDrawings) do d:Remove() end
	ESPDrawings = {}
	ClearBoxes()

	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") and player.Character:FindFirstChild("Humanoid") then
			local head = player.Character.Head
			local hp = player.Character.Humanoid
			local distance = (head.Position - Camera.CFrame.Position).Magnitude
			if hp.Health > 0 and distance <= MaxDistance then
				local pos, onScreen = Camera:WorldToViewportPoint(head.Position)
				if onScreen then
					local isIgnored = IgnoreList[player.UserId] == true

					-- الخط
					local line = Drawing.new("Line")
					line.From = Vector2.new(Camera.ViewportSize.X / 2, 0)
					line.To = Vector2.new(pos.X, pos.Y)
					line.Color = isIgnored and Color3.fromRGB(0, 255, 0) or player.TeamColor.Color
					line.Thickness = 1
					line.Transparency = 0.6
					line.Visible = true
					table.insert(ESPDrawings, line)

					-- النص (اسم اللاعب، المسافة، النسبة المئوية للدم)
					local text = Drawing.new("Text")
					text.Text = string.format("%s | %.0fm | %d%%", player.Name, distance, math.floor(hp.Health / hp.MaxHealth * 100))
					text.Position = Vector2.new(pos.X, pos.Y - 20)
					text.Size = 12
					text.Color = isIgnored and Color3.fromRGB(0, 255, 0) or player.TeamColor.Color
					text.Center = true
					text.Outline = true
					text.Visible = true
					table.insert(ESPDrawings, text)

					-- البوكس حول اللاعب
					DrawBox(player, isIgnored)
				end
			end
		end
	end
end

-- إنشاء الـ GUI الخارجي (زر فتح وغلق القائمة)
local externalGui = Instance.new("ScreenGui", CoreGui)
externalGui.Name = "DevAnwar_External"

local openButton = Instance.new("TextButton", externalGui)
openButton.Size = UDim2.new(0, 60, 0, 60)
openButton.Position = UDim2.new(0, 10, 0.4, 0)
openButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
openButton.Text = "Dev.Anwar"
openButton.TextColor3 = Color3.fromRGB(255, 255, 255)
openButton.TextSize = 14
openButton.Font = Enum.Font.SourceSansBold
openButton.BorderSizePixel = 0
openButton.Active = true
openButton.Draggable = true

-- إنشاء الـ GUI الداخلي (القائمة الرئيسية)
local gui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
gui.Name = "DevAnwar_GUI"
gui.Enabled = false
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 250, 0, 400)
frame.Position = UDim2.new(0.02, 0, 0.3, 0)
frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
frame.BorderSizePixel = 2
frame.BorderColor3 = Color3.fromRGB(255, 255, 255)
frame.Active = true
frame.Draggable = true

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, -35, 0, 25)
title.Position = UDim2.new(0, 5, 0, 0)
title.BackgroundTransparency = 1
title.Text = "Dev.Anwar🇮🇶"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 18
title.Font = Enum.Font.SourceSansBold

local closeBtn = Instance.new("TextButton", frame)
closeBtn.Size = UDim2.new(0, 30, 0, 25)
closeBtn.Position = UDim2.new(1, -35, 0, 0)
closeBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.Font = Enum.Font.SourceSansBold
closeBtn.TextSize = 18
closeBtn.MouseButton1Click:Connect(function()
	gui.Enabled = false
end)

local credits = Instance.new("TextLabel", frame)
credits.Size = UDim2.new(1, -10, 0, 25)
credits.Position = UDim2.new(0, 5, 0.06, 0)
credits.BackgroundTransparency = 1
credits.Text = "TikTok: @hf4_l"
credits.TextColor3 = Color3.fromRGB(0, 255, 0)
credits.TextSize = 13
credits.Font = Enum.Font.SourceSans

local updateNotice = Instance.new("TextLabel", frame)
updateNotice.Size = UDim2.new(1, -10, 0, 30)
updateNotice.Position = UDim2.new(0, 5, 0.12, 0)
updateNotice.BackgroundTransparency = 1
updateNotice.Text = "🔄 تم تحديث السكربت – تمت إضافة نظام تجاهل اللاعبين ✅"
updateNotice.TextColor3 = Color3.fromRGB(255, 255, 0)
updateNotice.TextSize = 14
updateNotice.Font = Enum.Font.SourceSansBold
updateNotice.TextWrapped = true

-- زر تفعيل وإيقاف Aimbot
local aimBtn = Instance.new("TextButton", frame)
aimBtn.Size = UDim2.new(0.9, 0, 0, 30)
aimBtn.Position = UDim2.new(0.05, 0, 0.2, 0)
aimBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
aimBtn.Text = "Aimbot: OFF"
aimBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
aimBtn.Font = Enum.Font.SourceSansBold
aimBtn.TextSize = 14
aimBtn.MouseButton1Click:Connect(function()
	IsAiming = not IsAiming
	aimBtn.Text = IsAiming and "Aimbot: ON" or "Aimbot: OFF"
end)

-- زر تغيير هدف الأيم بوت (رأس / جسم)
local aimPartBtn = Instance.new("TextButton", frame)
aimPartBtn.Size = UDim2.new(0.9, 0, 0, 30)
aimPartBtn.Position = UDim2.new(0.05, 0, 0.28, 0)
aimPartBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
aimPartBtn.Text = "Target: Body"
aimPartBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
aimPartBtn.Font = Enum.Font.SourceSansBold
aimPartBtn.TextSize = 14
aimPartBtn.MouseButton1Click:Connect(function()
	if AimPart == "HumanoidRootPart" then
		AimPart = "Head"
		aimPartBtn.Text = "Target: Head"
	else
		AimPart = "HumanoidRootPart"
		aimPartBtn.Text = "Target: Body"
	end
end)

-- زر تغيير قيمة Predict
local predictBtn = Instance.new("TextButton", frame)
predictBtn.Size = UDim2.new(0.9, 0, 0, 30)
predictBtn.Position = UDim2.new(0.05, 0, 0.36, 0)
predictBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
predictBtn.Text = "Predict: "..PredictAmount
predictBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
predictBtn.Font = Enum.Font.SourceSansBold
predictBtn.TextSize = 14
predictBtn.MouseButton1Click:Connect(function()
	PredictAmount = PredictAmount + 1
	if PredictAmount > 30 then PredictAmount = 1 end
	predictBtn.Text = "Predict: "..PredictAmount
end)

-- نص حجم FOV
local fovLabel = Instance.new("TextLabel", frame)
fovLabel.Size = UDim2.new(0.9, 0, 0, 20)
fovLabel.Position = UDim2.new(0.05, 0, 0.44, 0)
fovLabel.BackgroundTransparency = 1
fovLabel.Text = "FOV Size: "..AimZoneRadius
fovLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
fovLabel.TextSize = 14
fovLabel.Font = Enum.Font.SourceSansBold

-- مربع تعديل FOV
local fovBox = Instance.new("TextBox", frame)
fovBox.Size = UDim2.new(0.9, 0, 0, 30)
fovBox.Position = UDim2.new(0.05, 0, 0.48, 0)
fovBox.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
fovBox.Text = tostring(AimZoneRadius)
fovBox.TextColor3 = Color3.fromRGB(255, 255, 255)
fovBox.TextSize = 14
fovBox.Font = Enum.Font.SourceSansBold
fovBox.ClearTextOnFocus = false
fovBox.FocusLost:Connect(function()
	local num = tonumber(fovBox.Text)
	if num and num >= 50 and num <= 500 then
		AimZoneRadius = num
		FOVCircle.Radius = num
		fovLabel.Text = "FOV Size: "..num
	else
		fovBox.Text = tostring(AimZoneRadius)
	end
end)

-- *** قائمة تجاهل اللاعبين (Ignore Players List) ***

-- إطار القائمة الجديدة داخل الـ GUI
local ignoreFrame = Instance.new("Frame", frame)
ignoreFrame.Size = UDim2.new(0.9, 0, 0.3, 0)
ignoreFrame.Position = UDim2.new(0.05, 0, 0.57, 0)
ignoreFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
ignoreFrame.BorderSizePixel = 1
ignoreFrame.BorderColor3 = Color3.fromRGB(100, 100, 100)

-- عنوان القائمة
local ignoreTitle = Instance.new("TextLabel", ignoreFrame)
ignoreTitle.Size = UDim2.new(1, 0, 0, 25)
ignoreTitle.Position = UDim2.new(0, 0, 0, 0)
ignoreTitle.BackgroundTransparency = 1
ignoreTitle.Text = "Ignore Players"
ignoreTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
ignoreTitle.TextSize = 16
ignoreTitle.Font = Enum.Font.SourceSansBold

-- ScrollFrame لاحتواء الأسماء مع إمكانية التمرير
local ignoreListFrame = Instance.new("ScrollingFrame", ignoreFrame)
ignoreListFrame.Size = UDim2.new(1, 0, 1, -25)
ignoreListFrame.Position = UDim2.new(0, 0, 0, 25)
ignoreListFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ignoreListFrame.ScrollBarThickness = 6
ignoreListFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
ignoreListFrame.BorderSizePixel = 0

-- تخزين أزرار اللاعبين
local ignoreButtons = {}

-- وظيفة لتحديث قائمة الأسماء داخل الـ ScrollFrame
local function UpdateIgnoreList()
	-- نمسح الموجود سابقًا
	for _, btn in pairs(ignoreButtons) do
		btn:Destroy()
	end
	ignoreButtons = {}

	local yPos = 0
	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= LocalPlayer then
			local btn = Instance.new("TextButton", ignoreListFrame)
			btn.Size = UDim2.new(1, -10, 0, 30)
			btn.Position = UDim2.new(0, 5, 0, yPos)
			btn.BackgroundColor3 = IgnoreList[player.UserId] and Color3.fromRGB(150, 0, 0) or Color3.fromRGB(50, 50, 50)
			btn.TextColor3 = Color3.fromRGB(255, 255, 255)
			btn.Font = Enum.Font.SourceSansBold
			btn.TextSize = 14
			btn.Text = player.Name
			btn.BorderSizePixel = 0

			-- عند الضغط على الاسم يبدل حالة التجاهل
			btn.MouseButton1Click:Connect(function()
				if IgnoreList[player.UserId] then
					IgnoreList[player.UserId] = nil
					btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
				else
					IgnoreList[player.UserId] = true
					btn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
				end
			end)

			ignoreButtons[player.UserId] = btn
			yPos = yPos + 35
		end
	end

	-- تحديث حجم الكانفس للتمرير
	ignoreListFrame.CanvasSize = UDim2.new(0, 0, 0, yPos)
end

-- استدعاء التحديث أول مرة
UpdateIgnoreList()

-- تحديث القائمة كل ما دخل لاعب جديد أو خرج
Players.PlayerAdded:Connect(UpdateIgnoreList)
Players.PlayerRemoving:Connect(function(player)
	IgnoreList[player.UserId] = nil
	UpdateIgnoreList()
end)

-- زر فتح وغلق الـ GUI
openButton.MouseButton1Click:Connect(function()
	gui.Enabled = not gui.Enabled
end)

-- الحلقة الرئيسية للأيم بوت وتحديث ESP
RunService.RenderStepped:Connect(function()
	UpdateESP()

	if IsAiming then
		local closest, closestDist = nil, AimZoneRadius

		for _, player in ipairs(Players:GetPlayers()) do
			if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild(AimPart) and player.Character:FindFirstChild("Humanoid") then
				if not IgnoreList[player.UserId] then -- يتجاهل اللاعبين في القائمة
					local humanoid = player.Character.Humanoid
					if humanoid.Health > 0 then
						local pos, onScreen = Camera:WorldToViewportPoint(player.Character[AimPart].Position)
						local dist = (Vector2.new(pos.X, pos.Y) - Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)).Magnitude
						if onScreen and dist <= AimZoneRadius and dist < closestDist then
							closest = player
							closestDist = dist
						end
					end
				end
			end
		end

		CurrentTarget = closest

		if CurrentTarget and CurrentTarget.Character and CurrentTarget.Character:FindFirstChild(AimPart) then
			local part = CurrentTarget.Character[AimPart]
			local predicted = part.Position + (part.Velocity * (PredictAmount / 100))
			local aimCFrame = CFrame.new(Camera.CFrame.Position, predicted)
			Camera.CFrame = Camera.CFrame:Lerp(aimCFrame, AimStrength)
		end
	end
end)
