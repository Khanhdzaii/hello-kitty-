--// KittyUI Library | Orion-like | Hello Kitty Style
--// Mobile + PC | No animation | Local UI

local KittyUI = {}
KittyUI.Visible = false

-- Services
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

-- Keybind để toggle UI (mặc định là RightShift)
local ToggleKey = Enum.KeyCode.RightShift

-- ================= INITIALIZE =================
local ScreenGui
local Main

local function CreateUI()
    -- cleanup
    pcall(function()
        PlayerGui:FindFirstChild("KittyUI"):Destroy()
    end)

    -- ================= GUI =================
    ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "KittyUI"
    ScreenGui.Parent = PlayerGui
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Enabled = KittyUI.Visible

    Main = Instance.new("Frame", ScreenGui)
    Main.Size = UDim2.fromOffset(560, 380)
    Main.Position = UDim2.fromScale(0.5, 0.5)
    Main.AnchorPoint = Vector2.new(0.5, 0.5)
    Main.BackgroundColor3 = Color3.fromRGB(255, 190, 210)
    Main.BackgroundTransparency = 0.25
    Main.BorderSizePixel = 0
    Main.Active = true
    Main.Draggable = true
    Main.Visible = KittyUI.Visible
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 22)

    -- ================= TITLE =================
    local Title = Instance.new("TextLabel", Main)
    Title.Size = UDim2.new(1, 0, 0, 42)
    Title.Text = "😻 Kitty UI"
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 18
    Title.TextColor3 = Color3.new(1,1,1)
    Title.BackgroundTransparency = 1

    -- Close button
    local CloseBtn = Instance.new("TextButton", Main)
    CloseBtn.Size = UDim2.fromOffset(30, 30)
    CloseBtn.Position = UDim2.new(1, -35, 0, 6)
    CloseBtn.Text = "✕"
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.TextSize = 16
    CloseBtn.TextColor3 = Color3.new(1,1,1)
    CloseBtn.BackgroundTransparency = 1
    CloseBtn.Active = true
    
    CloseBtn.MouseButton1Click:Connect(function()
        KittyUI.Visible = false
        ScreenGui.Enabled = false
        Main.Visible = false
    end)

    -- ================= BODY =================
    local Body = Instance.new("Frame", Main)
    Body.Position = UDim2.fromOffset(0, 42)
    Body.Size = UDim2.new(1, 0, 1, -42)
    Body.BackgroundTransparency = 1

    -- Tabs list
    local Tabs = Instance.new("Frame", Body)
    Tabs.Size = UDim2.new(0, 140, 1, 0)
    Tabs.BackgroundTransparency = 1

    local TabsLayout = Instance.new("UIListLayout", Tabs)
    TabsLayout.Padding = UDim.new(0, 6)

    -- Pages
    local Pages = Instance.new("Frame", Body)
    Pages.Position = UDim2.fromOffset(140, 0)
    Pages.Size = UDim2.new(1, -140, 1, 0)
    Pages.BackgroundTransparency = 1

    -- ================= CREATE WATERMARK/TRAY ICON =================
    local TrayIcon = Instance.new("TextButton", PlayerGui)
    TrayIcon.Name = "KittyTrayIcon"
    TrayIcon.Size = UDim2.fromOffset(40, 40)
    TrayIcon.Position = UDim2.new(0, 10, 0.5, -20)
    TrayIcon.Text = "😻"
    TrayIcon.Font = Enum.Font.GothamBold
    TrayIcon.TextSize = 24
    TrayIcon.TextColor3 = Color3.new(1,1,1)
    TrayIcon.BackgroundColor3 = Color3.fromRGB(255, 130, 180)
    TrayIcon.BorderSizePixel = 0
    TrayIcon.Active = true
    TrayIcon.Draggable = true
    Instance.new("UICorner", TrayIcon).CornerRadius = UDim.new(1, 0)
    
    -- Hiệu ứng hover cho tray icon
    TrayIcon.MouseEnter:Connect(function()
        TweenService:Create(TrayIcon, TweenInfo.new(0.2), {Size = UDim2.fromOffset(44, 44)}):Play()
    end)
    
    TrayIcon.MouseLeave:Connect(function()
        TweenService:Create(TrayIcon, TweenInfo.new(0.2), {Size = UDim2.fromOffset(40, 40)}):Play()
    end)

    TrayIcon.MouseButton1Click:Connect(function()
        KittyUI.Visible = not KittyUI.Visible
        ScreenGui.Enabled = KittyUI.Visible
        Main.Visible = KittyUI.Visible
    end)

    -- ================= LIB =================
    local Library = {}
    local CurrentPage
    local CurrentTabBtn

    function Library:CreateWindow(title)
        Title.Text = title or "😻 Kitty UI"
        return Library
    end

    function Library:CreateTab(name)
        -- tab button
        local TabBtn = Instance.new("TextButton", Tabs)
        TabBtn.Size = UDim2.new(1, -10, 0, 36)
        TabBtn.Text = "  😻  "..name
        TabBtn.Font = Enum.Font.Gotham
        TabBtn.TextSize = 14
        TabBtn.TextXAlignment = Enum.TextXAlignment.Left
        TabBtn.TextColor3 = Color3.new(1,1,1)
        TabBtn.BackgroundTransparency = 0.5
        TabBtn.BorderSizePixel = 0
        TabBtn.Active = true
        Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 8)

        -- page
        local Page = Instance.new("Frame", Pages)
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.Visible = false
        Page.BackgroundTransparency = 1

        local Layout = Instance.new("UIListLayout", Page)
        Layout.Padding = UDim.new(0, 8)

        local function Select()
            if CurrentPage then CurrentPage.Visible = false end
            if CurrentTabBtn then CurrentTabBtn.BackgroundTransparency = 0.5 end
            Page.Visible = true
            TabBtn.BackgroundTransparency = 0.2
            CurrentPage = Page
            CurrentTabBtn = TabBtn
        end

        TabBtn.MouseButton1Click:Connect(Select)
        if not CurrentPage then Select() end

        local Tab = {}

        function Tab:AddToggle(text, default, callback)
            local state = default or false
            
            local B = Instance.new("TextButton", Page)
            B.Size = UDim2.new(1, -20, 0, 36)
            B.Text = text.." ["..(state and "ON" or "OFF").."]"
            B.Font = Enum.Font.Gotham
            B.TextSize = 14
            B.TextXAlignment = Enum.TextXAlignment.Left
            B.TextColor3 = Color3.new(1,1,1)
            B.BackgroundTransparency = 0.4
            B.BorderSizePixel = 0
            B.Active = true
            Instance.new("UICorner", B).CornerRadius = UDim.new(0, 8)

            B.MouseButton1Click:Connect(function()
                state = not state
                B.Text = text.." ["..(state and "ON" or "OFF").."]"
                if callback then 
                    pcall(callback, state)
                end
            end)
            
            return {
                Set = function(self, value)
                    state = value
                    B.Text = text.." ["..(state and "ON" or "OFF").."]"
                end,
                Get = function(self)
                    return state
                end
            }
        end

        function Tab:AddButton(text, callback)
            local B = Instance.new("TextButton", Page)
            B.Size = UDim2.new(1, -20, 0, 36)
            B.Text = "🎀 "..text
            B.Font = Enum.Font.Gotham
            B.TextSize = 14
            B.TextXAlignment = Enum.TextXAlignment.Left
            B.TextColor3 = Color3.new(1,1,1)
            B.BackgroundTransparency = 0.4
            B.BorderSizePixel = 0
            B.Active = true
            Instance.new("UICorner", B).CornerRadius = UDim.new(0, 8)

            -- Hiệu ứng hover
            local originalSize = B.Size
            B.MouseEnter:Connect(function()
                TweenService:Create(B, TweenInfo.new(0.1), {BackgroundTransparency = 0.2}):Play()
            end)
            
            B.MouseLeave:Connect(function()
                TweenService:Create(B, TweenInfo.new(0.1), {BackgroundTransparency = 0.4}):Play()
            end)

            B.MouseButton1Click:Connect(function()
                if callback then 
                    pcall(callback)
                end
            end)
        end

        function Tab:AddSlider(text, min, max, default, callback)
            local value = default or min
            
            local H = Instance.new("Frame", Page)
            H.Size = UDim2.new(1, -20, 0, 56)
            H.BackgroundTransparency = 1

            local L = Instance.new("TextLabel", H)
            L.Size = UDim2.new(1, 0, 0, 18)
            L.Text = text..": "..tostring(value)
            L.Font = Enum.Font.Gotham
            L.TextSize = 13
            L.TextColor3 = Color3.new(1,1,1)
            L.BackgroundTransparency = 1
            L.TextXAlignment = Enum.TextXAlignment.Left

            local Bar = Instance.new("Frame", H)
            Bar.Position = UDim2.fromOffset(0, 30)
            Bar.Size = UDim2.new(1, 0, 0, 12)
            Bar.BackgroundTransparency = 0.5
            Bar.BackgroundColor3 = Color3.fromRGB(255, 160, 200)
            Bar.Active = true
            Instance.new("UICorner", Bar).CornerRadius = UDim.new(1, 0)

            local Fill = Instance.new("Frame", Bar)
            Fill.Size = UDim2.fromScale((value - min) / (max - min), 1)
            Fill.BackgroundColor3 = Color3.fromRGB(255, 100, 170)
            Instance.new("UICorner", Fill).CornerRadius = UDim.new(1, 0)

            local dragging = false
            local function UpdateSlider(pos)
                local percent = math.clamp((pos.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
                Fill.Size = UDim2.fromScale(percent, 1)
                value = math.floor(min + (max - min) * percent)
                L.Text = text..": "..tostring(value)
                if callback then 
                    pcall(callback, value)
                end
            end

            Bar.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1
                or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = true
                    UpdateSlider(input.Position)
                end
            end)
            
            UIS.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1
                or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = false
                end
            end)
            
            UIS.InputChanged:Connect(function(input)
                if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
                or input.UserInputType == Enum.UserInputType.Touch) then
                    UpdateSlider(input.Position)
                end
            end)
            
            return {
                Set = function(self, val)
                    value = math.clamp(val, min, max)
                    Fill.Size = UDim2.fromScale((value - min) / (max - min), 1)
                    L.Text = text..": "..tostring(value)
                end,
                Get = function(self)
                    return value
                end
            }
        end

        function Tab:AddDropdown(text, options, default, callback)
            local selected = default or options[1]
            local isOpen = false
            
            local B = Instance.new("TextButton", Page)
            B.Size = UDim2.new(1, -20, 0, 36)
            B.Text = "📌 "..text..": "..selected
            B.Font = Enum.Font.Gotham
            B.TextSize = 14
            B.TextXAlignment = Enum.TextXAlignment.Left
            B.TextColor3 = Color3.new(1,1,1)
            B.BackgroundTransparency = 0.4
            B.BorderSizePixel = 0
            B.Active = true
            Instance.new("UICorner", B).CornerRadius = UDim.new(0, 8)

            local function CloseDropdown()
                isOpen = false
                for _, child in ipairs(Page:GetChildren()) do
                    if child.Name == "DropdownOption" then
                        child:Destroy()
                    end
                end
            end

            B.MouseButton1Click:Connect(function()
                if isOpen then
                    CloseDropdown()
                    return
                end
                
                isOpen = true
                local yOffset = 40
                
                for i, option in ipairs(options) do
                    local O = Instance.new("TextButton")
                    O.Name = "DropdownOption"
                    O.Parent = Page
                    O.Size = UDim2.new(1, -40, 0, 30)
                    O.Position = UDim2.new(0, 10, 0, (B.AbsolutePosition.Y - Page.AbsolutePosition.Y) + yOffset)
                    O.Text = option
                    O.Font = Enum.Font.Gotham
                    O.TextSize = 13
                    O.TextXAlignment = Enum.TextXAlignment.Left
                    O.TextColor3 = Color3.new(1,1,1)
                    O.BackgroundTransparency = 0.45
                    O.BackgroundColor3 = Color3.fromRGB(255, 170, 220)
                    O.BorderSizePixel = 0
                    O.Active = true
                    Instance.new("UICorner", O).CornerRadius = UDim.new(0, 6)
                    
                    yOffset = yOffset + 35

                    O.MouseButton1Click:Connect(function()
                        selected = option
                        B.Text = "📌 "..text..": "..selected
                        CloseDropdown()
                        if callback then 
                            pcall(callback, option)
                        end
                    end)
                end
            end)
            
            -- Đóng dropdown khi click ra ngoài
            Page.MouseButton1Click:Connect(function()
                if isOpen then
                    CloseDropdown()
                end
            end)
            
            return {
                Set = function(self, val)
                    if table.find(options, val) then
                        selected = val
                        B.Text = "📌 "..text..": "..selected
                    end
                end,
                Get = function(self)
                    return selected
                end
            }
        end

        function Tab:AddLabel(text)
            local L = Instance.new("TextLabel", Page)
            L.Size = UDim2.new(1, -20, 0, 25)
            L.Text = text
            L.Font = Enum.Font.Gotham
            L.TextSize = 14
            L.TextColor3 = Color3.new(1,1,1)
            L.BackgroundTransparency = 1
            L.TextXAlignment = Enum.TextXAlignment.Left
        end

        return Tab
    end

    return Library
end

-- ================= PUBLIC FUNCTIONS =================
function KittyUI:Init(title)
    local lib = CreateUI()
    return lib:CreateWindow(title)
end

function KittyUI:Toggle()
    KittyUI.Visible = not KittyUI.Visible
    if ScreenGui then
        ScreenGui.Enabled = KittyUI.Visible
        Main.Visible = KittyUI.Visible
    end
end

function KittyUI:SetToggleKey(key)
    ToggleKey = key
end

-- ================= KEYBIND =================
UIS.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == ToggleKey then
        KittyUI:Toggle()
    end
end)

return KittyUI