local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- Утилиты
local function create(instanceType, properties)
    local instance = Instance.new(instanceType)
    for property, value in pairs(properties) do
        instance[property] = value
    end
    return instance
end

-- Загрузка данных о предметах
local itemsData = {}
local success, response = pcall(function()
    return HttpService:GetAsync("https://raw.githubusercontent.com/Collecterme/Lt2tests/refs/heads/main/shopitems.txt")
end)

if success then
    for line in response:gmatch("[^\r\n]+") do
        local x, y, z, itemName, storeName = line:match("XYZ =%s*{(.-),(.-),(.-)}; ItemName =%s*{(.-)}; StoreName =%s*{(.-)}")
        if x and y and z and itemName and storeName then
            table.insert(itemsData, {
                position = Vector3.new(tonumber(x), tonumber(y), tonumber(z)),
                itemName = itemName,
                storeName = storeName
            })
        end
    end
else
    warn("Не удалось загрузить данные о предметах: " .. tostring(response))
    return
end

-- Создание маркеров для предметов
local autobuyFolder = create("Folder", {
    Name = "autobuy",
    Parent = Workspace
})

local itemMarkers = {}
for i, data in ipairs(itemsData) do
    local itemName = data.itemName
    local count = 1
    while itemMarkers[itemName.."_"..count] do
        count = count + 1
    end
    
    local marker = create("Part", {
        Name = itemName.."_"..count,
        Position = data.position,
        Size = Vector3.new(0.2, 0.2, 0.2),
        Shape = Enum.PartType.Ball,
        Anchored = true,
        CanCollide = false,
        Transparency = 0.7,
        Color = Color3.fromRGB(0, 255, 0),
        Parent = create("Folder", {
            Name = itemName,
            Parent = autobuyFolder
        })
    })
    
    itemMarkers[itemName.."_"..count] = {
        marker = marker,
        storeName = data.storeName,
        position = data.position
    }
end

-- ID магазинов
local storeIDs = {
    WoodRUs = -1,
    CarStore = -1,
    FurnitureStore = -1,
    ShackShop = -1,
    LogicStore = -1,
    FineArt = -1
}

-- Функции телепортации из оригинального скрипта
local ClientIsDragging = ReplicatedStorage:WaitForChild("Interaction"):WaitForChild("ClientIsDragging")

local function instantTeleportItem(item, targetPos)
    if not item or not item.Parent then return false end
    
    local mainPart = item:FindFirstChild("Main") or item:FindFirstChildWhichIsA("BasePart")
    if not mainPart then return false end

    -- Фиксация позиции
    for i = 1, 3 do
        ClientIsDragging:FireServer(item)
        mainPart.CFrame = CFrame.new(targetPos)
        task.wait(0.1)
    end

    return true
end

local function smoothTeleportItem(item, targetPos)
    if not item or not item.Parent then return false end
    
    local mainPart = item:FindFirstChild("Main") or item:FindFirstChildWhichIsA("BasePart")
    if not mainPart then return false end

    ClientIsDragging:FireServer(item)
    task.wait(0.1)

    local tweenInfo = TweenInfo.new(
        1.2,
        Enum.EasingStyle.Quad,
        Enum.EasingDirection.Out
    )

    local tween = TweenService:Create(
        mainPart,
        tweenInfo,
        {CFrame = CFrame.new(targetPos)}
    )

    local connection
    connection = RunService.Heartbeat:Connect(function()
        ClientIsDragging:FireServer(item)
    end)

    tween:Play()
    tween.Completed:Wait()
    connection:Disconnect()

    if item.Parent then
        mainPart.CFrame = CFrame.new(targetPos)
        ClientIsDragging:FireServer(item)
    end

    return true
end

-- Создание GUI
local ScreenGui = create("ScreenGui", {
    Name = "AutoBuyGUI",
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    Parent = game:GetService("CoreGui") or Player:WaitForChild("PlayerGui")
})

local MainFrame = create("Frame", {
    Size = UDim2.new(0, 300, 0, 350),
    Position = UDim2.new(0.5, -150, 0.5, -175),
    BackgroundColor3 = Color3.fromRGB(45, 45, 55),
    BackgroundTransparency = 0.15,
    Active = true,
    Parent = ScreenGui
})

