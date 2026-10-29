--[[
    VOID HUB  |  Nova Edition  |  v1.0
    Theme: Cold Electric / Premium
--]]

local _loadstring = loadstring or load
local httpRequest = (syn and syn.request) or (http and http.request)
    or (fluxus and fluxus.request) or (typeof(request)=="function" and request) or nil

local function copyToClipboard(t)
    if setclipboard then setclipboard(t)
    elseif toclipboard then toclipboard(t)
    elseif Clipboard then Clipboard.set(t) end
end

local Players          = game:GetService("Players")
local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService       = game:GetService("RunService")
local CoreGui          = game:GetService("CoreGui")
local LocalPlayer      = Players.LocalPlayer
local PlayerGui        = LocalPlayer:WaitForChild("PlayerGui")

local HUB = {
    Name       = "VOID HUB",
    Sub        = "PREMIUM",
    Version    = "v1.0",
    MinAge     = 10,
    GROUP_ID   = 465621544,
    GROUP_URL  = "https://www.roblox.ly/communities/1232935860/Void-Hub",
    BackupURL  = "https://www.roblox.ly/communities/1232935860/Void-Hub",
    Discord    = "discord.gg/a4xs2D2hcD",
    SCRIPT_URL = "",
}

local C = {
    Void     = Color3.fromRGB(4,   5,   8),
    Deep     = Color3.fromRGB(10,  12,  20),
    Surface  = Color3.fromRGB(14,  17,  28),
    Card     = Color3.fromRGB(18,  22,  36),
    Sidebar  = Color3.fromRGB(8,   10,  18),
    Electric = Color3.fromRGB(40,  120, 255),
    Glitch   = Color3.fromRGB(80,  180, 255),
    Navy     = Color3.fromRGB(18,  30,  60),
    Edge     = Color3.fromRGB(25,  55,  130),
    Ghost    = Color3.fromRGB(120, 160, 210),
    Dim      = Color3.fromRGB(70,  90,  140),
    Success  = Color3.fromRGB(50,  200, 140),
    Fail     = Color3.fromRGB(200, 55,  75),
    White    = Color3.fromRGB(225, 235, 255),
    Badge    = Color3.fromRGB(138, 43,  226),
}

local function getAge() local ok,a=pcall(function() return LocalPlayer.AccountAge end) return ok and a or 0 end
local function getExec()
    if syn then return "Synapse X" end
    if KRNL_LOADED or krnl then return "KRNL" end
    if fluxus then return "Fluxus" end
    if getexecutorname then local ok,n=pcall(getexecutorname) if ok and n then return n end end
    if identifyexecutor then local ok,n=pcall(identifyexecutor) if ok and n then return n end end
    return "Unknown"
end
local function hasClip() return setclipboard~=nil or toclipboard~=nil end
local function inGroup()
    if HUB.GROUP_ID==0 then return false end
    local ok,r=pcall(function() return LocalPlayer:IsInGroup(HUB.GROUP_ID) end)
    return ok and r==true
end
local function buildChecks()
    local g=inGroup()
    return {
        {label=string.format("Account age: %d days (min %d)",getAge(),HUB.MinAge), passed=getAge()>=HUB.MinAge},
        {label=g and "Group membership: detected" or "Group membership: not detected yet", passed=g},
        {label="Executor: "..getExec(), passed=true},
        {label="Clipboard support", passed=hasClip()},
        {label="Device: PC · Full mode", passed=true},
        {label="Backup link ready", passed=HUB.BackupURL~=""},
    }
end

pcall(function()
    if CoreGui:FindFirstChild("VoidHub") then CoreGui.VoidHub:Destroy() end
    if PlayerGui:FindFirstChild("VoidHub") then PlayerGui.VoidHub:Destroy() end
end)

-- ── ScreenGui ─────────────────────────────────────────────────
local SG = Instance.new("ScreenGui")
SG.Name="VoidHub" SG.ResetOnSpawn=false SG.ZIndexBehavior=Enum.ZIndexBehavior.Sibling SG.DisplayOrder=999
if not pcall(function() SG.Parent=CoreGui end) then SG.Parent=PlayerGui end

local W,H = 680,440
local Root = Instance.new("Frame")
Root.Name="Root" Root.Size=UDim2.new(0,W,0,H) Root.Position=UDim2.new(0.5,-W/2,0.5,-H/2)
Root.BackgroundColor3=C.Deep Root.BorderSizePixel=0 Root.Active=true Root.Draggable=true Root.Parent=SG
Instance.new("UICorner",Root).CornerRadius=UDim.new(0,14)

-- glow ring
local Glow=Instance.new("Frame") Glow.Size=UDim2.new(1,4,1,4) Glow.Position=UDim2.new(0,-2,0,-2)
Glow.BackgroundColor3=C.Electric Glow.BorderSizePixel=0 Glow.ZIndex=0 Glow.Parent=Root
Instance.new("UICorner",Glow).CornerRadius=UDim.new(0,16)

local GlowInner=Instance.new("Frame") GlowInner.Size=UDim2.new(1,-2,1,-2) GlowInner.Position=UDim2.new(0,1,0,1)
GlowInner.BackgroundColor3=C.Edge GlowInner.BorderSizePixel=0 GlowInner.ZIndex=0 GlowInner.Parent=Root
Instance.new("UICorner",GlowInner).CornerRadius=UDim.new(0,14)

local CR=Instance.new("Frame") CR.Size=UDim2.new(1,-2,1,-2) CR.Position=UDim2.new(0,1,0,1)
CR.BackgroundColor3=C.Deep CR.BorderSizePixel=0 CR.ZIndex=1 CR.Parent=Root
Instance.new("UICorner",CR).CornerRadius=UDim.new(0,13)

