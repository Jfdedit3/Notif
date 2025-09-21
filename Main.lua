-- NotificationLibrary - Version Améliorée
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

local NotificationLibrary = {}
NotificationLibrary.__index = NotificationLibrary

-- Configuration
NotificationLibrary.config = {
    defaultDuration = 4,
    maxWidth = 350,
    minHeight = 80,
    animationSpeed = 0.3,
    maxNotifications = 5,
    position = "topRight"
}

-- Stockage des notifications actives
NotificationLibrary.activeNotifications = {}

-- Positions prédéfinies
local positions = {
    topRight = {
        anchorPoint = Vector2.new(1, 0),
        offsetStart = function(width, height, index) return UDim2.new(1, 20, 0, 20 + (index - 1) * (height + 10)) end,
        offsetEnd = function(width, height, index) return UDim2.new(1, -20, 0, 20 + (index - 1) * (height + 10)) end
    },
    topLeft = {
        anchorPoint = Vector2.new(0, 0),
        offsetStart = function(width, height, index) return UDim2.new(0, -width - 20, 0, 20 + (index - 1) * (height + 10)) end,
        offsetEnd = function(width, height, index) return UDim2.new(0, 20, 0, 20 + (index - 1) * (height + 10)) end
    },
    bottomRight = {
        anchorPoint = Vector2.new(1, 1),
        offsetStart = function(width, height, index) return UDim2.new(1, 20, 1, -20 - index * (height + 10)) end,
        offsetEnd = function(width, height, index) return UDim2.new(1, -20, 1, -20 - index * (height + 10)) end
    },
    bottomLeft = {
        anchorPoint = Vector2.new(0, 1),
        offsetStart = function(width, height, index) return UDim2.new(0, -width - 20, 1, -20 - index * (height + 10)) end,
        offsetEnd = function(width, height, index) return UDim2.new(0, 20, 1, -20 - index * (height + 10)) end
    }
}

-- Création du ScreenGui principal
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "RTRIX_NotificationSystem"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = PlayerGui

-- Fonctions internes
function NotificationLibrary:GetPositionData()
    return positions[self.config.position] or positions.topRight
end

function NotificationLibrary:GetBackgroundColor(type)
    local colors = {
        success = Color3.fromRGB(46, 204, 113),
        warning = Color3.fromRGB(241, 196, 15),
        error = Color3.fromRGB(231, 76, 60),
        info = Color3.fromRGB(52, 152, 219),
        default = Color3.fromRGB(40, 40, 40)
    }
    return colors[type] or colors.default
end

function NotificationLibrary:PlayNotificationSound(type)
    local soundIds = {
        success = "rbxassetid://6578421743", -- success
        warning = "rbxassetid://1234567890", -- custom warning
        error = "rbxassetid://1234567891",   -- custom error
        info = "rbxassetid://1234567892",    -- custom info
        default = "rbxassetid://6578421743"
    }

    spawn(function()
        local sound = Instance.new("Sound")
        sound.SoundId = soundIds[type] or soundIds.default
        sound.Volume = 0.3
        sound.Parent = screenGui
        sound:Play()
        game:GetService("Debris"):AddItem(sound, sound.TimeLength + 1)
    end)
end

function NotificationLibrary:UpdateNotificationPositions()
    local posData = self:GetPositionData()
    for i, notif in ipairs(self.activeNotifications) do
        local frame = notif.frame
        local height = frame.AbsoluteSize.Y
        local width = self.config.maxWidth

        frame.AnchorPoint = posData.anchorPoint
        local targetPos = posData.offsetEnd(width, height, i)

        TweenService:Create(frame, TweenInfo.new(self.config.animationSpeed, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Position = targetPos
        }):Play()
    end
end

