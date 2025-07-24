-- Made By: Anwar🇮🇶 | TikTok: @hf4_l | Dev.Anwar ESP + Aimbot GUI

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- إنشاء واجهة رئيسية
local gui = Instance.new("ScreenGui")
gui.Name = "DevAnwarESP"
gui.ResetOnSpawn = false
gui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- زر دائري خارجي لتحريك وفتح القائمة
local circleBtn = Instance.new("TextButton")
circleBtn.Size = UDim2.new(0, 60, 0, 60)
circleBtn.Position = UDim2.new(0.5, -30, 0.05, 0)
circleBtn.Text = "Dev.Anwar"
circleBtn.TextColor3 = Color3.new(1, 1, 1)
circleBtn.Font = Enum.Font.GothamBold
circleBtn.TextSize = 12
circleBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
circleBtn.BorderSizePixel = 0
circleBtn.Name = "DevAnwarButton"
circleBtn.Parent = gui
circleBtn.Active = true
circleBtn.Draggable = true

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(1, 0)
corner.Parent = circleBtn

-- الإطار الداخلي للقائمة (الـESP + Aimbot)
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 220, 0, 180)
mainFrame.Position = UDim2.new(0.5, -110, 0.5, -90)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.Visible = false
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = gui

local corner2 = Instance.new("UICorner")
corner2.CornerRadius = UDim.new(0, 10)
corner2.Parent = mainFrame

-- عنوان الحقوق (مكان العنوان القديم)
local rightsLabel = Instance.new("TextLabel")
rightsLabel.Size = UDim2.new(1, 0, 0, 20)
rightsLabel.Position = UDim2.new(0, 0, 0, 0)
rightsLabel.BackgroundTransparency = 1
rightsLabel.Text = "Made By: Anwar🇮🇶"
rightsLabel.TextColor3 = Color3.new(1, 1, 1)
rightsLabel.Font = Enum.Font.SourceSansSemibold
rightsLabel.TextSize = 16
rightsLabel.Parent = mainFrame

local rightsLabel2 = Instance.new("TextLabel")
rightsLabel2.Size = UDim2.new(1, 0, 0, 20)
rightsLabel2.Position = UDim2.new(0, 0, 0, 25)
rightsLabel2.BackgroundTransparency = 1
rightsLabel2.Text = "TikTok: @hf4_l"
rightsLabel2.TextColor3 = Color3.new(1, 1, 1)
rightsLabel2.Font = Enum.Font.SourceSansSemibold
rightsLabel2.TextSize = 14
rightsLabel2.Parent = mainFrame

-- --------------------
-- زر تفعيل وإيقاف Aimbot
local aimbotEnabled = false
local fovRadius = 150

local toggleAimbotBtn = Instance.new("TextButton")
toggleAimbotBtn.Size = UDim2.new(0, 200, 0, 30)
toggleAimbotBtn.Position = UDim2.new(0, 10, 0, 55)
toggleAimbotBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
toggleAimbotBtn.TextColor3 = Color3.new(1, 1, 1)
toggleAimbotBtn.Font = Enum.Font.SourceSansBold
toggleAimbotBtn.TextSize = 16
toggleAimbotBtn.Text = "Aimbot: OFF"
toggleAimbotBtn.Parent = mainFrame

-- إدخال تغيير حجم دائرة FOV
local FOVInput = Instance.new("TextBox")
FOVInput.Size = UDim2.new(0, 200, 0, 25)
FOVInput.Position = UDim2.new(0, 10, 0, 90)
FOVInput.PlaceholderText = "FOV Radius (50-500)"
FOVInput.Text = tostring(fovRadius)
FOVInput.ClearTextOnFocus = false
FOVInput.TextColor3 = Color3.new(1, 1, 1)
FOVInput.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
FOVInput.Font = Enum.Font.SourceSans
FOVInput.TextSize = 14
FOVInput.Parent = mainFrame

-- دائرة FOV مرسومة
local FOVCircle = Drawing.new("Circle")
FOVCircle.Radius = fovRadius
FOVCircle.Thickness = 2
FOVCircle.Color = Color3.fromRGB(0, 255, 255)
FOVCircle.Filled = false
FOVCircle.Visible = true

toggleAimbotBtn.MouseButton1Click:Connect(function()
    aimbotEnabled = not aimbotEnabled
    toggleAimbotBtn.Text = aimbotEnabled and "Aimbot: ON" or "Aimbot: OFF"
end)

FOVInput.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        local val = tonumber(FOVInput.Text)
        if val and val >= 50 and val <= 500 then
            fovRadius = val
            FOVCircle.Radius = fovRadius
        else
            FOVInput.Text = tostring(fovRadius)
        end
    end
end)

