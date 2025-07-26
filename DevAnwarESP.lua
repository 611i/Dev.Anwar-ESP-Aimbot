local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local AimPart = "HumanoidRootPart"
local PredictAmount = 15
local IsAiming = false
local AimStrength = 1
local AimZoneRadius = 50
local MaxDistance = 1000
local CurrentTarget = nil
local ESPDrawings, BoxAdorns = {}, {}

-- FOV Circle
local FOVCircle = Drawing.new("Circle")
FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
FOVCircle.Radius = 100
FOVCircle.Thickness = 1
FOVCircle.Color = Color3.fromRGB(255,255,255)
FOVCircle.Transparency = 0.4
FOVCircle.Filled = false
FOVCircle.Visible = true

local function ClearBoxes()
    for _, box in pairs(BoxAdorns) do box:Destroy() end
    BoxAdorns = {}
end

local function DrawBox(player)
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
    adorn.Color3 = player.TeamColor.Color
    adorn.Parent = char
    table.insert(BoxAdorns, adorn)
end

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
                    local line = Drawing.new("Line")
                    line.From = Vector2.new(Camera.ViewportSize.X / 2, 0)
                    line.To = Vector2.new(pos.X, pos.Y)
                    line.Color = player.TeamColor.Color
                    line.Thickness = 1
                    line.Transparency = 0.6
                    line.Visible = true
                    table.insert(ESPDrawings, line)

                    local text = Drawing.new("Text")
                    text.Text = string.format("%s | %.0fm | %d%%", player.Name, distance, math.floor(hp.Health / hp.MaxHealth * 100))
                    text.Position = Vector2.new(pos.X, pos.Y - 20)
                    text.Size = 12
                    text.Color = player.TeamColor.Color
                    text.Center = true
                    text.Outline = true
                    text.Visible = true
                    table.insert(ESPDrawings, text)

                    DrawBox(player)
                end
            end
        end
    end
end

local function GetClosestToCrosshair()
    local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    local closestPlayer, closestDist = nil, math.huge

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild(AimPart) and player.Character:FindFirstChild("Humanoid") then
            if player.Character.Humanoid.Health > 0 then
                local pos, onScreen = Camera:WorldToViewportPoint(player.Character[AimPart].Position)
                if onScreen then
                    local dist = (Vector2.new(pos.X, pos.Y) - center).Magnitude
                    local worldDist = (player.Character[AimPart].Position - Camera.CFrame.Position).Magnitude
                    if dist < closestDist and dist <= AimZoneRadius and worldDist <= MaxDistance then
                        closestDist = dist
                        closestPlayer = player
                    end
                end
            end
        end
    end

    return closestPlayer
end

-- GUI
local gui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
gui.Name = "DevAnwar_Aimbot"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 160, 0, 130)
frame.Position = UDim2.new(0.02, 0, 0.3, 0)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 2
frame.BorderColor3 = Color3.fromRGB(255, 255, 255)
frame.Active = true
frame.Draggable = true

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 20)
title.BackgroundTransparency = 1
title.Text = "made by Anwar"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 16
title.Font = Enum.Font.SourceSansBold

local toggle = Instance.new("TextButton", frame)
toggle.Size = UDim2.new(0.9, 0, 0, 30)
toggle.Position = UDim2.new(0.05, 0, 0.2, 0)
toggle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
toggle.Text = "Aim OFF"
toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
toggle.Font = Enum.Font.SourceSansBold
toggle.TextSize = 18

local aimpartBtn = Instance.new("TextButton", frame)
aimpartBtn.Size = UDim2.new(0.9, 0, 0, 20)
aimpartBtn.Position = UDim2.new(0.05, 0, 0.55, 0)
aimpartBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
aimpartBtn.Text = "Aim: Body"
aimpartBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
aimpartBtn.Font = Enum.Font.SourceSansBold
aimpartBtn.TextSize = 14

local predict = Instance.new("TextButton", frame)
predict.Size = UDim2.new(0.9, 0, 0, 30)
predict.Position = UDim2.new(0.05, 0, 0.75, 0)
predict.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
predict.Text = "Predict: "..PredictAmount
predict.TextColor3 = Color3.fromRGB(255, 255, 255)
predict.Font = Enum.Font.SourceSansBold
predict.TextSize = 16

toggle.MouseButton1Click:Connect(function()
	IsAiming = not IsAiming
	toggle.Text = IsAiming and "Aim ON" or "Aim OFF"
end)

predict.MouseButton1Click:Connect(function()
	PredictAmount += 1
	if PredictAmount > 30 then PredictAmount = 1 end
	predict.Text = "Predict: "..PredictAmount
end)

aimpartBtn.MouseButton1Click:Connect(function()
	if AimPart == "HumanoidRootPart" then
		AimPart = "Head"
		aimpartBtn.Text = "Aim: Head"
	else
		AimPart = "HumanoidRootPart"
		aimpartBtn.Text = "Aim: Body"
	end
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.X then
        IsAiming = not IsAiming
        toggle.Text = IsAiming and "Aim ON" or "Aim OFF"
    end
end)

RunService.RenderStepped:Connect(function()
	UpdateESP()

	if IsAiming then
		if not CurrentTarget or not CurrentTarget.Character or CurrentTarget.Character:FindFirstChild("Humanoid") == nil or CurrentTarget.Character.Humanoid.Health <= 0 then
			CurrentTarget = GetClosestToCrosshair()
		end
		if CurrentTarget and CurrentTarget.Character and CurrentTarget.Character:FindFirstChild(AimPart) then
			local part = CurrentTarget.Character[AimPart]
			local predicted = part.Position + (part.Velocity * (PredictAmount / 100))
			local aimCFrame = CFrame.new(Camera.CFrame.Position, predicted)
			Camera.CFrame = Camera.CFrame:Lerp(aimCFrame, AimStrength)
		end
	end
end)
