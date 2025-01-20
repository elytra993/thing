local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

-- Variables
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local MinimizeButton = Instance.new("TextButton")
local TabsFrame = Instance.new("Frame")
local TabButtonTemplate = Instance.new("TextButton")
local ContentFrame = Instance.new("Frame")
local Gradient = Instance.new("UIGradient")

-- ScreenGui Properties
ScreenGui.Name = "FuturisticScriptHub"
ScreenGui.Parent = game.CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- MainFrame Properties
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.BackgroundTransparency = 0.2
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.3, 0, 0.2, 0)
MainFrame.Size = UDim2.new(0, 500, 0, 350)
MainFrame.Active = true
MainFrame.Draggable = true

-- Title Properties
Title.Name = "Title"
Title.Parent = MainFrame
Title.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Title.BackgroundTransparency = 0.7
Title.BorderSizePixel = 0
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Font = Enum.Font.GothamBold
Title.Text = "Futuristic Script Hub"
Title.TextColor3 = Color3.fromRGB(200, 150, 255) -- Light purple
Title.TextSize = 20

-- Gradient Effect for Title
Gradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(200, 150, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(180, 100, 255))
}
Gradient.Parent = Title

-- MinimizeButton Properties
MinimizeButton.Name = "MinimizeButton"
MinimizeButton.Parent = Title
MinimizeButton.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
MinimizeButton.Position = UDim2.new(1, -40, 0, 5)
MinimizeButton.Size = UDim2.new(0, 30, 0, 30)
MinimizeButton.Font = Enum.Font.GothamBold
MinimizeButton.Text = "-"
MinimizeButton.TextColor3 = Color3.fromRGB(200, 150, 255) -- Light purple
MinimizeButton.TextSize = 20

-- TabsFrame Properties (Adjust to stack vertically)
TabsFrame.Name = "TabsFrame"
TabsFrame.Parent = MainFrame
TabsFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
TabsFrame.BackgroundTransparency = 0.4
TabsFrame.BorderSizePixel = 0
TabsFrame.Position = UDim2.new(0, 0, 0, 40)
TabsFrame.Size = UDim2.new(0, 120, 1, -40)  -- Keep width fixed, stretch vertically

-- TabButtonTemplate Properties (Adjust for vertical stacking)
TabButtonTemplate.Name = "TabButton"
TabButtonTemplate.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
TabButtonTemplate.BackgroundTransparency = 0.4
TabButtonTemplate.Size = UDim2.new(0, 120, 0, 40)
TabButtonTemplate.Font = Enum.Font.Gotham
TabButtonTemplate.Text = "Tab"
TabButtonTemplate.TextColor3 = Color3.fromRGB(200, 150, 255) -- Light purple
TabButtonTemplate.TextSize = 14

-- ContentFrame Properties
ContentFrame.Name = "ContentFrame"
ContentFrame.Parent = MainFrame
ContentFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
ContentFrame.BackgroundTransparency = 0.2
ContentFrame.BorderSizePixel = 0
ContentFrame.Position = UDim2.new(0, 120, 0, 40)
ContentFrame.Size = UDim2.new(1, -120, 1, -40)

-- Create the tab and content
local activeTab = nil  -- Track the currently active tab
local activeUnderline = nil  -- Track the current underline

