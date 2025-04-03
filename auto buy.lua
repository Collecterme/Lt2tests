local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

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

-- Выбор магазина
local StoreLabel = Instance.new("TextLabel")
StoreLabel.Text = "Магазин:"
StoreLabel.Font = Enum.Font.SourceSans
StoreLabel.TextSize = 16
StoreLabel.TextColor3 = Color3.new(0.9, 0.9, 0.9)
StoreLabel.Size = UDim2.new(0.9, 0, 0, 20)
StoreLabel.Position = UDim2.new(0.05, 0, 0.15, 0)
StoreLabel.BackgroundTransparency = 1
StoreLabel.Parent = MainFrame

local StoreDropdown = Instance.new("TextButton")
StoreDropdown.Name = "StoreDropdown"
StoreDropdown.Text = "Все магазины"
StoreDropdown.Font = Enum.Font.SourceSansSemibold
StoreDropdown.TextSize = 16
StoreDropdown.TextColor3 = Color3.new(1, 1, 1)
StoreDropdown.Size = UDim2.new(0.9, 0, 0, 30)
StoreDropdown.Position = UDim2.new(0.05, 0, 0.2, 0)
StoreDropdown.BackgroundColor3 = Color3.fromRGB(70, 70, 90)
StoreDropdown.AutoButtonColor = true
StoreDropdown.Parent = MainFrame

local UICornerDropdown = Instance.new("UICorner")
UICornerDropdown.CornerRadius = UDim.new(0, 6)
UICornerDropdown.Parent = StoreDropdown

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
QuantityLine.Size = UDim2.new(0.9, 0, 0, 30)
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
    {Name = "WoodRUs", NPC = "Thom", SampleItem = "BasicHatchet"},
    {Name = "CarStore", NPC = "Jenny", SampleItem = "Pickup1"},
    {Name = "FineArt", NPC = "Timothy", SampleItem = "Painting3"},
    {Name = "FurnitureStore", NPC = "Corey", SampleItem = "LightBulb"},
    {Name = "LogicStore", NPC = "Lincoln", SampleItem = "NeonWireOrange"},
    {Name = "ShackShop", NPC = "Bob", SampleItem = "Dynamite"}
}

local allItems = {}
local selectedStore = nil
local selectedItem = nil
local isRunning = false
local stopRequested = false

-- Функции
local function updateStatus(text, color)
    StatusLabel.Text = text
    StatusLabel.TextColor3 = color or Color3.new(0.9, 0.9, 0.9)
end

local function updateProgress(current, total)
    ProgressLabel.Text = current.."/"..total
end

-- Поиск стоек для покупки
local function getStoreCounters()
    local counters = {}
    for _, store in ipairs(stores) do
        local counter = workspace.Stores[store.Name]:FindFirstChild("Counter")
        if counter then
            counters[store.Name] = counter
        end
    end
    return counters
end

-- Поиск предметов для покупки
local function scanShopItems()
    local items = {}
    local itemNames = {}
    
    -- Сканируем все ShopItems в Stores
    for _, storeFolder in ipairs(workspace.Stores:GetChildren()) do
        local shopItems = storeFolder:FindFirstChild("ShopItems")
        if shopItems then
            for _, box in ipairs(shopItems:GetChildren()) do
                if box.Name == "Box" then
                    local itemName = box:FindFirstChild("BoxItemName")
                    if itemName and itemName.Value ~= "" and not itemNames[itemName.Value] then
                        table.insert(items, {
                            Name = itemName.Value,
                            Box = box,
                            Store = storeFolder.Name
                        })
                        itemNames[itemName.Value] = true
                    end
                end
            end
        end
    end
    
    return items
end

-- Заполнение списка магазинов
local function populateStoreDropdown()
    StoreDropdown.Text = "Все магазины"
    selectedStore = nil
end

-- Заполнение списка предметов
local function populateItemDropdown()
    ItemDropdown.Text = "Выберите предмет"
    selectedItem = nil
    
    allItems = scanShopItems()
    
    -- Если выбран магазин, фильтруем предметы
    local filteredItems = {}
    if selectedStore then
        for _, item in ipairs(allItems) do
            if item.Store == selectedStore then
                table.insert(filteredItems, item)
            end
        end
    else
        filteredItems = allItems
    end
    
    -- Сортируем по алфавиту
    table.sort(filteredItems, function(a, b) return a.Name < b.Name end)
    
    return filteredItems
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
        if model.Name == "Box Purchased by "..playerName then
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