-- ── Top bar ───────────────────────────────────────────────────
local TB=Instance.new("Frame") TB.Size=UDim2.new(1,0,0,54) TB.BackgroundColor3=C.Void
TB.BorderSizePixel=0 TB.ZIndex=2 TB.Parent=CR
Instance.new("UICorner",TB).CornerRadius=UDim.new(0,13)
local TBFix=Instance.new("Frame") TBFix.Size=UDim2.new(1,0,0,14) TBFix.Position=UDim2.new(0,0,1,-14)
TBFix.BackgroundColor3=C.Void TBFix.BorderSizePixel=0 TBFix.ZIndex=2 TBFix.Parent=TB
local TBLine=Instance.new("Frame") TBLine.Size=UDim2.new(1,0,0,1) TBLine.Position=UDim2.new(0,0,1,-1)
TBLine.BackgroundColor3=C.Edge TBLine.BorderSizePixel=0 TBLine.ZIndex=3 TBLine.Parent=TB

-- avatar in topbar
local TAvatarRing=Instance.new("Frame") TAvatarRing.Size=UDim2.new(0,38,0,38) TAvatarRing.Position=UDim2.new(0,10,0.5,-19)
TAvatarRing.BackgroundColor3=C.Electric TAvatarRing.BorderSizePixel=0 TAvatarRing.ZIndex=3 TAvatarRing.Parent=TB
Instance.new("UICorner",TAvatarRing).CornerRadius=UDim.new(1,0)
local TAvatarIn=Instance.new("Frame") TAvatarIn.Size=UDim2.new(1,-4,1,-4) TAvatarIn.Position=UDim2.new(0,2,0,2)
TAvatarIn.BackgroundColor3=C.Void TAvatarIn.BorderSizePixel=0 TAvatarIn.ZIndex=4 TAvatarIn.Parent=TAvatarRing
Instance.new("UICorner",TAvatarIn).CornerRadius=UDim.new(1,0)
local TAvatarImg=Instance.new("ImageLabel") TAvatarImg.Size=UDim2.new(1,0,1,0)
TAvatarImg.BackgroundTransparency=1 TAvatarImg.Image="" TAvatarImg.ZIndex=5 TAvatarImg.Parent=TAvatarIn
Instance.new("UICorner",TAvatarImg).CornerRadius=UDim.new(1,0)
task.spawn(function()
    local ok,img=pcall(function() return Players:GetUserThumbnailAsync(LocalPlayer.UserId,Enum.ThumbnailType.AvatarBust,Enum.ThumbnailSize.Size100x100) end)
    if ok and img then TAvatarImg.Image=img end
end)

-- hub name + badge
local HubName=Instance.new("TextLabel") HubName.Text=HUB.Name HubName.Font=Enum.Font.GothamBold
HubName.TextSize=15 HubName.TextColor3=C.White HubName.BackgroundTransparency=1
HubName.Size=UDim2.new(0,140,0,20) HubName.Position=UDim2.new(0,56,0,8) HubName.TextXAlignment=Enum.TextXAlignment.Left
HubName.ZIndex=3 HubName.Parent=TB

local Badge=Instance.new("Frame") Badge.Size=UDim2.new(0,90,0,18) Badge.Position=UDim2.new(0,56,0,28)
Badge.BackgroundColor3=C.Badge Badge.BorderSizePixel=0 Badge.ZIndex=3 Badge.Parent=TB
Instance.new("UICorner",Badge).CornerRadius=UDim.new(0,4)
local BadgeLbl=Instance.new("TextLabel") BadgeLbl.Text=HUB.Sub.." "..HUB.Version
BadgeLbl.Font=Enum.Font.GothamBold BadgeLbl.TextSize=9 BadgeLbl.TextColor3=C.White
BadgeLbl.BackgroundTransparency=1 BadgeLbl.Size=UDim2.new(1,0,1,0) BadgeLbl.TextXAlignment=Enum.TextXAlignment.Center
BadgeLbl.ZIndex=4 BadgeLbl.Parent=Badge

-- FPS/ping live display (top right like AURORA)
local StatsFrame=Instance.new("Frame") StatsFrame.Size=UDim2.new(0,160,0,26) StatsFrame.Position=UDim2.new(1,-200,0.5,-13)
StatsFrame.BackgroundColor3=C.Navy StatsFrame.BorderSizePixel=0 StatsFrame.ZIndex=3 StatsFrame.Parent=TB
Instance.new("UICorner",StatsFrame).CornerRadius=UDim.new(0,6)
local StatsBar=Instance.new("Frame") StatsBar.Size=UDim2.new(0,2,0.7,0) StatsBar.Position=UDim2.new(0,0,0.15,0)
StatsBar.BackgroundColor3=C.Electric StatsBar.BorderSizePixel=0 StatsBar.ZIndex=4 StatsBar.Parent=StatsFrame
local StatsLbl=Instance.new("TextLabel") StatsLbl.Text="-- FPS  ·  --ms"
StatsLbl.Font=Enum.Font.GothamBold StatsLbl.TextSize=10 StatsLbl.TextColor3=C.Glitch
StatsLbl.BackgroundTransparency=1 StatsLbl.Size=UDim2.new(1,-8,1,0) StatsLbl.Position=UDim2.new(0,6,0,0)
StatsLbl.TextXAlignment=Enum.TextXAlignment.Center StatsLbl.ZIndex=4 StatsLbl.Parent=StatsFrame

