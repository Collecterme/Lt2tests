local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

-- ID магазинов (по умолчанию -1)
local WoodRUsID = -1
local CarStoreID = -1
local FurnitureStoreID = -1
local LogicStoreID = -1
local ShackShopID = -1
local FineArtID = -1

-- RemoteEvents
local NPCDialog = ReplicatedStorage:WaitForChild("NPCDialog"):WaitForChild("PlayerChatted")
local ClientIsDragging = ReplicatedStorage:WaitForChild("Interaction"):WaitForChild("ClientIsDragging")

-- Создаем GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AutoBuyGUI"
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = game:GetService("CoreGui") or Player:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 300, 0, 350)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -175)
MainFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
MainFrame.BackgroundTransparency = 0.15
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

-- Заголовок
local Title = Instance.new("TextLabel")
Title.Text = "Lumber Auto Buyer"
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 20
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Size = UDim2.new(1, -10, 0, 30)
Title.Position = UDim2.new(0, 5, 0, 5)
Title.BackgroundTransparency = 1
Title.Parent = MainFrame

-- Кнопка настройки
local SetupButton = Instance.new("TextButton")
SetupButton.Name = "SetupButton"
SetupButton.Text = "Настроить магазины"
SetupButton.Font = Enum.Font.SourceSansSemibold
SetupButton.TextSize = 16
SetupButton.TextColor3 = Color3.new(1, 1, 1)
SetupButton.Size = UDim2.new(0.9, 0, 0, 35)
SetupButton.Position = UDim2.new(0.05, 0, 0.15, 0)
SetupButton.BackgroundColor3 = Color3.fromRGB(100, 100, 150)
SetupButton.AutoButtonColor = true
SetupButton.Parent = MainFrame

local UICornerSetup = Instance.new("UICorner")
UICornerSetup.CornerRadius = UDim.new(0, 6)
UICornerSetup.Parent = SetupButton

-- Выбор предмета
local ItemLabel = Instance.new("TextLabel")
ItemLabel.Text = "Предмет:"
ItemLabel.Font = Enum.Font.SourceSans
ItemLabel.TextSize = 16
ItemLabel.TextColor3 = Color3.new(0.9, 0.9, 0.9)
ItemLabel.Size = UDim2.new(0.9, 0, 0, 20)
ItemLabel.Position = UDim2.new(0.05, 0, 0.35, 0)
ItemLabel.BackgroundTransparency = 1
ItemLabel.Parent = MainFrame

local ItemDropdown = Instance.new("TextButton")
ItemDropdown.Name = "ItemDropdown"
ItemDropdown.Text = "Выберите предмет"
ItemDropdown.Font = Enum.Font.SourceSansSemibold
ItemDropdown.TextSize = 16
ItemDropdown.TextColor3 = Color3.new(1, 1, 1)
ItemDropdown.Size = UDim2.new(0.9, 0, 0, 30)
ItemDropdown.Position = UDim2.new(0.05, 0, 0.4, 0)
ItemDropdown.BackgroundColor3 = Color3.fromRGB(70, 70, 90)
ItemDropdown.AutoButtonColor = true
ItemDropdown.Parent = MainFrame

local UICornerItem = Instance.new("UICorner")
UICornerItem.CornerRadius = UDim.new(0, 6)
UICornerItem.Parent = ItemDropdown

-- Количество предметов
local QuantityLabel = Instance.new("TextLabel")
QuantityLabel.Text = "Количество:"
QuantityLabel.Font = Enum.Font.SourceSans
QuantityLabel.TextSize = 16
QuantityLabel.TextColor3 = Color3.new(0.9, 0.9, 0.9)
QuantityLabel.Size = UDim2.new(0.9, 0, 0, 20)
QuantityLabel.Position = UDim2.new(0.05, 0, 0.55, 0)
QuantityLabel.BackgroundTransparency = 1
QuantityLabel.Parent = MainFrame

local QuantityBox = Instance.new("TextBox")
QuantityBox.Name = "QuantityBox"
QuantityBox.Text = "1"
QuantityBox.Font = Enum.Font.SourceSans
QuantityBox.TextSize = 16
QuantityBox.TextColor3 = Color3.new(0, 0, 0)
QuantityBox.Size = UDim2.new(0.9, 0, 0, 30)
QuantityBox.Position = UDim2.new(0.05, 0, 0.6, 0)
QuantityBox.BackgroundColor3 = Color3.new(1, 1, 1)
QuantityBox.Parent = MainFrame

