local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Remote events and functions
local ClientIsDragging = ReplicatedStorage:WaitForChild("Interaction"):WaitForChild("ClientIsDragging")
local NPCDialog = ReplicatedStorage:WaitForChild("NPCDialog"):WaitForChild("PlayerChatted")

-- Store IDs (will be detected automatically)
local WoodRUsID = -1
local FurnitureStoreID = -1
local LogicStoreID = -1
local ShackShopID = -1
local CarStoreID = -1
local FineArtID = -1

-- Store counters
local storeCounters = {
    WoodRUs = "Thom",
    FurnitureStore = "Corey",
    LogicStore = "Lincoln",
    ShackShop = "Bob",
    CarStore = "Jenny",
    FineArt = "Timothy"
}

-- GUI setup
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AutoPurchaseGUI"
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = game:GetService("CoreGui") or Player:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 350, 0, 450)
MainFrame.Position = UDim2.new(0.5, -175, 0.5, -225)
MainFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
MainFrame.BackgroundTransparency = 0.15
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

-- Title
local Title = Instance.new("TextLabel")
Title.Text = "Auto Purchase System"
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 20
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Size = UDim2.new(1, -10, 0, 30)
Title.Position = UDim2.new(0, 5, 0, 5)
Title.BackgroundTransparency = 1
Title.Parent = MainFrame

-- Store selection dropdown
local StoreLabel = Instance.new("TextLabel")
StoreLabel.Text = "Select Store:"
StoreLabel.Font = Enum.Font.SourceSans
StoreLabel.TextSize = 16
StoreLabel.TextColor3 = Color3.new(0.9, 0.9, 0.9)
StoreLabel.Size = UDim2.new(0.9, 0, 0, 20)
StoreLabel.Position = UDim2.new(0.05, 0, 0.1, 0)
StoreLabel.BackgroundTransparency = 1
StoreLabel.Parent = MainFrame

local StoreDropdown = Instance.new("TextButton")
StoreDropdown.Name = "StoreDropdown"
StoreDropdown.Text = "Select Store ▼"
StoreDropdown.Font = Enum.Font.SourceSansSemibold
StoreDropdown.TextSize = 16
StoreDropdown.TextColor3 = Color3.new(1, 1, 1)
StoreDropdown.Size = UDim2.new(0.9, 0, 0, 30)
StoreDropdown.Position = UDim2.new(0.05, 0, 0.15, 0)
StoreDropdown.BackgroundColor3 = Color3.fromRGB(70, 70, 90)
StoreDropdown.AutoButtonColor = true
StoreDropdown.Parent = MainFrame

local DropdownFrame = Instance.new("Frame")
DropdownFrame.Name = "DropdownFrame"
DropdownFrame.Size = UDim2.new(0.9, 0, 0, 150)
DropdownFrame.Position = UDim2.new(0.05, 0, 0.15, 30)
DropdownFrame.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
DropdownFrame.Visible = false
DropdownFrame.Parent = MainFrame

local DropdownScroll = Instance.new("ScrollingFrame")
DropdownScroll.Size = UDim2.new(1, 0, 1, 0)
DropdownScroll.BackgroundTransparency = 1
DropdownScroll.ScrollBarThickness = 5
DropdownScroll.Parent = DropdownFrame

local DropdownList = Instance.new("UIListLayout")
DropdownList.Parent = DropdownScroll

-- Selection mode
local SelectionModeLabel = Instance.new("TextLabel")
SelectionModeLabel.Text = "Selection Mode:"
SelectionModeLabel.Font = Enum.Font.SourceSans
SelectionModeLabel.TextSize = 16
SelectionModeLabel.TextColor3 = Color3.new(0.9, 0.9, 0.9)
SelectionModeLabel.Size = UDim2.new(0.9, 0, 0, 20)
SelectionModeLabel.Position = UDim2.new(0.05, 0, 0.3, 0)
SelectionModeLabel.BackgroundTransparency = 1
SelectionModeLabel.Parent = MainFrame

