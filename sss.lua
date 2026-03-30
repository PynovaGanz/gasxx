local GetService = game.GetService
local Clone = game.Clone 
local Destroy = game.Destroy 

if (not game:IsLoaded()) then
    game.Loaded:Wait()
end

local Setup = {
    Version = "1.0.0",
    GameName = "Game",
    Keybind = Enum.KeyCode.RightControl,
    Transparency = 0.05,
    ThemeMode = "Dark",
    Size = UDim2.new(0, 600, 0, 360),
}

local Theme = {
    Primary = Color3.fromRGB(15, 15, 15),       
    Secondary = Color3.fromRGB(22, 22, 22),     
    Component = Color3.fromRGB(30, 30, 30),   
    Interactables = Color3.fromRGB(40, 40, 40),
    Tab = Color3.fromRGB(200, 200, 200),
    Title = Color3.fromRGB(255, 255, 255),      
    Description = Color3.fromRGB(150, 150, 150),
    Shadow = Color3.fromRGB(255, 0, 0),         
    Outline = Color3.fromRGB(200, 0, 0),        
    ActiveElement = Color3.fromRGB(255, 0, 0), 
}

local Type = nil
local LocalPlayer = GetService(game, "Players").LocalPlayer;
local Services = {
    Insert = GetService(game, "InsertService");
    Tween = GetService(game, "TweenService");
    Input = GetService(game, "UserInputService");
}

local Player = { Mouse = LocalPlayer:GetMouse(); GUI = LocalPlayer.PlayerGui; }

local Tween = function(Object, Speed, Properties, Info)
    local Style = Info and Info["EasingStyle"] or Enum.EasingStyle.Quint
    local Direction = Info and Info["EasingDirection"] or Enum.EasingDirection.Out
    return Services.Tween:Create(Object, TweenInfo.new(Speed, Style, Direction), Properties):Play()
end

local SetProperty = function(Object, Properties)
    for Index, Property in next, Properties do Object[Index] = Property end return Object
end

local Drag = function(Canvas)
    if Canvas then
        local Dragging, DragInput, Start, StartPosition
        local function Update(input)
            local delta = input.Position - Start
            Canvas.Position = UDim2.new(StartPosition.X.Scale, StartPosition.X.Offset + delta.X, StartPosition.Y.Scale, StartPosition.Y.Offset + delta.Y)
        end
        Canvas.InputBegan:Connect(function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch and not Type then
                Dragging = true; Start = Input.Position; StartPosition = Canvas.Position
                Input.Changed:Connect(function() if Input.UserInputState == Enum.UserInputState.End then Dragging = false end end)
            end
        end)
        Canvas.InputChanged:Connect(function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch and not Type then DragInput = Input end
        end)
        Services.Input.InputChanged:Connect(function(Input)
            if Input == DragInput and Dragging and not Type then Update(Input) end
        end)
    end
end

if (identifyexecutor) then
    Screen = Services.Insert:LoadLocalAsset("rbxassetid://121532429088360")
else
    Screen = script.Parent
end

Screen.Main.Visible = false
xpcall(function() Screen.Parent = game.CoreGui end, function() Screen.Parent = Player.GUI end)

local Animations = {}
local Components = Screen:FindFirstChild("Components")
local Library = {}
local StoredInfo = { ["Sections"] = {}; ["Tabs"] = {} }

function Animations:Open(Window, Transparency)
    local Shadow = Window:FindFirstChildOfClass("UIStroke")
    SetProperty(Window, { GroupTransparency = 1, Visible = true })
    if Shadow then Shadow.Transparency = 1; Tween(Shadow, 0.4, { Transparency = 0, Thickness = 1.5 }) end
    Tween(Window, 0.4, { GroupTransparency = Transparency or 0 })
end

