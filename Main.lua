local GUILibrary = {}
GUILibrary.__index = GUILibrary

-- Fonction pour créer un GUI (ScreenGui)
function GUILibrary:CreateGUI(guiName)
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = guiName or "CustomGUI"
    screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    return screenGui
end

-- Fonction pour créer un cadre (Frame)
function GUILibrary:CreateFrame(parent, size, position, bgColor)
    local frame = Instance.new("Frame")
    frame.Size = size or UDim2.new(0, 300, 0, 200)
    frame.Position = position or UDim2.new(0.5, -150, 0.5, -100)
    frame.BackgroundColor3 = bgColor or Color3.fromRGB(40, 40, 40)
    frame.Parent = parent
    return frame
end

-- Fonction pour arrondir les coins d'un élément
function GUILibrary:ApplyCorners(instance, cornerRadius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, cornerRadius or 12)
    corner.Parent = instance
end

-- Fonction pour créer un bouton (TextButton)
function GUILibrary:CreateButton(parent, text, size, position, bgColor, textColor)
    local button = Instance.new("TextButton")
    button.Size = size or UDim2.new(0, 100, 0, 50)
    button.Position = position or UDim2.new(0.5, -50, 0.5, -25)
    button.BackgroundColor3 = bgColor or Color3.fromRGB(0, 170, 255)
    button.Text = text or "Button"
    button.TextColor3 = textColor or Color3.fromRGB(255, 255, 255)
    button.Font = Enum.Font.GothamBold
    button.TextSize = 14
    button.Parent = parent
    return button
end

-- Fonction pour créer un label (TextLabel)
function GUILibrary:CreateLabel(parent, text, size, position, textColor)
    local label = Instance.new("TextLabel")
    label.Size = size or UDim2.new(0, 200, 0, 50)
    label.Position = position or UDim2.new(0.5, -100, 0.5, -25)
    label.BackgroundTransparency = 1
    label.Text = text or "Label"
    label.TextColor3 = textColor or Color3.fromRGB(255, 255, 255)
    label.Font = Enum.Font.Gotham
    label.TextSize = 14
    label.Parent = parent
    return label
end

-- Fonction pour ajouter des animations à un élément (Tween)
function GUILibrary:TweenObject(instance, targetPosition, duration)
    instance:TweenPosition(targetPosition, Enum.EasingDirection.Out, Enum.EasingStyle.Quad, duration or 0.5, true)
end

return GUILibrary
