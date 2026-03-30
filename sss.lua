local GetService = game.GetService
local Players = GetService(game, "Players")
local RunService = GetService(game, "RunService")
local UserInputService = GetService(game, "UserInputService")
local InsertService = GetService(game, "InsertService")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

--// LOAD ASSET
local Success, Screen = pcall(function()
    -- Menggunakan ID Asset terbaru kamu
    return InsertService:LoadLocalAsset("rbxassetid://121532429088360")
end)

if not Success or not Screen then
    warn("Gagal memuat Asset UI. Pastikan ID sudah Public!")
    return
end

--// UI SETUP
Screen.Main.Visible = false
xpcall(function() Screen.Parent = game:GetService("CoreGui") end, function() Screen.Parent = LocalPlayer.PlayerGui end)

local Library = {}
local Components = Screen:WaitForChild("Components")

function Library:CreateWindow(Settings)
    local Window = Screen.Main:Clone()
    Window.Parent = Screen
    Window.Visible = true
    
    -- Judul RGB Otomatis
    local Title = Window:FindFirstChild("Title", true)
    if Title then
        Title.RichText = true
        task.spawn(function()
            while task.wait() do
                local Color = Color3.fromHSV(tick() % 5 / 5, 1, 1)
                Title.Text = string.format('<font color="rgb(%d,%d,%d)">Zero Traces</font> | %s', Color.R*255, Color.G*255, Color.B*255, Settings.GameName or "MM2")
            end
        end)
    end

    local Options = {}
    
    function Options:AddTab(Name)
        local Page = Components.MainExample:Clone()
        Page.Name = Name
        Page.Parent = Window.Main
        Page.Visible = false
        
        -- Tombol Tab di Sidebar
        local TabBtn = Components.TabButtonExample:Clone()
        TabBtn.Parent = Window.Sidebar.Tab
        TabBtn.TextLabel.Text = Name
        TabBtn.Visible = true
        
        TabBtn.MouseButton1Click:Connect(function()
            for _, v in pairs(Window.Main:GetChildren()) do v.Visible = false end
            Page.Visible = true
        end)
        
        return Page.ScrollingFrame
    end

    function Options:AddToggle(Settings)
        local Toggle = Components.Toggle:Clone()
        Toggle.Parent = Settings.Tab
        Toggle.Labels.Title.Text = Settings.Title
        Toggle.Visible = true
        
        local On = false
        Toggle.MouseButton1Click:Connect(function()
            On = not On
            Toggle.Main.BackgroundColor3 = On and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(40, 40, 40)
            Toggle.Main.Circle:TweenPosition(On and UDim2.new(1, -18, 0.5, 0) or UDim2.new(0, 2, 0.5, 0), "Out", "Quint", 0.2)
            Settings.Callback(On)
        end)
    end

    function Options:AddSlider(Settings)
        local Slider = Components.Slider:Clone()
        Slider.Parent = Settings.Tab
        Slider.Labels.Title.Text = Settings.Title
        Slider.Visible = true
        
        Slider.Slider.Slide.Fire.MouseButton1Down:Connect(function()
            local Connection
            Connection = RunService.RenderStepped:Connect(function()
                local MousePos = UserInputService:GetMouseLocation().X
                local RelativePos = MousePos - Slider.Slider.Slide.AbsolutePosition.X
                local Percentage = math.clamp(RelativePos / Slider.Slider.Slide.AbsoluteSize.X, 0, 1)
                Slider.Slider.Slide.Highlight.Size = UDim2.fromScale(Percentage, 1)
                local Value = math.floor(Percentage * Settings.MaxValue)
                Slider.Slider.Main.Input.Text = tostring(Value)
                Settings.Callback(Value)
            end)
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then Connection:Disconnect() end
            end)
        end)
    end

    return Options
end

--// PENTING: MENGEMBALIKAN LIBRARY KE LOADSTRING
return Library
