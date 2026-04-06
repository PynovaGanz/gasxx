local GetService = game.GetService
local Clone = game.Clone 
local Destroy = game.Destroy 

if not game:IsLoaded() then
    game.Loaded:Wait()
end

local Success, GameInfo = pcall(function()
    return game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId)
end)
local AutoGameName = Success and GameInfo.Name or "Unknown Game"

local Setup = {
    Version = "1.0.0",
    GameName = AutoGameName,
    Keybind = Enum.KeyCode.RightControl,
    Transparency = 0.05,
    Size = UDim2.new(0, 600, 0, 360),
}

-- THEME UPDATED: BLUE TO CYAN (MIVORA THEME)
local Theme = {
    Primary = Color3.fromRGB(5, 10, 15),       -- Biru Sangat Gelap
    Secondary = Color3.fromRGB(10, 20, 30),     -- Biru Gelap
    Component = Color3.fromRGB(15, 35, 45),     -- Biru Komponen
    Interactables = Color3.fromRGB(20, 50, 65), -- Biru Interaksi
    Tab = Color3.fromRGB(180, 240, 255),        -- Cyan Muda (Tab)
    Title = Color3.fromRGB(255, 255, 255),      -- Putih
    Description = Color3.fromRGB(150, 200, 220),-- Biru Pudar
    Shadow = Color3.fromRGB(0, 170, 255),       -- Biru Terang
    Outline = Color3.fromRGB(0, 255, 255),      -- Cyan (Garis Tepi)
    ActiveElement = Color3.fromRGB(0, 255, 255), -- Cyan Aktif
}

local Type = nil
local LocalPlayer = GetService(game, "Players").LocalPlayer
local Services = {
    Tween = GetService(game, "TweenService"),
    Input = GetService(game, "UserInputService")
}

local Player = { Mouse = LocalPlayer:GetMouse(), GUI = LocalPlayer.PlayerGui }

local Tween = function(Object, Speed, Properties, Info)
    local Style = Info and Info["EasingStyle"] or Enum.EasingStyle.Quint
    local Direction = Info and Info["EasingDirection"] or Enum.EasingDirection.Out
    local TInfo = TweenInfo.new(Speed, Style, Direction)
    local Anim = Services.Tween:Create(Object, TInfo, Properties)
    Anim:Play()
    return Anim
end

local SetProperty = function(Object, Properties)
    for Index, Property in next, Properties do 
        Object[Index] = Property 
    end 
    return Object
end

local Drag = function(Canvas)
    if Canvas then
        local Dragging, DragInput, Start, StartPosition
        local function Update(input)
            local delta = input.Position - Start
            Canvas.Position = UDim2.new(StartPosition.X.Scale, StartPosition.X.Offset + delta.X, StartPosition.Y.Scale, StartPosition.Y.Offset + delta.Y)
        end
        Canvas.InputBegan:Connect(function(Input)
            if (Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch) and not Type then
                Dragging = true; Start = Input.Position; StartPosition = Canvas.Position
                Input.Changed:Connect(function() 
                    if Input.UserInputState == Enum.UserInputState.End then 
                        Dragging = false 
                    end 
                end)
            end
        end)
        Canvas.InputChanged:Connect(function(Input)
            if (Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch) and not Type then 
                DragInput = Input 
            end
        end)
        Services.Input.InputChanged:Connect(function(Input)
            if Input == DragInput and Dragging and not Type then 
                Update(Input) 
            end
        end)
    end
end

local Screen
if identifyexecutor then
    local success, loaded = pcall(function() return game:GetObjects("rbxassetid://125099252638193")[1] end)
    if success and loaded then
        if loaded:IsA("ScreenGui") then
            Screen = loaded
        else
            Screen = loaded:FindFirstChildWhichIsA("ScreenGui", true) or loaded
        end
    else
        Screen = Instance.new("ScreenGui")
    end
else
    Screen = script.Parent
end

local MainFrame = Screen:WaitForChild("Main", 5)
if not MainFrame then
    for _, child in pairs(Screen:GetChildren()) do
        if child:IsA("Frame") or child:IsA("CanvasGroup") then
            MainFrame = child
            break
        end
    end