create("UICorner", {
    CornerRadius = UDim.new(0, 8),
    Parent = MainFrame
})

-- Заголовок
local Title = create("TextLabel", {
    Text = "Auto Buy",
    Font = Enum.Font.SourceSansBold,
    TextSize = 18,
    TextColor3 = Color3.new(1, 1, 1),
    Size = UDim2.new(1, -10, 0, 30),
    Position = UDim2.new(0, 5, 0, 5),
    BackgroundTransparency = 1,
    Parent = MainFrame
})

-- Выбор магазина
local StoreSelection = create("TextButton", {
    Text = "Выберите магазин",
    Font = Enum.Font.SourceSansSemibold,
    TextSize = 16,
    TextColor3 = Color3.new(1, 1, 1),
    Size = UDim2.new(0.9, 0, 0, 35),
    Position = UDim2.new(0.05, 0, 0.1, 0),
    BackgroundColor3 = Color3.fromRGB(70, 120, 200),
    AutoButtonColor = true,
    Parent = MainFrame
})

create("UICorner", {
    CornerRadius = UDim.new(0, 6),
    Parent = StoreSelection
})

-- Выбор предмета
local ItemSelection = create("TextButton", {
    Text = "Выберите предмет",
    Font = Enum.Font.SourceSansSemibold,
    TextSize = 16,
    TextColor3 = Color3.new(1, 1, 1),
    Size = UDim2.new(0.9, 0, 0, 35),
    Position = UDim2.new(0.05, 0, 0.25, 0),
    BackgroundColor3 = Color3.fromRGB(70, 120, 200),
    AutoButtonColor = true,
    Parent = MainFrame
})

create("UICorner", {
    CornerRadius = UDim.new(0, 6),
    Parent = ItemSelection
})

-- Количество
local QuantityInput = create("TextBox", {
    Text = "1",
    Font = Enum.Font.SourceSans,
    TextSize = 16,
    TextColor3 = Color3.new(0, 0, 0),
    Size = UDim2.new(0.9, 0, 0, 30),
    Position = UDim2.new(0.05, 0, 0.4, 0),
    BackgroundColor3 = Color3.new(1, 1, 1),
    PlaceholderText = "Количество",
    Parent = MainFrame
})

create("UICorner", {
    CornerRadius = UDim.new(0, 6),
    Parent = QuantityInput
})

-- Кнопки управления
local StartButton = create("TextButton", {
    Text = "Начать покупку",
    Font = Enum.Font.SourceSansSemibold,
    TextSize = 16,
    TextColor3 = Color3.new(1, 1, 1),
    Size = UDim2.new(0.9, 0, 0, 35),
    Position = UDim2.new(0.05, 0, 0.55, 0),
    BackgroundColor3 = Color3.fromRGB(80, 160, 90),
    AutoButtonColor = true,
    Parent = MainFrame
})

create("UICorner", {
    CornerRadius = UDim.new(0, 6),
    Parent = StartButton
})

local StopButton = create("TextButton", {
    Text = "Остановить",
    Font = Enum.Font.SourceSansSemibold,
    TextSize = 16,
    TextColor3 = Color3.new(1, 1, 1),
    Size = UDim2.new(0.9, 0, 0, 35),
    Position = UDim2.new(0.05, 0, 0.7, 0),
    BackgroundColor3 = Color3.fromRGB(200, 80, 80),
    AutoButtonColor = true,
    Parent = MainFrame
})

create("UICorner", {
    CornerRadius = UDim.new(0, 6),
    Parent = StopButton
})

-- Статус
local StatusLabel = create("TextLabel", {
    Text = "Готов к работе",
    Font = Enum.Font.SourceSans,
    TextSize = 14,
    TextColor3 = Color3.new(0.9, 0.9, 0.9),
    Size = UDim2.new(0.9, 0, 0, 20),
    Position = UDim2.new(0.05, 0, 0.85, 0),
    BackgroundTransparency = 1,
    Parent = MainFrame
})

-- Прогресс
local ProgressLabel = create("TextLabel", {
    Text = "Куплено: 0/0",
    Font = Enum.Font.SourceSans,
    TextSize = 14,
    TextColor3 = Color3.new(0.9, 0.9, 0.9),
    Size = UDim2.new(0.9, 0, 0, 20),
    Position = UDim2.new(0.05, 0, 0.9, 0),
    BackgroundTransparency = 1,
    Parent = MainFrame
})