-- Определение ID магазина
local function determineStoreID(storeName)
    local storeData
    for _, data in ipairs(stores) do
        if data.Name == storeName then
            storeData = data
            break
        end
    end
    
    if not storeData then return false end
    
    -- Сохраняем текущую позицию
    local char = Player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return false end
    local savedPosition = char.HumanoidRootPart.Position
    
    -- Находим стойку
    local counter = workspace.Stores[storeName]:FindFirstChild("Counter")
    if not counter then return false end
    
    -- Находим пример предмета
    local sampleItem
    for _, item in ipairs(allItems) do
        if item.Name == storeData.SampleItem and item.Store == storeName then
            sampleItem = item.Box
            break
        end
    end
    
    if not sampleItem then return false end
    
    -- Создаем GUI для подбора ID
    local IDGui = Instance.new("ScreenGui")
    IDGui.Name = "IDFinderGUI"
    IDGui.Parent = ScreenGui
    
    local IDFrame = Instance.new("Frame")
    IDFrame.Size = UDim2.new(0, 250, 0, 100)
    IDFrame.Position = UDim2.new(0.5, -125, 0.7, -50)
    IDFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    IDFrame.BackgroundTransparency = 0.15
    IDFrame.Parent = IDGui
    
    local IDCorner = Instance.new("UICorner")
    IDCorner.CornerRadius = UDim.new(0, 8)
    IDCorner.Parent = IDFrame
    
    local IDTitle = Instance.new("TextLabel")
    IDTitle.Text = "Подбор ID для "..storeName
    IDTitle.Font = Enum.Font.SourceSansBold
    IDTitle.TextSize = 18
    IDTitle.TextColor3 = Color3.new(1, 1, 1)
    IDTitle.Size = UDim2.new(1, -10, 0, 30)
    IDTitle.Position = UDim2.new(0, 5, 0, 5)
    IDTitle.BackgroundTransparency = 1
    IDTitle.Parent = IDFrame
    
    local IDStatus = Instance.new("TextLabel")
    IDStatus.Text = "Попытка ID: 0"
    IDStatus.Font = Enum.Font.SourceSans
    IDStatus.TextSize = 16
    IDStatus.TextColor3 = Color3.new(0.9, 0.9, 0.9)
    IDStatus.Size = UDim2.new(1, -10, 0, 30)
    IDStatus.Position = UDim2.new(0, 5, 0, 35)
    IDStatus.BackgroundTransparency = 1
    IDStatus.Parent = IDFrame
    
    local IDProgress = Instance.new("TextLabel")
    IDProgress.Text = "Идет процесс..."
    IDProgress.Font = Enum.Font.SourceSans
    IDProgress.TextSize = 14
    IDProgress.TextColor3 = Color3.new(0.9, 0.9, 0.9)
    IDProgress.Size = UDim2.new(1, -10, 0, 20)
    IDProgress.Position = UDim2.new(0, 5, 0, 70)
    IDProgress.BackgroundTransparency = 1
    IDProgress.Parent = IDFrame
    
    -- Подбор ID
    local foundID = false
    local currentID = 0
    
    while not foundID and not stopRequested do
        currentID = currentID + 1
        IDStatus.Text = "Попытка ID: "..currentID
        
        -- Устанавливаем ID
        _G[storeName.."ID"] = currentID
        
        -- Телепортируем предмет к стойке
        teleportItem(sampleItem, counter.Position + Vector3.new(0, 2, 0))
        task.wait(0.1)
        
        -- Телепортируем игрока к стойке
        teleportPlayer(counter.Position + Vector3.new(0, 0, -2))
        task.wait(0.1)
        
        -- Пытаемся купить
        purchaseItem(storeName, storeData.SampleItem)
        task.wait(0.1)
        
        -- Проверяем, купили ли мы предмет
        local purchased = findPurchasedItem()
        if purchased then
            foundID = true
            renamePurchasedItem(purchased)
            IDProgress.Text = "Найден ID: "..currentID
            _G[storeName.."ID"] = currentID
        end
    end
    
    -- Восстанавливаем позицию
    teleportPlayer(savedPosition)
    task.wait(0.5)
    
    -- Удаляем GUI
    IDGui:Destroy()
    
    return foundID
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
    
    -- Проверяем ID магазина
    if _G[selectedItem.Store.."ID"] == -1 then
        updateStatus("Определяем ID магазина...", Color3.fromRGB(255, 255, 150))
        local success = determineStoreID(selectedItem.Store)
        if not success then
            updateStatus("Не удалось определить ID", Color3.fromRGB(255, 100, 100))
            isRunning = false
            StartButton.Visible = true
            StopButton.Visible = false
            return
        end
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