local SingleSelectButton = Instance.new("TextButton")
SingleSelectButton.Name = "SingleSelectButton"
SingleSelectButton.Text = "Single"
SingleSelectButton.Font = Enum.Font.SourceSansSemibold
SingleSelectButton.TextSize = 16
SingleSelectButton.TextColor3 = Color3.new(1, 1, 1)
SingleSelectButton.Size = UDim2.new(0.44, 0, 0, 30)
SingleSelectButton.Position = UDim2.new(0.05, 0, 0.35, 0)
SingleSelectButton.BackgroundColor3 = Color3.fromRGB(70, 120, 200)
SingleSelectButton.AutoButtonColor = true
SingleSelectButton.Parent = MainFrame

local MultiSelectButton = Instance.new("TextButton")
MultiSelectButton.Name = "MultiSelectButton"
MultiSelectButton.Text = "Multiple"
MultiSelectButton.Font = Enum.Font.SourceSansSemibold
MultiSelectButton.TextSize = 16
MultiSelectButton.TextColor3 = Color3.new(1, 1, 1)
MultiSelectButton.Size = UDim2.new(0.44, 0, 0, 30)
MultiSelectButton.Position = UDim2.new(0.51, 0, 0.35, 0)
MultiSelectButton.BackgroundColor3 = Color3.fromRGB(70, 70, 90)
MultiSelectButton.AutoButtonColor = true
MultiSelectButton.Parent = MainFrame

-- Purchase mode
local PurchaseModeLabel = Instance.new("TextLabel")
PurchaseModeLabel.Text = "Purchase Mode:"
PurchaseModeLabel.Font = Enum.Font.SourceSans
PurchaseModeLabel.TextSize = 16
PurchaseModeLabel.TextColor3 = Color3.new(0.9, 0.9, 0.9)
PurchaseModeLabel.Size = UDim2.new(0.9, 0, 0, 20)
PurchaseModeLabel.Position = UDim2.new(0.05, 0, 0.42, 0)
PurchaseModeLabel.BackgroundTransparency = 1
PurchaseModeLabel.Parent = MainFrame

local TogetherButton = Instance.new("TextButton")
TogetherButton.Name = "TogetherButton"
TogetherButton.Text = "Together"
TogetherButton.Font = Enum.Font.SourceSansSemibold
TogetherButton.TextSize = 16
TogetherButton.TextColor3 = Color3.new(1, 1, 1)
TogetherButton.Size = UDim2.new(0.44, 0, 0, 30)
TogetherButton.Position = UDim2.new(0.05, 0, 0.47, 0)
TogetherButton.BackgroundColor3 = Color3.fromRGB(70, 120, 200)
TogetherButton.AutoButtonColor = true
TogetherButton.Parent = MainFrame

local SeparateButton = Instance.new("TextButton")
SeparateButton.Name = "SeparateButton"
SeparateButton.Text = "Separate"
SeparateButton.Font = Enum.Font.SourceSansSemibold
SeparateButton.TextSize = 16
SeparateButton.TextColor3 = Color3.new(1, 1, 1)
SeparateButton.Size = UDim2.new(0.44, 0, 0, 30)
SeparateButton.Position = UDim2.new(0.51, 0, 0.47, 0)
SeparateButton.BackgroundColor3 = Color3.fromRGB(70, 70, 90)
SeparateButton.AutoButtonColor = true
SeparateButton.Parent = MainFrame

-- Item count input
local CountLabel = Instance.new("TextLabel")
CountLabel.Text = "Item Count:"
CountLabel.Font = Enum.Font.SourceSans
CountLabel.TextSize = 16
CountLabel.TextColor3 = Color3.new(0.9, 0.9, 0.9)
CountLabel.Size = UDim2.new(0.9, 0, 0, 20)
CountLabel.Position = UDim2.new(0.05, 0, 0.54, 0)
CountLabel.BackgroundTransparency = 1
CountLabel.Parent = MainFrame

local CountInput = Instance.new("TextBox")
CountInput.Name = "CountInput"
CountInput.Text = "1"
CountInput.Font = Enum.Font.SourceSans
CountInput.TextSize = 16
CountInput.TextColor3 = Color3.new(1, 1, 1)
CountInput.Size = UDim2.new(0.9, 0, 0, 30)
CountInput.Position = UDim2.new(0.05, 0, 0.58, 0)
CountInput.BackgroundColor3 = Color3.fromRGB(70, 70, 90)
CountInput.ClearTextOnFocus = false
CountInput.Parent = MainFrame

