-- OXIRO GATE | FIXED VERSION
-- No Add No Touch | currentTab added | GUI fixed
local MAX_ATTEMPTS = 3
local CORRECT_KEY = "hello"

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TextChatService = game:GetService("TextChatService")
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")

local Player = Players.LocalPlayer
local attempts = 0
local currentTab = "target" -- ✅ FIXED: missing variable added

-- KEY SYSTEM UI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "OXIROGATE"
ScreenGui.Parent = Player:WaitForChild("PlayerGui")
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(8, 8, 16)
MainFrame.Position = UDim2.new(0.5, -185, 0.5, -125)
MainFrame.Size = UDim2.new(0, 370, 0, 250)
MainFrame.Active = true
MainFrame.Draggable = true

local GlowCorner = Instance.new("UICorner")
GlowCorner.CornerRadius = UDim.new(0, 16)
GlowCorner.Parent = MainFrame

local OuterStroke = Instance.new("UIStroke")
OuterStroke.Name = "OuterGlow"
OuterStroke.Parent = MainFrame
OuterStroke.Color = Color3.fromRGB(60, 220, 255)
OuterStroke.Thickness = 3
OuterStroke.Transparency = 0

TweenService:Create(OuterStroke, TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
	Color = Color3.fromRGB(140, 240, 255),
	Thickness = 5
}):Play()

local Title = Instance.new("TextLabel")
Title.Parent = MainFrame
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 0, 0, 18)
Title.Size = UDim2.new(1, 0, 0, 55)
Title.Font = Enum.Font.GothamBold
Title.Text = "OXIRO GATE"
Title.TextColor3 = Color3.fromRGB(80, 240, 255)
Title.TextSize = 36
Instance.new("UIStroke", Title).Color = Color3.fromRGB(100, 255, 255)

local SubTitle = Instance.new("TextLabel")
SubTitle.Parent = MainFrame
SubTitle.BackgroundTransparency = 1
SubTitle.Position = UDim2.new(0, 0, 0, 70)
SubTitle.Size = UDim2.new(1, 0, 0, 22)
SubTitle.Font = Enum.Font.GothamMedium
SubTitle.Text = "SECURITY VERIFICATION"
SubTitle.TextColor3 = Color3.fromRGB(160, 200, 220)
SubTitle.TextSize = 13

local KeyBox = Instance.new("TextBox")
KeyBox.Parent = MainFrame
KeyBox.BackgroundColor3 = Color3.fromRGB(12, 18, 30)
KeyBox.Position = UDim2.new(0.07, 0, 0, 100)
KeyBox.Size = UDim2.new(0.86, 0, 0, 50)
KeyBox.Font = Enum.Font.Gotham
KeyBox.PlaceholderText = "Enter access key..."
KeyBox.Text = ""
KeyBox.TextColor3 = Color3.fromRGB(220, 250, 255)
KeyBox.TextSize = 16
KeyBox.PlaceholderColor3 = Color3.fromRGB(90, 140, 160)
Instance.new("UICorner", KeyBox).CornerRadius = UDim.new(0, 10)
Instance.new("UIStroke", KeyBox).Color = Color3.fromRGB(60, 220, 255)

local SubmitBtn = Instance.new("TextButton")
SubmitBtn.Parent = MainFrame
SubmitBtn.BackgroundColor3 = Color3.fromRGB(20, 130, 200)
SubmitBtn.Position = UDim2.new(0.18, 0, 0, 165)
SubmitBtn.Size = UDim2.new(0.64, 0, 0, 45)
SubmitBtn.Font = Enum.Font.GothamBold
SubmitBtn.Text = "VERIFY"
SubmitBtn.TextColor3 = Color3.fromRGB(240, 255, 255)
SubmitBtn.TextSize = 17
Instance.new("UICorner", SubmitBtn).CornerRadius = UDim.new(0, 10)

