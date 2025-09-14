-- NotificationLibrary - Version Corrigée
local NotificationLibrary = {}
NotificationLibrary.__index = NotificationLibrary

NotificationLibrary.config = {
    defaultDuration = 4,
    maxWidth = 350,
    minHeight = 80,
    animationSpeed = 0.3,
    maxNotifications = 5,
    position = "topRight"
}

NotificationLibrary.activeNotifications = {}

function NotificationLibrary:NewNotification(title, message, duration, type)
    -- Vérifier la limite de notifications
    if #self.activeNotifications >= self.config.maxNotifications then
        local oldest = table.remove(self.activeNotifications, 1)
        if oldest.gui and oldest.gui.Parent then
            oldest.gui:Destroy()
        end
    end

    duration = duration or self.config.defaultDuration
    type = type or "info"

    -- Créer le ScreenGui
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "RTRIX_Notification_" .. tostring(os.time())
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    local playerGui = game.Players.LocalPlayer:FindFirstChild("PlayerGui")
    if not playerGui then return end
    screenGui.Parent = playerGui

    -- Cadre principal (transparent)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, self.config.maxWidth, 0, self.config.minHeight)
    frame.BackgroundTransparency = 1
    frame.Parent = screenGui

    -- Container avec fond coloré
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 1, 0)
    container.BackgroundColor3 = self:GetBackgroundColor(type)
    container.BackgroundTransparency = 0.1
    container.Parent = frame

    -- Coins arrondis
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = container

    -- Layout principal
    local layout = Instance.new("UIListLayout")
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 8)
    layout.Parent = container

    -- Padding
    local padding = Instance.new("UIPadding")
    padding.PaddingTop = UDim.new(0, 12)
    padding.PaddingBottom = UDim.new(0, 12)
    padding.PaddingLeft = UDim.new(0, 16)
    padding.PaddingRight = UDim.new(0, 16)
    padding.Parent = container

    -- Titre
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, 0, 0, 20)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title or "Notification"
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 18
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.TextTruncate = Enum.TextTruncate.AtEnd
    titleLabel.Parent = container

    -- Message
    local messageLabel = Instance.new("TextLabel")
    messageLabel.Size = UDim2.new(1, 0, 0, 0)
    messageLabel.BackgroundTransparency = 1
    messageLabel.Text = message or ""
    messageLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
    messageLabel.Font = Enum.Font.Gotham
    messageLabel.TextSize = 14
    messageLabel.TextXAlignment = Enum.TextXAlignment.Left
    messageLabel.TextWrapped = true
    messageLabel.TextTruncate = Enum.TextTruncate.AtEnd
    messageLabel.Parent = container

    -- Calculer la hauteur automatiquement
    local textService = game:GetService("TextService")
    local messageSize = textService:GetTextSize(
        message or "", 
        14, 
        Enum.Font.Gotham, 
        Vector2.new(self.config.maxWidth - 32, math.huge)
    )
    
    messageLabel.Size = UDim2.new(1, 0, 0, messageSize.Y)
    frame.Size = UDim2.new(0, self.config.maxWidth, 0, math.max(self.config.minHeight, 40 + messageSize.Y + 32))

    -- Position initiale selon la configuration
    local startPosition, endPosition = self:GetNotificationPositions()
    frame.Position = startPosition

    -- Stocker la notification
    local notification = {
        id = os.time(),
        gui = screenGui,
        frame = frame,
        container = container,
        startTime = tick(),
        duration = duration,
        type = type
    }
    
    table.insert(self.activeNotifications, notification)

    -- Animation d'entrée
    frame:TweenPosition(endPosition, Enum.EasingDirection.Out, Enum.EasingStyle.Quad, self.config.animationSpeed, true)

    -- Son de notification
    self:PlayNotificationSound(type)

    -- Fermeture automatique
    spawn(function()
        wait(duration)
        self:CloseNotification(notification)
    end)

    return notification
end

function NotificationLibrary:CloseNotification(notification)
    if not notification or not notification.gui or not notification.gui.Parent then
        return
    end

    local startPosition, endPosition = self:GetNotificationPositions()
    notification.frame:TweenPosition(startPosition, Enum.EasingDirection.In, Enum.EasingStyle.Quad, self.config.animationSpeed, true, function()
        if notification.gui and notification.gui.Parent then
            notification.gui:Destroy()
        end
        
        for i, notif in ipairs(self.activeNotifications) do
            if notif.id == notification.id then
                table.remove(self.activeNotifications, i)
                break
            end
        end
    end)
end

function NotificationLibrary:GetNotificationPositions()
    local positions = {
        topRight = {
            start = UDim2.new(1, 20, 0, 20),
            endPos = UDim2.new(1, -self.config.maxWidth - 20, 0, 20)
        },
        topLeft = {
            start = UDim2.new(0, -self.config.maxWidth - 20, 0, 20),
            endPos = UDim2.new(0, 20, 0, 20)
        },
        bottomRight = {
            start = UDim2.new(1, 20, 1, -self.config.minHeight - 20),
            endPos = UDim2.new(1, -self.config.maxWidth - 20, 1, -self.config.minHeight - 20)
        },
        bottomLeft = {
            start = UDim2.new(0, -self.config.maxWidth - 20, 1, -self.config.minHeight - 20),
            endPos = UDim2.new(0, 20, 1, -self.config.minHeight - 20)
        }
    }

    local pos = positions[self.config.position] or positions.topRight
    return pos.start, pos.endPos
end

function NotificationLibrary:GetBackgroundColor(type)
    local colors = {
        success = Color3.fromRGB(46, 204, 113),   -- Vert
        warning = Color3.fromRGB(241, 196, 15),   -- Jaune
        error = Color3.fromRGB(231, 76, 60),      -- Rouge
        info = Color3.fromRGB(52, 152, 219),      -- Bleu
        default = Color3.fromRGB(40, 40, 40)      -- Gris
    }
    
    return colors[type] or colors.default
end

function NotificationLibrary:PlayNotificationSound(type)
    local soundIds = {
        success = "rbxassetid://6578421743",
        warning = "rbxassetid://6578421743",
        error = "rbxassetid://6578421743",
        info = "rbxassetid://6578421743",
        default = "rbxassetid://6578421743"
    }

    spawn(function()
        local sound = Instance.new("Sound")
        sound.SoundId = soundIds[type] or soundIds.default
        sound.Volume = 0.3
        sound.Parent = game.Players.LocalPlayer:FindFirstChild("PlayerGui") or game.Players.LocalPlayer
        
        sound:Play()
        
        game:GetService("Debris"):AddItem(sound, sound.TimeLength + 1)
    end)
end

function NotificationLibrary:Success(title, message, duration)
    return self:NewNotification(title, message, duration, "success")
end

function NotificationLibrary:Warning(title, message, duration)
    return self:NewNotification(title, message, duration, "warning")
end

function NotificationLibrary:Error(title, message, duration)
    return self:NewNotification(title, message, duration, "error")
end

function NotificationLibrary:Info(title, message, duration)
    return self:NewNotification(title, message, duration, "info")
end

function NotificationLibrary:CloseAll()
    for i = #self.activeNotifications, 1, -1 do
        local notification = self.activeNotifications[i]
        self:CloseNotification(notification)
    end
end

function NotificationLibrary:SetPosition(position)
    if position == "topRight" or position == "topLeft" or position == "bottomRight" or position == "bottomLeft" then
        self.config.position = position
    else
        warn("Position invalide. Utilisez: topRight, topLeft, bottomRight, bottomLeft")
    end
end

return setmetatable(NotificationLibrary, NotificationLibrary)