-- ====================================================================
--   SCRIPT STEAL AN EGG - CUSTOM NO KEY VERSI ANDA (ZONA & RARITY)
-- ====================================================================

-- Pustaka GUI Kavo (Langsung Terbuka Tanpa Meminta Key)
local KavoUi = loadstring(game:HttpGet("https://githubusercontent.com"))()
local Window = KavoUi.CreateLib("Steal An Egg - Script Versi Ku [NO KEY]", "BloodTheme")

-- Membuat Tab Menu
local MainTab = Window:NewTab("Auto Steal Filter")
local BossTab = Window:NewTab("Auto Boss")
local GymTab = Window:NewTab("Auto Treadmill")

local FarmSection = MainTab:NewSection("Pengaturan Filter Telur")
local BossSection = BossTab:NewSection("Fitur Lawan Boss")
local GymSection = GymTab:NewSection("Fitur Latihan")

-- Variabel Kontrol Pilihan Anda
getgenv().AutoSteal = false
getgenv().SelectedZone = "Semua Zona"
getgenv().SelectedRarity = "Semua Rarity"
getgenv().AutoBoss = false
getgenv().AutoAttack = false
getgenv().StayOnTreadmill = false

local player = game:GetService("Players").LocalPlayer

-- ==========================================
-- OPSI PILIHAN DROPDOWN (FILTER)
-- ==========================================

-- 1. Pilihan Zona / Bioma
local listZona = {"Semua Zona", "Forest", "Lake", "Desert", "Jungle", "Snow", "Volcano", "Abyss Ocean", "Prehistoric", "Cosmic", "Cherry Blossom"}
FarmSection:NewDropdown("Pilih Zona Berburu", "Pilih lokasi spesifik untuk mengambil telur", listZona, function(currentOption)
    getgenv().SelectedZone = currentOption
end)

-- 2. Pilihan Rarity Telur
local listRarity = {"Semua Rarity", "Common", "Uncommon", "Rare", "Epic", "Legendary", "Mythic", "Cosmic", "Secret"}
FarmSection:NewDropdown("Pilih Rarity Telur", "Hanya ambil telur dengan kelangkaan ini", listRarity, function(currentOption)
    getgenv().SelectedRarity = currentOption
end)

-- ==========================================
-- 1. AKTIVASI AUTO STEAL (DENGAN FILTER)
-- ==========================================
FarmSection:NewToggle("Aktifkan Auto Steal Filtered", "Mulai mencuri telur sesuai filter di atas", function(state)
    getgenv().AutoSteal = state
    task.spawn(function()
        while getgenv().AutoSteal do
            task.wait(0.2)
            pcall(function()
                local char = player.Character or player.CharacterAdded:Wait()
                local hrp = char:WaitForChild("HumanoidRootPart")
                
                -- Deteksi folder utama tempat telur muncul
                local eggFolder = workspace:FindFirstChild("Eggs") or workspace:FindFirstChild("DroppedEggs") or workspace:FindFirstChild("EggSpawn")
                
                if eggFolder then
                    for _, egg in pairs(eggFolder:GetChildren()) do
                        if not getgenv().AutoSteal then break end
                        
                        -- Ambil data nama objek untuk mencocokkan Zona dan Rarity
                        local eggName = string.lower(egg.Name)
                        local matchZone = false
                        local matchRarity = false
                        
                        -- Cek kecocokan Zona
                        if getgenv().SelectedZone == "Semua Zona" or string.find(eggName, string.lower(getgenv().SelectedZone)) then
                            matchZone = true
                        end
                        
                        -- Cek kecocokan Rarity
                        if getgenv().SelectedRarity == "Semua Rarity" or string.find(eggName, string.lower(getgenv().SelectedRarity)) then
                            matchRarity = true
                        end
                        
                        -- Jika lolos filter, lakukan teleport ke telur
                        if matchZone and matchRarity then
                            local target = egg:IsA("BasePart") and egg or egg:FindFirstChildWhichIsA("BasePart")
                            if target then
                                hrp.CFrame = target.CFrame + Vector3.new(0, 1.5, 0)
                                task.wait(0.25) -- Jeda teleportasi aman
                            end
                        end
                    end
                end
            end)
        end
    end)
end)

-- ==========================================
-- 2. FITUR AUTO BOSS & AUTO ATTACK
-- ==========================================
BossSection:NewToggle("Auto Boss (Teleport)", "Otomatis mengunci posisi di arena Boss", function(state)
    getgenv().AutoBoss = state
    task.spawn(function()
        while getgenv().AutoBoss do
            task.wait(0.5)
            pcall(function()
                local char = player.Character or player.CharacterAdded:Wait()
                local hrp = char:WaitForChild("HumanoidRootPart")
                local boss = workspace:FindFirstChild("Boss") or workspace:FindFirstChild("BossNPC") or workspace:FindFirstChild("BossArena")
                if boss then
                    local bossPart = boss:IsA("BasePart") and boss or boss:FindFirstChildWhichIsA("BasePart") or boss:FindFirstChild("HumanoidRootPart")
                    if bossPart then
                        hrp.CFrame = bossPart.CFrame + Vector3.new(0, 5, -2) -- Menempel aman di dekat boss
                    end
                end
            end)
        end
    end)
end)

BossSection:NewToggle("Auto Nyerang Boss", "Spam serangan otomatis", function(state)
    getgenv().AutoAttack = state
    task.spawn(function()
        while getgenv().AutoAttack do
            task.wait(0.1)
            pcall(function()
                local combatEvent = game:GetService("ReplicatedStorage"):FindFirstChild("Attack") or game:GetService("ReplicatedStorage"):FindFirstChild("Punch")
                if combatEvent then
                    combatEvent:FireServer()
                else
                    local tool = player.Backpack:FindFirstChildWhichIsA("Tool") or (player.Character and player.Character:FindFirstChildWhichIsA("Tool"))
                    if tool then
                        if not player.Character:FindFirstChild(tool.Name) then
                            player.Character.Humanoid:EquipTool(tool)
                        end
                        tool:Activate()
                    end
                end
            end)
        end
    end)
end)

-- ==========================================
-- 3. FITUR AUTO TREADMILL & STAY ON TREADMILL
-- ==========================================
GymSection:NewToggle("Stay on Treadmill", "Kunci posisi karakter di atas Treadmill", function(state)
    getgenv().StayOnTreadmill = state
    task.spawn(function()
        while getgenv().StayOnTreadmill do
            task.wait(0.3)
            pcall(function()
                local char = player.Character or player.CharacterAdded:Wait()
                local hrp = char:WaitForChild("HumanoidRootPart")
                local treadmillFolder = workspace:FindFirstChild("Treadmills") or workspace:FindFirstChild("Gym") or workspace
                
                for _, obj in pairs(treadmillFolder:GetDescendants()) do
                    if string.find(string.lower(obj.Name), "treadmill") and obj:IsA("BasePart") then
                        hrp.CFrame = obj.CFrame + Vector3.new(0, 2, 0) -- Berdiri terus di papan lari
                        local prompt = obj:FindFirstChildWhichIsA("ProximityPrompt") or obj.Parent:FindFirstChildWhichIsA("ProximityPrompt")
                        if prompt then
                            fireproximityprompt(prompt)
                        end
                        break
                    end
                end
            end)
        end
    end)
end)