-- Обработчики событий
StoreDropdown.MouseButton1Click:Connect(function()
    -- Создаем меню выбора магазина
    local dropdown = Instance.new("Frame")
    dropdown.Size = UDim2.new(0.9, 0, 0, 150)
    dropdown.Position = UDim2.new(0.05, 0, 0.2, 30)
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
    
    -- Добавляем "Все магазины"
    local allButton = Instance.new("TextButton")
    allButton.Text = "Все магазины"
    allButton.Size = UDim2.new(1, 0, 0, 30)
    allButton.BackgroundColor3 = Color3.fromRGB(80, 80, 100)
    allButton.TextColor3 = Color3.new(1, 1, 1)
    allButton.Font = Enum.Font.SourceSansSemibold
    allButton.TextSize = 16
    allButton.Parent = scroll
    
    local allCorner = Instance.new("UICorner")
    allCorner.CornerRadius = UDim.new(0, 4)
    allCorner.Parent = allButton
    
    allButton.MouseButton1Click:Connect(function()
        StoreDropdown.Text = "Все магазины"
        selectedStore = nil
        populateItemDropdown()
        dropdown:Destroy()
    end)
    
    -- Добавляем магазины
    for _, store in ipairs(stores) do
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
            StoreDropdown.Text = store.Name
            selectedStore = store.Name
            populateItemDropdown()
            dropdown:Destroy()
        end)
    end
    
    -- Закрытие при клике вне меню
    local connection
    connection = game:GetService("UserInputService").InputBegan:Connect(function(input, processed)
        if not processed and input.UserInputType == Enum.UserInputType.MouseButton1 then
            local mousePos = game:GetService("UserInputService"):GetMouseLocation()
            local absPos = dropdown.AbsolutePosition
            local absSize = dropdown.AbsoluteSize
            
            if not (mousePos.X >= absPos.X and mousePos.X <= absPos.X + absSize.X and
                   mousePos.Y >= absPos.Y and mousePos.Y <= absPos.Y + absSize.Y) then
                dropdown:Destroy()
                connection:Disconnect()
            end
        end
    end)
end)

ItemDropdown.MouseButton1Click:Connect(function()
    if #allItems == 0 then
        allItems = scanShopItems()
    end
    
    local filteredItems = populateItemDropdown()
    if #filteredItems == 0 then
        updateStatus("Нет доступных предметов", Color3.fromRGB(255, 100, 100))
        return
    end
    
    -- Создаем меню выбора предмета
    local dropdown = Instance.new("Frame")
    dropdown.Size = UDim2.new(0.9, 0, 0, math.min(200, #filteredItems * 30 + 10))
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
    for _, item in ipairs(filteredItems) do
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
    connection = game:GetService("UserInputService").InputBegan:Connect(function(input, processed)
        if not processed and input.UserInputType == Enum.UserInputType.MouseButton1 then
            local mousePos = game:GetService("UserInputService"):GetMouseLocation()
            local absPos = dropdown.AbsolutePosition
            local absSize = dropdown.AbsoluteSize
            
            if not (mousePos.X >= absPos.X and mousePos.X <= absPos.X + absSize.X and
                   mousePos.Y >= absPos.Y and mousePos.Y <= absPos.Y + absSize.Y) then
                dropdown:Destroy()
                connection:Disconnect()
            end
        end
    end)
end)

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

-- Инициализация
for _, store in ipairs(stores) do
    _G[store.Name.."ID"] = -1
end

populateStoreDropdown()
updateStatus("Готов к работе")