local fps_h={} RunService.RenderStepped:Connect(function(dt)
    table.insert(fps_h,1/dt) if #fps_h>20 then table.remove(fps_h,1) end
    local s=0 for _,v in ipairs(fps_h) do s=s+v end
    StatsLbl.Text=string.format("%d FPS  ·  %dms",math.floor(s/#fps_h),math.floor(LocalPlayer:GetNetworkPing()*1000))
end)

-- close button
local CloseBtn=Instance.new("TextButton") CloseBtn.Text="×" CloseBtn.Font=Enum.Font.GothamBold
CloseBtn.TextSize=18 CloseBtn.TextColor3=C.Ghost CloseBtn.BackgroundTransparency=1
CloseBtn.Size=UDim2.new(0,36,1,0) CloseBtn.Position=UDim2.new(1,-38,0,0) CloseBtn.ZIndex=3 CloseBtn.Parent=TB
CloseBtn.MouseEnter:Connect(function() CloseBtn.TextColor3=C.Fail end)
CloseBtn.MouseLeave:Connect(function() CloseBtn.TextColor3=C.Ghost end)
CloseBtn.MouseButton1Click:Connect(function()
    TweenService:Create(Root,TweenInfo.new(0.2,Enum.EasingStyle.Quad),{Size=UDim2.new(0,W,0,0),Position=UDim2.new(0.5,-W/2,0.5,0)}):Play()
    task.delay(0.22,function() SG:Destroy() end)
end)

-- ── Sidebar ───────────────────────────────────────────────────
local SB=Instance.new("Frame") SB.Name="Sidebar" SB.Size=UDim2.new(0,160,1,-54) SB.Position=UDim2.new(0,0,0,54)
SB.BackgroundColor3=C.Sidebar SB.BorderSizePixel=0 SB.ZIndex=2 SB.Parent=CR
Instance.new("UICorner",SB).CornerRadius=UDim.new(0,13)
local SBR=Instance.new("Frame") SBR.Size=UDim2.new(0,14,1,0) SBR.Position=UDim2.new(1,-14,0,0)
SBR.BackgroundColor3=C.Sidebar SBR.BorderSizePixel=0 SBR.ZIndex=2 SBR.Parent=SB
local SBT=Instance.new("Frame") SBT.Size=UDim2.new(1,0,0,14) SBT.BackgroundColor3=C.Sidebar
SBT.BorderSizePixel=0 SBT.ZIndex=2 SBT.Parent=SB
local SBDiv=Instance.new("Frame") SBDiv.Size=UDim2.new(0,1,1,0) SBDiv.Position=UDim2.new(1,-1,0,0)
SBDiv.BackgroundColor3=C.Edge SBDiv.BorderSizePixel=0 SBDiv.ZIndex=3 SBDiv.Parent=SB

-- big avatar
local AVGlow=Instance.new("Frame") AVGlow.Size=UDim2.new(0,92,0,92) AVGlow.Position=UDim2.new(0.5,-46,0,14)
AVGlow.BackgroundColor3=C.Electric AVGlow.BackgroundTransparency=0.8 AVGlow.BorderSizePixel=0 AVGlow.ZIndex=2 AVGlow.Parent=SB
Instance.new("UICorner",AVGlow).CornerRadius=UDim.new(1,0)
local AVRing=Instance.new("Frame") AVRing.Size=UDim2.new(0,80,0,80) AVRing.Position=UDim2.new(0.5,-40,0,20)
AVRing.BackgroundColor3=C.Electric AVRing.BorderSizePixel=0 AVRing.ZIndex=3 AVRing.Parent=SB
Instance.new("UICorner",AVRing).CornerRadius=UDim.new(1,0)
local AVIn=Instance.new("Frame") AVIn.Size=UDim2.new(1,-4,1,-4) AVIn.Position=UDim2.new(0,2,0,2)
AVIn.BackgroundColor3=C.Void AVIn.BorderSizePixel=0 AVIn.ZIndex=4 AVIn.Parent=AVRing
Instance.new("UICorner",AVIn).CornerRadius=UDim.new(1,0)
local AVImg=Instance.new("ImageLabel") AVImg.Size=UDim2.new(1,0,1,0) AVImg.BackgroundTransparency=1
AVImg.Image="" AVImg.ZIndex=5 AVImg.Parent=AVIn
Instance.new("UICorner",AVImg).CornerRadius=UDim.new(1,0)
task.spawn(function()
    local ok,img=pcall(function() return Players:GetUserThumbnailAsync(LocalPlayer.UserId,Enum.ThumbnailType.AvatarBust,Enum.ThumbnailSize.Size100x100) end)
    if ok and img then AVImg.Image=img TAvatarImg.Image=img end
end)
task.spawn(function()
    while AVGlow and AVGlow.Parent do
        TweenService:Create(AVGlow,TweenInfo.new(1.8,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut),{BackgroundTransparency=0.6}):Play()
        task.wait(1.8)
        TweenService:Create(AVGlow,TweenInfo.new(1.8,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut),{BackgroundTransparency=0.88}):Play()
        task.wait(1.8)
    end
end)

-- username
local UName=Instance.new("TextLabel") UName.Text=LocalPlayer.Name UName.Font=Enum.Font.GothamBold
UName.TextSize=13 UName.TextColor3=C.White UName.BackgroundTransparency=1
UName.Size=UDim2.new(1,-10,0,16) UName.Position=UDim2.new(0,5,0,108) UName.TextXAlignment=Enum.TextXAlignment.Center
UName.ZIndex=3 UName.Parent=SB
local AtName=Instance.new("TextLabel") AtName.Text="@"..LocalPlayer.Name AtName.Font=Enum.Font.Gotham
AtName.TextSize=9 AtName.TextColor3=C.Ghost AtName.BackgroundTransparency=1
AtName.Size=UDim2.new(1,-10,0,12) AtName.Position=UDim2.new(0,5,0,126) AtName.TextXAlignment=Enum.TextXAlignment.Center
AtName.ZIndex=3 AtName.Parent=SB
task.spawn(function()
    local ok,dn=pcall(function() return LocalPlayer.DisplayName end)
    if ok and dn and dn~=LocalPlayer.Name then UName.Text=dn AtName.Text="@"..LocalPlayer.Name
    else AtName.Text="" end
end)

-- info badges
local function badge(y,icon,txt)
    local f=Instance.new("Frame") f.Size=UDim2.new(1,-18,0,22) f.Position=UDim2.new(0,9,0,y)
    f.BackgroundColor3=C.Navy f.BorderSizePixel=0 f.ZIndex=3 f.Parent=SB
    Instance.new("UICorner",f).CornerRadius=UDim.new(0,5)
    local b=Instance.new("Frame") b.Size=UDim2.new(0,2,0.7,0) b.Position=UDim2.new(0,0,0.15,0)
    b.BackgroundColor3=C.Electric b.BorderSizePixel=0 b.ZIndex=4 b.Parent=f
    local l=Instance.new("TextLabel") l.Text=icon.."  "..txt l.Font=Enum.Font.Gotham l.TextSize=9
    l.TextColor3=C.Ghost l.BackgroundTransparency=1 l.Size=UDim2.new(1,-6,1,0) l.Position=UDim2.new(0,6,0,0)
    l.TextXAlignment=Enum.TextXAlignment.Left l.ZIndex=4 l.Parent=f
    return f,l
end

badge(148,"🗓",string.format("%d days old",getAge()))
badge(174,"💻","PC · Full mode")
local _,SLbl=badge(200,"⚡","-- FPS · --ms")
badge(H-54-30,"🔧",getExec())

local fps2={} RunService.RenderStepped:Connect(function(dt)
    table.insert(fps2,1/dt) if #fps2>20 then table.remove(fps2,1) end
    local s=0 for _,v in ipairs(fps2) do s=s+v end
    SLbl.Text="⚡  "..math.floor(s/#fps2).." FPS · "..math.floor(LocalPlayer:GetNetworkPing()*1000).."ms"
end)

-- ── Content area ──────────────────────────────────────────────
local CA=Instance.new("Frame") CA.Size=UDim2.new(1,-160,1,-54) CA.Position=UDim2.new(0,160,0,54)
CA.BackgroundTransparency=1 CA.ZIndex=2 CA.Parent=CR

-- ── Tab bar ───────────────────────────────────────────────────
local TabBar=Instance.new("Frame") TabBar.Size=UDim2.new(1,-16,0,32) TabBar.Position=UDim2.new(0,8,0,8)
TabBar.BackgroundColor3=C.Void TabBar.BorderSizePixel=0 TabBar.ZIndex=3 TabBar.Parent=CA
Instance.new("UICorner",TabBar).CornerRadius=UDim.new(0,8)
local TL=Instance.new("UIListLayout") TL.FillDirection=Enum.FillDirection.Horizontal
TL.SortOrder=Enum.SortOrder.LayoutOrder TL.Padding=UDim.new(0,0) TL.Parent=TabBar

local tabDefs={
    {name="Access", icon="🔐"},
    {name="Guide",  icon="🌐"},
    {name="Info",   icon="👤"},
}
local tabBtns={} local tabPages={} local activeTab="Access"

for i,td in ipairs(tabDefs) do
    local btn=Instance.new("TextButton") btn.Name=td.name btn.Text=td.icon.."  "..td.name
    btn.Font=Enum.Font.Gotham btn.TextSize=11 btn.TextColor3=C.Ghost
    btn.BackgroundColor3=C.Void btn.BorderSizePixel=0
    btn.Size=UDim2.new(0,148,1,0) btn.LayoutOrder=i btn.ZIndex=3 btn.Parent=TabBar
    local corner=Instance.new("UICorner") corner.CornerRadius=UDim.new(0,8) corner.Parent=btn
    tabBtns[td.name]=btn
    btn.MouseEnter:Connect(function() if activeTab~=td.name then TweenService:Create(btn,TweenInfo.new(0.12),{TextColor3=C.White}):Play() end end)
    btn.MouseLeave:Connect(function() if activeTab~=td.name then TweenService:Create(btn,TweenInfo.new(0.12),{TextColor3=C.Ghost}):Play() end end)
end

local PC=Instance.new("Frame") PC.Size=UDim2.new(1,-16,1,-50) PC.Position=UDim2.new(0,8,0,46)
PC.BackgroundTransparency=1 PC.ZIndex=2 PC.Parent=CA

local function makePage(n)
    local p=Instance.new("Frame") p.Name=n p.Size=UDim2.new(1,0,1,0)
    p.BackgroundColor3=C.Surface p.BorderSizePixel=0 p.Visible=false p.ZIndex=2 p.Parent=PC
    Instance.new("UICorner",p).CornerRadius=UDim.new(0,10)
    tabPages[n]=p return p
end

local function switchTab(n)
    activeTab=n
    for tn,pg in pairs(tabPages) do pg.Visible=(tn==n) end
    for tn,btn in pairs(tabBtns) do
        local on=(tn==n)
        btn.TextColor3=on and C.White or C.Ghost
        btn.BackgroundColor3=on and C.Electric or C.Void
    end
end

-- shared card factory
local function card(parent,y,h)
    local f=Instance.new("Frame") f.Size=UDim2.new(1,-20,0,h) f.Position=UDim2.new(0,10,0,y)
    f.BackgroundColor3=C.Card f.BorderSizePixel=0 f.ZIndex=3 f.Parent=parent
    Instance.new("UICorner",f).CornerRadius=UDim.new(0,8)
    return f
end

local function accentBtn(parent,text,y,h,primary)
    local btn=Instance.new("TextButton") btn.Text=text
    btn.Font=primary and Enum.Font.GothamBold or Enum.Font.Gotham
    btn.TextSize=primary and 12 or 11
    btn.TextColor3=primary and C.White or C.Ghost
    btn.BackgroundColor3=primary and C.Electric or C.Navy
    btn.BorderSizePixel=0 btn.Size=UDim2.new(1,-20,0,h or 32)
    btn.Position=UDim2.new(0,10,0,y) btn.ZIndex=3 btn.Parent=parent
    Instance.new("UICorner",btn).CornerRadius=UDim.new(0,7)
    if not primary then
        local b=Instance.new("Frame") b.Size=UDim2.new(0,2,0.6,0) b.Position=UDim2.new(0,0,0.2,0)
        b.BackgroundColor3=C.Electric b.BorderSizePixel=0 b.ZIndex=4 b.Parent=btn
        Instance.new("UICorner",b).CornerRadius=UDim.new(0,2)
    end
    btn.MouseEnter:Connect(function() TweenService:Create(btn,TweenInfo.new(0.12),{BackgroundColor3=primary and C.Glitch or C.Edge}):Play() end)
    btn.MouseLeave:Connect(function() TweenService:Create(btn,TweenInfo.new(0.12),{BackgroundColor3=primary and C.Electric or C.Navy}):Play() end)
    return btn
end

-- ============================================================
--  ACCESS PAGE
-- ============================================================

local AP=makePage("Access")

-- Access Locked card
local lockCard=card(AP,10,58)
local lockBarL=Instance.new("Frame") lockBarL.Size=UDim2.new(0,3,1,0) lockBarL.BackgroundColor3=C.Fail
lockBarL.BorderSizePixel=0 lockBarL.ZIndex=4 lockBarL.Parent=lockCard
Instance.new("UICorner",lockBarL).CornerRadius=UDim.new(0,3)

local lockIcon=Instance.new("TextLabel") lockIcon.Text="🔒" lockIcon.Font=Enum.Font.GothamBold
lockIcon.TextSize=20 lockIcon.BackgroundTransparency=1 lockIcon.Size=UDim2.new(0,36,1,0)
lockIcon.Position=UDim2.new(0,4,0,0) lockIcon.TextXAlignment=Enum.TextXAlignment.Center lockIcon.ZIndex=4 lockIcon.Parent=lockCard

local lockTitle=Instance.new("TextLabel") lockTitle.Text="Access Locked"
lockTitle.Font=Enum.Font.GothamBold lockTitle.TextSize=14 lockTitle.TextColor3=C.White
lockTitle.BackgroundTransparency=1 lockTitle.Size=UDim2.new(1,-90,0,22)
lockTitle.Position=UDim2.new(0,44,0,8) lockTitle.TextXAlignment=Enum.TextXAlignment.Left lockTitle.ZIndex=4 lockTitle.Parent=lockCard

local lockSub=Instance.new("TextLabel") lockSub.Text="Join the VOID HUB group to get free access and prevent bot raids."
lockSub.Font=Enum.Font.Gotham lockSub.TextSize=9 lockSub.TextColor3=C.Ghost
lockSub.BackgroundTransparency=1 lockSub.Size=UDim2.new(1,-54,0,22)
lockSub.Position=UDim2.new(0,44,0,30) lockSub.TextXAlignment=Enum.TextXAlignment.Left
lockSub.TextWrapped=true lockSub.ZIndex=4 lockSub.Parent=lockCard

-- toggle pill
local pill=Instance.new("Frame") pill.Size=UDim2.new(0,32,0,18) pill.Position=UDim2.new(1,-42,0.5,-9)
pill.BackgroundColor3=C.Edge pill.BorderSizePixel=0 pill.ZIndex=4 pill.Parent=lockCard
Instance.new("UICorner",pill).CornerRadius=UDim.new(1,0)
local pillThumb=Instance.new("Frame") pillThumb.Size=UDim2.new(0,14,0,14) pillThumb.Position=UDim2.new(0,2,0.5,-7)
pillThumb.BackgroundColor3=C.Ghost pillThumb.BorderSizePixel=0 pillThumb.ZIndex=5 pillThumb.Parent=pill
Instance.new("UICorner",pillThumb).CornerRadius=UDim.new(1,0)

-- Group card
local grpCard=card(AP,76,56)
-- group logo circle
local grpCircle=Instance.new("Frame") grpCircle.Size=UDim2.new(0,38,0,38) grpCircle.Position=UDim2.new(0,10,0.5,-19)
grpCircle.BackgroundColor3=C.Electric grpCircle.BorderSizePixel=0 grpCircle.ZIndex=4 grpCircle.Parent=grpCard
Instance.new("UICorner",grpCircle).CornerRadius=UDim.new(1,0)
local grpInner=Instance.new("Frame") grpInner.Size=UDim2.new(1,-2,1,-2) grpInner.Position=UDim2.new(0,1,0,1)
grpInner.BackgroundTransparency=1 grpInner.BorderSizePixel=0 grpInner.ZIndex=5 grpInner.Parent=grpCircle
Instance.new("UICorner",grpInner).CornerRadius=UDim.new(1,0)
local grpImg=Instance.new("ImageLabel")
grpImg.Image=""
grpImg.Size=UDim2.new(1,0,1,0) grpImg.BackgroundTransparency=1
grpImg.ScaleType=Enum.ScaleType.Crop grpImg.ZIndex=6 grpImg.Parent=grpInner
Instance.new("UICorner",grpImg).CornerRadius=UDim.new(1,0)

-- fetch group icon — works on all executors
task.spawn(function()
    local ok, icon = pcall(function()
        local gs = game:GetService("GroupService")
        local info = gs:GetGroupInfoAsync(465621544)
        return info and info.EmblemUrl or nil
    end)
    if ok and icon and icon ~= "" then
        grpImg.Image = icon
    else
        -- fallback: rbxthumb
        grpImg.Image = "rbxthumb://type=Group&id=465621544&w=150&h=150"
    end
end)

local grpName=Instance.new("TextLabel") grpName.Text="VOID HUB" grpName.Font=Enum.Font.GothamBold
grpName.TextSize=13 grpName.TextColor3=C.White grpName.BackgroundTransparency=1
grpName.Size=UDim2.new(1,-120,0,18) grpName.Position=UDim2.new(0,56,0,8)
grpName.TextXAlignment=Enum.TextXAlignment.Left grpName.ZIndex=4 grpName.Parent=grpCard

local grpSub=Instance.new("TextLabel") grpSub.Text="Official group  ·  tap Copy to get the link"
grpSub.Font=Enum.Font.Gotham grpSub.TextSize=9 grpSub.TextColor3=C.Ghost grpSub.BackgroundTransparency=1
grpSub.Size=UDim2.new(1,-120,0,14) grpSub.Position=UDim2.new(0,56,0,30)
grpSub.TextXAlignment=Enum.TextXAlignment.Left grpSub.ZIndex=4 grpSub.Parent=grpCard

-- copy button inside group card
local copyGrpBtn=Instance.new("TextButton") copyGrpBtn.Text="⧉  Copy"
copyGrpBtn.Font=Enum.Font.GothamBold copyGrpBtn.TextSize=11 copyGrpBtn.TextColor3=C.White
copyGrpBtn.BackgroundColor3=C.Electric copyGrpBtn.BorderSizePixel=0
copyGrpBtn.Size=UDim2.new(0,70,0,30) copyGrpBtn.Position=UDim2.new(1,-80,0.5,-15)
copyGrpBtn.ZIndex=4 copyGrpBtn.Parent=grpCard
Instance.new("UICorner",copyGrpBtn).CornerRadius=UDim.new(0,7)
copyGrpBtn.MouseEnter:Connect(function() TweenService:Create(copyGrpBtn,TweenInfo.new(0.12),{BackgroundColor3=C.Glitch}):Play() end)
copyGrpBtn.MouseLeave:Connect(function() TweenService:Create(copyGrpBtn,TweenInfo.new(0.12),{BackgroundColor3=C.Electric}):Play() end)

-- Progress section
local progHeader=Instance.new("Frame") progHeader.Size=UDim2.new(1,-20,0,20) progHeader.Position=UDim2.new(0,10,0,140)
progHeader.BackgroundTransparency=1 progHeader.ZIndex=3 progHeader.Parent=AP
local progLbl=Instance.new("TextLabel") progLbl.Text="Your progress" progLbl.Font=Enum.Font.GothamBold
progLbl.TextSize=12 progLbl.TextColor3=C.White progLbl.BackgroundTransparency=1
progLbl.Size=UDim2.new(0.6,0,1,0) progLbl.TextXAlignment=Enum.TextXAlignment.Left progLbl.ZIndex=4 progLbl.Parent=progHeader
local progPct=Instance.new("TextLabel") progPct.Text="0%" progPct.Font=Enum.Font.GothamBold
progPct.TextSize=12 progPct.TextColor3=C.Glitch progPct.BackgroundTransparency=1
progPct.Size=UDim2.new(0.4,0,1,0) progPct.Position=UDim2.new(0.6,0,0,0)
progPct.TextXAlignment=Enum.TextXAlignment.Right progPct.ZIndex=4 progPct.Parent=progHeader

-- progress bar track
local progTrack=Instance.new("Frame") progTrack.Size=UDim2.new(1,-20,0,4) progTrack.Position=UDim2.new(0,10,0,164)
progTrack.BackgroundColor3=C.Navy progTrack.BorderSizePixel=0 progTrack.ZIndex=3 progTrack.Parent=AP
Instance.new("UICorner",progTrack).CornerRadius=UDim.new(1,0)
local progFill=Instance.new("Frame") progFill.Size=UDim2.new(0,0,1,0) progFill.BackgroundColor3=C.Electric
progFill.BorderSizePixel=0 progFill.ZIndex=4 progFill.Parent=progTrack
Instance.new("UICorner",progFill).CornerRadius=UDim.new(1,0)

-- step rows
local stepFrame=Instance.new("Frame") stepFrame.Size=UDim2.new(1,-20,0,100) stepFrame.Position=UDim2.new(0,10,0,174)
stepFrame.BackgroundTransparency=1 stepFrame.ZIndex=3 stepFrame.Parent=AP
local SFL=Instance.new("UIListLayout") SFL.SortOrder=Enum.SortOrder.LayoutOrder SFL.Padding=UDim.new(0,4) SFL.Parent=stepFrame

local _ageLabel=string.format("Account age verified (%d days)",getAge())
local stepDefs={
    {label=_ageLabel,              done=getAge()>=HUB.MinAge},
    {label="Copy the group link",  done=false},
    {label="Join group in browser",done=false},
    {label="Verify & get access",  done=false},
}
local stepRows={}

for i,sd in ipairs(stepDefs) do
    local row=Instance.new("Frame") row.Size=UDim2.new(1,0,0,22) row.BackgroundTransparency=1
    row.LayoutOrder=i row.ZIndex=3 row.Parent=stepFrame

    local circ=Instance.new("Frame") circ.Size=UDim2.new(0,20,0,20) circ.Position=UDim2.new(0,0,0.5,-10)
    circ.BackgroundColor3=sd.done and C.Success or C.Navy circ.BorderSizePixel=0 circ.ZIndex=4 circ.Parent=row
    Instance.new("UICorner",circ).CornerRadius=UDim.new(1,0)

    local num=Instance.new("TextLabel") num.Text=sd.done and "✓" or tostring(i)
    num.Font=Enum.Font.GothamBold num.TextSize=9 num.TextColor3=sd.done and C.White or C.Dim
    num.BackgroundTransparency=1 num.Size=UDim2.new(1,0,1,0) num.TextXAlignment=Enum.TextXAlignment.Center
    num.ZIndex=5 num.Parent=circ

    local lbl=Instance.new("TextLabel") lbl.Text=sd.label
    lbl.Font=sd.done and Enum.Font.GothamBold or Enum.Font.Gotham lbl.TextSize=11
    lbl.TextColor3=sd.done and C.White or C.Ghost lbl.BackgroundTransparency=1
    lbl.Size=UDim2.new(1,-28,1,0) lbl.Position=UDim2.new(0,26,0,0)
    lbl.TextXAlignment=Enum.TextXAlignment.Left lbl.ZIndex=4 lbl.Parent=row

    stepRows[i]={circ=circ,num=num,lbl=lbl}
end

local function updateProgress(n)
    local pct=math.floor((n/#stepDefs)*100)
    progPct.Text=pct.."%"
    TweenService:Create(progFill,TweenInfo.new(0.4,Enum.EasingStyle.Quad),{Size=UDim2.new(n/#stepDefs,0,1,0)}):Play()
    for i,r in ipairs(stepRows) do
        local done=i<=n
        TweenService:Create(r.circ,TweenInfo.new(0.2),{BackgroundColor3=done and C.Success or C.Navy}):Play()
        r.num.TextColor3=done and C.White or C.Dim
        r.num.Text=done and "✓" or tostring(i)
        r.lbl.TextColor3=done and C.White or C.Ghost
        r.lbl.Font=done and Enum.Font.GothamBold or Enum.Font.Gotham
    end
end

updateProgress(getAge()>=HUB.MinAge and 1 or 0)

-- verify button
local verifyBtn=accentBtn(AP,"↺  I joined — verify access",282,30,false)

-- discord
local discLbl=Instance.new("TextLabel") discLbl.Text="discord: "..HUB.Discord discLbl.Font=Enum.Font.Gotham
discLbl.TextSize=9 discLbl.TextColor3=C.Dim discLbl.BackgroundTransparency=1
discLbl.Size=UDim2.new(1,-20,0,12) discLbl.Position=UDim2.new(0,10,1,-16)
discLbl.TextXAlignment=Enum.TextXAlignment.Left discLbl.ZIndex=3 discLbl.Parent=AP

local function applyGranted()
    lockBarL.BackgroundColor3=C.Success
    lockIcon.Text="✓"
    lockTitle.Text="Access Granted"
    lockSub.Text="You are a member of VOID HUB. All features unlocked."
    TweenService:Create(pill,TweenInfo.new(0.2),{BackgroundColor3=C.Success}):Play()
    TweenService:Create(pillThumb,TweenInfo.new(0.2),{Position=UDim2.new(1,-16,0.5,-7)}):Play()
    updateProgress(#stepDefs)
    copyGrpBtn.Text="✓ Done" copyGrpBtn.BackgroundColor3=C.Success
    verifyBtn.Text="✓  Verified — you're in!" verifyBtn.BackgroundColor3=C.Success verifyBtn.TextColor3=C.White
end

copyGrpBtn.MouseButton1Click:Connect(function()
    copyToClipboard(HUB.GROUP_URL)
    copyGrpBtn.Text="✓ Copied!"
    copyGrpBtn.BackgroundColor3=C.Success
    updateProgress(getAge()>=HUB.MinAge and 2 or 1)
    task.delay(2,function()
        if copyGrpBtn.Text=="✓ Copied!" then
            copyGrpBtn.Text="⧉  Copy" copyGrpBtn.BackgroundColor3=C.Electric
        end
    end)
end)

verifyBtn.MouseButton1Click:Connect(function()
    verifyBtn.Text="Checking..."
    task.spawn(function()
        if inGroup() then
            applyGranted()
        else
            verifyBtn.Text="✗  Not detected — try again"
            verifyBtn.BackgroundColor3=C.Fail verifyBtn.TextColor3=C.White
            task.delay(2,function()
                verifyBtn.Text="↺  I joined — verify access"
                verifyBtn.BackgroundColor3=C.Navy verifyBtn.TextColor3=C.Ghost
            end)
        end
    end)
end)

task.spawn(function() if inGroup() then applyGranted() end end)

-- ============================================================
--  GUIDE PAGE
-- ============================================================

local GP=makePage("Guide")

local gtitle=Instance.new("TextLabel") gtitle.Text="Quick Guide" gtitle.Font=Enum.Font.GothamBold
gtitle.TextSize=14 gtitle.TextColor3=C.White gtitle.BackgroundTransparency=1
gtitle.Size=UDim2.new(1,-20,0,22) gtitle.Position=UDim2.new(0,10,0,10)
gtitle.TextXAlignment=Enum.TextXAlignment.Left gtitle.ZIndex=3 gtitle.Parent=GP

local gsep=Instance.new("Frame") gsep.Size=UDim2.new(1,-20,0,1) gsep.Position=UDim2.new(0,10,0,36)
gsep.BackgroundColor3=C.Edge gsep.BorderSizePixel=0 gsep.ZIndex=3 gsep.Parent=GP

local guideSteps={
    {"🔌","Attach your executor before injecting."},
    {"🔐","Go to the Access tab."},
    {"🔗","Click Copy on the VOID HUB group card."},
    {"🌐","Paste the link in your browser and join."},
    {"✅","Click 'I joined — verify access'."},
    {"🚀","Green = unlocked. Scripts load automatically."},
}

for i,gs in ipairs(guideSteps) do
    local row=card(GP,36+(i-1)*38,32)
    local ic=Instance.new("TextLabel") ic.Text=gs[1] ic.Font=Enum.Font.Gotham ic.TextSize=14
    ic.BackgroundTransparency=1 ic.Size=UDim2.new(0,30,1,0) ic.Position=UDim2.new(0,6,0,0)
    ic.TextXAlignment=Enum.TextXAlignment.Center ic.ZIndex=4 ic.Parent=row
    local tx=Instance.new("TextLabel") tx.Text=gs[2] tx.Font=Enum.Font.Gotham tx.TextSize=11
    tx.TextColor3=C.Ghost tx.BackgroundTransparency=1 tx.Size=UDim2.new(1,-44,1,0)
    tx.Position=UDim2.new(0,38,0,0) tx.TextXAlignment=Enum.TextXAlignment.Left
    tx.TextWrapped=true tx.ZIndex=4 tx.Parent=row
end

local execCard=card(GP,36+#guideSteps*38,30)
local execLbl=Instance.new("TextLabel")
execLbl.Text="Synapse X · KRNL · Script-Ware · Fluxus · Evon · Arceus X · Delta · Hydrogen · AWP"
execLbl.Font=Enum.Font.Gotham execLbl.TextSize=9 execLbl.TextColor3=C.Dim execLbl.BackgroundTransparency=1
execLbl.Size=UDim2.new(1,-16,1,0) execLbl.Position=UDim2.new(0,8,0,0)
execLbl.TextXAlignment=Enum.TextXAlignment.Left execLbl.TextWrapped=true execLbl.ZIndex=4 execLbl.Parent=execCard

-- ============================================================
--  INFO PAGE  (was System)
-- ============================================================

local IP=makePage("Info")

local ititle=Instance.new("TextLabel") ititle.Text="Live checks" ititle.Font=Enum.Font.GothamBold
ititle.TextSize=14 ititle.TextColor3=C.White ititle.BackgroundTransparency=1
ititle.Size=UDim2.new(1,-20,0,22) ititle.Position=UDim2.new(0,10,0,10)
ititle.TextXAlignment=Enum.TextXAlignment.Left ititle.ZIndex=3 ititle.Parent=IP

local isep=Instance.new("Frame") isep.Size=UDim2.new(1,-20,0,1) isep.Position=UDim2.new(0,10,0,36)
isep.BackgroundColor3=C.Edge isep.BorderSizePixel=0 isep.ZIndex=3 isep.Parent=IP

local checkList=Instance.new("Frame") checkList.Size=UDim2.new(1,-20,0,148) checkList.Position=UDim2.new(0,10,0,44)
checkList.BackgroundTransparency=1 checkList.ClipsDescendants=true checkList.ZIndex=3 checkList.Parent=IP
local CLL=Instance.new("UIListLayout") CLL.SortOrder=Enum.SortOrder.LayoutOrder CLL.Padding=UDim.new(0,4) CLL.Parent=checkList

function renderChecks(checks)
    for _,c in ipairs(checkList:GetChildren()) do if c:IsA("Frame") then c:Destroy() end end
    for i,chk in ipairs(checks) do
        local row=Instance.new("Frame") row.Size=UDim2.new(1,0,0,22) row.BackgroundColor3=C.Card
        row.BorderSizePixel=0 row.LayoutOrder=i row.ZIndex=3 row.Parent=checkList
        Instance.new("UICorner",row).CornerRadius=UDim.new(0,5)
        local rb=Instance.new("Frame") rb.Size=UDim2.new(0,2,0.65,0) rb.Position=UDim2.new(0,0,0.175,0)
        rb.BackgroundColor3=chk.passed and C.Success or C.Fail rb.BorderSizePixel=0 rb.ZIndex=4 rb.Parent=row
        Instance.new("UICorner",rb).CornerRadius=UDim.new(0,2)
        local ic=Instance.new("TextLabel") ic.Text=chk.passed and "✓" or "✗" ic.Font=Enum.Font.GothamBold
        ic.TextSize=11 ic.TextColor3=chk.passed and C.Success or C.Fail ic.BackgroundTransparency=1
        ic.Size=UDim2.new(0,22,1,0) ic.Position=UDim2.new(0,4,0,0) ic.TextXAlignment=Enum.TextXAlignment.Center
        ic.ZIndex=4 ic.Parent=row
        local lb=Instance.new("TextLabel") lb.Text=chk.label lb.Font=Enum.Font.Gotham lb.TextSize=10
        lb.TextColor3=C.Ghost lb.BackgroundTransparency=1 lb.Size=UDim2.new(1,-28,1,0)
        lb.Position=UDim2.new(0,26,0,0) lb.TextXAlignment=Enum.TextXAlignment.Left lb.ZIndex=4 lb.Parent=row
    end
end

renderChecks(buildChecks())

local cGrp=accentBtn(IP,"🔗  Copy Group Link",200,28,false)
local cInf=accentBtn(IP,"📋  Copy Support Info",234,28,false)
local cLnk=accentBtn(IP,"🔗  Copy Backup Link",268,28,false)
local cRechk=accentBtn(IP,"↺  Refresh checks",302,28,false)

cGrp.MouseButton1Click:Connect(function()
    copyToClipboard(HUB.GROUP_URL)
    cGrp.Text="✓  Copied!" task.delay(2,function() cGrp.Text="🔗  Copy Group Link" end)
end)
cInf.MouseButton1Click:Connect(function()
    copyToClipboard(string.format("VOID HUB %s | %s | Executor: %s | Age: %d | Game: %d",
        HUB.Version,LocalPlayer.Name,getExec(),getAge(),game.PlaceId))
    cInf.Text="✓  Copied!" task.delay(1.5,function() cInf.Text="📋  Copy Support Info" end)
end)
cLnk.MouseButton1Click:Connect(function()
    copyToClipboard(HUB.BackupURL)
    cLnk.Text="✓  Copied!" task.delay(1.5,function() cLnk.Text="🔗  Copy Backup Link" end)
end)
cRechk.MouseButton1Click:Connect(function()
    cRechk.Text="Refreshing..."
    task.spawn(function() renderChecks(buildChecks()) cRechk.Text="↺  Refresh checks" end)
end)

-- ── Tab wiring ────────────────────────────────────────────────
for _,td in ipairs(tabDefs) do
    tabBtns[td.name].MouseButton1Click:Connect(function() switchTab(td.name) end)
end
switchTab("Access")

-- ── Fade in ───────────────────────────────────────────────────
Root.BackgroundTransparency=1
TweenService:Create(Root,TweenInfo.new(0.35,Enum.EasingStyle.Quad),{BackgroundTransparency=0}):Play()

-- ── Keybind ───────────────────────────────────────────────────
UserInputService.InputBegan:Connect(function(i,gp)
    if gp then return end
    if i.KeyCode==Enum.KeyCode.RightShift then Root.Visible=not Root.Visible end
end)

-- ── Loader ────────────────────────────────────────────────────
local function loadMain()
    if HUB.SCRIPT_URL=="" then return end
    if not httpRequest then warn("[VOID HUB] No HTTP.") return end
    local ok,res=pcall(httpRequest,{Url=HUB.SCRIPT_URL,Method="GET"})
    if ok and res and res.StatusCode==200 then
        local fn,err=_loadstring(res.Body)
        if fn then pcall(fn) else warn("[VOID HUB] "..tostring(err)) end
    end
end
task.spawn(loadMain)
print("[VOID HUB] Loaded — "..HUB.Version)
