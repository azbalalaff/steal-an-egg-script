-- Verify GUI Script — Universal Executor Compatible
-- Synapse X, KRNL, Delta, Fluxus, Arceus X, Oxygen U, Script-Ware, etc.
-- Place in StarterPlayerScripts as a LocalScript OR execute via executor

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
local player = Players.LocalPlayer
assert(player, "Run this script on the client as a LocalScript.")
local playerGui = player:WaitForChild("PlayerGui")

-- Remove existing instance if re-executed
if playerGui:FindFirstChild("VerifyGui") then
    playerGui.VerifyGui:Destroy()
end
if game:GetService("Lighting"):FindFirstChild("BlurEffect") then
    game:GetService("Lighting").BlurEffect:Destroy()
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "VerifyGui"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
-- Universal: some executors need this
pcall(function() screenGui.DisplayOrder = 999 end)
screenGui.Parent = playerGui

local blur = Instance.new("BlurEffect")
blur.Name = "BlurEffect"
blur.Size = 24
blur.Parent = game:GetService("Lighting")

-- ============================================================
-- LOADING SCREEN
-- ============================================================

local loadOverlay = Instance.new("Frame")
loadOverlay.Size = UDim2.new(1, 0, 1, 0)
loadOverlay.BackgroundColor3 = Color3.fromRGB(8, 8, 14)
loadOverlay.BorderSizePixel = 0
loadOverlay.ZIndex = 20
loadOverlay.Parent = screenGui

-- Animated background grid lines
local gridFrame = Instance.new("Frame")
gridFrame.Size = UDim2.new(1, 0, 1, 0)
gridFrame.BackgroundTransparency = 1
gridFrame.ZIndex = 21
gridFrame.Parent = loadOverlay

for i = 1, 8 do
    local hLine = Instance.new("Frame")
    hLine.Size = UDim2.new(1, 0, 0, 1)
    hLine.Position = UDim2.new(0, 0, i / 9, 0)
    hLine.BackgroundColor3 = Color3.fromRGB(30, 50, 120)
    hLine.BackgroundTransparency = 0.7
    hLine.BorderSizePixel = 0
    hLine.ZIndex = 21
    hLine.Parent = gridFrame
end
for i = 1, 12 do
    local vLine = Instance.new("Frame")
    vLine.Size = UDim2.new(0, 1, 1, 0)
    vLine.Position = UDim2.new(i / 13, 0, 0, 0)
    vLine.BackgroundColor3 = Color3.fromRGB(30, 50, 120)
    vLine.BackgroundTransparency = 0.7
    vLine.BorderSizePixel = 0
    vLine.ZIndex = 21
    vLine.Parent = gridFrame
end

-- Center logo container
local logoFrame = Instance.new("Frame")
logoFrame.Size = UDim2.new(0, 120, 0, 120)
logoFrame.AnchorPoint = Vector2.new(0.5, 0.5)
logoFrame.Position = UDim2.new(0.5, 0, 0.38, 0)
logoFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
logoFrame.BorderSizePixel = 0
logoFrame.ZIndex = 22
logoFrame.Parent = loadOverlay

local logoCorner = Instance.new("UICorner")
logoCorner.CornerRadius = UDim.new(0, 24)
logoCorner.Parent = logoFrame

local logoStroke = Instance.new("UIStroke")
logoStroke.Color = Color3.fromRGB(55, 100, 255)
logoStroke.Thickness = 2
logoStroke.Parent = logoFrame

local logoIcon = Instance.new("TextLabel")
logoIcon.Size = UDim2.new(1, 0, 1, 0)
logoIcon.BackgroundTransparency = 1
logoIcon.Text = "🔒"
logoIcon.TextSize = 52
logoIcon.Font = Enum.Font.GothamBold
logoIcon.ZIndex = 23
logoIcon.Parent = logoFrame

-- Pulsing ring around logo
local ring = Instance.new("Frame")
ring.Size = UDim2.new(0, 120, 0, 120)
ring.AnchorPoint = Vector2.new(0.5, 0.5)
ring.Position = UDim2.new(0.5, 0.5, 0.5, 0.5)
ring.BackgroundTransparency = 1
ring.BorderSizePixel = 0
ring.ZIndex = 22
ring.Parent = logoFrame