local UICornerQuantity = Instance.new("UICorner")
UICornerQuantity.CornerRadius = UDim.new(0, 6)
UICornerQuantity.Parent = QuantityBox

-- Кнопки
local StartButton = Instance.new("TextButton")
StartButton.Name = "StartButton"
StartButton.Text = "Начать покупку"
StartButton.Font = Enum.Font.SourceSansSemibold
StartButton.TextSize = 16
StartButton.TextColor3 = Color3.new(1, 1, 1)
StartButton.Size = UDim2.new(0.9, 0, 0, 35)
StartButton.Position = UDim2.new(0.05, 0, 0.75, 0)
StartButton.BackgroundColor3 = Color3.fromRGB(80, 160, 90)
StartButton.AutoButtonColor = true
StartButton.Parent = MainFrame

local UICornerStart = Instance.new("UICorner")
UICornerStart.CornerRadius = UDim.new(0, 6)
UICornerStart.Parent = StartButton

local StopButton = Instance.new("TextButton")
StopButton.Name = "StopButton"
StopButton.Text = "Остановить"
StopButton.Font = Enum.Font.SourceSansSemibold
StopButton.TextSize = 16
StopButton.TextColor3 = Color3.new(1, 1, 1)
StopButton.Size = UDim2.new(0.9, 0, 0, 35)
StopButton.Position = UDim2.new(0.05, 0, 0.85, 0)
StopButton.BackgroundColor3 = Color3.fromRGB(200, 80, 80)
StopButton.AutoButtonColor = true
StopButton.Visible = false
StopButton.Parent = MainFrame

local UICornerStop = Instance.new("UICorner")
UICornerStop.CornerRadius = UDim.new(0, 6)
UICornerStop.Parent = StopButton

-- Статус
local StatusLabel = Instance.new("TextLabel")
StatusLabel.Text = "Готов к работе"
StatusLabel.Font = Enum.Font.SourceSans
StatusLabel.TextSize = 14
StatusLabel.TextColor3 = Color3.new(0.9, 0.9, 0.9)
StatusLabel.Size = UDim2.new(0.9, 0, 0, 20)
StatusLabel.Position = UDim2.new(0.05, 0, 0.95, 0)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Parent = MainFrame

-- Прогресс
local ProgressLabel = Instance.new("TextLabel")
ProgressLabel.Text = "0/0"
ProgressLabel.Font = Enum.Font.SourceSans
ProgressLabel.TextSize = 14
ProgressLabel.TextColor3 = Color3.new(0.9, 0.9, 0.9)
ProgressLabel.Size = UDim2.new(0.9, 0, 0, 20)
ProgressLabel.Position = UDim2.new(0.05, 0, 0.65, 0)
ProgressLabel.BackgroundTransparency = 1
ProgressLabel.Parent = MainFrame

-- Переменные
local stores = {
    {Name = "WoodRUs", NPC = "Thom", SampleItem = "BasicHatchet", Configured = false},
    {Name = "CarStore", NPC = "Jenny", SampleItem = "Pickup1", Configured = false},
    {Name = "FineArt", NPC = "Timothy", SampleItem = "Painting3", Configured = false},
    {Name = "FurnitureStore", NPC = "Corey", SampleItem = "LightBulb", Configured = false},
    {Name = "LogicStore", NPC = "Lincoln", SampleItem = "NeonWireOrange", Configured = false},
    {Name = "ShackShop", NPC = "Bob", SampleItem = "Dynamite", Configured = false}
}

local allItems = {}
local selectedItem = nil
local isRunning = false
local stopRequested = false
local isSettingUp = false
local savedPosition = nil
local currentSetupStore = nil

-- Функции
local function updateStatus(text, color)
    StatusLabel.Text = text
    StatusLabel.TextColor3 = color or Color3.new(0.9, 0.9, 0.9)
end

local function updateProgress(current, total)
    ProgressLabel.Text = current.."/"..total
end

-- Функция для подсветки предмета
local function highlightItem(item, color)
    if item:FindFirstChild("ItemHighlight") then
        item.ItemHighlight:Destroy()
    end
    
    local highlight = Instance.new("Highlight")
    highlight.Name = "ItemHighlight"
    highlight.FillColor = color or Color3.fromRGB(0, 200, 100)
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    highlight.Parent = item
end