-- Position selection
local SetPosButton = Instance.new("TextButton")
SetPosButton.Name = "SetPosButton"
SetPosButton.Text = "Set Target Position"
SetPosButton.Font = Enum.Font.SourceSansSemibold
SetPosButton.TextSize = 16
SetPosButton.TextColor3 = Color3.new(1, 1, 1)
SetPosButton.Size = UDim2.new(0.9, 0, 0, 35)
SetPosButton.Position = UDim2.new(0.05, 0, 0.65, 0)
SetPosButton.BackgroundColor3 = Color3.fromRGB(80, 160, 90)
SetPosButton.AutoButtonColor = true
SetPosButton.Parent = MainFrame

-- Start/Stop buttons
local StartButton = Instance.new("TextButton")
StartButton.Name = "StartButton"
StartButton.Text = "Start Purchase"
StartButton.Font = Enum.Font.SourceSansSemibold
StartButton.TextSize = 16
StartButton.TextColor3 = Color3.new(1, 1, 1)
StartButton.Size = UDim2.new(0.44, 0, 0, 35)
StartButton.Position = UDim2.new(0.05, 0, 0.75, 0)
StartButton.BackgroundColor3 = Color3.fromRGB(80, 160, 90)
StartButton.AutoButtonColor = true
StartButton.Parent = MainFrame

local StopButton = Instance.new("TextButton")
StopButton.Name = "StopButton"
StopButton.Text = "Stop"
StopButton.Font = Enum.Font.SourceSansSemibold
StopButton.TextSize = 16
StopButton.TextColor3 = Color3.new(1, 1, 1)
StopButton.Size = UDim2.new(0.44, 0, 0, 35)
StopButton.Position = UDim2.new(0.51, 0, 0.75, 0)
StopButton.BackgroundColor3 = Color3.fromRGB(200, 80, 80)
StopButton.AutoButtonColor = true
StopButton.Visible = false
StopButton.Parent = MainFrame

-- Status label
local StatusLabel = Instance.new("TextLabel")
StatusLabel.Text = "Ready"
StatusLabel.Font = Enum.Font.SourceSans
StatusLabel.TextSize = 14
StatusLabel.TextColor3 = Color3.new(0.9, 0.9, 0.9)
StatusLabel.Size = UDim2.new(0.9, 0, 0, 40)
StatusLabel.Position = UDim2.new(0.05, 0, 0.85, 0)
StatusLabel.BackgroundTransparency = 1
StatusLabel.TextWrapped = true
StatusLabel.Parent = MainFrame

-- Progress label
local ProgressLabel = Instance.new("TextLabel")
ProgressLabel.Text = ""
ProgressLabel.Font = Enum.Font.SourceSans
ProgressLabel.TextSize = 14
ProgressLabel.TextColor3 = Color3.new(0.9, 0.9, 0.9)
ProgressLabel.Size = UDim2.new(0.9, 0, 0, 20)
ProgressLabel.Position = UDim2.new(0.05, 0, 0.92, 0)
ProgressLabel.BackgroundTransparency = 1
ProgressLabel.Parent = MainFrame

-- Add rounded corners to buttons and input
for _, btn in pairs({StoreDropdown, SingleSelectButton, MultiSelectButton, TogetherButton, 
                    SeparateButton, CountInput, SetPosButton, StartButton, StopButton}) do
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = btn
end

-- Variables
local selectedStore = nil
local selectedItems = {}
local targetPosition = nil
local isSelecting = false
local selectionMode = "single" -- "single" or "multiple"
local purchaseMode = "together" -- "together" or "separate"
local isPurchasing = false
local originalPosition = nil
local itemCounter = 0

-- Update status function
local function updateStatus(text, color)
    StatusLabel.Text = text
    StatusLabel.TextColor3 = color or Color3.new(0.9, 0.9, 0.9)
end

-- Update progress function
local function updateProgress(text)
    ProgressLabel.Text = text