end

if MainFrame then MainFrame.Visible = false end
xpcall(function() Screen.Parent = game.CoreGui end, function() Screen.Parent = Player.GUI end)

local Animations = {}
local Components = Screen:FindFirstChild("Components")
local Library = {}

function Animations:Open(Window, Transparency)
    local Shadow = Window:FindFirstChildOfClass("UIStroke")
    SetProperty(Window, { GroupTransparency = 1, Visible = true })
    if Shadow then 
        Shadow.Transparency = 1
        Tween(Shadow, 0.4, { Transparency = 0, Thickness = 1.5 }) 
    end
    Tween(Window, 0.4, { GroupTransparency = Transparency or 0 })
end

function Animations:Close(Window)
    local Shadow = Window:FindFirstChildOfClass("UIStroke")
    if Shadow then 
        Tween(Shadow, 0.3, { Transparency = 1 }) 
    end
    Tween(Window, 0.3, { GroupTransparency = 1 })
    task.wait(0.3)
    Window.Visible = false
end

function Library:CreateWindow(Settings)
    Setup.Version = Settings.Version or Setup.Version
    Setup.GameName = Settings.GameName or Setup.GameName

    local LoadGui = Instance.new("ScreenGui", Screen.Parent)
    local LoadBG = Instance.new("Frame", LoadGui)
    LoadBG.Size = UDim2.new(1, 0, 1, 0)
    LoadBG.BackgroundColor3 = Theme.Primary
    LoadBG.BorderSizePixel = 0
    
    local KKLogo = Instance.new("TextLabel", LoadBG)
    KKLogo.Size = UDim2.new(1, 0, 1, -40)
    KKLogo.BackgroundTransparency = 1
    KKLogo.Text = "ZT" -- Mivora Hub Initials
    KKLogo.Font = Enum.Font.GothamBlack
    KKLogo.TextSize = 80
    KKLogo.TextColor3 = Theme.Outline -- Cyan Color
    
    local KKText = Instance.new("TextLabel", LoadBG)
    KKText.Size = UDim2.new(1, 0, 1, 60)
    KKText.BackgroundTransparency = 1
    KKText.Text = "Zero Traces" -- Updated Name
    KKText.Font = Enum.Font.GothamBold
    KKText.TextSize = 20
    KKText.TextColor3 = Color3.fromRGB(255, 255, 255)
    KKText.TextTransparency = 1

    Tween(KKLogo, 1, {TextSize = 90})
    Tween(KKText, 1, {TextTransparency = 0})
    task.wait(1.5)
    Tween(LoadBG, 0.5, {BackgroundTransparency = 1})
    Tween(KKLogo, 0.5, {TextTransparency = 1})
    Tween(KKText, 0.5, {TextTransparency = 1})
    task.wait(0.5)
    LoadGui:Destroy()

    local Window = Clone(MainFrame)
    Window.Parent = Screen
    if MainFrame.Parent == Screen then MainFrame:Destroy() end

    local Sidebar = Window:FindFirstChild("Sidebar") or Window
    local Holder = Window:FindFirstChild("Main") or Window
    local Tab = Sidebar:FindFirstChild("Tab")

    local TopFrame = Sidebar:FindFirstChild("Top")
    if TopFrame then
        TopFrame.Visible = true
        
        local TitleHub = TopFrame:FindFirstChild("TitleHub")
        if not TitleHub then
            TitleHub = Instance.new("TextLabel", TopFrame)
            TitleHub.Name = "TitleHub"
            TitleHub.BackgroundTransparency = 1
            TitleHub.Size = UDim2.new(1, -20, 0, 20)
            TitleHub.Position = UDim2.new(0, 15, 0, 10)
        end
        TitleHub.Visible = true
        TitleHub.TextTransparency = 0
        TitleHub.RichText = true
        -- Updated Title Color Cyan
        TitleHub.Text = "ZeroTraces <font color='#00FFFF'>|</font> <font color='#aaaaaa'>v" .. Setup.Version .. "</font>"
        TitleHub.TextColor3 = Theme.Title
        TitleHub.Font = Enum.Font.GothamBlack
        TitleHub.TextSize = 14
        TitleHub.TextXAlignment = Enum.TextXAlignment.Left

        local GameTitle = TopFrame:FindFirstChild("GameTitle")
        if not GameTitle then
            GameTitle = Instance.new("TextLabel", TopFrame)
            GameTitle.Name = "GameTitle"
            GameTitle.BackgroundTransparency = 1
            GameTitle.Size = UDim2.new(1, -20, 0, 20)
            GameTitle.Position = UDim2.new(0, 15, 0, 28)
        end
        GameTitle.Visible = true
        GameTitle.TextTransparency = 0
        GameTitle.Text = Setup.GameName
        GameTitle.TextColor3 = Theme.Description
        GameTitle.Font = Enum.Font.GothamBold
        GameTitle.TextSize = 12
        GameTitle.TextXAlignment = Enum.TextXAlignment.Left

        if TopFrame:FindFirstChild("Buttons") then 
            TopFrame.Buttons:Destroy() 
        end
    end

    local Options = {} 
    local Examples = {} 
    local Opened = true
    
    for Index, Example in next, Window:GetDescendants() do 
        if Example.Name:find("Example") and not Examples[Example.Name] then 
            Examples[Example.Name] = Example 
        end 
    end

    Drag(Window)
    Setup.Size = Settings.Size or Setup.Size
    Setup.Keybind = Settings.MinimizeKeybind or Setup.Keybind

    local Close = function()
        if Opened then 
            Opened = false
            Animations:Close(Window) 
        else 
            Animations:Open(Window, Setup.Transparency)
            Opened = true 
        end
    end

    -- Toggle Button Update Cyan
    local ToggleBtn = Instance.new("ImageButton", Screen.Parent)
    ToggleBtn.Name = "ZeroToggle"
    ToggleBtn.Size = UDim2.new(0, 50, 0, 50)
    ToggleBtn.Position = UDim2.new(0, 20, 0, 20)
    ToggleBtn.BackgroundColor3 = Theme.Secondary
    ToggleBtn.BackgroundTransparency = 0.2
    ToggleBtn.Image = "rbxassetid://120980344725307" -- Ganti asset ID jika perlu
    ToggleBtn.ImageColor3 = Theme.ActiveElement
    ToggleBtn.ZIndex = 10
    
    local ToggleStroke = Instance.new("UIStroke", ToggleBtn)
    ToggleStroke.Color = Theme.Outline
    ToggleStroke.Thickness = 2
    
    local UICorner = Instance.new("UICorner", ToggleBtn)
    UICorner.CornerRadius = UDim.new(1, 0)

    Drag(ToggleBtn)
    ToggleBtn.MouseButton1Click:Connect(function() Close() end)

    Services.Input.InputBegan:Connect(function(Input, Focused) 
        if (Input.KeyCode == Setup.Keybind) and not Focused then 
            Close() 
        end 
    end)

    function Options:SetTab(Name)
        if not Tab then return end
        for Index, Button in next, Tab:GetChildren() do
            if Button:IsA("TextButton") then
                local OpenedVal = Button:FindFirstChild("Value")
                if not OpenedVal then continue end
                local SameName = (Button.Name == Name)
                if SameName and not OpenedVal.Value then 
                    Tween(Button, .25, { BackgroundTransparency = 0.8, BackgroundColor3 = Theme.ActiveElement })
                    OpenedVal.Value = true
                elseif not SameName and OpenedVal.Value then 
                    Tween(Button, .25, { BackgroundTransparency = 1 })
                    OpenedVal.Value = false 
                end
            end
        end
        for Index, MainContainer in next, Holder:GetChildren() do
            if MainContainer:IsA("CanvasGroup") then
                local OpenedVal = MainContainer:FindFirstChild("Value")
                if not OpenedVal then continue end
                local SameName = (MainContainer.Name == Name)
                if SameName and not OpenedVal.Value then 
                    OpenedVal.Value = true
                    MainContainer.Visible = true
                    Tween(MainContainer, .3, { GroupTransparency = 0 })
                elseif not SameName and OpenedVal.Value then 
                    OpenedVal.Value = false
                    Tween(MainContainer, .15, { GroupTransparency = 1 })
                    task.delay(.15, function() MainContainer.Visible = false end) 
                end
            end
        end
    end

    function Options:AddTab(Settings)
        if not Examples["TabButtonExample"] or not Examples["MainExample"] then return end
        local Example, MainExample = Examples["TabButtonExample"], Examples["MainExample"]
        local MainContainer = Clone(MainExample)
        local TabBtn = Clone(Example)
        if not Settings.Icon then 
            if TabBtn:FindFirstChild("ICO") then Destroy(TabBtn["ICO"]) end 
        else 
            if TabBtn:FindFirstChild("ICO") then SetProperty(TabBtn["ICO"], { Image = Settings.Icon, ImageColor3 = Theme.ActiveElement }) end 
        end
        if TabBtn:FindFirstChild("TextLabel") then SetProperty(TabBtn["TextLabel"], { Text = Settings.Title, TextColor3 = Theme.Title }) end 
        SetProperty(MainContainer, { Parent = MainExample.Parent, Name = Settings.Title }) 
        SetProperty(TabBtn, { Parent = Example.Parent, Name = Settings.Title, Visible = true })
        TabBtn.MouseButton1Click:Connect(function() Options:SetTab(TabBtn.Name) end) 
        return MainContainer:FindFirstChild("ScrollingFrame") or MainContainer
    end
    
    function Options:AddSection(Settings) 
        if not Components or not Components:FindFirstChild("Section") then return end
        local Section = Clone(Components["Section"]) 
        SetProperty(Section, { Text = Settings.Name, Parent = Settings.Tab, Visible = true, TextColor3 = Theme.Outline }) 
    end

    function Options:AddButton(Settings)
        if not Components or not Components:FindFirstChild("Button") then return end
        local Button = Clone(Components["Button"])
        Button.BackgroundTransparency = 1
        if Button:FindFirstChild("Labels") then
            Button.Labels.Title.TextColor3 = Theme.Title
            Button.Labels.Description.TextColor3 = Theme.Description
            SetProperty(Button.Labels.Title, { Text = Settings.Title })
            if Settings.Description then
                SetProperty(Button.Labels.Description, { Text = Settings.Description })
            end
        end
        Button.MouseButton1Click:Connect(function() Settings.Callback() end)
        SetProperty(Button, { Name = Settings.Title, Parent = Settings.Tab, Visible = true })
    end
    
    function Options:AddToggle(Settings) 
        if not Components or not Components:FindFirstChild("Toggle") then return end
        local Toggle = Clone(Components["Toggle"])
        local On = Toggle:FindFirstChild("Value")
        local MainC = Toggle:FindFirstChild("Main")
        local Circle = MainC and MainC:FindFirstChild("Circle")
        Toggle.BackgroundTransparency = 1
        local Set = function(Value)
            if Value and MainC and Circle then 
                Tween(MainC, .2, { BackgroundColor3 = Theme.ActiveElement }) 
                Tween(Circle, .2, { BackgroundColor3 = Theme.Title, Position = UDim2.new(1, -16, 0.5, 0) })
            elseif MainC and Circle then 
                Tween(MainC, .2, { BackgroundColor3 = Theme.Interactables }) 
                Tween(Circle, .2, { BackgroundColor3 = Theme.Title, Position = UDim2.new(0, 3, 0.5, 0) }) 
            end
            if On then On.Value = Value end
        end 
        Toggle.MouseButton1Click:Connect(function() 
            local Value = not (On and On.Value or false)
            Set(Value)
            Settings.Callback(Value) 
        end)
        if Toggle:FindFirstChild("Labels") then
            Toggle.Labels.Title.TextColor3 = Theme.Title
            Toggle.Labels.Description.TextColor3 = Theme.Description
            SetProperty(Toggle.Labels.Title, { Text = Settings.Title })
            if Settings.Description then SetProperty(Toggle.Labels.Description, { Text = Settings.Description }) end
        end
        Set(Settings.Default)
        SetProperty(Toggle, { Name = Settings.Title, Parent = Settings.Tab, Visible = true })
    end

    function Options:AddSlider(Settings) 
        if not Components or not Components:FindFirstChild("Slider") then return end
        local Slider = Clone(Components["Slider"])
        local MainC = Slider:FindFirstChild("Slider") and Slider.Slider:FindFirstChild("Main")
        local Slide = Slider:FindFirstChild("Slider") and Slider.Slider:FindFirstChild("Slide")
        local Fill = Slide and Slide:FindFirstChild("Highlight")
        local Value = 0
        local Active = false
        Slider.BackgroundTransparency = 1
        if Fill then Fill.BackgroundColor3 = Theme.ActiveElement end
        if Slide then Slide.BackgroundColor3 = Theme.Interactables end
        local function Update(Number)
            if not Slide or not MainC then return end
            local Scale = math.clamp((Player.Mouse.X - Slide.AbsolutePosition.X) / Slide.AbsoluteSize.X, 0, 1)
            Value = math.floor((Number or (Scale * Settings.MaxValue)) + 0.5)
            MainC.Input.Text = tostring(Value)
            if Fill then Fill.Size = UDim2.fromScale(Value / Settings.MaxValue, 1) end
            Settings.Callback(Value)
        end
        if Slide and Slide:FindFirstChild("Fire") then
            Slide.Fire.MouseButton1Down:Connect(function() 
                Active = true
                repeat task.wait() Update() until not Active 
            end)
        end
        Services.Input.InputEnded:Connect(function(Input) 
            if Input.UserInputType == Enum.UserInputType.MouseButton1 then 
                Active = false 
            end 
        end)
        if Slider:FindFirstChild("Labels") then
            Slider.Labels.Title.TextColor3 = Theme.Title
            SetProperty(Slider.Labels.Title, { Text = Settings.Title })
        end
        SetProperty(Slider, { Parent = Settings.Tab, Visible = true })
    end

    function Options:AddDropdown(Settings)
        local DropdownFrame = Instance.new("Frame")
        DropdownFrame.Name = Settings.Title or "Dropdown"
        DropdownFrame.Size = UDim2.new(1, -20, 0, 40)
        DropdownFrame.BackgroundTransparency = 1
        DropdownFrame.Parent = Settings.Tab
        
        local MainC = Instance.new("TextButton")
        MainC.Name = "Main"
        MainC.Size = UDim2.new(1, 0, 0, 40)
        MainC.BackgroundColor3 = Theme.Interactables
        MainC.AutoButtonColor = false
        MainC.Text = ""
        MainC.Parent = DropdownFrame
        
        local Corner = Instance.new("UICorner", MainC)
        Corner.CornerRadius = UDim.new(0, 6)
        
        local Title = Instance.new("TextLabel", MainC)
        Title.Size = UDim2.new(1, -40, 1, 0)
        Title.Position = UDim2.new(0, 15, 0, 0)
        Title.BackgroundTransparency = 1
        Title.Text = Settings.Title or "Dropdown"
        Title.TextColor3 = Theme.Title
        Title.Font = Enum.Font.GothamBold
        Title.TextSize = 13
        Title.TextXAlignment = Enum.TextXAlignment.Left
        
        local SelectedText = Instance.new("TextLabel", MainC)
        SelectedText.Size = UDim2.new(0, 120, 1, 0)
        SelectedText.Position = UDim2.new(1, -150, 0, 0)
        SelectedText.BackgroundTransparency = 1
        SelectedText.Text = Settings.Default or "Select..."
        SelectedText.TextColor3 = Theme.Description
        SelectedText.Font = Enum.Font.Gotham
        SelectedText.TextSize = 12
        SelectedText.TextXAlignment = Enum.TextXAlignment.Right
        
        local Icon = Instance.new("ImageLabel", MainC)
        Icon.Size = UDim2.new(0, 20, 0, 20)
        Icon.Position = UDim2.new(1, -25, 0.5, -10)
        Icon.BackgroundTransparency = 1
        Icon.Image = "rbxassetid://6031090990" -- Arrow Down Icon
        Icon.ImageColor3 = Theme.Description
        
        local ListFrame = Instance.new("ScrollingFrame", DropdownFrame)
        ListFrame.Size = UDim2.new(1, 0, 0, 0)
        ListFrame.Position = UDim2.new(0, 0, 0, 45)
        ListFrame.BackgroundColor3 = Theme.Secondary
        ListFrame.BorderSizePixel = 0
        ListFrame.ScrollBarThickness = 2
        ListFrame.ScrollBarImageColor3 = Theme.Outline
        ListFrame.ClipsDescendants = true
        ListFrame.Visible = false
        
        local ListCorner = Instance.new("UICorner", ListFrame)
        ListCorner.CornerRadius = UDim.new(0, 6)
        
        local UIListLayout = Instance.new("UIListLayout", ListFrame)
        UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
        UIListLayout.Padding = UDim.new(0, 4)
        UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        
        local UIPadding = Instance.new("UIPadding", ListFrame)
        UIPadding.PaddingTop = UDim.new(0, 5)
        UIPadding.PaddingBottom = UDim.new(0, 5)
        
        local Opened = false
        local OptionCount = Settings.Options and #Settings.Options or 0
        local MaxHeight = math.clamp((OptionCount * 30) + 10, 0, 120)
        
        local function ToggleDropdown()
            Opened = not Opened
            if Opened then
                ListFrame.Visible = true
                Tween(DropdownFrame, 0.2, {Size = UDim2.new(1, -20, 0, 45 + MaxHeight)})
                Tween(ListFrame, 0.2, {Size = UDim2.new(1, 0, 0, MaxHeight)})
                Tween(Icon, 0.2, {Rotation = 180})
            else
                Tween(DropdownFrame, 0.2, {Size = UDim2.new(1, -20, 0, 40)})
                Tween(ListFrame, 0.2, {Size = UDim2.new(1, 0, 0, 0)})
                Tween(Icon, 0.2, {Rotation = 0})
                task.delay(0.2, function() if not Opened then ListFrame.Visible = false end end)
            end
        end
        
        MainC.MouseButton1Click:Connect(ToggleDropdown)
        
        local function AddOption(OptionName)
            local OptionBtn = Instance.new("TextButton", ListFrame)
            OptionBtn.Size = UDim2.new(1, -10, 0, 26)
            OptionBtn.BackgroundColor3 = Theme.Component
            OptionBtn.AutoButtonColor = false
            OptionBtn.Text = OptionName
            OptionBtn.TextColor3 = Theme.Title
            OptionBtn.Font = Enum.Font.Gotham
            OptionBtn.TextSize = 12
            
            local OptCorner = Instance.new("UICorner", OptionBtn)
            OptCorner.CornerRadius = UDim.new(0, 4)
            
            OptionBtn.MouseButton1Click:Connect(function()
                SelectedText.Text = OptionName
                ToggleDropdown()
                if Settings.Callback then Settings.Callback(OptionName) end
            end)
            
            OptionBtn.MouseEnter:Connect(function() Tween(OptionBtn, 0.15, {BackgroundColor3 = Theme.ActiveElement, TextColor3 = Color3.fromRGB(0,0,0)}) end)
            OptionBtn.MouseLeave:Connect(function() Tween(OptionBtn, 0.15, {BackgroundColor3 = Theme.Component, TextColor3 = Theme.Title}) end)
        end
        
        for _, Option in pairs(Settings.Options or {}) do AddOption(Option) end
        
        ListFrame.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y + 10)
        UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            ListFrame.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y + 10)
        end)
        
        return DropdownFrame
    end

    function Options:SetTheme()
        Window.BackgroundColor3 = Theme.Primary
        if Holder then Holder.BackgroundColor3 = Theme.Secondary end
        if Sidebar then Sidebar.BackgroundColor3 = Theme.Secondary end
        local Stroke = Window:FindFirstChildOfClass("UIStroke")
        if Stroke then 
            Stroke.Color = Theme.Outline 
        end
    end

    SetProperty(Window, { Size = Settings.Size or Setup.Size, Visible = true, Parent = Screen })
    Options:SetTheme()
    Animations:Open(Window, Settings.Transparency or Setup.Transparency)

    return Options
end

return Library