local Status = Instance.new("TextLabel")
Status.Parent = MainFrame
Status.BackgroundTransparency = 1
Status.Position = UDim2.new(0, 0, 0, 218)
Status.Size = UDim2.new(1, 0, 0, 20)
Status.Font = Enum.Font.GothamMedium
Status.Text = ""
Status.TextColor3 = Color3.fromRGB(255, 90, 90)
Status.TextSize = 12

SubmitBtn.MouseButton1Click:Connect(function()
	if attempts >= MAX_ATTEMPTS then return end
	local input = KeyBox.Text
	if input == "" then
		Status.Text = "ENTER KEY FIRST"
		Status.TextColor3 = Color3.fromRGB(255, 180, 60)
		return
	end
	attempts += 1
	if input == CORRECT_KEY then
		Status.Text = "ACCESS GRANTED"
		Status.TextColor3 = Color3.fromRGB(80, 255, 140)
		task.wait(1.5)
		ScreenGui:Destroy()
	else
		local rem = MAX_ATTEMPTS - attempts
		if rem > 0 then
			Status.Text = "INVALID. "..rem.." ATTEMPTS LEFT"
		else
			Status.Text = "BANNED"
			task.wait(1.5)
			Player:Kick("Too many attempts")
		end
	end
end)

KeyBox.FocusLost:Connect(function(enterPressed)
	if enterPressed and attempts < MAX_ATTEMPTS and KeyBox.Text ~= "" then
		SubmitBtn:Activate()
	end
end)

-- MAIN SCRIPT STARTS AFTER KEY --
local function runMain()
local OWNER_USERNAME = "Markarenoob"
local isOwner = Player.Name == OWNER_USERNAME

local blockedUsernames = {}
for _, name in ipairs(blockedUsernames) do
	if Player.Name:lower() == name:lower() then return end
end

local permanentControllers = {}
local tempControllers = {}

local function isAuthorized(plr)
	if not plr then return false end
	if plr.Name == OWNER_USERNAME then return true end
	if permanentControllers[plr.UserId] then return true end
	if tempControllers[plr.UserId] then return true end
	return false
end

local HVH_MODE = false
local HVH_TARGET_USERID = nil
local HVH_VOID = false
local HVH_NOCLIP = false

local function findPlayerByFuzzy(str)
	if not str or str == "" then return nil end
	str = str:lower()
	for _, plr in ipairs(Players:GetPlayers()) do
		if plr.DisplayName:lower():find(str) or plr.Name:lower():find(str) then
			return plr
		end
	end
	return nil
end

local mode = "idle"
local attackTarget = nil
local savedTargetUserId = nil
local FLOAT_HEIGHT = 2.5
local DISTANCE = 3.0
local SPRING_SMOOTH = 0.025
local HITBOX_SIZE = 100
local BLOCK_ENABLED = true
local UNLIMITED_M1_ENABLED = true
local ATTACK_RESET_INTERVAL = 4
local FALL_SPEED = -3500
local FALL_CHECK_Y = -4900
local WALKSPEED = 16
local ORBIT_ENABLED = false
local ORBIT_SPEED = 1.0
local ORBIT_RADIUS = 4.0
local ORBIT_ANGLE = 0
local CAMLOCK_ENABLED = false
local isVoiding = false
local VOID_MODE_ENABLED = false
local NOCLIP_ENABLED = false
local followConnection = nil
local noclipConnection = nil
local m1Running = false
local playerButtons = {}

local function applyWalkSpeed(speed)
	WALKSPEED = speed
	local c = Player.Character
	if c then local h = c:FindFirstChild("Humanoid") if h then h.WalkSpeed = speed end end
end

Player.CharacterAdded:Connect(function() task.wait(0.15) applyWalkSpeed(WALKSPEED) end)