local ringStroke = Instance.new("UIStroke")
ringStroke.Color = Color3.fromRGB(55, 100, 255)
ringStroke.Thickness = 2
ringStroke.Transparency = 0.5
ringStroke.Parent = ring

local ringCorner = Instance.new("UICorner")
ringCorner.CornerRadius = UDim.new(0.5, 0)
ringCorner.Parent = ring

-- Loading title
local loadTitle = Instance.new("TextLabel")
loadTitle.Size = UDim2.new(0, 360, 0, 40)
loadTitle.AnchorPoint = Vector2.new(0.5, 0)
loadTitle.Position = UDim2.new(0.5, 0, 0, 0)
loadTitle.BackgroundTransparency = 1
loadTitle.Text = "SECURE VERIFICATION"
loadTitle.TextColor3 = Color3.fromRGB(235, 235, 255)
loadTitle.TextSize = isMobile and 17 or 20
loadTitle.Font = Enum.Font.GothamBold
loadTitle.TextXAlignment = Enum.TextXAlignment.Center
loadTitle.ZIndex = 22
loadTitle.Parent = logoFrame

-- Reposition title below logo
loadTitle.Size = UDim2.new(0, 360, 0, 36)
loadTitle.AnchorPoint = Vector2.new(0.5, 0)
loadTitle.Position = UDim2.new(0.5, 0, 0.52, 0)
loadTitle.Parent = loadOverlay

-- Subtitle
local loadSub = Instance.new("TextLabel")
loadSub.Size = UDim2.new(0, 300, 0, 24)
loadSub.AnchorPoint = Vector2.new(0.5, 0)
loadSub.Position = UDim2.new(0.5, 0, 0.57, 0)
loadSub.BackgroundTransparency = 1
loadSub.Text = "Initializing security check..."
loadSub.TextColor3 = Color3.fromRGB(100, 100, 150)
loadSub.TextSize = 13
loadSub.Font = Enum.Font.Gotham
loadSub.TextXAlignment = Enum.TextXAlignment.Center
loadSub.ZIndex = 22
loadSub.Parent = loadOverlay

-- Progress bar track
local barTrack = Instance.new("Frame")
barTrack.Size = UDim2.new(0, isMobile and 280 or 340, 0, 6)
barTrack.AnchorPoint = Vector2.new(0.5, 0)
barTrack.Position = UDim2.new(0.5, 0, 0.63, 0)
barTrack.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
barTrack.BorderSizePixel = 0
barTrack.ZIndex = 22
barTrack.Parent = loadOverlay

local barTrackCorner = Instance.new("UICorner")
barTrackCorner.CornerRadius = UDim.new(1, 0)
barTrackCorner.Parent = barTrack

-- Progress bar fill
local barFill = Instance.new("Frame")
barFill.Size = UDim2.new(0, 0, 1, 0)
barFill.BackgroundColor3 = Color3.fromRGB(55, 100, 255)
barFill.BorderSizePixel = 0
barFill.ZIndex = 23
barFill.Parent = barTrack

local barFillCorner = Instance.new("UICorner")
barFillCorner.CornerRadius = UDim.new(1, 0)
barFillCorner.Parent = barFill

-- Percentage label
local pctLabel = Instance.new("TextLabel")
pctLabel.Size = UDim2.new(0, 100, 0, 22)
pctLabel.AnchorPoint = Vector2.new(0.5, 0)
pctLabel.Position = UDim2.new(0.5, 0, 0.67, 0)
pctLabel.BackgroundTransparency = 1
pctLabel.Text = "0%"
pctLabel.TextColor3 = Color3.fromRGB(80, 140, 255)
pctLabel.TextSize = 13
pctLabel.Font = Enum.Font.GothamBold
pctLabel.TextXAlignment = Enum.TextXAlignment.Center
pctLabel.ZIndex = 22
pctLabel.Parent = loadOverlay

-- Step dots
local dotsFrame = Instance.new("Frame")
dotsFrame.Size = UDim2.new(0, 200, 0, 20)
dotsFrame.AnchorPoint = Vector2.new(0.5, 0)
dotsFrame.Position = UDim2.new(0.5, 0, 0.72, 0)
dotsFrame.BackgroundTransparency = 1
dotsFrame.ZIndex = 22
dotsFrame.Parent = loadOverlay