-- Списки магазинов и предметов
local StoreList = create("ScrollingFrame", {
    Size = UDim2.new(0.9, 0, 0, 0),
    Position = UDim2.new(0.05, 0, 0.1, 35),
    BackgroundColor3 = Color3.fromRGB(60, 60, 70),
    ScrollBarThickness = 5,
    Visible = false,
    Parent = MainFrame
})

create("UICorner", {
    CornerRadius = UDim.new(0, 6),
    Parent = StoreList
})

local ItemList = create("ScrollingFrame", {
    Size = UDim2.new(0.9, 0, 0, 0),
    Position = UDim2.new(0.05, 0, 0.25, 35),
    BackgroundColor3 = Color3.fromRGB(60, 60, 70),
    ScrollBarThickness = 5,
    Visible = false,
    Parent = MainFrame
})

create("UICorner", {
    CornerRadius = UDim.new(0, 6),
    Parent = ItemList
})

-- Переменные состояния
local selectedStore = nil
local selectedItem = nil
local isBuying = false
local stopRequested = false
local purchasedCount = 0
local totalToPurchase = 0

-- Функции обновления интерфейса
local function updateStatus(text, color)
    StatusLabel.Text = text
    StatusLabel.TextColor3 = color or Color3.new(0.9, 0.9, 0.9)
end

local function updateProgress()
    ProgressLabel.Text = string.format("Куплено: %d/%d", purchasedCount, totalToPurchase)
end

local function toggleStoreList(show)
    if show then
        StoreList.Visible = true
        local tween = TweenService:Create(
            StoreList,
            TweenInfo.new(0.3),
            {Size = UDim2.new(0.9, 0, 0, math.min(200, StoreList.AbsoluteContentSize.Y))}
        )
        tween:Play()
    else
        local tween = TweenService:Create(
            StoreList,
            TweenInfo.new(0.3),
            {Size = UDim2.new(0.9, 0, 0, 0)}
        )
        tween.Completed:Connect(function()
            StoreList.Visible = false
        end)
        tween:Play()
    end
end

local function toggleItemList(show)
    if show then
        ItemList.Visible = true
        local tween = TweenService:Create(
            ItemList,
            TweenInfo.new(0.3),
            {Size = UDim2.new(0.9, 0, 0, math.min(200, ItemList.AbsoluteContentSize.Y))}
        )
        tween:Play()
    else
        local tween = TweenService:Create(
            ItemList,
            TweenInfo.new(0.3),
            {Size = UDim2.new(0.9, 0, 0, 0)}
        )
        tween.Completed:Connect(function()
            ItemList.Visible = false
        end)
        tween:Play()
    end
end

-- Заполнение списка магазинов
local function populateStoreList()
    StoreList:ClearAllChildren()
    
    local stores = {}
    for _, data in pairs(itemMarkers) do
        if not table.find(stores, data.storeName) then
            table.insert(stores, data.storeName)
        end
    end
    
    table.sort(stores)
    
    local allButton = create("TextButton", {
        Text = "Все магазины",
        Size = UDim2.new(1, -10, 0, 30),
        Position = UDim2.new(0, 5, 0, 5),
        BackgroundColor3 = Color3.fromRGB(80, 80, 100),
        Parent = StoreList
    })
    
    create("UICorner", {
        CornerRadius = UDim.new(0, 4),
        Parent = allButton
    })
    
    allButton.MouseButton1Click:Connect(function()
        selectedStore = "All"
        StoreSelection.Text = "Все магазины"
        toggleStoreList(false)
    end)
    
    local yOffset = 40
    for _, storeName in ipairs(stores) do
        local button = create("TextButton", {
            Text = storeName,
            Size = UDim2.new(1, -10, 0, 30),
            Position = UDim2.new(0, 5, 0, yOffset),
            BackgroundColor3 = Color3.fromRGB(80, 80, 100),
            Parent = StoreList
        })
        
        create("UICorner", {
            CornerRadius = UDim.new(0, 4),
            Parent = button
        })
        
        button.MouseButton1Click:Connect(function()
            selectedStore = storeName
            StoreSelection.Text = storeName
            toggleStoreList(false)
        end)
        
        yOffset = yOffset + 35
    end
    
    StoreList.CanvasSize = UDim2.new(0, 0, 0, yOffset + 5)