local function CreateTab(tabName, contentText)
    local TabButton = TabButtonTemplate:Clone()
    TabButton.Parent = TabsFrame
    TabButton.Text = tabName

    -- Position the buttons vertically by changing the Y position
    local totalTabHeight = #TabsFrame:GetChildren() * 40  -- 40 is the height of each tab button
    TabButton.Position = UDim2.new(0, 0, 0, totalTabHeight)

    -- Create content for the tab
    local Content = Instance.new("TextLabel")
    Content.Parent = ContentFrame
    Content.Name = tabName  -- Give it a name so we can reference it
    Content.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Content.BackgroundTransparency = 0.4
    Content.BorderSizePixel = 0
    Content.Size = UDim2.new(1, 0, 1, 0)
    Content.Visible = false  -- Hide initially
    Content.Font = Enum.Font.Gotham
    Content.Text = contentText
    Content.TextColor3 = Color3.fromRGB(200, 150, 255) -- Light purple
    Content.TextSize = 16

    -- Define the click animation using TweenService
    local function animateTabClick(button)
        local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tweenGoal = {Size = UDim2.new(0, 130, 0, 45)} -- Slightly enlarge the button
        local tween = TweenService:Create(button, tweenInfo, tweenGoal)
        tween:Play()

        -- Reset to original size after animation
        tween.Completed:Connect(function()
            local resetTweenGoal = {Size = UDim2.new(0, 120, 0, 40)}
            local resetTween = TweenService:Create(button, tweenInfo, resetTweenGoal)
            resetTween:Play()
        end)
    end

    -- Remove the old underline if exists
    local function removeOldUnderline()
        if activeUnderline then
            activeUnderline:Destroy()
        end
    end

    -- Create underline animation for the active tab
    local function createUnderline(tabButton)
        removeOldUnderline()  -- Remove old underline before creating a new one

        activeUnderline = Instance.new("Frame")
        activeUnderline.Size = UDim2.new(0, 0, 0, 2) -- Start with width 0
        activeUnderline.BackgroundColor3 = Color3.fromRGB(200, 150, 255) -- Light purple
        activeUnderline.Position = UDim2.new(0, 0, 1, 0) -- At the bottom of the tab
        activeUnderline.Parent = tabButton

        -- Animate underline from left to right
        local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Bounce, Enum.EasingDirection.Out)
        local tweenGoal = {Size = UDim2.new(1, 0, 0, 3)} -- Animate width to 100% and increase height
        local tween = TweenService:Create(activeUnderline, tweenInfo, tweenGoal)
        tween:Play()
    end

    -- Change color when the tab is clicked
    local function changeTabColor(button)
        local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tweenGoal = {BackgroundColor3 = Color3.fromRGB(50, 50, 50)} -- Darken the button when selected
        local tween = TweenService:Create(button, tweenInfo, tweenGoal)
        tween:Play()

        -- Reset color when tab is deselected
        tween.Completed:Connect(function()
            local resetTweenGoal = {BackgroundColor3 = Color3.fromRGB(20, 20, 20)} -- Original color
            local resetTween = TweenService:Create(button, tweenInfo, resetTweenGoal)
            resetTween:Play()
        end)
    end

    -- Show content when tab is clicked
    TabButton.MouseButton1Click:Connect(function()
        -- Animate the tab button click
        animateTabClick(TabButton)

        -- Change color to show the active tab
        changeTabColor(TabButton)

        -- Create and animate the underline for the active tab
        createUnderline(TabButton)

        -- Hide all content
        for _, v in pairs(ContentFrame:GetChildren()) do
            v.Visible = false
        end
        -- Show the selected tab's content
        Content.Visible = true

        -- Update the active tab
        activeTab = TabButton
    end)
end

-- Minimize Functionality (using Right Shift keybind)
local isMinimized = false

-- Function to toggle visibility when Right Shift is pressed
local function onKeyPress(input)
    if input.UserInputType == Enum.UserInputType.Keyboard then
        if input.KeyCode == Enum.KeyCode.RightShift then
            isMinimized = not isMinimized
            MainFrame.Visible = not isMinimized
        end
    end
end

-- Connect the key press event
UserInputService.InputBegan:Connect(onKeyPress)

-- Minimize Button functionality (for mouse click)
MinimizeButton.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    MainFrame.Visible = not isMinimized
end)

-- Adding Tabs
CreateTab("Home", "Welcome to the Futuristic Script Hub!")
CreateTab("Features", "Feature list goes here.")
CreateTab("Settings", "Customize your hub here.")
CreateTab("Credits", "Script created by:\nDatabasesVoid\nContributors: None yet.")

-- Default Visibility for the first tab
ContentFrame:FindFirstChild("Home").Visible = true