local function setNoclip(enabled)
	NOCLIP_ENABLED = enabled
	if noclipConnection then noclipConnection:Disconnect() end
	if enabled then
		noclipConnection = RunService.Stepped:Connect(function()
			local c = Player.Character if not c then return end
			for _, p in ipairs(c:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide = false end end
		end)
	else noclipConnection = nil end
end

task.spawn(function()
	m1Running = true
	while m1Running do
		if UNLIMITED_M1_ENABLED and attackTarget then
			pcall(function()
				local rem = ReplicatedStorage:FindFirstChild("CombatRemote")
				if rem then rem:FireServer("M1") end
			end)
		end
		task.wait()
	end
end)

TextChatService.MessageReceived:Connect(function(msg)
	local sender = Players:GetPlayerByUserId(msg.PlayerUserId)
	if not sender then return end
	local c = msg.Message:lower()
	local a = string.split(c, " ")
	local cmd = a[1] or ""
	local arg = table.concat(a, " ", 2)

	if isOwner then
		if cmd == "hvh" and arg == "on" then HVH_MODE = true
		elseif cmd == "hvh" and arg == "off" then
			HVH_MODE = false HVH_TARGET_USERID = nil HVH_VOID = false HVH_NOCLIP = false
			if followConnection then stopFollowing() end
		elseif cmd == "attack" and arg ~= "" then
			local t = findPlayerByFuzzy(arg) if t then HVH_TARGET_USERID = t.UserId HVH_MODE = true selectTarget(t) end
		elseif cmd == "orbit" and arg == "on" then ORBIT_ENABLED = true
		elseif cmd == "orbit" and arg == "off" then ORBIT_ENABLED = false
		elseif cmd == "camlock" and arg == "on" then CAMLOCK_ENABLED = true
		elseif cmd == "camlock" and arg == "off" then CAMLOCK_ENABLED = false
		elseif cmd == "void" and arg == "all" then HVH_VOID = true VOID_MODE_ENABLED = true
		elseif cmd == "voidoff" and arg == "all" then HVH_VOID = false VOID_MODE_ENABLED = false
		elseif cmd == "noclip" and arg == "all" then HVH_NOCLIP = true setNoclip(true)
		elseif cmd == "noclipoff" and arg == "all" then HVH_NOCLIP = false setNoclip(false)
		elseif cmd == "stop" then HVH_MODE = false HVH_TARGET_USERID = nil if followConnection then stopFollowing() end
		elseif cmd == "addperm" and arg ~= "" then local t = findPlayerByFuzzy(arg) if t then permanentControllers[t.UserId] = true end
		elseif cmd == "addctrl" and arg ~= "" then local t = findPlayerByFuzzy(arg) if t then tempControllers[t.UserId] = true end
		elseif cmd == "revoke" and arg ~= "" then local t = findPlayerByFuzzy(arg) if t then permanentControllers[t.UserId] = nil tempControllers[t.UserId] = nil end
		end
	end
	if HVH_MODE and HVH_TARGET_USERID then
		local t = Players:GetPlayerByUserId(HVH_TARGET_USERID)
		if t and t ~= attackTarget then selectTarget(t) end
		if HVH_VOID then VOID_MODE_ENABLED = true end
		if HVH_NOCLIP then setNoclip(true) end
	end
	if not isAuthorized(sender) then return end
	if cmd == "stop" then if followConnection then stopFollowing() end
	elseif cmd == "orbit" and arg == "on" then ORBIT_ENABLED = true
	elseif cmd == "orbit" and arg == "off" then ORBIT_ENABLED = false
	elseif cmd == "camlock" and arg == "on" then CAMLOCK_ENABLED = true
	elseif cmd == "camlock" and arg == "off" then CAMLOCK_ENABLED = false
	elseif cmd == "void" then VOID_MODE_ENABLED = true
	elseif cmd == "voidoff" then VOID_MODE_ENABLED = false
	elseif cmd == "noclip" then setNoclip(true)
	elseif cmd == "noclipoff" then setNoclip(false)
	elseif cmd == "attack" and arg ~= "" then local t = findPlayerByFuzzy(arg) if t then selectTarget(t) end end
end)

local function goVoid(target)
	if isVoiding or not VOID_MODE_ENABLED then return end
	if not target or not target.Character then return end
	local my = Player.Character if not my then return end
	local myHRP = my:FindFirstChild("HumanoidRootPart") if not myHRP then return end
	local tHRP = target.Character:FindFirstChild("HumanoidRootPart") if not tHRP then return end
	isVoiding = true
	myHRP.CFrame = CFrame.new(tHRP.Position.X, myHRP.Position.Y, tHRP.Position.Z)
	task.spawn(function()
		for i=1,8 do task.wait(0.015) if not myHRP or not isVoiding then break end
			myHRP.Velocity = Vector3.new(0, FALL_SPEED, 0)
		end
	end)
	task.delay(0.5, function() isVoiding = false end)
end

task.spawn(function()
	while true do task.wait(0.03)
		if VOID_MODE_ENABLED and mode == "attack" and attackTarget then
			local c = Player.Character if not c then continue end
			local hrp = c:FindFirstChild("HumanoidRootPart")
			if hrp and hrp.Position.Y < FALL_CHECK_Y then
				local h = c:FindFirstChild("Humanoid") if h then h.Health = 0 end
			end
		end
	end
end)

task.spawn(function()
	while true do task.wait(ATTACK_RESET_INTERVAL)
		if VOID_MODE_ENABLED and mode == "attack" and attackTarget then goVoid(attackTarget) end
	end
end)

local function restoreTarget()
	if HVH_MODE and HVH_TARGET_USERID then
		local t = Players:GetPlayerByUserId(HVH_TARGET_USERID)
		if t then attackTarget = t savedTargetUserId = t.UserId
			if HVH_VOID then VOID_MODE_ENABLED = true end
			if HVH_NOCLIP then setNoclip(true) end
			task.wait(0.05) if not followConnection then startFollowing() end
		end
		return
	end
	if not savedTargetUserId then return end
	local t = Players:GetPlayerByUserId(savedTargetUserId) if not t then return end
	attackTarget = t task.wait(0.05) if not followConnection then startFollowing() end
end

Player.CharacterAdded:Connect(function() task.wait(0.05) restoreTarget() end)

local smoothPos = nil
local function positionAtTarget(target)
	local my = Player.Character if not my then return end
	local myHRP = my:FindFirstChild("HumanoidRootPart") if not myHRP then return end
	if not target or not target.Character then return end
	local tHRP = target.Character:FindFirstChild("HumanoidRootPart") if not tHRP then return end
	if isVoiding then return end
	local targetPos = tHRP.Position + Vector3.new(0, FLOAT_HEIGHT, 0)
	local desired
	if ORBIT_ENABLED then
		ORBIT_ANGLE += ORBIT_SPEED * 0.05
		desired = targetPos + Vector3.new(math.cos(ORBIT_ANGLE)*ORBIT_RADIUS, 0, math.sin(ORBIT_ANGLE)*ORBIT_RADIUS)
	else
		local dir = (targetPos - myHRP.Position).Unit
		desired = targetPos - dir * DISTANCE
	end
	smoothPos = smoothPos and (smoothPos + (desired - smoothPos) * SPRING_SMOOTH) or myHRP.Position
	myHRP.CFrame = CFrame.new(smoothPos, targetPos)
	if CAMLOCK_ENABLED then Workspace.CurrentCamera.CFrame = CFrame.new(Workspace.CurrentCamera.CFrame.Position, targetPos) end
end

RunService.Heartbeat:Connect(function()
	for _, plr in ipairs(Players:GetPlayers()) do
		local c = plr.Character if not c then continue end
		local hrp = c:FindFirstChild("HumanoidRootPart") if not hrp then continue end
		hrp.Size = plr == Player and Vector3.new(2,2,2) or Vector3.new(HITBOX_SIZE, HITBOX_SIZE, HITBOX_SIZE)
	end
end)

function startFollowing()
	if followConnection then followConnection:Disconnect() end
	followConnection = RunService.Heartbeat:Connect(function()
		local my = Player.Character if not my or isVoiding then return end
		if HVH_MODE and HVH_TARGET_USERID and (not attackTarget or attackTarget.UserId ~= HVH_TARGET_USERID) then
			attackTarget = Players:GetPlayerByUserId(HVH_TARGET_USERID)
			if HVH_VOID then VOID_MODE_ENABLED = true end
			if HVH_NOCLIP then setNoclip(true) end
		end
		if not attackTarget and savedTargetUserId then attackTarget = Players:GetPlayerByUserId(savedTargetUserId) end
		if not attackTarget or not attackTarget:IsDescendantOf(Players) then
			if not HVH_MODE then stopFollowing() end return
		end
		positionAtTarget(attackTarget)
		pcall(function() if BLOCK_ENABLED then local r = ReplicatedStorage:FindFirstChild("CombatRemote") if r then r:FireServer("Block") end end end)
	end)
	mode = "attack"
end

function stopFollowing()
	if followConnection then followConnection:Disconnect() end
	followConnection = nil mode = "idle"
	if not HVH_MODE then attackTarget = nil savedTargetUserId = nil end
	isVoiding = false smoothPos = nil
end

function selectTarget(plr)
	if plr == Player then return end
	mode = "attack" attackTarget = plr savedTargetUserId = plr.UserId
	smoothPos = nil startFollowing()
end

pcall(function() if CoreGui:FindFirstChild("OxiroGui") then CoreGui.OxiroGui:Destroy() end end)

local Gui = Instance.new("ScreenGui")
Gui.Name = "OxiroGui"
Gui.Parent = Player:WaitForChild("PlayerGui")
Gui.ResetOnSpawn = false Gui.DisplayOrder = 99999

local OpenBtn = Instance.new("TextButton")
OpenBtn.Size = UDim2.new(0,160,0,55)
OpenBtn.Position = UDim2.new(0.82,0,0.88,0)
OpenBtn.BackgroundColor3 = Color3.fromRGB(20,30,45)
OpenBtn.Text = isOwner and "OXIRO [OWNER]" or "OXIRO"
OpenBtn.Font = Enum.Font.GothamBold
OpenBtn.TextColor3 = Color3.fromRGB(80,240,255)
OpenBtn.TextSize = 22
OpenBtn.Parent = Gui
Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(0,12)

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0,420,0,720)
MainFrame.Position = UDim2.new(0.20,0,0.03,0)
MainFrame.BackgroundColor3 = Color3.fromRGB(8,12,24)
MainFrame.Active = true MainFrame.Draggable = true MainFrame.Visible = false
MainFrame.Parent = Gui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0,14)

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0,50,0,36)
CloseBtn.Position = UDim2.new(1,-55,0,5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(50,20,30)
CloseBtn.Text = "X" CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextColor3 = Color3.fromRGB(220,180,180) CloseBtn.TextSize = 22
CloseBtn.Parent = MainFrame
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0,10)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1,-60,0,40)
Title.Position = UDim2.new(0,15,0,8)
Title.BackgroundTransparency = 1
Title.Text = isOwner and "OXIRO — OWNER PANEL" or "OXIRO"
Title.Font = Enum.Font.GothamBold Title.TextColor3 = Color3.fromRGB(80,240,255) Title.TextSize = 20
Title.TextXAlignment = Enum.TextXAlignment.Left Title.Parent = MainFrame