-- Функция для настройки магазинов
local function setupStores()
    if isSettingUp then return end
    
    local char = Player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then
        updateStatus("Персонаж не найден", Color3.fromRGB(255, 100, 100))
        return
    end
    
    savedPosition = char.HumanoidRootPart.Position
    isSettingUp = true
    SetupButton.Text = "Настройка..."
    
    -- Получаем список не настроенных магазинов
    local unconfiguredStores = {}
    for _, store in ipairs(stores) do
        if not store.Configured then
            table.insert(unconfiguredStores, store)
        end
    end
    
    if #unconfiguredStores == 0 then
        updateStatus("Все магазины настроены!", Color3.fromRGB(0, 255, 0))
        isSettingUp = false
        SetupButton.Text = "Настроить магазины"
        return
    end
    
    -- Создаем меню выбора магазина для настройки
    local dropdown = Instance.new("Frame")
    dropdown.Name = "StoreSetupDropdown"
    dropdown.Size = UDim2.new(0.9, 0, 0, math.min(200, #unconfiguredStores * 30 + 10))
    dropdown.Position = UDim2.new(0.05, 0, 0.15, 30)
    dropdown.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    dropdown.Parent = MainFrame
    
    local dropdownCorner = Instance.new("UICorner")
    dropdownCorner.CornerRadius = UDim.new(0, 6)
    dropdownCorner.Parent = dropdown
    
    local scroll = Instance.new("ScrollingFrame")
    scroll.Size = UDim2.new(1, -5, 1, -5)
    scroll.Position = UDim2.new(0, 5, 0, 5)
    scroll.BackgroundTransparency = 1
    scroll.ScrollBarThickness = 5
    scroll.Parent = dropdown
    
    local layout = Instance.new("UIListLayout")
    layout.Parent = scroll
    
    -- Добавляем магазины
    for _, store in ipairs(unconfiguredStores) do
        local button = Instance.new("TextButton")
        button.Text = store.Name
        button.Size = UDim2.new(1, 0, 0, 30)
        button.BackgroundColor3 = Color3.fromRGB(80, 80, 100)
        button.TextColor3 = Color3.new(1, 1, 1)
        button.Font = Enum.Font.SourceSansSemibold
        button.TextSize = 16
        button.Parent = scroll
        
        local buttonCorner = Instance.new("UICorner")
        buttonCorner.CornerRadius = UDim.new(0, 4)
        buttonCorner.Parent = button
        
        button.MouseButton1Click:Connect(function()
            currentSetupStore = store
            dropdown:Destroy()
            updateStatus("Нажмите на товар в магазине "..store.Name, Color3.fromRGB(255, 255, 150))
        end)
    end
    
    -- Закрытие при клике вне меню
    local connection
    connection = UserInputService.InputBegan:Connect(function(input, processed)
        if not processed and input.UserInputType == Enum.UserInputType.MouseButton1 then
            local mousePos = UserInputService:GetMouseLocation()
            local absPos = dropdown.AbsolutePosition
            local absSize = dropdown.AbsoluteSize
            
            if not (mousePos.X >= absPos.X and mousePos.X <= absPos.X + absSize.X and
                   mousePos.Y >= absPos.Y and mousePos.Y <= absPos.Y + absSize.Y) then
                dropdown:Destroy()
                connection:Disconnect()
                isSettingUp = false
                SetupButton.Text = "Настроить магазины"
                updateStatus("Настройка отменена", Color3.fromRGB(255, 150, 0))
            end
        end
    end)
end

-- Обработчик клика по предмету при настройке
local function handleSetupClick(target)
    if not isSettingUp or not currentSetupStore then return end
    
    -- Проверяем, что кликнули на предмет из текущего магазина
    local item = target
    while item and item ~= workspace do
        if item:FindFirstChild("BoxItemName") and item:IsA("Model") then
            -- Проверяем, что это предмет из нужного магазина
            local storeFolder = item:FindFirstAncestor(currentSetupStore.Name)
            if storeFolder and storeFolder:IsA("Model") and storeFolder.Parent == workspace.Stores then
                -- Нашли предмет для настройки
                highlightItem(item, Color3.fromRGB(0, 200, 200))
                
                -- Добавляем предмет в список
                table.insert(allItems, {
                    Name = item.BoxItemName.Value,
                    Box = item,
                    Store = currentSetupStore.Name
                })
                
                -- Помечаем магазин как настроенный
                currentSetupStore.Configured = true
                
                -- Возвращаем игрока на сохраненную позицию
                teleportPlayer(savedPosition)
                
                -- Обновляем статус
                updateStatus("Магазин "..currentSetupStore.Name.." настроен!", Color3.fromRGB(0, 255, 0))
                
                -- Сбрасываем состояние настройки
                isSettingUp = false
                currentSetupStore = nil
                SetupButton.Text = "Настроить магазины"
                
                return
            end
        end
        item = item.Parent
    end
end

-- Мгновенная телепортация предмета
local function teleportItem(item, position)
    local mainPart = item:FindFirstChild("Main") or item:FindFirstChildWhichIsA("BasePart")
    if not mainPart then return false end
    
    -- Начинаем перетаскивание
    ClientIsDragging:FireServer(item)
    task.wait(0.1)
    
    -- Устанавливаем позицию
    mainPart.CFrame = CFrame.new(position)
    ClientIsDragging:FireServer(item)
    
    return true
end

-- Телепортация игрока
local function teleportPlayer(position)
    local char = Player.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        char.HumanoidRootPart.CFrame = CFrame.new(position)
        return true
    end
    return false
end

-- Поиск купленного предмета
local function findPurchasedItem()
    local playerName = Player.Name
    for _, model in ipairs(workspace.PlayerModels:GetChildren()) do
        if string.find(model.Name, "Box Purchased by "..playerName) then
            return model
        end
    end
    return nil
end

-- Переименование купленного предмета
local function renamePurchasedItem(item)
    local newName = tostring(#workspace.PlayerModels:GetChildren())
    item.Name = newName
    return newName
end

-- Покупка предмета
local function purchaseItem(storeName, itemName)
    local storeData
    for _, data in ipairs(stores) do
        if data.Name == storeName then
            storeData = data
            break
        end
    end
    
    if not storeData then return false end
    
    local args = {
        [1] = {
            ["ID"] = _G[storeName.."ID"] or -1,
            ["Character"] = workspace:WaitForChild("Stores"):WaitForChild(storeName):WaitForChild(storeData.NPC),
            ["Name"] = storeData.NPC,
            ["Dialog"] = workspace:WaitForChild("Stores"):WaitForChild(storeName):WaitForChild(storeData.NPC):WaitForChild("Dialog")
        },
        [2] = "ConfirmPurchase"
    }
    
    NPCDialog:InvokeServer(unpack(args))
    return true
end

-- Автоматическая покупка
local function autoBuyItems()
    if not selectedItem or not tonumber(QuantityBox.Text) or tonumber(QuantityBox.Text) < 1 then
        updateStatus("Выберите предмет и укажите количество", Color3.fromRGB(255, 150, 0))
        return
    end
    
    local quantity = math.floor(tonumber(QuantityBox.Text))
    if quantity <= 0 then return end
    
    isRunning = true
    stopRequested = false
    StartButton.Visible = false
    StopButton.Visible = true
    
    -- Сохраняем текущую позицию
    local char = Player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then
        updateStatus("Персонаж не найден", Color3.fromRGB(255, 100, 100))
        isRunning = false
        StartButton.Visible = true
        StopButton.Visible = false
        return
    end
    
    local savedPosition = char.HumanoidRootPart.Position
    
    -- Находим стойку магазина
    local counter = workspace.Stores[selectedItem.Store]:FindFirstChild("Counter")
    if not counter then
        updateStatus("Стойка не найдена", Color3.fromRGB(255, 100, 100))
        isRunning = false
        StartButton.Visible = true
        StopButton.Visible = false
        return
    end
    
    updateStatus("Начата покупка...", Color3.fromRGB(150, 255, 150))
    
    local purchasedCount = 0
    
    while purchasedCount < quantity and not stopRequested do
        updateProgress(purchasedCount, quantity)
        
        -- Телепортируем предмет к стойке
        teleportItem(selectedItem.Box, counter.Position + Vector3.new(0, 2, 0))
        task.wait(0.1)
        
        -- Телепортируем игрока к стойке
        teleportPlayer(counter.Position + Vector3.new(0, 0, -2))
        task.wait(0.1)
        
        -- Покупаем предмет
        purchaseItem(selectedItem.Store, selectedItem.Name)
        task.wait(0.1)
        
        -- Ищем купленный предмет
        local purchased = findPurchasedItem()
        if purchased then
            -- Переименовываем
            renamePurchasedItem(purchased)
            
            -- Телепортируем к сохраненной позиции
            teleportItem(purchased, savedPosition + Vector3.new(0, 3, 0))
            task.wait(0.1)
            
            purchasedCount = purchasedCount + 1
            updateProgress(purchasedCount, quantity)
        else
            updateStatus("Ошибка покупки, пробуем снова...", Color3.fromRGB(255, 150, 0))
        end
    end
    
    -- Возвращаем игрока
    teleportPlayer(savedPosition)
    
    if stopRequested then
        updateStatus("Покупка остановлена", Color3.fromRGB(255, 150, 0))
    else
        updateStatus("Покупка завершена!", Color3.fromRGB(0, 255, 0))
    end
    
    isRunning = false
    stopRequested = false
    StartButton.Visible = true
    StopButton.Visible = false
end

-- Функция для создания выпадающего списка предметов
local function createItemDropdown()
    if #allItems == 0 then
        updateStatus("Нет доступных предметов", Color3.fromRGB(255, 100, 100))
        return
    end
    
    -- Удаляем старый дропдаун, если есть
    local oldDropdown = MainFrame:FindFirstChild("ItemDropdownMenu")
    if oldDropdown then oldDropdown:Destroy() end
    
    -- Сортируем предметы по алфавиту
    table.sort(allItems, function(a, b) return a.Name < b.Name end)
    
    -- Создаем новый дропдаун
    local dropdown = Instance.new("Frame")
    dropdown.Name = "ItemDropdownMenu"
    dropdown.Size = UDim2.new(0.9, 0, 0, math.min(200, #allItems * 30 + 10))
    dropdown.Position = UDim2.new(0.05, 0, 0.4, 30)
    dropdown.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    dropdown.Parent = MainFrame
    
    local dropdownCorner = Instance.new("UICorner")
    dropdownCorner.CornerRadius = UDim.new(0, 6)
    dropdownCorner.Parent = dropdown
    
    local scroll = Instance.new("ScrollingFrame")
    scroll.Size = UDim2.new(1, -5, 1, -5)
    scroll.Position = UDim2.new(0, 5, 0, 5)
    scroll.BackgroundTransparency = 1
    scroll.ScrollBarThickness = 5
    scroll.Parent = dropdown
    
    local layout = Instance.new("UIListLayout")
    layout.Parent = scroll
    
    -- Добавляем предметы
    for _, item in ipairs(allItems) do
        local button = Instance.new("TextButton")
        button.Text = item.Name
        button.Size = UDim2.new(1, 0, 0, 30)
        button.BackgroundColor3 = Color3.fromRGB(80, 80, 100)
        button.TextColor3 = Color3.new(1, 1, 1)
        button.Font = Enum.Font.SourceSansSemibold
        button.TextSize = 16
        button.Parent = scroll
        
        local buttonCorner = Instance.new("UICorner")
        buttonCorner.CornerRadius = UDim.new(0, 4)
        buttonCorner.Parent = button
        
        button.MouseButton1Click:Connect(function()
            ItemDropdown.Text = item.Name
            selectedItem = item
            dropdown:Destroy()
            updateStatus("Выбран: "..item.Name, Color3.fromRGB(150, 255, 150))
        end)
    end
    
    -- Закрытие при клике вне меню
    local connection
    connection = UserInputService.InputBegan:Connect(function(input, processed)
        if not processed and input.UserInputType == Enum.UserInputType.MouseButton1 then
            local mousePos = UserInputService:GetMouseLocation()
            local absPos = dropdown.AbsolutePosition
            local absSize = dropdown.AbsoluteSize
            
            if not (mousePos.X >= absPos.X and mousePos.X <= absPos.X + absSize.X and
                   mousePos.Y >= absPos.Y and mousePos.Y <= absPos.Y + absSize.Y) then
                dropdown:Destroy()
                connection:Disconnect()
            end
        end
    end)
end

-- Обработчики событий
SetupButton.MouseButton1Click:Connect(setupStores)
ItemDropdown.MouseButton1Click:Connect(createItemDropdown)

StartButton.MouseButton1Click:Connect(function()
    if not isRunning then
        autoBuyItems()
    end
end)

StopButton.MouseButton1Click:Connect(function()
    if isRunning then
        stopRequested = true
    end
end)

QuantityBox.FocusLost:Connect(function()
    local num = tonumber(QuantityBox.Text)
    if not num or num < 1 then
        QuantityBox.Text = "1"
    else
        QuantityBox.Text = tostring(math.floor(num))
    end
end)

-- Обработчик кликов мыши
game:GetService("UserInputService").InputBegan:Connect(function(input, processed)
    if not processed and input.UserInputType == Enum.UserInputType.MouseButton1 and isSettingUp then
        local target = game:GetService("UserInputService"):GetMouseTarget()
        if target then
            handleSetupClick(target)
        end
    end
end)

-- Инициализация
for _, store in ipairs(stores) do
    _G[store.Name.."ID"] = -1
end

updateStatus("Готов к работе")