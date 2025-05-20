-- Renk tablosu
local colourTable = {
    Green = Color3.fromRGB(0, 255, 0),
    Blue = Color3.fromRGB(0, 0, 255),
    Red = Color3.fromRGB(255, 0, 0),
    Yellow = Color3.fromRGB(255, 255, 0),
    Orange = Color3.fromRGB(255, 165, 0),
    Purple = Color3.fromRGB(128, 0, 128)
}
local colourChosen = colourTable.Red

-- Servisler
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

-- Karakter bulucu
local function getCharacter(player)
    for _, descendant in pairs(workspace:GetDescendants()) do
        pcall(function()
            if descendant.Name == player.Name and descendant:FindFirstChild("HumanoidRootPart") then
                return descendant
            end
        end)
    end   
    return Workspace:FindFirstChild(player.Name)
end

-- Highlight ekle
local function addHighlightToCharacter(player, character)
    if player == LocalPlayer then return end
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if humanoidRootPart and not humanoidRootPart:FindFirstChild("Highlight") then
        local highlightClone = Instance.new("Highlight")
        highlightClone.Name = "Highlight"
        highlightClone.Adornee = character
        highlightClone.Parent = humanoidRootPart
        highlightClone.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        highlightClone.FillColor = colourChosen
        highlightClone.OutlineColor = Color3.fromRGB(255, 255, 255)
        highlightClone.FillTransparency = 0.5
    end
end

-- Highlight sil
local function removeHighlightFromCharacter(character)
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if humanoidRootPart then
        local highlightInstance = humanoidRootPart:FindFirstChild("Highlight")
        if highlightInstance then
            highlightInstance:Destroy()
        end
    end
end

-- Highlight güncelle
local function updateHighlights()
    for _, player in pairs(Players:GetPlayers()) do
        local character = getCharacter(player)
        if character then
            if _G.ESPToggle then
                addHighlightToCharacter(player, character)
            else
                removeHighlightFromCharacter(character)
            end
        end
    end
end

-- Her karede güncelle
RunService.RenderStepped:Connect(function()
    updateHighlights()
end)

-- Yeni oyuncular için highlight
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(character)
        if _G.ESPToggle then
            addHighlightToCharacter(player, character)
        end
    end)
end)

-- Oyuncu çıkınca highlight sil
Players.PlayerRemoving:Connect(function(playerRemoved)
    local character = playerRemoved.Character
    if character then
        removeHighlightFromCharacter(character)
    end
end)

-- Klavyeden toggle
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if input.KeyCode == _G.KeyBind and not gameProcessed then
        _G.ESPToggle = not _G.ESPToggle
    end
end)
