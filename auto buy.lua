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

-- [Остальной код интерфейса остается таким же...]

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

-- Функция для глубокого поиска всех BoxItemName в магазине
local function findItemsInStore(storeName)
    local items = {}
    local store = workspace.Stores:FindFirstChild(storeName)
    if not store then return items end
    
    local shopItems = store:FindFirstChild("ShopItems")
    if not shopItems then return items end
    
    -- Рекурсивно ищем все BoxItemName в магазине
    for _, descendant in ipairs(shopItems:GetDescendants()) do
        if descendant.Name == "BoxItemName" and descendant:IsA("StringValue") then
            local box = descendant.Parent
            if box and box:IsA("Model") then
                local mainPart = box:FindFirstChild("Main") or box:FindFirstChildWhichIsA("BasePart")
                if mainPart then
                    table.insert(items, {
                        Name = descendant.Value,
                        Box = box,
                        Store = storeName,
                        MainPart = mainPart
                    })
                end
            end
        end
    end
    
    return items
end

-- Улучшенный поиск всех предметов во всех магазинах
local function scanAllShopItems()
    local items = {}
    local itemNames = {}
    
    for _, store in ipairs(stores) do
        local storeItems = findItemsInStore(store.Name)
        for _, item in ipairs(storeItems) do
            if not itemNames[item.Name] then
                table.insert(items, item)
                itemNames[item.Name] = true
            end
        end
    end
    
    return items
end

-- Функция для поиска стойки магазина
local function getStoreCounter(storeName)
    local store = workspace.Stores:FindFirstChild(storeName)
    if not store then return nil end
    return store:FindFirstChild("Counter")
end

-- Мгновенная телепортация предмета
local function teleportItem(item, position)
    if not item or not item.Parent then return false end
    if not item.MainPart then return false end
    
    -- Начинаем перетаскивание
    ClientIsDragging:FireServer(item.Box)
    task.wait(0.1)
    
    -- Устанавливаем позицию
    item.MainPart.CFrame = CFrame.new(position)
    ClientIsDragging:FireServer(item.Box)
    
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
    local searchPattern = "Box Purchased by "..playerName
    
    for _, model in ipairs(workspace.PlayerModels:GetChildren()) do
        if string.find(model.Name, searchPattern) then
            local mainPart = model:FindFirstChild("Main") or model:FindFirstChildWhichIsA("BasePart")
            if mainPart then
                return {
                    Model = model,
                    MainPart = mainPart
                }
            end
        end
    end
    return nil
end

-- Переименование купленного предмета
local function renamePurchasedItem(item)
    if not item or not item.Model then return end
    local newName = "PurchasedItem_"..tick()
    item.Model.Name = newName
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

-- Функция для поиска стойки магазина
local function getStoreCounter(storeName)
    local store = workspace.Stores:FindFirstChild(storeName)
    if not store then return nil end
    return store:FindFirstChild("Counter")
end

-- Мгновенная телепортация предмета
local function teleportItem(item, position)
    if not item or not item.Parent then return false end
    if not item.MainPart then return false end
    
    -- Начинаем перетаскивание
    ClientIsDragging:FireServer(item.Box)
    task.wait(0.1)
    
    -- Устанавливаем позицию
    item.MainPart.CFrame = CFrame.new(position)
    ClientIsDragging:FireServer(item.Box)
    
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
    local searchPattern = "Box Purchased by "..playerName
    
    for _, model in ipairs(workspace.PlayerModels:GetChildren()) do
        if string.find(model.Name, searchPattern) then
            local mainPart = model:FindFirstChild("Main") or model:FindFirstChildWhichIsA("BasePart")
            if mainPart then
                return {
                    Model = model,
                    MainPart = mainPart
                }
            end
        end
    end
    return nil
end

-- Переименование купленного предмета
local function renamePurchasedItem(item)
    if not item or not item.Model then return end
    local newName = "PurchasedItem_"..tick()
    item.Model.Name = newName
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

-- Основная функция автоматической покупки
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
    local counter = getStoreCounter(selectedItem.Store)
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
        if not teleportItem(selectedItem, counter.Position + Vector3.new(0, 2, 0)) then
            updateStatus("Ошибка: предмет не найден", Color3.fromRGB(255, 100, 100))
            break
        end
        task.wait(0.1)
        
        -- Телепортируем игрока к стойке
        teleportPlayer(counter.Position + Vector3.new(0, 0, -2))
        task.wait(0.1)
        
        -- Покупаем предмет
        purchaseItem(selectedItem.Store, selectedItem.Name)
        task.wait(0.3)
        
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

-- [Остальные функции интерфейса и обработчики событий остаются без изменений...]

-- Инициализация при запуске
for _, store in ipairs(stores) do
    _G[store.Name.."ID"] = -1
end

-- Первоначальное сканирование предметов
task.spawn(function()
    updateStatus("Сканируем предметы...", Color3.fromRGB(255, 255, 150))
    allItems = scanAllShopItems()
    if #allItems > 0 then
        updateStatus("Готов к работе. Найдено "..#allItems.." предметов", Color3.fromRGB(150, 255, 150))
    else
        updateStatus("Предметы не найдены!", Color3.fromRGB(255, 100, 100))
    end
end)