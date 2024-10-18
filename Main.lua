local NotificationLibrary = {}
NotificationLibrary.__index = NotificationLibrary

-- Fonction pour créer une nouvelle notification
function NotificationLibrary:NewNotification(title, message, duration, type)
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "NotificationGui"
    screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

    -- Cadre de la notification
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 300, 0, 100)
    frame.Position = UDim2.new(0.5, -150, 0, -120) -- Apparition hors écran
    frame.BackgroundColor3 = self:GetBackgroundColor(type)
    frame.BorderSizePixel = 0
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

    -- Jouer un son en fonction du type de notification
    self:PlayNotificationSound(type)

    -- Fermeture après la durée spécifiée
    wait(duration)

    -- Animation de disparition
    frame:TweenPosition(UDim2.new(0.5, -150, 0, -120), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.5, true, function()
        screenGui:Destroy() -- Supprime la notification après la disparition
    end)
end

-- Fonction pour obtenir la couleur du fond en fonction du type de notification
function NotificationLibrary:GetBackgroundColor(type)
    if type == "success" then
        return Color3.fromRGB(46, 204, 113)  -- Vert
    elseif type == "warning" then
        return Color3.fromRGB(241, 196, 15)  -- Jaune
    elseif type == "error" then
        return Color3.fromRGB(231, 76, 60)   -- Rouge
    else
        return Color3.fromRGB(40, 40, 40)    -- Couleur par défaut (gris)
    end
end

-- Fonction pour jouer un son en fonction du type de notification
function NotificationLibrary:PlayNotificationSound(type)
    local sound = Instance.new("Sound")
    sound.Parent = game.Players.LocalPlayer
    sound.Volume = 0.5

    if type == "success" then
        sound.SoundId = "rbxassetid://1234567"  -- ID du son de succès
    elseif type == "warning" then
        sound.SoundId = "rbxassetid://2345678"  -- ID du son d'avertissement
    elseif type == "error" then
        sound.SoundId = "rbxassetid://3456789"  -- ID du son d'erreur
    else
        sound.SoundId = "rbxassetid://4567890"  -- Son par défaut
    end

    sound:Play()
    sound.Ended:Connect(function()
        sound:Destroy()  -- Détruire le son après qu'il ait été joué
    end)
end

return NotificationLibrary