local dotLayout = Instance.new("UIListLayout")
dotLayout.FillDirection = Enum.FillDirection.Horizontal
dotLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
dotLayout.VerticalAlignment = Enum.VerticalAlignment.Center
dotLayout.Padding = UDim.new(0, 10)
dotLayout.Parent = dotsFrame

local dots = {}
for i = 1, 5 do
    local dot = Instance.new("Frame")
    dot.Size = UDim2.new(0, 8, 0, 8)
    dot.BackgroundColor3 = Color3.fromRGB(40, 40, 70)
    dot.BorderSizePixel = 0
    dot.ZIndex = 23
    dot.Parent = dotsFrame

    local dotCorner = Instance.new("UICorner")
    dotCorner.CornerRadius = UDim.new(1, 0)
    dotCorner.Parent = dot

    dots[i] = dot
end

-- ============================================================
-- LOADING SEQUENCE
-- ============================================================

local loadSteps = {
    { text = "Initializing security check...",  pct = 0  },
    { text = "Connecting to servers...",         pct = 20 },
    { text = "Validating session token...",      pct = 45 },
    { text = "Encrypting request...",            pct = 68 },
    { text = "Almost ready...",                  pct = 88 },
    { text = "Done.",                            pct = 100 },
}

-- Pulse ring animation
local ringPulsing = true
task.spawn(function()
    while ringPulsing do
        TweenService:Create(ringStroke, TweenInfo.new(0.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
            Transparency = 0.1
        }):Play()
        task.wait(0.8)
        TweenService:Create(ringStroke, TweenInfo.new(0.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
            Transparency = 0.8
        }):Play()
        task.wait(0.8)
    end
end)

-- Run loading steps
task.spawn(function()
    -- Progress uses relative scale, so no measured width is needed.

    for i, step in ipairs(loadSteps) do
        -- Update subtitle
        loadSub.Text = step.text

        -- Animate bar
        local targetScale = step.pct / 100
        TweenService:Create(barFill, TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
            Size = UDim2.new(targetScale, 0, 1, 0)
        }):Play()

        -- Animate percentage
        local startPct = i > 1 and loadSteps[i-1].pct or 0
        local endPct = step.pct
        local duration = 0.4
        local elapsed = 0
        local increment = 0.03
        task.spawn(function()
            while elapsed < duration do
                elapsed = elapsed + increment
                local current = math.floor(startPct + (endPct - startPct) * (elapsed / duration))
                pctLabel.Text = current .. "%"
                task.wait(increment)
            end
            pctLabel.Text = endPct .. "%"
        end)

        -- Light up dot
        if dots[i] then
            TweenService:Create(dots[i], TweenInfo.new(0.2), {
                BackgroundColor3 = Color3.fromRGB(55, 100, 255)
            }):Play()
        end

        -- Bar color shifts green at 100%
        if step.pct == 100 then
            TweenService:Create(barFill, TweenInfo.new(0.3), {
                BackgroundColor3 = Color3.fromRGB(30, 180, 100)
            }):Play()
            pctLabel.TextColor3 = Color3.fromRGB(30, 180, 100)
            loadSub.TextColor3 = Color3.fromRGB(80, 200, 120)
            ringPulsing = false
            ringStroke.Color = Color3.fromRGB(30, 180, 100)
        end

        task.wait(i == #loadSteps and 0.6 or 0.55)
    end

    -- Blur fade in
    TweenService:Create(blur, TweenInfo.new(0.5), { Size = 24 }):Play()

    -- Fade out loading screen
    TweenService:Create(loadOverlay, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
        BackgroundTransparency = 1
    }):Play()
    for _, v in ipairs(loadOverlay:GetDescendants()) do
        local properties
        if v:IsA("TextLabel") then
            properties = { BackgroundTransparency = 1, TextTransparency = 1 }
        elseif v:IsA("Frame") then
            properties = { BackgroundTransparency = 1 }
        elseif v:IsA("UIStroke") then
            properties = { Transparency = 1 }
        end
        if properties then
            TweenService:Create(v, TweenInfo.new(0.4), properties):Play()
        end
    end

    task.wait(0.5)
    loadOverlay:Destroy()

    -- ============================================================
    -- VERIFY CARD
    -- ============================================================