-- التعديل هنا في دالة getClosestPlayer
local function getClosestPlayer()
    local closest = nil
    local shortestDist = math.huge
    local camPos = Camera.CFrame.Position
    local center = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)

    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("Head") then
            local headPos = plr.Character.Head.Position
            local dist = (headPos - camPos).Magnitude

            local screenPos, onScreen = Camera:WorldToViewportPoint(headPos)
            local screenPos2D = Vector2.new(screenPos.X, screenPos.Y)
            local distToCenter = (screenPos2D - center).Magnitude

            if dist < shortestDist and distToCenter <= fovRadius and onScreen then
                shortestDist = dist
                closest = plr
            end
        end
    end

    return closest
end

-- وظيفة الاسب داخلي: دائرة الكشف لون أزرق شفاف (قليل الوضوح لكن واضح)
local ESP = {}
ESP.Enabled = true
ESP.TeamCheck = false
ESP.Players = true
ESP.Boxes = true
ESP.Names = true
ESP.Tracers = true
ESP.HealthBar = true
ESP.Colors = {
    Enemy = Color3.fromRGB(50, 150, 255),  -- أزرق شفاف غير قوي
    Teammate = Color3.fromRGB(0, 255, 0)
}

local function Draw(type)
    local obj = Drawing.new(type)
    obj.Visible = false
    return obj
end

local function NewESP(player)
    local box = Draw("Square")
    local tracer = Draw("Line")
    local name = Draw("Text")
    local healthbar = Draw("Line")

    return RunService.RenderStepped:Connect(function()
        if not ESP.Enabled or not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
            box.Visible = false
            tracer.Visible = false
            name.Visible = false
            healthbar.Visible = false
            return
        end

        local hrp = player.Character.HumanoidRootPart
        local hum = player.Character:FindFirstChildOfClass("Humanoid")
        local pos, onScreen = Camera:WorldToViewportPoint(hrp.Position)

        if not onScreen then
            box.Visible = false
            tracer.Visible = false
            name.Visible = false
            healthbar.Visible = false
            return
        end

        local color = ESP.Colors.Enemy
        if ESP.TeamCheck and player.Team == LocalPlayer.Team then
            color = ESP.Colors.Teammate
        end

        local top = Camera:WorldToViewportPoint(hrp.Position + Vector3.new(0, 3, 0))
        local bottom = Camera:WorldToViewportPoint(hrp.Position - Vector3.new(0, 3, 0))
        local height = top.Y - bottom.Y
        local width = height / 2

        if ESP.Boxes then
            box.Size = Vector2.new(width, height)
            box.Position = Vector2.new(pos.X - width / 2, pos.Y - height / 2)
            box.Color = color
            box.Thickness = 2
            box.Transparency = 0.5 -- شفاف أقل من الافتراضي
            box.Visible = true
        else
            box.Visible = false
        end

        if ESP.Tracers then
            tracer.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
            tracer.To = Vector2.new(pos.X, pos.Y)
            tracer.Color = color
            tracer.Thickness = 1
            tracer.Transparency = 0.5
            tracer.Visible = true
        else
            tracer.Visible = false
        end

        if ESP.Names then
            name.Text = player.Name
            name.Position = Vector2.new(pos.X, pos.Y - height / 2 - 15)
            name.Color = color
            name.Size = 16
            name.Center = true
            name.Outline = true
            name.Visible = true
        else
            name.Visible = false
        end

        if ESP.HealthBar and hum then
            local healthPercent = hum.Health / hum.MaxHealth
            healthbar.From = Vector2.new(pos.X - width / 2 - 6, pos.Y + height / 2)
            healthbar.To = Vector2.new(pos.X - width / 2 - 6, pos.Y + height / 2 - height * healthPercent)
            healthbar.Color = Color3.fromRGB(0, 255, 0)
            healthbar.Thickness = 2
            healthbar.Visible = true
        else
            healthbar.Visible = false
        end
    end)
end

for _, player in ipairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        coroutine.wrap(function()
            NewESP(player)
        end)()
    end
end

Players.PlayerAdded:Connect(function(player)
    if player ~= LocalPlayer then
        coroutine.wrap(function()
            NewESP(player)
        end)()
    end
end)

-- تحديث دائرة FOV ومكانها باستمرار (دائرة الأيمبوت)
RunService.RenderStepped:Connect(function()
    local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    FOVCircle.Position = center
    FOVCircle.Visible = true

    if aimbotEnabled then
        local target = getClosestPlayer()
        if target and target.Character and target.Character:FindFirstChild("Head") then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Character.Head.Position)
        end
    end
end)

-- زر لفتح وغلق القائمة الداخلية عند الضغط على الزر الدائري الخارجي
circleBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = not mainFrame.Visible
end)