local TabCont = Instance.new("Frame")
TabCont.Size = UDim2.new(1,-30,0,40)
TabCont.Position = UDim2.new(0,15,0,55)
TabCont.BackgroundTransparency = 1 TabCont.Parent = MainFrame
Instance.new("UIListLayout", TabCont).FillDirection = Enum.FillDirection.Horizontal
Instance.new("UIListLayout", TabCont).Padding = UDim.new(0,8)

local TargetTab = Instance.new("TextButton")
TargetTab.Size = UDim2.new(0,115,1,0)
TargetTab.BackgroundColor3 = Color3.fromRGB(25,60,90)
TargetTab.Text = "TARGET" TargetTab.Font = Enum.Font.GothamBold
TargetTab.TextColor3 = Color3.fromRGB(120,240,255) TargetTab.TextSize = 13
TargetTab.Parent = TabCont Instance.new("UICorner", TargetTab).CornerRadius = UDim.new(0,8)

local SettingsTab = Instance.new("TextButton")
SettingsTab.Size = UDim2.new(0,115,1,0)
SettingsTab.BackgroundColor3 = Color3.fromRGB(25,35,55)
SettingsTab.Text = "SETTINGS" SettingsTab.Font = Enum.Font.GothamBold
SettingsTab.TextColor3 = Color3.fromRGB(180,200,220) SettingsTab.TextSize = 13
SettingsTab.Parent = TabCont Instance.new("UICorner", SettingsTab).CornerRadius = UDim.new(0,8)