end

-- Заполнение списка предметов
local function populateItemList()
    ItemList:ClearAllChildren()
    
    if not selectedStore then return end
    
    local items = {}
    for markerName, data in pairs(itemMarkers) do
        if selectedStore == "All" or data.storeName == selectedStore then
            if not table.find(items, data.itemName) then
                table.insert(items, data.itemName)
            end
        end
    end
    
    table.sort(items)
    
    local yOffset = 5
    for _, itemName in ipairs(items) do
        local button = create("TextButton", {
            Text = itemName,
            Size = UDim2.new(1, -10, 0, 30),
            Position = UDim2.new(0, 5, 0, yOffset),
            BackgroundColor3 = Color3.fromRGB(80, 80, 100),
            Parent = ItemList
        })
        
        create("UICorner", {
            CornerRadius = UDim.new(0, 4),
            Parent = button
        })
        
        button.MouseButton1Click:Connect(function()
            selectedItem = itemName
            ItemSelection.Text = itemName
            toggleItemList(false)
        end)
        
        yOffset = yOffset + 35
    end
    
    ItemList.CanvasSize = UDim2.new(0, 0, 0, yOffset + 5)
end

-- Обработчики событий
StoreSelection.MouseButton1Click:Connect(function()
    if StoreList.Visible then
        toggleStoreList(false)
    else
        populateStoreList()
        toggleStoreList(true)
        if ItemList.Visible then
            toggleItemList(false)
        end
    end
end)

ItemSelection.MouseButton1Click:Connect(function()
    if not selectedStore then
        updateStatus("Сначала выберите магазин", Color3.fromRGB(255, 100, 100))
        return
    end
    
    if ItemList.Visible then
        toggleItemList(false)
    else
        populateItemList()
        toggleItemList(true)
        if StoreList.Visible then
            toggleStoreList(false)
        end
    end
end)

-- Поддержка мобильных устройств
UserInputService.TouchStarted:Connect(function(touch, gameProcessed)
    if gameProcessed then return end
    
    local touchPos = touch.Position
    local storeAbsPos = StoreSelection.AbsolutePosition
    local storeAbsSize = StoreSelection.AbsoluteSize
    
    if touchPos.X >= storeAbsPos.X and touchPos.X <= storeAbsPos.X + storeAbsSize.X and
       touchPos.Y >= storeAbsPos.Y and touchPos.Y <= storeAbsPos.Y + storeAbsSize.Y then
        StoreSelection.MouseButton1Click:Fire()
    end
    
    local itemAbsPos = ItemSelection.AbsolutePosition
    local itemAbsSize = ItemSelection.AbsoluteSize
    
    if touchPos.X >= itemAbsPos.X and touchPos.X <= itemAbsPos.X + itemAbsSize.X and
       touchPos.Y >= itemAbsPos.Y and touchPos.Y <= itemAbsPos.Y + itemAbsSize.Y then
        ItemSelection.MouseButton1Click:Fire()
    end
end)

-- Функции для покупки
local function getCounterPosition(storeName)
    local counters = {
        WoodRUs = Workspace.Stores.WoodRUs.Counter,
        CarStore = Workspace.Stores.CarStore.Counter,
        FurnitureStore = Workspace.Stores.FurnitureStore.Counter,
        ShackShop = Workspace.Stores.ShackShop.Counter,
        LogicStore = Workspace.Stores.LogicStore.Counter,
        FineArt = Workspace.Stores.FineArt.Counter
    }
    
    return counters[storeName] and counters[storeName].Position + Vector3.new(0, 3, 0)
end