function Animations:Close(Window)
    local Shadow = Window:FindFirstChildOfClass("UIStroke")
    if Shadow then Tween(Shadow, 0.3, { Transparency = 1 }) end
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
    LoadBG.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    LoadBG.BorderSizePixel = 0
    
    local ZTLogo = Instance.new("TextLabel", LoadBG)
    ZTLogo.Size = UDim2.new(1, 0, 1, -40)
    ZTLogo.BackgroundTransparency = 1
    ZTLogo.Text = "ZT"
    ZTLogo.Font = Enum.Font.GothamBlack
    ZTLogo.TextSize = 80
    ZTLogo.TextColor3 = Theme.Shadow
    
    local ZTText = Instance.new("TextLabel", LoadBG)
    ZTText.Size = UDim2.new(1, 0, 1, 60)
    ZTText.BackgroundTransparency = 1
    ZTText.Text = "ZERO TRACES"
    ZTText.Font = Enum.Font.GothamBold
    ZTText.TextSize = 20
    ZTText.TextColor3 = Color3.fromRGB(255, 255, 255)
    ZTText.TextTransparency = 1

    Tween(ZTLogo, 1, {TextSize = 90})
    Tween(ZTText, 1, {TextTransparency = 0})
    task.wait(1.5)
    Tween(LoadBG, 0.5, {BackgroundTransparency = 1})
    Tween(ZTLogo, 0.5, {TextTransparency = 1})
    Tween(ZTText, 0.5, {TextTransparency = 1})
    task.wait(0.5)
    LoadGui:Destroy()

    local Window = Clone(Screen:WaitForChild("Main"));
    local Sidebar = Window:FindFirstChild("Sidebar");
    local Holder = Window:FindFirstChild("Main");
    local Tab = Sidebar:FindFirstChild("Tab");

    if Sidebar.Top:FindFirstChild("Title") and Sidebar.Top.Title:IsA("TextLabel") then
        Sidebar.Top.Title.RichText = true
        Sidebar.Top.Title.Text = "Zero Traces HUB <font color='#FF0000'>|</font> " .. Setup.GameName .. " <font color='#aaaaaa'>v" .. Setup.Version .. "</font>"
        Sidebar.Top.Title.TextColor3 = Theme.Title
        Sidebar.Top.Title.Font = Enum.Font.GothamBlack
        Sidebar.Top.Title.TextSize = 14
        Sidebar.Top.Title.TextXAlignment = Enum.TextXAlignment.Left
        Sidebar.Top.Title.Position = UDim2.new(0, 15, 0, 0)
    end
    if Sidebar.Top:FindFirstChild("Buttons") then Sidebar.Top.Buttons:Destroy() end

    local Options = {}; local Examples = {}; local Opened = true;
    for Index, Example in next, Window:GetDescendants() do if Example.Name:find("Example") and not Examples[Example.Name] then Examples[Example.Name] = Example end end

    Drag(Window);
    Setup.Size = Settings.Size or Setup.Size
    Setup.Keybind = Settings.MinimizeKeybind or Setup.Keybind

    local Close = function()
        if Opened then Opened = false; Animations:Close(Window); 
        else Animations:Open(Window, Setup.Transparency); Opened = true; end
    end

    local ToggleBtn = Instance.new("ImageButton", Screen.Parent)
    ToggleBtn.Name = "ZTToggle"
    ToggleBtn.Size = UDim2.new(0, 50, 0, 50)
    ToggleBtn.Position = UDim2.new(0, 20, 0, 20)
    ToggleBtn.BackgroundTransparency = 1
    ToggleBtn.Image = "rbxassetid://120980344725307"
    ToggleBtn.ZIndex = 10
    
    local ToggleStroke = Instance.new("UIStroke", ToggleBtn)
    ToggleStroke.Color = Theme.Shadow
    ToggleStroke.Thickness = 2
    
    local UICorner = Instance.new("UICorner", ToggleBtn)
    UICorner.CornerRadius = UDim.new(1, 0)

    Drag(ToggleBtn)
    ToggleBtn.MouseButton1Click:Connect(function() Close() end)

    Services.Input.InputBegan:Connect(function(Input, Focused) if (Input == Setup.Keybind or Input.KeyCode == Setup.Keybind) and not Focused then Close() end end)

    function Options:SetTab(Name)
        for Index, Button in next, Tab:GetChildren() do
            if Button:IsA("TextButton") then
                local Opened = Button.Value; local SameName = (Button.Name == Name);
                if SameName and not Opened.Value then 
                    Tween(Button, .25, { BackgroundTransparency = 0.8 }); Opened.Value = true;
                elseif not SameName and Opened.Value then 
                    Tween(Button, .25, { BackgroundTransparency = 1 }); Opened.Value = false; 
                end
            end
        end
        for Index, Main in next, Holder:GetChildren() do
            if Main:IsA("CanvasGroup") then
                local Opened = Main.Value; local SameName = (Main.Name == Name);
                if SameName and not Opened.Value then Opened.Value = true; Main.Visible = true; Tween(Main, .3, { GroupTransparency = 0 });
                elseif not SameName and Opened.Value then Opened.Value = false; Tween(Main, .15, { GroupTransparency = 1 }); task.delay(.15, function() Main.Visible = false end) end
            end
        end
    end

    function Options:AddTab(Settings)
        local Example, MainExample = Examples["TabButtonExample"], Examples["MainExample"];
        local Main = Clone(MainExample); local TabBtn = Clone(Example);
        if not Settings.Icon then Destroy(TabBtn["ICO"]); else SetProperty(TabBtn["ICO"], { Image = Settings.Icon }); end
        SetProperty(TabBtn["TextLabel"], { Text = Settings.Title, TextColor3 = Theme.Title }); 
        SetProperty(Main, { Parent = MainExample.Parent, Name = Settings.Title; }); 
        SetProperty(TabBtn, { Parent = Example.Parent, Name = Settings.Title; Visible = true; });
        TabBtn.MouseButton1Click:Connect(function() Options:SetTab(TabBtn.Name); end); 
        return Main.ScrollingFrame
    end
    
    function Options:AddSection(Settings) 
        local Section = Clone(Components["Section"]); 
        SetProperty(Section, { Text = Settings.Name, Parent = Settings.Tab, Visible = true, TextColor3 = Theme.Title }) 
    end

    function Options:AddButton(Settings)
        local Button = Clone(Components["Button"])
        if Button then
            Button.BackgroundTransparency = 1
            Button.Labels.Title.TextColor3 = Theme.Title
            Button.Labels.Description.TextColor3 = Theme.Description
            SetProperty(Button.Labels.Title, { Text = Settings.Title })
            if Settings.Description then
                SetProperty(Button.Labels.Description, { Text = Settings.Description })
            end
            Button.MouseButton1Click:Connect(function() Settings.Callback() end)
            SetProperty(Button, { Name = Settings.Title, Parent = Settings.Tab, Visible = true })
        end
    end
    
    function Options:AddToggle(Settings) 
        local Toggle = Clone(Components["Toggle"]); local On = Toggle["Value"]; local Main = Toggle["Main"]; local Circle = Main["Circle"];
        Toggle.BackgroundTransparency = 1
        local Set = function(Value)
            if Value then 
                Tween(Main, .2, { BackgroundColor3 = Theme.ActiveElement }); 
                Tween(Circle, .2, { BackgroundColor3 = Theme.Title, Position = UDim2.new(1, -16, 0.5, 0) });
            else 
                Tween(Main, .2, { BackgroundColor3 = Theme.Interactables }); 
                Tween(Circle, .2, { BackgroundColor3 = Theme.Title, Position = UDim2.new(0, 3, 0.5, 0) }); 
            end
            On.Value = Value
        end 
        Toggle.MouseButton1Click:Connect(function() local Value = not On.Value; Set(Value); Settings.Callback(Value) end)
        Toggle.Labels.Title.TextColor3 = Theme.Title
        Toggle.Labels.Description.TextColor3 = Theme.Description
        Set(Settings.Default); SetProperty(Toggle.Labels.Title, { Text = Settings.Title }); SetProperty(Toggle.Labels.Description, { Text = Settings.Description }); SetProperty(Toggle, { Name = Settings.Title, Parent = Settings.Tab, Visible = true, })
    end

    function Options:AddSlider(Settings) 
        local Slider = Clone(Components["Slider"]); local Main = Slider["Slider"]["Main"]; local Slide = Slider["Slider"]["Slide"]; local Fill = Slide["Highlight"]; local Value = 0; local Active = false
        Slider.BackgroundTransparency = 1
        Fill.BackgroundColor3 = Theme.ActiveElement 
        Slide.BackgroundColor3 = Theme.Interactables
        local function Update(Number)
            local Scale = math.clamp((Player.Mouse.X - Slide.AbsolutePosition.X) / Slide.AbsoluteSize.X, 0, 1)
            Value = math.floor((Number or (Scale * Settings.MaxValue)) + 0.5)
            Main.Input.Text = tostring(Value); Fill.Size = UDim2.fromScale(Value / Settings.MaxValue, 1); Settings.Callback(Value)
        end
        Slide.Fire.MouseButton1Down:Connect(function() Active = true; repeat task.wait(); Update() until not Active end)
        Services.Input.InputEnded:Connect(function(Input) if Input.UserInputType == Enum.UserInputType.MouseButton1 then Active = false end end)
        Slider.Labels.Title.TextColor3 = Theme.Title
        SetProperty(Slider.Labels.Title, { Text = Settings.Title }); SetProperty(Slider, { Parent = Settings.Tab, Visible = true, })
    end

    function Options:AddDropdown(Settings)
        local DropdownFuncs = {}
        local Dropdown = Instance.new("Frame")
        Dropdown.Name = Settings.Title
        Dropdown.Parent = Settings.Tab
        Dropdown.BackgroundTransparency = 1
        Dropdown.Size = UDim2.new(1, 0, 0, 65)
        Dropdown.Visible = true
        local Title = Instance.new("TextLabel", Dropdown)
        Title.Size = UDim2.new(1, -20, 0, 20)
        Title.Position = UDim2.new(0, 10, 0, 5)
        Title.BackgroundTransparency = 1
        Title.Text = Settings.Title
        Title.TextColor3 = Theme.Title
        Title.Font = Enum.Font.GothamBold
        Title.TextSize = 14
        Title.TextXAlignment = Enum.TextXAlignment.Left
        local MainBtn = Instance.new("TextButton", Dropdown)
        MainBtn.Size = UDim2.new(1, -20, 0, 30)
        MainBtn.Position = UDim2.new(0, 10, 0, 30)
        MainBtn.BackgroundColor3 = Theme.Interactables
        MainBtn.Text = Settings.Default or "Select Option"
        MainBtn.TextColor3 = Theme.Title
        MainBtn.Font = Enum.Font.Gotham
        MainBtn.TextSize = 14
        local UICorner = Instance.new("UICorner", MainBtn)
        UICorner.CornerRadius = UDim.new(0, 6)
        local Container = Instance.new("Frame", Dropdown)
        Container.Size = UDim2.new(1, -20, 0, 0)
        Container.Position = UDim2.new(0, 10, 0, 65)
        Container.BackgroundColor3 = Theme.Component
        Container.ClipsDescendants = true
        local UICorner2 = Instance.new("UICorner", Container)
        UICorner2.CornerRadius = UDim.new(0, 6)
        local UIList = Instance.new("UIListLayout", Container)
        UIList.SortOrder = Enum.SortOrder.LayoutOrder
        local IsOpen = false
        local CurrentOptions = Settings.Options
        MainBtn.MouseButton1Click:Connect(function()
            IsOpen = not IsOpen
            local ListHeight = #CurrentOptions * 30
            if IsOpen then
                Tween(Dropdown, 0.2, {Size = UDim2.new(1, 0, 0, 65 + ListHeight)})
                Tween(Container, 0.2, {Size = UDim2.new(1, -20, 0, ListHeight)})
            else
                Tween(Dropdown, 0.2, {Size = UDim2.new(1, 0, 0, 65)})
                Tween(Container, 0.2, {Size = UDim2.new(1, -20, 0, 0)})
            end
        end)
        function DropdownFuncs:Refresh(NewOptions)
            CurrentOptions = NewOptions or {}
            for _, child in pairs(Container:GetChildren()) do
                if child:IsA("TextButton") then
                    child:Destroy()
                end
            end
            for _, Opt in pairs(CurrentOptions) do
                local OptBtn = Instance.new("TextButton", Container)
                OptBtn.Size = UDim2.new(1, 0, 0, 30)
                OptBtn.BackgroundTransparency = 1
                OptBtn.Text = "  " .. Opt
                OptBtn.TextColor3 = Theme.Description
                OptBtn.Font = Enum.Font.Gotham
                OptBtn.TextSize = 14
                OptBtn.TextXAlignment = Enum.TextXAlignment.Left
                OptBtn.MouseEnter:Connect(function() Tween(OptBtn, 0.2, {TextColor3 = Theme.ActiveElement}) end)
                OptBtn.MouseLeave:Connect(function() Tween(OptBtn, 0.2, {TextColor3 = Theme.Description}) end)
                OptBtn.MouseButton1Click:Connect(function()
                    MainBtn.Text = Opt
                    Settings.Callback(Opt)
                    IsOpen = false
                    Tween(Dropdown, 0.2, {Size = UDim2.new(1, 0, 0, 65)})
                    Tween(Container, 0.2, {Size = UDim2.new(1, -20, 0, 0)})
                end)
            end
            if IsOpen then
                IsOpen = false
                Tween(Dropdown, 0.2, {Size = UDim2.new(1, 0, 0, 65)})
                Tween(Container, 0.2, {Size = UDim2.new(1, -20, 0, 0)})
            end
        end
        DropdownFuncs:Refresh(CurrentOptions)
        return DropdownFuncs
    end

    function Options:SetTheme()
        Window.BackgroundColor3 = Theme.Primary
        Holder.BackgroundColor3 = Theme.Secondary
        Sidebar.BackgroundColor3 = Theme.Secondary
        if Window:FindFirstChildOfClass("UIStroke") then Window.UIStroke.Color = Theme.Outline end
    end

    SetProperty(Window, { Size = Settings.Size or Setup.Size, Visible = true, Parent = Screen });
    Options:SetTheme()
    Animations:Open(Window, Settings.Transparency or Setup.Transparency)

    return Options
end

return Library