local ControlTab = nil
if isOwner then
	ControlTab = Instance.new("TextButton")
	ControlTab.Size = UDim2.new(0,115,1,0)
	ControlTab.BackgroundColor3 = Color3.fromRGB(25,35,55)
	ControlTab.Text = "CONTROL" ControlTab.Font = Enum.Font.GothamBold
	ControlTab.TextColor3 = Color3.fromRGB(180,200,220) ControlTab.TextSize = 13
	ControlTab.Parent = TabCont Instance.new("UICorner", ControlTab).CornerRadius = UDim.new(0,8)
end

local Content = Instance.new("Frame")
Content.Size = UDim2.new(1,-30,1,-125)
Content.Position = UDim2.new(0,15,0,105)
Content.BackgroundTransparency = 1 Content.Parent = MainFrame

local TargetPage = Instance.new("Frame")
TargetPage.Size = UDim2.new(1,0,1,0) TargetPage.BackgroundTransparency = 1
TargetPage.Visible = true TargetPage.Parent = Content

local PlayerScroll = Instance.new("ScrollingFrame")
PlayerScroll.Size = UDim2.new(1,0,1,-35)
PlayerScroll.Position = UDim2.new(0,0,0,35)
PlayerScroll.BackgroundTransparency = 1
PlayerScroll.ScrollBarThickness = 8
PlayerScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
PlayerScroll.CanvasSize = UDim2.new(0,0,0,0)
PlayerScroll.Parent = TargetPage
Instance.new("UIListLayout", PlayerScroll).Padding = UDim.new(0,7)

