-- Create a ScreenGui if it doesn't exist
local screenGui = game.Players.LocalPlayer.PlayerGui:FindFirstChild("AimbotScreenGui")
if not screenGui then
    screenGui = Instance.new("ScreenGui")
    screenGui.Name = "AimbotScreenGui"
    screenGui.Parent = game.Players.LocalPlayer.PlayerGui
end

-- Create the button inside the ScreenGui
local aimbotToggleButton = Instance.new("ImageButton")  -- Changed to ImageButton for circular shape
aimbotToggleButton.Name = "AimbotToggleButton"
aimbotToggleButton.Image = "https://www.roblox.com/catalog/17670028832" -- Replace with the circular image ID
aimbotToggleButton.Size = UDim2.new(0, 50, 0, 50)  -- Adjust size for circular shape
aimbotToggleButton.Position = UDim2.new(0.5, -25, 0.9, -25)  -- Adjust position for circular shape
aimbotToggleButton.BackgroundColor3 = Color3.new(1, 1, 1) -- Set button color
aimbotToggleButton.BorderSizePixel = 0 -- Remove border
aimbotToggleButton.AutoButtonColor = false

-- Add text label to indicate aimbot state
local aimbotTextLabel = Instance.new("TextLabel")
aimbotTextLabel.Name = "AimbotText"
aimbotTextLabel.Size = UDim2.new(1, 0, 0, 20) -- Set text label size
aimbotTextLabel.Position = UDim2.new(0, 0, 1, 0) -- Position text label below button
aimbotTextLabel.BackgroundTransparency = 1 -- Make text label background transparent
aimbotTextLabel.TextColor3 = Color3.new(1, 1, 1) -- Set text color
aimbotTextLabel.Font = Enum.Font.SourceSans -- Set font
aimbotTextLabel.TextSize = 14 -- Set text size
aimbotTextLabel.Text = "Aimbot OFF" -- Initial text
aimbotTextLabel.Parent = aimbotToggleButton -- Parent text label to button

-- Parent button to ScreenGui
aimbotToggleButton.Parent = screenGui

-- Apply circular shape
local round = Instance.new("UICorner")
round.CornerRadius = UDim.new(1, 0)  -- Set to 1 for circular shape
round.Parent = aimbotToggleButton

-- Add black outline to the circle
local FOVring = Instance.new("Frame")
FOVring.Visible = false
FOVring.Size = UDim2.new(0, 120, 0, 120)
FOVring.Position = UDim2.new(0, -10, 0, -10)
FOVring.BackgroundColor3 = Color3.new(0, 0, 0)
FOVring.BorderSizePixel = 0
FOVring.BackgroundTransparency = 0.5
FOVring.Parent = aimbotToggleButton

-- Initialize aimbot state
local aimbotEnabled = false

-- Teams interface
local teamsInterface = Instance.new("Frame")
teamsInterface.Name = "TeamsInterface"
teamsInterface.Size = UDim2.new(0, 200, 0, 300)
teamsInterface.Position = UDim2.new(0.5, -100, 0.5, -150)
teamsInterface.BackgroundTransparency = 0.5
teamsInterface.BackgroundColor3 = Color3.fromRGB(50, 50, 50) -- Set background color to black or gray
teamsInterface.BorderSizePixel = 0
teamsInterface.Visible = false
teamsInterface.Parent = screenGui

-- Add "Ken Aimbot" text
local kenAimbotText = Instance.new("TextLabel")
kenAimbotText.Name = "KenAimbotText"
kenAimbotText.Size = UDim2.new(0, 100, 0, 20)
kenAimbotText.Position = UDim2.new(0, 0, 0, 0)
kenAimbotText.BackgroundColor3 = Color3.fromRGB(50, 50, 50) -- Set background color to black or gray
kenAimbotText.BorderSizePixel = 0
kenAimbotText.Text = "Ken Aimbot"
kenAimbotText.TextColor3 = Color3.new(1, 1, 1) -- Set text color to white
kenAimbotText.Parent = teamsInterface

-- Create a minimize button
local minimizeButton = Instance.new("TextButton")
minimizeButton.Name = "MinimizeButton"
minimizeButton.Size = UDim2.new(0, 50, 0, 20)
minimizeButton.Position = UDim2.new(1, -50, 0, 0)
minimizeButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50) -- Set background color to black or gray
minimizeButton.BorderSizePixel = 0
minimizeButton.Text = "-"
minimizeButton.Parent = teamsInterface

-- Dragging functionality for teams interface
local draggingTeams = false
local startPosTeams
local offsetTeams

teamsInterface.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        draggingTeams = true
        startPosTeams = input.Position - teamsInterface.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                draggingTeams = false
            end
        end)
    end
end)

teamsInterface.InputChanged:Connect(function(input)
    if draggingTeams and input.UserInputType == Enum.UserInputType.Touch then
        local newPosition = input.Position - startPosTeams
        teamsInterface.Position = UDim2.new(0, newPosition.X, 0, newPosition.Y)
    end
end)

-- Example teams list (replace with your own)
local teamsList = {} -- Initialize an empty table

-- Populate the teams list with the teams present in the game
for _, team in ipairs(game.Teams:GetChildren()) do
    table.insert(teamsList, team.Name)
end

-- Add "Non-Team Players" to the teams list
table.insert(teamsList, "Non-Team Players")

-- Create a scrolling frame for the team list
local teamsScrollingFrame = Instance.new("ScrollingFrame")
teamsScrollingFrame.Name = "TeamsScrollingFrame"
teamsScrollingFrame.Size = UDim2.new(1, 0, 1, -25)
teamsScrollingFrame.Position = UDim2.new(0, 0, 0, 25)
teamsScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, #teamsList * 25)
teamsScrollingFrame.Parent = teamsInterface

