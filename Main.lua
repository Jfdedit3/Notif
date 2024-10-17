local NotificationLibrary = {}
NotificationLibrary.__index = NotificationLibrary

-- Fonction pour afficher une notification
function NotificationLibrary:NewNotification(title, text, duration)
    local gui = Instance.new("ScreenGui")
    gui.Name = "NotificationGUI"
    gui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

    -- Cadre de notification
    local notificationFrame = Instance.new("Frame")
    notificationFrame.Size = UDim2.new(0, 300, 0, 100)
    notificationFrame.Position = UDim2.new(0.5, -150, 0, 50)
    notificationFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    notificationFrame.BorderSizePixel = 0
    notificationFrame.Parent = gui

    -- Coins arrondis
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 10)
    UICorner.Parent = notificationFrame

    -- Animation d'entrée
    notificationFrame.Position = UDim2.new(0.5, -150, 0, -100) -- Position initiale hors de l'écran
    notificationFrame:TweenPosition(UDim2.new(0.5, -150, 0, 50), Enum.EasingDirection.Out, Enum.EasingStyle.Bounce, 0.5, true)
    
    -- Animation de fondu
    notificationFrame.BackgroundTransparency = 1
    notificationFrame:TweenBackgroundTransparency(0, Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.5, true)

    -- Titre de la notification
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, 0, 0, 30)
    titleLabel.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    titleLabel.Text = title
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.TextSize = 16
    titleLabel.Parent = notificationFrame

    -- Description de la notification
    local descriptionLabel = Instance.new("TextLabel")
    descriptionLabel.Size = UDim2.new(1, 0, 0, 70)
    descriptionLabel.Position = UDim2.new(0, 0, 0, 30)
    descriptionLabel.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    descriptionLabel.Text = text
    descriptionLabel.Font = Enum.Font.Gotham
    descriptionLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    descriptionLabel.TextSize = 14
    descriptionLabel.Parent = notificationFrame

    -- Animation de disparition
    wait(duration) -- Attend la durée spécifiée

    -- Animation de sortie avec fondu
    notificationFrame:TweenPosition(UDim2.new(0.5, -150, 0, -100), Enum.EasingDirection.Out, Enum.EasingStyle.Bounce, 0.5, true)
    notificationFrame:TweenBackgroundTransparency(1, Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.5, true, function()
        gui:Destroy() -- Détruire le GUI après la durée
    end)
end

-- Fonction d'initialisation
function NotificationLibrary:Init()
    -- Configuration ou initialisation de la bibliothèque si nécessaire
end

return NotificationLibrary