local SettingsPage = Instance.new("Frame")
SettingsPage.Size = UDim2.new(1,0,1,0) SettingsPage.BackgroundTransparency = 1
SettingsPage.Visible = false SettingsPage.Parent = Content

local SettingsScroll = Instance.new("ScrollingFrame")
SettingsScroll.Size = UDim2.new(1,0,1,0) SettingsScroll.BackgroundTransparency = 1
SettingsScroll.ScrollBarThickness = 8
SettingsScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
SettingsScroll.CanvasSize = UDim2.new(0,0,0,0)
SettingsScroll.Parent = SettingsPage
Instance.new("UIListLayout", SettingsScroll).Padding = UDim.new(0,12)

local ControlPage, ControlScroll
if isOwner then
	ControlPage = Instance.new("Frame")
	ControlPage.Size = UDim2.new(1,0,1,0) ControlPage.BackgroundTransparency = 1
	ControlPage.Visible = false ControlPage.Parent = Content
	ControlScroll = Instance.new("ScrollingFrame")
	ControlScroll.Size = UDim2.new(1,0,1,0) ControlScroll.BackgroundTransparency = 1
	ControlScroll.ScrollBarThickness = 8
	ControlScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
	ControlScroll.CanvasSize = UDim2.new(0,0,0,0)
	ControlScroll.Parent = ControlPage
	Instance.new("UIListLayout", ControlScroll).Padding = UDim.new(0,12)
end