local overlay = Instance.new("Frame")
overlay.Size = UDim2.new(1, 0, 1, 0)
overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
overlay.BackgroundTransparency = 0.45
overlay.ZIndex = 5
overlay.Parent = screenGui

local card = Instance.new("Frame")
card.Size = UDim2.new(0, 440, 0, 320)
card.AnchorPoint = Vector2.new(0.5, 0.5)
card.Position = UDim2.new(0.5, 0, 0.65, 0)
card.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
card.BackgroundTransparency = 1
card.BorderSizePixel = 0
card.ZIndex = 10
card.Parent = screenGui

local cardCorner = Instance.new("UICorner")
cardCorner.CornerRadius = UDim.new(0, 14)
cardCorner.Parent = card

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(60, 100, 255)
stroke.Thickness = 1.5
stroke.Transparency = 0.3
stroke.Parent = card

local accent = Instance.new("Frame")
accent.Size = UDim2.new(1, 0, 0, 4)
accent.Position = UDim2.new(0, 0, 0, 0)
accent.BackgroundColor3 = Color3.fromRGB(55, 100, 255)
accent.BorderSizePixel = 0
accent.ZIndex = 13
accent.Parent = card

local accentCorner = Instance.new("UICorner")
accentCorner.CornerRadius = UDim.new(0, 14)
accentCorner.Parent = accent

local icon = Instance.new("TextLabel")
icon.Size = UDim2.new(1, 0, 0, 50)
icon.Position = UDim2.new(0, 0, 0, 18)
icon.BackgroundTransparency = 1
icon.Text = "🔒"
icon.TextSize = 36
icon.Font = Enum.Font.GothamBold
icon.ZIndex = 11
icon.Parent = card

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -40, 0, 36)
title.Position = UDim2.new(0, 20, 0, 72)
title.BackgroundTransparency = 1
title.Text = "⚡ Unlock your exclusive access by joining the group ⚡"
title.TextColor3 = Color3.fromRGB(235, 235, 255)
title.TextSize = 18
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Center
title.ZIndex = 11
title.Parent = card

local divider = Instance.new("Frame")
divider.Size = UDim2.new(0, 320, 0, 1)
divider.AnchorPoint = Vector2.new(0.5, 0)
divider.Position = UDim2.new(0.5, 0, 0, 118)
divider.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
divider.BorderSizePixel = 0
divider.ZIndex = 11
divider.Parent = card

local step1 = Instance.new("TextLabel")
step1.Size = UDim2.new(1, -40, 0, 24)
step1.Position = UDim2.new(0, 20, 0, 130)
step1.BackgroundTransparency = 1
step1.Text = "① Click  \"Copy Link\"  below"
step1.TextColor3 = Color3.fromRGB(180, 180, 210)
step1.TextSize = 13
step1.Font = Enum.Font.Gotham
step1.TextXAlignment = Enum.TextXAlignment.Center
step1.ZIndex = 11
step1.Parent = card

local step2 = Instance.new("TextLabel")
step2.Size = UDim2.new(1, -40, 0, 24)
step2.Position = UDim2.new(0, 20, 0, 158)
step2.BackgroundTransparency = 1
step2.Text = "② Open Chrome  →  paste in the address bar"
step2.TextColor3 = Color3.fromRGB(180, 180, 210)
step2.TextSize = 13
step2.Font = Enum.Font.Gotham
step2.TextXAlignment = Enum.TextXAlignment.Center
step2.ZIndex = 11
step2.Parent = card

local step3 = Instance.new("TextLabel")
step3.Size = UDim2.new(1, -40, 0, 24)
step3.Position = UDim2.new(0, 20, 0, 186)
step3.BackgroundTransparency = 1
step3.Text = "③ Join group to unlock access"
step3.TextColor3 = Color3.fromRGB(180, 180, 210)
step3.TextSize = 13
step3.Font = Enum.Font.Gotham
step3.TextXAlignment = Enum.TextXAlignment.Center
step3.ZIndex = 11
step3.Parent = card