function NotificationLibrary:NewNotification(title, message, duration, type, onClose)
    if #self.activeNotifications >= self.config.maxNotifications then
        local oldest = table.remove(self.activeNotifications, 1)
        if oldest.gui and oldest.gui.Parent then
            oldest.gui:Destroy()
        end
    end

    duration = duration or self.config.defaultDuration
    type = type or "info"

    -- Création du conteneur principal
    local frame = Instance.new("Frame")
    frame.BackgroundTransparency = 1
    frame.BorderSizePixel = 0
    frame.Size = UDim2.new(0, self.config.maxWidth, 0, self.config.minHeight)
    frame.AnchorPoint = self:GetPositionData().anchorPoint
    frame.Position = self:GetPositionData().offsetStart(self.config.maxWidth, self.config.minHeight, #self.activeNotifications + 1)

    -- Container avec fond coloré
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 1, 0)
    container.BackgroundColor3 = self:GetBackgroundColor(type)
    container.BackgroundTransparency = 0.1
    container.Parent = frame

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = container

    local layout = Instance.new("UIListLayout")
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 8)
    layout.Parent = container

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

    -- Calcul de la hauteur
    local textService = game:GetService("TextService")
    local messageSize = textService:GetTextSize(message or "", 14, Enum.Font.Gotham, Vector2.new(self.config.maxWidth - 32, math.huge))
    messageLabel.Size = UDim2.new(1, 0, 0, messageSize.Y)
    frame.Size = UDim2.new(0, self.config.maxWidth, 0, math.max(self.config.minHeight, 40 + messageSize.Y + 32))

    frame.Parent = screenGui

    -- Fermeture au clic
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            self:CloseNotification(notification)
            if onClose then onClose() end
        end
    end)

    -- Auto fermeture
    local notification = {
        id = tick(),
        frame = frame,
        container = container,
        startTime = tick(),
        duration = duration,
        type = type
    }

    table.insert(self.activeNotifications, notification)
    self:UpdateNotificationPositions()

    -- Animation d'entrée
    local posData = self:GetPositionData()
    local finalPosition = posData.offsetEnd(self.config.maxWidth, frame.AbsoluteSize.Y, #self.activeNotifications)
    TweenService:Create(frame, TweenInfo.new(self.config.animationSpeed, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Position = finalPosition
    }):Play()

    -- Son
    self:PlayNotificationSound(type)

    -- Timer
    spawn(function()
        wait(duration)
        self:CloseNotification(notification)
    end)

    return notification
end

function NotificationLibrary:CloseNotification(notification)
    if not notification or not notification.frame or not notification.frame.Parent then return end

    local frame = notification.frame
    local posData = self:GetPositionData()
    local startPosition = posData.offsetStart(self.config.maxWidth, frame.AbsoluteSize.Y, 1)

    TweenService:Create(frame, TweenInfo.new(self.config.animationSpeed, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        Position = startPosition
    }):Play()

    wait(self.config.animationSpeed)

    if frame and frame.Parent then
        frame:Destroy()
    end

    for i, notif in ipairs(self.activeNotifications) do
        if notif.id == notification.id then
            table.remove(self.activeNotifications, i)
            break
        end
    end

    self:UpdateNotificationPositions()
end

function NotificationLibrary:CloseAll()
    for i = #self.activeNotifications, 1, -1 do
        self:CloseNotification(self.activeNotifications[i])
    end
end

function NotificationLibrary:SetPosition(position)
    if positions[position] then
        self.config.position = position
        self:UpdateNotificationPositions()
    else
        warn("Position invalide. Utilisez : topRight, topLeft, bottomRight, bottomLeft")
    end
end

-- Raccourcis
function NotificationLibrary:Success(title, message, duration, onClose)
    return self:NewNotification(title, message, duration, "success", onClose)
end

function NotificationLibrary:Warning(title, message, duration, onClose)
    return self:NewNotification(title, message, duration, "warning", onClose)
end

function NotificationLibrary:Error(title, message, duration, onClose)
    return self:NewNotification(title, message, duration, "error", onClose)
end

function NotificationLibrary:Info(title, message, duration, onClose)
    return self:NewNotification(title, message, duration, "info", onClose)
end

return setmetatable(NotificationLibrary, NotificationLibrary)