local function switchTab(name)
	currentTab = name
	TargetPage.Visible = name == "target"
	SettingsPage.Visible = name == "settings"
	if isOwner then ControlPage.Visible = name == "control" end
	TargetTab.BackgroundColor3 = name == "target" and Color3.fromRGB(25,60,90) or Color3.fromRGB(25,35,55)
	TargetTab.TextColor3 = name == "target" and Color3.fromRGB(120,240,255) or Color3.fromRGB(180,200,220)
	SettingsTab.BackgroundColor3 = name == "settings" and Color3.fromRGB(25,60,90) or Color3.fromRGB(25,35,55)
	SettingsTab.TextColor3 = name == "settings" and Color3.fromRGB(120,240,255) or Color3.fromRGB(180,200,220)
	if isOwner then
		ControlTab.BackgroundColor3 = name == "control" and Color3.fromRGB(25,60,90) or Color3.fromRGB(25,35,55)
		ControlTab.TextColor3 = name == "control" and Color3.fromRGB(120,240,255) or Color3.fromRGB(180,200,220)
	end
end

TargetTab.MouseButton1Click:Connect(function() switchTab("target") end)
SettingsTab.MouseButton1Click:Connect(function() switchTab("settings") end)
if isOwner then ControlTab.MouseButton1Click:Connect(function() switchTab("control") end) end
OpenBtn.MouseButton1Click:Connect(function() MainFrame.Visible = true end)
CloseBtn.MouseButton1Click:Connect(function() MainFrame.Visible = false end)

function refreshList()
	for _,b in ipairs(playerButtons) do b:Destroy() end table.clear(playerButtons)
	for _,plr in ipairs(Players:GetPlayers()) do
		if plr ~= Player then
			local btn = Instance.new("TextButton")
			btn.Size = UDim2.new(1,0,0,36)
			btn.BackgroundColor3 = Color3.fromRGB(25,40,65)
			btn.Text = plr.DisplayName.." (@"..plr.Name..")"
			btn.Font = Enum.Font.Gotham btn.TextColor3 = Color3.fromRGB(180,220,255) btn.TextSize = 12
			btn.Parent = PlayerScroll Instance.new("UICorner", btn).CornerRadius = UDim.new(0,8)
			btn.MouseButton1Click:Connect(function()
				if isOwner then HVH_MODE = true HVH_TARGET_USERID = plr.UserId end
				selectTarget(plr)
			end)
			table.insert(playerButtons, btn)
		end
	end
end

Players.PlayerAdded:Connect(refreshList)
Players.PlayerRemoving:Connect(refreshList)
task.spawn(refreshList)

local function numInp(label, def, cb, par)
	local c = Instance.new("Frame")
	c.Size = UDim2.new(1,0,0,42) c.BackgroundColor3 = Color3.fromRGB(20,30,50) c.Parent = par or SettingsScroll
	Instance.new("UICorner",c).CornerRadius = UDim.new(0,8)
	local l = Instance.new("TextLabel")
	l.Size = UDim2.new(0,130,1,0) l.Position = UDim2.new(0,15,0,0)
	l.BackgroundTransparency = 1 l.Text = label l.Font = Enum.Font.Gotham
	l.TextColor3 = Color3.fromRGB(180,220,255) l.TextSize = 13 l.Parent = c
	local b = Instance.new("TextBox")
	b.Size = UDim2.new(1,-160,1,-8) b.Position = UDim2.new(0,145,0,4)
	b.BackgroundColor3 = Color3.fromRGB(25,45,70) b.Font = Enum.Font.Gotham
	b.Text = tostring(def) b.TextColor3 = Color3.fromRGB(200,240,255) b.TextSize = 13
	b.Parent = c Instance.new("UICorner",b).CornerRadius = UDim.new(0,6)
	b.FocusLost:Connect(function(e) if e then local v = tonumber(b.Text) if v then cb(v) end end end)
end

local function toggle(text, get, set, par)
	local b = Instance.new("TextButton")
	b.Size = UDim2.new(1,0,0,42)
	local function upd() local s=get() b.BackgroundColor3 = s and Color3.fromRGB(20,60,50) or Color3.fromRGB(25,35,55) b.Text = text.." — "..(s and "ON" or "OFF") end
	upd() b.Font = Enum.Font.GothamSemibold b.TextColor3 = Color3.fromRGB(180,240,255) b.TextSize = 14
	b.Parent = par or SettingsScroll Instance.new("UICorner",b).CornerRadius = UDim.new(0,8)b.MouseButton1Click:Connect(function() set(not get()) upd() end)