local function getPurchaseFunction(storeName)
    local npcData = {
        WoodRUs = {
            Character = Workspace:WaitForChild("Stores"):WaitForChild("WoodRUs"):WaitForChild("Thom"),
            Name = "Thom",
            Dialog = Workspace:WaitForChild("Stores"):WaitForChild("WoodRUs"):WaitForChild("Thom"):WaitForChild("Dialog")
        },
        CarStore = {
            Character = Workspace:WaitForChild("Stores"):WaitForChild("CarStore"):WaitForChild("Jenny"),
            Name = "Jenny",
            Dialog = Workspace:WaitForChild("Stores"):WaitForChild("CarStore"):WaitForChild("Jenny"):WaitForChild("Dialog")
        },
        FurnitureStore = {
            Character = Workspace:WaitForChild("Stores"):WaitForChild("FurnitureStore"):WaitForChild("Corey"),
            Name = "Corey",
            Dialog = Workspace:WaitForChild("Stores"):WaitForChild("FurnitureStore"):WaitForChild("Corey"):WaitForChild("Dialog")
        },
        ShackShop = {
            Character = Workspace:WaitForChild("Stores"):WaitForChild("ShackShop"):WaitForChild("Bob"),
            Name = "Bob",
            Dialog = Workspace:WaitForChild("Stores"):WaitForChild("ShackShop"):WaitForChild("Bob"):WaitForChild("Dialog")
        },
        LogicStore = {
            Character = Workspace:WaitForChild("Stores"):WaitForChild("LogicStore"):WaitForChild("Lincoln"),
            Name = "Lincoln",
            Dialog = Workspace:WaitForChild("Stores"):WaitForChild("LogicStore"):WaitForChild("Lincoln"):WaitForChild("Dialog")
        },
        FineArt = {
            Character = Workspace:WaitForChild("Stores"):WaitForChild("FineArt"):WaitForChild("Timothy"),
            Name = "Timothy",
            Dialog = Workspace:WaitForChild("Stores"):WaitForChild("FineArt"):WaitForChild("Timothy"):WaitForChild("Dialog")
        }
    }
    
    return function(id)
        local args = {
            [1] = {
                ID = id,
                Character = npcData[storeName].Character,
                Name = npcData[storeName].Name,
                Dialog = npcData[storeName].Dialog
            },
            [2] = "ConfirmPurchase"
        }
        ReplicatedStorage:WaitForChild("NPCDialog"):WaitForChild("PlayerChatted"):InvokeServer(unpack(args))
    end
end

local function findItemInStore(itemName, storeName)
    for markerName, data in pairs(itemMarkers) do
        if data.itemName == itemName and (storeName == "All" or data.storeName == storeName) then
            -- Проверяем, есть ли предмет на месте маркера
            local parts = Workspace:GetPartsInPart(data.marker)
            for _, part in ipairs(parts) do
                local model = part:FindFirstAncestorOfClass("Model")
                if model and (model:FindFirstChild("Main") or model:IsA("BasePart")) then
                    return model
                end
            end
        end
    end
    return nil
end

local function findPurchasedBox()
    local playerName = Player.Name
    for _, child in ipairs(Workspace.PlayerModels:GetChildren()) do
        if child.Name == "Box Purchased by "..playerName then
            return child
        end
    end
    return nil
end

local function renamePurchasedBoxes()
    local playerName = Player.Name
    local count = 1
    for _, child in ipairs(Workspace.PlayerModels:GetChildren()) do
        if child.Name == "Box Purchased by "..playerName then
            child.Name = tostring(count)
            count = count + 1
        end
    end
end

local function findStoreForItem(itemName)
    for _, data in pairs(itemMarkers) do
        if data.itemName == itemName then
            return data.storeName
        end
    end
    return nil
end

local function getStoreID(storeName)
    if storeIDs[storeName] ~= -1 then
        return storeIDs[storeName]
    end
    
    -- Подбор ID
    updateStatus("Подбираем ID для "..storeName, Color3.fromRGB(255, 255, 150))
    
    local purchaseFunc = getPurchaseFunction(storeName)
    local currentID = 0
    
    while not stopRequested do
        currentID = currentID + 1
        purchaseFunc(currentID)
        task.wait(0.5)
        
        local box = findPurchasedBox()
        if box then
            storeIDs[storeName] = currentID
            renamePurchasedBoxes()
            updateStatus("Найден ID: "..currentID, Color3.fromRGB(150, 255, 150))
            return currentID
        end
    end
    
    return nil
end