end

-- Populate store dropdown
local function populateStoreDropdown()
    DropdownScroll:ClearAllChildren()
    
    for storeName, _ in pairs(storeCounters) do
        local storeButton = Instance.new("TextButton")
        storeButton.Text = storeName
        storeButton.Font = Enum.Font.SourceSans
        storeButton.TextSize = 16
        storeButton.TextColor3 = Color3.new(1, 1, 1)
        storeButton.Size = UDim2.new(1, -10, 0, 30)
        storeButton.Position = UDim2.new(0, 5, 0, 0)
        storeButton.BackgroundColor3 = Color3.fromRGB(80, 80, 100)
        storeButton.AutoButtonColor = true
        storeButton.Parent = DropdownScroll
        
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 4)
        btnCorner.Parent = storeButton
        
        storeButton.MouseButton1Click:Connect(function()
            selectedStore = storeName
            StoreDropdown.Text = storeName
            DropdownFrame.Visible = false
            updateStatus("Selected store: "..storeName)
        end)
    end
end

-- Toggle dropdown visibility
StoreDropdown.MouseButton1Click:Connect(function()
    DropdownFrame.Visible = not DropdownFrame.Visible
    if DropdownFrame.Visible then
        populateStoreDropdown()
    end
end)

-- Close dropdown when clicking elsewhere
UIS.InputBegan:Connect(function(input, gameProcessed)
    if input.UserInputType == Enum.UserInputType.MouseButton1 and DropdownFrame.Visible then
        local mousePos = UIS:GetMouseLocation()
        local dropdownPos = DropdownFrame.AbsolutePosition
        local dropdownSize = DropdownFrame.AbsoluteSize
        
        if not (mousePos.X >= dropdownPos.X and mousePos.X <= dropdownPos.X + dropdownSize.X and
               mousePos.Y >= dropdownPos.Y and mousePos.Y <= dropdownPos.Y + dropdownSize.Y) then
            DropdownFrame.Visible = false
        end
    end
end)

-- Selection mode buttons
SingleSelectButton.MouseButton1Click:Connect(function()
    selectionMode = "single"
    SingleSelectButton.BackgroundColor3 = Color3.fromRGB(70, 120, 200)
    MultiSelectButton.BackgroundColor3 = Color3.fromRGB(70, 70, 90)
    updateStatus("Selection mode: Single")
end)

MultiSelectButton.MouseButton1Click:Connect(function()
    selectionMode = "multiple"
    MultiSelectButton.BackgroundColor3 = Color3.fromRGB(70, 120, 200)
    SingleSelectButton.BackgroundColor3 = Color3.fromRGB(70, 70, 90)
    updateStatus("Selection mode: Multiple")
end)

-- Purchase mode buttons
TogetherButton.MouseButton1Click:Connect(function()
    purchaseMode = "together"
    TogetherButton.BackgroundColor3 = Color3.fromRGB(70, 120, 200)
    SeparateButton.BackgroundColor3 = Color3.fromRGB(70, 70, 90)
    updateStatus("Purchase mode: Together")
end)

SeparateButton.MouseButton1Click:Connect(function()
    purchaseMode = "separate"
    SeparateButton.BackgroundColor3 = Color3.fromRGB(70, 120, 200)
    TogetherButton.BackgroundColor3 = Color3.fromRGB(70, 70, 90)
    updateStatus("Purchase mode: Separate")
end)

-- Validate item count input
CountInput.FocusLost:Connect(function()
    local num = tonumber(CountInput.Text)
    if not num or num < 1 or num % 1 ~= 0 then
        CountInput.Text = "1"
        updateStatus("Item count must be integer ≥1", Color3.fromRGB(255, 100, 100))
    end
end)