end

local function btn(text, cb, par)
	local b = Instance.new("TextButton")
	b.Size = UDim2.new(1,0,0,42) b.BackgroundColor3 = Color3.fromRGB(20,40,70)
	b.Text = text b.Font = Enum.Font.Gotham b.TextColor3 = Color3.fromRGB(180,240,255) b.TextSize = 14
	b.Parent = par or SettingsScroll Instance.new("UICorner",b).CornerRadius = UDim.new(0,8)
	b.MouseButton1Click:Connect(cb)
end

numInp("WalkSpeed", WALKSPEED, function(v) applyWalkSpeed(v) end)
numInp("Hitbox Size", HITBOX_SIZE, function(v) HITBOX_SIZE = v end)
numInp("Float Height", FLOAT_HEIGHT, function(v) FLOAT_HEIGHT = v end)
numInp("Distance", DISTANCE, function(v) DISTANCE = v end)
numInp("Orbit Speed", ORBIT_SPEED, function(v) ORBIT_SPEED = v end)
numInp("Orbit Radius", ORBIT_RADIUS, function(v) ORBIT_RADIUS = v end)

toggle("Atomic Orbit", function() return ORBIT_ENABLED end, function(v) ORBIT_ENABLED = v end)toggle("Camlock", function() return CAMLOCK_ENABLED end, function(v) CAMLOCK_ENABLED = v end)
toggle("VOID MODE", function() return VOID_MODE_ENABLED end, function(v) VOID_MODE_ENABLED = v end)
toggle("NOCLIP", function() return NOCLIP_ENABLED end, function(v) setNoclip(v) end)
toggle("M1 Spam", function() return UNLIMITED_M1_ENABLED end, function(v) UNLIMITED_M1_ENABLED = v end)
toggle("Auto Block", function() return BLOCK_ENABLED end, function(v) BLOCK_ENABLED = v end)

btn("Stop / Idle", function() if followConnection then stopFollowing() end end)

if isOwner then
	toggle("HVH GROUP MODE", function() return HVH_MODE end, function(v) HVH_MODE = v if not v then HVH_TARGET_USERID = nil HVH_VOID = false HVH_NOCLIP = false end end, ControlScroll)
	btn("Stop All / HVH OFF", function() HVH_MODE = false HVH_TARGET_USERID = nil HVH_VOID = false HVH_NOCLIP = false if followConnection then stopFollowing() end end, ControlScroll)
end

end -- END runMain()

-- WAIT FOR KEY CORRECT THEN RUN MAIN
local origSubmit = SubmitBtn.MouseButton1Click
SubmitBtn.MouseButton1Click:Disconnect()
SubmitBtn.MouseButton1Click:Connect(function()
	if attempts >= MAX_ATTEMPTS then return end
	local input = KeyBox.Text
	if input == "" then
		Status.Text = "ENTER KEY FIRST"
		Status.TextColor3 = Color3.fromRGB(255,180,60)
		return
	end
	attempts += 1
	if input == CORRECT_KEY then
		Status.Text = "ACCESS GRANTED"
		Status.TextColor3 = Color3.fromRGB(80,255,140)
		task.wait(1.5)
		ScreenGui:Destroy()
		runMain() -- ✅ RUNS MAIN SCRIPT
	else
		local rem = MAX_ATTEMPTS - attempts
		if rem > 0 then
			Status.Text = "INVALID. "..rem.." ATTEMPTS LEFT"
		else
			Status.Text = "BANNED"
			task.wait(1.5)
			Player:Kick("Too many attempts")
		end
	end
end)

KeyBox.FocusLost:Connect(function(enterPressed)
	if enterPressed and attempts < MAX_ATTEMPTS and KeyBox.Text ~= "" then
		SubmitBtn:Activate()
	end
end)
