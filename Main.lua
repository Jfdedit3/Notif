local NotificationLibrary = {}
NotificationLibrary.__index = NotificationLibrary

-- Fonction pour créer une nouvelle notification
function NotificationLibrary:NewNotification(title, message, duration)
    -- Créer le GUI
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "NotificationGui"
    screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

    -- Cadre de la notification
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 300, 0, 100)
    frame.Position = UDim2.new(0.5, -150, 0, -120) -- Apparition hors écran
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    frame.Parent = screenGui

    -- Arrondir les coins
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = frame

    -- Titre
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, 0, 0, 40)
    titleLabel.Position = UDim2.new(0, 0, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 20
    titleLabel.Parent = frame

    -- Message
    local messageLabel = Instance.new("TextLabel")
    messageLabel.Size = UDim2.new(1, 0, 0, 60)
    messageLabel.Position = UDim2.new(0, 0, 0, 40)
    messageLabel.BackgroundTransparency = 1
    messageLabel.Text = message
    messageLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    messageLabel.Font = Enum.Font.Gotham
    messageLabel.TextSize = 16
    messageLabel.Parent = frame

    -- Animation d'entrée (Tween)
    frame:TweenPosition(UDim2.new(0.5, -150, 0, 50), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.5, true)

    -- Fermeture après la durée spécifiée
    wait(duration)

    -- Animation de disparition
    frame:TweenPosition(UDim2.new(0.5, -150, 0, -120), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.5, true, function()
        screenGui:Destroy() -- Supprime la notification après la disparition
    end)
end

return NotificationLibrary