-- Set target position
SetPosButton.MouseButton1Click:Connect(function()
    local char = Player.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        targetPosition = char.HumanoidRootPart.Position + char.HumanoidRootPart.CFrame.LookVector * 5
        
        -- Create visual marker
        if not workspace:FindFirstChild("TargetPositionMarker") then
            local marker = Instance.new("Part")
            marker.Name = "TargetPositionMarker"
            marker.Size = Vector3.new(1, 1, 1)
            marker.Position = targetPosition
            marker.Anchored = true
            marker.CanCollide = false
            marker.Transparency = 0.5
            marker.Color = Color3.fromRGB(0, 255, 0)
            marker.Shape = Enum.PartType.Ball
            marker.Parent = workspace
            
            local highlight = Instance.new("Highlight")
            highlight.FillColor = Color3.fromRGB(0, 255, 0)
            highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
            highlight.Parent = marker
        else
            workspace.TargetPositionMarker.Position = targetPosition
        end
        
        updateStatus("Target position set!", Color3.fromRGB(150, 255, 150))
    else
        updateStatus("Character not found", Color3.fromRGB(255, 100, 100))
    end
end)

-- Clear selection when store changes
StoreDropdown:GetPropertyChangedSignal("Text"):Connect(function()
    selectedItems = {}
    updateStatus("Store changed - selection cleared")
end)

-- Initial setup
SingleSelectButton.BackgroundColor3 = Color3.fromRGB(70, 120, 200)
TogetherButton.BackgroundColor3 = Color3.fromRGB(70, 120, 200)
updateStatus("Ready")

-- Clear item selection
local function clearSelection()
    for _, item in pairs(selectedItems) do
        if item and item:FindFirstChild("ItemHighlight") then
            item.ItemHighlight:Destroy()
        end
    end
    selectedItems = {}
    isSelecting = false
    updateStatus("Selection cleared")
end

-- Highlight item
local function highlightItem(item)
    if not item then return end
    
    local highlight = Instance.new("Highlight")
    highlight.Name = "ItemHighlight"
    highlight.FillColor = Color3.fromRGB(0, 200, 100)
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    highlight.Parent = item
end