local teamCheckboxes = {}

for i, teamName in ipairs(teamsList) do
    local checkbox = Instance.new("TextButton")
    checkbox.Name = teamName
    checkbox.Size = UDim2.new(1, 0, 0, 20)
    checkbox.Position = UDim2.new(0, 0, 0, (i - 1) * 25)
    checkbox.BackgroundColor3 = Color3.new(1, 1, 1)
    checkbox.BorderSizePixel = 0
    checkbox.Text = teamName
    checkbox.Parent = teamsScrollingFrame

    -- Checkbox functionality
    checkbox.MouseButton1Click:Connect(function()
        teamCheckboxes[teamName] = not teamCheckboxes[teamName]
        if teamCheckboxes[teamName] then
            checkbox.TextColor3 = Color3.new(0, 1, 0) -- Change text color when checked
        else
            checkbox.TextColor3 = Color3.new(1, 0, 0) -- Change text color to red when unchecked
        end
    end)

    teamCheckboxes[teamName] = true -- Default to true for all teams
end

-- Function to toggle aimbot state
local function toggleAimbot()
    aimbotEnabled = not aimbotEnabled
    if aimbotEnabled then
        -- Show teams interface
        teamsInterface.Visible = true
        aimbotToggleButton.Image = "rbxassetid://17670028832"  -- Update to image when aimbot is ON
        aimbotTextLabel.Text = "Aimbot ON"  -- Update text to indicate aimbot is ON
        print("Aimbot enabled")
    else
        -- Hide teams interface
        teamsInterface.Visible = false
        aimbotToggleButton.Image = "rbxassetid://17670028832"  -- Update to image when aimbot is OFF
        aimbotTextLabel.Text = "Aimbot OFF"  -- Update text to indicate aimbot is OFF
        print("Aimbot disabled")
    end
end

-- Connect button click event to toggle aimbot
aimbotToggleButton.MouseButton1Click:Connect(toggleAimbot)

-- Connect minimize button event
minimizeButton.MouseButton1Click:Connect(function()
    teamsInterface.Visible = not teamsInterface.Visible
    minimizeButton.Text = teamsInterface.Visible and "-" or "+" -- Change text based on visibility
end)

-- Dragging functionality for toggle button
local dragging = false
local startPos
local offset

aimbotToggleButton.MouseButton1Down:Connect(function()
    if not dragging then
        dragging = true
        startPos = aimbotToggleButton.Position
        offset = startPos - UDim2.new(0, game.Players.LocalPlayer:GetMouse().X, 0, game.Players.LocalPlayer:GetMouse().Y)
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.Touch then
        aimbotToggleButton.Position = UDim2.new(0, input.Position.X, 0, input.Position.Y) + offset
    end
end)

game:GetService("UserInputService").InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

-- Aimbot logic (integrated)
local fov = 60
local maxTransparency = 0.1
local sensitivity = 0.3  -- Adjust the sensitivity for smoother aim on mobile
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Cam = game.Workspace.CurrentCamera

local function updateDrawings()
    local camViewportSize = Cam.ViewportSize
    FOVring.Position = UDim2.new(0.5, -60, 0.5, -60) -- Center the circle
end

local function lookAt(target)
    local headPosition = target + Vector3.new(0, -8, 0) -- Default head position
    local lookVector = (headPosition - Cam.CFrame.Position).unit
    local newCFrame = CFrame.new(Cam.CFrame.Position, headPosition) -- Look directly at the adjusted head position
    Cam.CFrame = newCFrame

    -- Calculate distance to target
    local distanceToTarget = (target - Cam.CFrame.Position).magnitude

    -- Adjust head position based on distance
    if distanceToTarget > 50 then
        headPosition = target + Vector3.new(0, -8 - (distanceToTarget - 50) * 0.03, 0) -- Lower head position for far away enemies
    elseif distanceToTarget > 5 then
        headPosition = target + Vector3.new(0, -4, 0) -- Default head position for medium distance enemies
    end
end

local function calculateTransparency(distance)
    local transparency = (1 - (distance / fov)) * maxTransparency
    return transparency
end

local function getClosestPlayerInFOV(trg_part)
    local nearest = nil
    local last = math.huge
    local playerMousePos = Cam.ViewportSize / 2
    local localPlayer = Players.LocalPlayer

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= localPlayer and (not player.Team or not localPlayer.Team or player.Team ~= localPlayer.Team) then
            local part = player.Character and player.Character:FindFirstChild(trg_part)
            if part then
                local ePos, isVisible = Cam:WorldToViewportPoint(part.Position)
                local distance = (Vector2.new(ePos.x, ePos.y) - playerMousePos).Magnitude

                -- Check if the player is visible and within the FOV
                if isVisible and distance < fov then
                    if distance < last then
                        last = distance
                        nearest = player
                    end
                end
            end
        end
    end

    -- Check if the player is on one of the checked teams
    if nearest and ((not nearest.Team and teamCheckboxes["Non-Team Players"]) or (nearest.Team and teamCheckboxes[nearest.Team.Name])) then
        -- Target only if the player is on a checked team or has no team
        return nearest
    else
        return nil
    end
end

RunService.RenderStepped:Connect(function()
    if aimbotEnabled then
        updateDrawings()
        local closest = getClosestPlayerInFOV("Head")
        if closest and closest.Character:FindFirstChild("Head") then
            lookAt(closest.Character.Head.Position)

            local ePos, isVisible = Cam:WorldToViewportPoint(closest.Character.Head.Position)
            local distance = (Vector2.new(ePos.x, ePos.y) - (Cam.ViewportSize / 2)).Magnitude
            FOVring.BackgroundTransparency = calculateTransparency(distance)
        else
            FOVring.BackgroundTransparency = 0.1
        end
    end
end)