-- Основная функция покупки
local function buyItem(itemName, storeName)
    if stopRequested then return false end
    
    -- Сохраняем позицию игрока
    local char = Player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then
        updateStatus("Персонаж не найден", Color3.fromRGB(255, 100, 100))
        return false
    end
    
    local savedPosition = char.HumanoidRootPart.Position
    renamePurchasedBoxes()
    
    -- Находим предмет в магазине
    local item = findItemInStore(itemName, storeName)
    if not item then
        updateStatus("Предмет не найден: "..itemName, Color3.fromRGB(255, 100, 100))
        return false
    end
    
    -- Определяем магазин, если выбран "Все"
    local actualStoreName = storeName
    if storeName == "All" then
        actualStoreName = findStoreForItem(itemName)
        if not actualStoreName then
            updateStatus("Не удалось определить магазин", Color3.fromRGB(255, 100, 100))
            return false
        end
    end
    
    -- Получаем позицию стойки
    local counterPos = getCounterPosition(actualStoreName)
    if not counterPos then
        updateStatus("Не найдена стойка для "..actualStoreName, Color3.fromRGB(255, 100, 100))
        return false
    end
    
    -- Телепортируем игрока к предмету
    local itemPos = item:FindFirstChild("Main") and item.Main.Position or item.Position
    char.HumanoidRootPart.CFrame = CFrame.new(itemPos + Vector3.new(0, 3, 0))
    task.wait(0.5)
    
    -- Телепортируем предмет к стойке
    if not smoothTeleportItem(item, counterPos) then
        updateStatus("Ошибка телепортации", Color3.fromRGB(255, 100, 100))
        return false
    end
    task.wait(0.5)
    
    -- Телепортируем игрока к стойке
    char.HumanoidRootPart.CFrame = CFrame.new(counterPos + Vector3.new(0, 3, 0))
    task.wait(0.5)
    
    -- Получаем ID магазина
    local storeID = getStoreID(actualStoreName)
    if not storeID then
        updateStatus("Не удалось получить ID", Color3.fromRGB(255, 100, 100))
        return false
    end
    
    -- Покупаем предмет
    local purchaseFunc = getPurchaseFunction(actualStoreName)
    purchaseFunc(storeID)
    task.wait(1)
    
    -- Находим купленный ящик
    local box = findPurchasedBox()
    if not box then
        updateStatus("Не удалось найти купленный предмет", Color3.fromRGB(255, 100, 100))
        return false
    end
    
    -- Телепортируем ящик к сохраненной позиции
    if not smoothTeleportItem(box, savedPosition + Vector3.new(0, 3, 0)) then
        updateStatus("Ошибка телепортации ящика", Color3.fromRGB(255, 100, 100))
        return false
    end
    
    -- Переименовываем ящик
    renamePurchasedBoxes()
    
    return true
end

-- Обработчики кнопок
StartButton.MouseButton1Click:Connect(function()
    if isBuying then return end
    
    if not selectedItem then
        updateStatus("Выберите предмет", Color3.fromRGB(255, 100, 100))
        return
    end
    
    local quantity = tonumber(QuantityInput.Text) or 1
    if quantity <= 0 then
        updateStatus("Неверное количество", Color3.fromRGB(255, 100, 100))
        return
    end
    
    isBuying = true
    stopRequested = false
    purchasedCount = 0
    totalToPurchase = quantity
    updateProgress()
    
    coroutine.wrap(function()
        for i = 1, quantity do
            if stopRequested then break end
            
            updateStatus(string.format("Покупка %d/%d...", i, quantity), Color3.fromRGB(255, 255, 150))
            
            if buyItem(selectedItem, selectedStore or "All") then
                purchasedCount = purchasedCount + 1
                updateProgress()
            else
                break
            end
            
            task.wait(1)
        end
        
        isBuying = false
        if not stopRequested then
            updateStatus("Покупка завершена", Color3.fromRGB(150, 255, 150))
        else
            updateStatus("Покупка остановлена", Color3.fromRGB(255, 150, 0))
        end
    end)()
end)

StopButton.MouseButton1Click:Connect(function()
    if isBuying then
        stopRequested = true
    end
end)

-- Инициализация
populateStoreList()
updateStatus("Готов к работе", Color3.fromRGB(150, 255, 150))
updateProgress()

-- Очистка при выходе
Player.CharacterRemoving:Connect(function()
    ScreenGui:Destroy()
    for _, marker in pairs(itemMarkers) do
        marker.marker:Destroy()
    end
end)