-- Item selection handler
Mouse.Button1Down:Connect(function()
    if isSelecting and Mouse.Target then
        local item = Mouse.Target
        local parent = item.Parent
        
        -- Find the main part or model
        while parent ~= workspace do
            if parent:FindFirstChild("Main") or parent:IsA("Model") then
                item = parent
                break
            end
            parent = parent.Parent
        end

        if item:FindFirstChild("Main") or item:IsA("BasePart") then
            if selectionMode == "single" then
                clearSelection()
                table.insert(selectedItems, item)
                highlightItem(item)
                isSelecting = false
                updateStatus("Selected: "..item.Name, Color3.fromRGB(150, 255, 150))
            else
                -- Check if already selected
                local alreadySelected = false
                for _, selItem in pairs(selectedItems) do
                    if selItem == item then
                        alreadySelected = true
                        break
                    end
                end
                
                if not alreadySelected then
                    table.insert(selectedItems, item)
                    highlightItem(item)
                    updateStatus("Added: "..item.Name.." ("..#selectedItems.." selected)", Color3.fromRGB(150, 255, 150))
                end
            end
        else
            updateStatus("Invalid item!", Color3.fromRGB(255, 100, 100))
        end
    end
end)

-- Start selection button (we'll add this to the GUI later)
local SelectButton = Instance.new("TextButton")
SelectButton.Name = "SelectButton"
SelectButton.Text = "Select Items"
SelectButton.Font = Enum.Font.SourceSansSemibold
SelectButton.TextSize = 16
SelectButton.TextColor3 = Color3.new(1, 1, 1)
SelectButton.Size = UDim2.new(0.9, 0, 0, 35)
SelectButton.Position = UDim2.new(0.05, 0, 0.2, 0)
SelectButton.BackgroundColor3 = Color3.fromRGB(70, 120, 200)
SelectButton.AutoButtonColor = true
SelectButton.Parent = MainFrame

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0, 6)
btnCorner.Parent = SelectButton

SelectButton.MouseButton1Click:Connect(function()
    isSelecting = true
    updateStatus("Click on items to select...", Color3.fromRGB(255, 255, 150))
end)

-- Find purchased items
local function findPurchasedItems()
    local purchasedItems = {}
    local playerName = Player.Name
    
    for _, model in pairs(workspace.PlayerModels:GetChildren()) do
        if model.Name == "Box Purchased by "..playerName then
            table.insert(purchasedItems, model)
        end
    end
    
    return purchasedItems
end

-- Rename purchased items
local function renamePurchasedItems()
    local purchasedItems = findPurchasedItems()
    local counter = 0
    
    for _, item in pairs(purchasedItems) do
        -- Find a unique name
        while workspace.PlayerModels:FindFirstChild(tostring(counter)) do
            counter = counter + 1
        end
        
        item.Name = tostring(counter)
        counter = counter + 1
    end
end

-- Smooth teleport function
local function smoothTeleport(item, targetPos)
    if not item or not item.Parent then return false end
    
    local mainPart = item:FindFirstChild("Main") or item:FindFirstChildWhichIsA("BasePart")
    if not mainPart then return false end

    -- Start dragging
    ClientIsDragging:FireServer(item)
    task.wait(0.1)

    -- Smooth movement with tweens
    local tweenInfo = TweenInfo.new(
        0.5, -- Duration
        Enum.EasingStyle.Quad,
        Enum.EasingDirection.Out
    )

    local tween = TweenService:Create(
        mainPart,
        tweenInfo,
        {CFrame = CFrame.new(targetPos)}
    )

    -- Sync with server during movement
    local connection
    connection = RunService.Heartbeat:Connect(function()
        ClientIsDragging:FireServer(item)
    end)

    tween:Play()
    tween.Completed:Wait()
    connection:Disconnect()

    -- Final position
    if item.Parent then
        mainPart.CFrame = CFrame.new(targetPos)
        ClientIsDragging:FireServer(item)
    end

    return true
end

-- Teleport character
local function teleportCharacter(position)
    local char = Player.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        char.HumanoidRootPart.CFrame = CFrame.new(position)
        return true
    end
    return false
end

-- Purchase item function
local function purchaseItem(storeName)
    if not storeName or not storeCounters[storeName] then return false end
    
    local npcName = storeCounters[storeName]
    local storeID = -1
    
    -- Get the correct ID variable
    if storeName == "WoodRUs" then
        storeID = WoodRUsID
    elseif storeName == "FurnitureStore" then
        storeID = FurnitureStoreID
    elseif storeName == "LogicStore" then
        storeID = LogicStoreID
    elseif storeName == "ShackShop" then
        storeID = ShackShopID
    elseif storeName == "CarStore" then
        storeID = CarStoreID
    elseif storeName == "FineArt" then
        storeID = FineArtID
    end
    
    -- Check if we need to find the ID
    if storeID == -1 then
        updateStatus("Finding ID for "..storeName.."...", Color3.fromRGB(255, 255, 150))
        return false, true -- Second return value indicates we need to find ID
    end
    
    local args = {
        [1] = {
            ["ID"] = storeID,
            ["Character"] = workspace:WaitForChild("Stores"):WaitForChild(storeName):WaitForChild(npcName),
            ["Name"] = npcName,
            ["Dialog"] = workspace:WaitForChild("Stores"):WaitForChild(storeName):WaitForChild(npcName):WaitForChild("Dialog")
        },
        [2] = "ConfirmPurchase"
    }
    
    NPCDialog:InvokeServer(unpack(args))
    return true, false
end

-- Find store ID function
local function findStoreID(storeName)
    if not storeName or not storeCounters[storeName] then return false end
    
    local npcName = storeCounters[storeName]
    local currentID = 0
    local found = false
    
    -- Create ID finding GUI
    local idGui = Instance.new("ScreenGui")
    idGui.Name = "IDFinderGUI"
    idGui.Parent = Player.PlayerGui
    
    local idFrame = Instance.new("Frame")
    idFrame.Size = UDim2.new(0, 300, 0, 100)
    idFrame.Position = UDim2.new(0.5, -150, 0.7, -50)
    idFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    idFrame.BackgroundTransparency = 0.2
    idFrame.Parent = idGui
    
    local idLabel = Instance.new("TextLabel")
    idLabel.Text = "Finding ID for "..storeName
    idLabel.Font = Enum.Font.SourceSansBold
    idLabel.TextSize = 18
    idLabel.TextColor3 = Color3.new(1, 1, 1)
    idLabel.Size = UDim2.new(1, 0, 0.5, 0)
    idLabel.BackgroundTransparency = 1
    idLabel.Parent = idFrame
    
    local idCounter = Instance.new("TextLabel")
    idCounter.Text = "Trying ID: 0"
    idCounter.Font = Enum.Font.SourceSans
    idCounter.TextSize = 16
    idCounter.TextColor3 = Color3.new(1, 1, 1)
    idCounter.Size = UDim2.new(1, 0, 0.5, 0)
    idCounter.Position = UDim2.new(0, 0, 0.5, 0)
    idCounter.BackgroundTransparency = 1
    idCounter.Parent = idFrame
    
    -- Save original position
    local char = Player.Character
    local originalPos = char and char:FindFirstChild("HumanoidRootPart") and char.HumanoidRootPart.Position
    
    -- Teleport to counter
    local counter = workspace.Stores[storeName].Counter
    if char and char.HumanoidRootPart and counter then
        char.HumanoidRootPart.CFrame = CFrame.new(counter.Position + Vector3.new(0, 3, 0))
    end
    
    -- Try IDs until we find the correct one
    while not found and isPurchasing do
        currentID = currentID + 1
        idCounter.Text = "Trying ID: "..currentID
        
        local args = {
            [1] = {
                ["ID"] = currentID,
                ["Character"] = workspace:WaitForChild("Stores"):WaitForChild(storeName):WaitForChild(npcName),
                ["Name"] = npcName,
                ["Dialog"] = workspace:WaitForChild("Stores"):WaitForChild(storeName):WaitForChild(npcName):WaitForChild("Dialog")
            },
            [2] = "ConfirmPurchase"
        }
        
        NPCDialog:InvokeServer(unpack(args))
        task.wait(0.1)
        
        -- Check if purchase was successful
        local purchasedItems = findPurchasedItems()
        if #purchasedItems > 0 then
            found = true
            -- Set the correct ID
            if storeName == "WoodRUs" then
                WoodRUsID = currentID
            elseif storeName == "FurnitureStore" then
                FurnitureStoreID = currentID
            elseif storeName == "LogicStore" then
                LogicStoreID = currentID
            elseif storeName == "ShackShop" then
                ShackShopID = currentID
            elseif storeName == "CarStore" then
                CarStoreID = currentID
            elseif storeName == "FineArt" then
                FineArtID = currentID
            end
            
            -- Clean up
            for _, item in pairs(purchasedItems) do
                item:Destroy()
            end
        end
        
        task.wait(0.1)
    end
    
    -- Clean up GUI
    idGui:Destroy()
    
    -- Return to original position
    if originalPos and char and char.HumanoidRootPart then
        char.HumanoidRootPart.CFrame = CFrame.new(originalPos)
    end
    
    return found
end

-- Main purchase function
local function startPurchase()
    if isPurchasing then return end
    if not selectedStore then
        updateStatus("Select a store first!", Color3.fromRGB(255, 100, 100))
        return
    end
    if #selectedItems == 0 then
        updateStatus("Select items first!", Color3.fromRGB(255, 100, 100))
        return
    end
    if not targetPosition then
        updateStatus("Set target position first!", Color3.fromRGB(255, 100, 100))
        return
    end
    
    local itemCount = tonumber(CountInput.Text) or 1
    if itemCount < 1 then itemCount = 1 end
    
    isPurchasing = true
    StartButton.Visible = false
    StopButton.Visible = true
    
    -- Save original position
    local char = Player.Character
    if char and char.HumanoidRootPart then
        originalPosition = char.HumanoidRootPart.Position
    end
    
    -- Purchase logic
    coroutine.wrap(function()
        local totalItems = itemCount
        local itemsPerSelection = purchaseMode == "together" and math.ceil(itemCount / #selectedItems) or itemCount
        local remainingItems = itemCount
        
        while remainingItems > 0 and isPurchasing do
            for _, item in pairs(selectedItems) do
                if not isPurchasing then break end
                
                local itemsToBuy = math.min(itemsPerSelection, remainingItems)
                if itemsToBuy <= 0 then break end
                
                -- Update progress
                if purchaseMode == "together" then
                    updateProgress(string.format("Remaining: %d/%d", remainingItems, totalItems))
                else
                    updateProgress(string.format("%s remaining: %d", item.Name, itemsToBuy))
                end
                
                -- Check if we need to find the store ID
                local storeIDFound = true
                if selectedStore == "WoodRUs" and WoodRUsID == -1 then
                    storeIDFound = findStoreID(selectedStore)
                elseif selectedStore == "FurnitureStore" and FurnitureStoreID == -1 then
                    storeIDFound = findStoreID(selectedStore)
                elseif selectedStore == "LogicStore" and LogicStoreID == -1 then
                    storeIDFound = findStoreID(selectedStore)
                elseif selectedStore == "ShackShop" and ShackShopID == -1 then
                    storeIDFound = findStoreID(selectedStore)
                elseif selectedStore == "CarStore" and CarStoreID == -1 then
                    storeIDFound = findStoreID(selectedStore)
                elseif selectedStore == "FineArt" and FineArtID == -1 then
                    storeIDFound = findStoreID(selectedStore)
                end
                
                if not storeIDFound then
                    updateStatus("Failed to find store ID", Color3.fromRGB(255, 100, 100))
                    isPurchasing = false
                    break
                end
                
                -- Teleport to item
                if item:FindFirstChild("Main") then
                    teleportCharacter(item.Main.Position + Vector3.new(0, 3, 0))
                    task.wait(0.1)
                    
                    -- Teleport item to counter
                    local counter = workspace.Stores[selectedStore].Counter
                    if counter then
                        smoothTeleport(item, counter.Position + Vector3.new(0, 1, 0))
                        task.wait(0.1)
                    end
                end
                
                -- Teleport to counter
                local counter = workspace.Stores[selectedStore].Counter
                if counter then
                    teleportCharacter(counter.Position + Vector3.new(0, 3, 0))
                    task.wait(0.1)
                end
                
                -- Purchase item
                for i = 1, itemsToBuy do
                    if not isPurchasing then break end
                    
                    local success, needID = purchaseItem(selectedStore)
                    if not success then
                        if needID then
                            -- This shouldn't happen as we already checked IDs
                            updateStatus("ID not found, aborting", Color3.fromRGB(255, 100, 100))
                            isPurchasing = false
                            break
                        else
                            updateStatus("Purchase failed", Color3.fromRGB(255, 100, 100))
                        end
                    else
                        remainingItems = remainingItems - 1
                        updateProgress(string.format("Remaining: %d/%d", remainingItems, totalItems))
                    end
                    
                    task.wait(0.1)
                    
                    -- Find and move purchased item
                    local purchasedItems = findPurchasedItems()
                    for _, purchased in pairs(purchasedItems) do
                        smoothTeleport(purchased, targetPosition)
                        renamePurchasedItems()
                    end
                end
            end
        end
        
        -- Return to original position
        if originalPosition and char and char.HumanoidRootPart then
            char.HumanoidRootPart.CFrame = CFrame.new(originalPosition)
        end
        
        -- Clean up
        isPurchasing = false
        StartButton.Visible = true
        StopButton.Visible = false
        
        if remainingItems == 0 then
            updateStatus("Purchase completed!", Color3.fromRGB(150, 255, 150))
        else
            updateStatus("Purchase stopped", Color3.fromRGB(255, 150, 0))
        end
        updateProgress("")
    end)()
end

-- Stop purchase function
local function stopPurchase()
    isPurchasing = false
    StartButton.Visible = true
    StopButton.Visible = false
    updateStatus("Stopping...", Color3.fromRGB(255, 150, 0))
end

-- Connect buttons
StartButton.MouseButton1Click:Connect(startPurchase)
StopButton.MouseButton1Click:Connect(stopPurchase)

-- Clean up when player leaves
Player.CharacterRemoving:Connect(function()
    ScreenGui:Destroy()
    if workspace:FindFirstChild("TargetPositionMarker") then
        workspace.TargetPositionMarker:Destroy()
    end
end)

-- Initialization complete
updateStatus("Ready to use")