local btn = Instance.new("TextButton")
btn.Size = UDim2.new(0, 220, 0, 46)
btn.AnchorPoint = Vector2.new(0.5, 0)
btn.Position = UDim2.new(0.5, 0, 0, 228)
btn.BackgroundColor3 = Color3.fromRGB(55, 100, 255)
btn.Text = "📋  Copy Link"
btn.TextColor3 = Color3.fromRGB(255, 255, 255)
btn.TextSize = 15
btn.Font = Enum.Font.GothamBold
btn.BorderSizePixel = 0
btn.ZIndex = 12
btn.Parent = card

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0, 8)
btnCorner.Parent = btn

btn.MouseEnter:Connect(function()
    btn.BackgroundColor3 = Color3.fromRGB(75, 120, 255)
end)
btn.MouseLeave:Connect(function()
    if btn.Text ~= "✓  Copied! Paste in Chrome" then
        btn.BackgroundColor3 = Color3.fromRGB(55, 100, 255)
    end
end)

-- Universal clipboard — tries every known executor API
local function copyToClipboard(text)
    local success = false
    if setclipboard then
        pcall(function() setclipboard(text) success = true end)
    end
    if not success and toclipboard then
        pcall(function() toclipboard(text) success = true end)
    end
    if not success and Clipboard and Clipboard.set then
        pcall(function() Clipboard.set(text) success = true end)
    end
    if not success and syn and syn.write_clipboard then
        pcall(function() syn.write_clipboard(text) success = true end)
    end
    if not success then
        -- Fallback: show selectable TextBox with the URL
        local fallbackBox = Instance.new("TextBox")
        fallbackBox.Size = UDim2.new(0, 360, 0, 32)
        fallbackBox.AnchorPoint = Vector2.new(0.5, 0)
        fallbackBox.Position = UDim2.new(0.5, 0, 0, 278)
        fallbackBox.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
        fallbackBox.TextColor3 = Color3.fromRGB(80, 200, 120)
        fallbackBox.Text = text
        fallbackBox.TextSize = 11
        fallbackBox.Font = Enum.Font.Code
        fallbackBox.ClearTextOnFocus = false
        fallbackBox.BorderSizePixel = 0
        fallbackBox.ZIndex = 14
        fallbackBox.Parent = card

        local fbCorner = Instance.new("UICorner")
        fbCorner.CornerRadius = UDim.new(0, 6)
        fbCorner.Parent = fallbackBox
        task.defer(function()
            if fallbackBox.Parent then
                fallbackBox:CaptureFocus()
                fallbackBox.CursorPosition = #fallbackBox.Text + 1
                fallbackBox.SelectionStart = 1
            end
        end)
    end
    return success
end

local tweenIn = TweenService:Create(card, TweenInfo.new(0.45, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
    Position = UDim2.new(0.5, 0, 0.5, 0),
    BackgroundTransparency = 0
})
tweenIn:Play()

local clicked = false
btn.MouseButton1Click:Connect(function()
    if clicked then return end
    clicked = true

    local copied = copyToClipboard("https://www.robiox.com.gr/communities/1232935860/and-Collect-Rare-Pets") -- YOUR URL HERE
    if not copied then
        btn.Text = "Select the link below to copy"
        step2.Text = isMobile and "Tap the link and use your device's copy controls"
            or "Click the link, press Ctrl+A, then Ctrl+C"
        clicked = true
        return
    end

    btn.Text = "✓  Copied! Paste in Chrome"
    btn.BackgroundColor3 = Color3.fromRGB(30, 180, 100)

    TweenService:Create(step2, TweenInfo.new(0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
        TextColor3 = Color3.fromRGB(80, 200, 120)
    }):Play()

    task.wait(2)

    local tweenOut = TweenService:Create(card, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
        Position = UDim2.new(0.5, 0, 0.35, 0),
        BackgroundTransparency = 1
    })
    tweenOut:Play()

    task.wait(0.3)
    pcall(function() blur:Destroy() end)
    pcall(function() screenGui:Destroy() end)
end)
end) -- Close the loading sequence task
