-- ============================================================================
-- Nama Script: h4ll0 w0rld | Silent Assassin (Universal Mobile & PC UI)
-- Deskripsi  : UI Manajemen Mekanik Karakter dengan Tombol Toggle Khusus Android
-- Penempatan : 1 File di GitHub, dimuat via loadstring
-- ============================================================================

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

if not LocalPlayer then return end
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Hapus UI lama jika script di-execute ulang agar tidak menumpuk
if PlayerGui:FindFirstChild("SilentAssassin_UI") then
    PlayerGui.SilentAssassin_UI:Destroy()
end

-- 1. PEMBUATAN SCREEN GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SilentAssassin_UI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

-- 2. FRAME UTAMA (MENU)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 320, 0, 380) -- Ukuran disesuaikan agar pas di layar HP
MainFrame.Position = UDim2.new(0.5, -160, 0.5, -190) 
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BorderSizePixel = 2
MainFrame.BorderColor3 = Color3.fromRGB(150, 0, 0)
MainFrame.Active = true
MainFrame.Draggable = true -- Bisa digeser di PC maupun ditarik di Android
MainFrame.BackgroundTransparency = 1
MainFrame.Visible = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = MainFrame

-- 3. HEADER / JUDUL MENU
local HeaderLabel = Instance.new("TextLabel")
HeaderLabel.Name = "HeaderLabel"
HeaderLabel.Size = UDim2.new(1, 0, 0, 45)
HeaderLabel.BackgroundColor3 = Color3.fromRGB(40, 5, 5)
HeaderLabel.Text = "💀 Silent Assassin 💀"
HeaderLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
HeaderLabel.TextSize = 18
HeaderLabel.Font = Enum.Font.SourceSansBold
HeaderLabel.TextTransparency = 1
HeaderLabel.BackgroundTransparency = 1
HeaderLabel.Parent = MainFrame

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 10)
HeaderCorner.Parent = HeaderLabel

-- CONTAINER TOMBOL
local ButtonContainer = Instance.new("ScrollingFrame")
ButtonContainer.Size = UDim2.new(1, -20, 1, -65)
ButtonContainer.Position = UDim2.new(0, 10, 0, 55)
ButtonContainer.BackgroundTransparency = 1
ButtonContainer.CanvasSize = UDim2.new(0, 0, 0, 320)
ButtonContainer.ScrollBarThickness = 4
ButtonContainer.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Padding = UDim.new(0, 8)
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Parent = ButtonContainer

-- 4. FUNGSI MEMBUAT TOMBOL TOGGLE
local TombolList = {}
local function BuatTombolToggle(namaFitur, order, callback)
    local StatusAktif = false

    local Button = Instance.new("TextButton")
    Button.Name = namaFitur .. "Btn"
    Button.Size = UDim2.new(1, 0, 0, 42)
    Button.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Button.Text = "  " .. namaFitur .. " : [ OFF ]"
    Button.TextColor3 = Color3.fromRGB(200, 200, 200)
    Button.TextXAlignment = Enum.TextXAlignment.Left
    Button.TextSize = 14
    Button.Font = Enum.Font.SourceSans
    Button.LayoutOrder = order
    Button.BackgroundTransparency = 1
    Button.TextTransparency = 1
    Button.Parent = ButtonContainer

    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(0, 6)
    BtnCorner.Parent = Button

    table.insert(TombolList, Button)

    Button.MouseButton1Click:Connect(function()
        StatusAktif = not StatusAktif
        if StatusAktif then
            TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(100, 0, 0)}):Play()
            Button.Text = "  💀 " .. namaFitur .. " : [ ON ]"
            Button.TextColor3 = Color3.fromRGB(255, 255, 255)
            Button.Font = Enum.Font.SourceSansBold
        else
            TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(30, 30, 30)}):Play()
            Button.Text = "  " .. namaFitur .. " : [ OFF ]"
            Button.TextColor3 = Color3.fromRGB(200, 200, 200)
            Button.Font = Enum.Font.SourceSans
        end
        callback(StatusAktif)
    end)
end

-- DAFTAR TOMBOL GAME
BuatTombolToggle("SPEED MULTIPLIER", 1, function(state)
    local humanoid = (LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()):FindFirstChildOfClass("Humanoid")
    if humanoid then humanoid.WalkSpeed = state and 50 or 16 end
end)

BuatTombolToggle("SUPER JUMP", 2, function(state)
    local humanoid = (LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()):FindFirstChildOfClass("Humanoid")
    if humanoid then humanoid.JumpPower = state and 120 or 50 end
end)

BuatTombolToggle("SNEAK INVISIBLE", 3, function(state)
    local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    for _, part in ipairs(character:GetDescendants()) do
        if (part:IsA("BasePart") or part:IsA("Decal")) and part.Name ~= "HumanoidRootPart" then
            part.LocalTransparencyModifier = state and 0.8 or 0
        end
    end
end)

BuatTombolToggle("AUTO DODGE CHANCE", 4, function(state) end)
BuatTombolToggle("OBJECT ESP VISUAL", 5, function(state) end)

-- ============================================================================
-- 5. TOMBOL PENGECIL / FLOATING BUTTON (UNTUK ANDROID / MOBILE)
-- ============================================================================
local FloatingButton = Instance.new("TextButton")
FloatingButton.Name = "FloatingToggleButton"
FloatingButton.Size = UDim2.new(0, 55, 0, 55)
-- Diletakkan di pojok kanan atas agar tidak mengganggu kontrol d-pad Android
FloatingButton.Position = UDim2.new(0.85, 0, 0.1, 0) 
FloatingButton.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
FloatingButton.BorderSizePixel = 1
FloatingButton.BorderColor3 = Color3.fromRGB(255, 0, 0)
FloatingButton.Text = "💀"
FloatingButton.TextSize = 28
FloatingButton.Active = true
FloatingButton.Draggable = true -- Tombol 💀 melayang bisa digeser sesuka hati di HP!
FloatingButton.Parent = ScreenGui

local RoundCorner = Instance.new("UICorner")
RoundCorner.CornerRadius = UDim.new(1, 0) -- Membuat tombol berbentuk lingkaran bulat sempurna
RoundCorner.Parent = FloatingButton

-- ============================================================================
-- 6. ANIMASI PEMBUKA & LOGIKA OPEN/CLOSE (UNIVERSAL)
-- ============================================================================
local MenuTerbuka = true
local AnimasiBerjalan = false

local function ToggleMenu()
    if AnimasiBerjalan then return end
    AnimasiBerjalan = true
    MenuTerbuka = not MenuTerbuka
    
    if MenuTerbuka then
        MainFrame.Visible = true
        TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
            Position = UDim2.new(0.5, -160, 0.5, -190),
            Size = UDim2.new(0, 320, 0, 380),
            BackgroundTransparency = 0
        }):Play()
        task.wait(0.3)
        AnimasiBerjalan = false
    else
        -- Mengecil ke arah tengah-tengah frame saat ini
        local targetX = MainFrame.Position.X.Offset + (MainFrame.Size.X.Offset / 2)
        local targetY = MainFrame.Position.Y.Offset + (MainFrame.Size.Y.Offset / 2)
        local targetPos = UDim2.new(MainFrame.Position.X.Scale, targetX, MainFrame.Position.Y.Scale, targetY)
        
        local closeTween = TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
            Position = targetPos,
            Size = UDim2.new(0, 0, 0, 0),
            BackgroundTransparency = 1
        })
        closeTween:Play()
        closeTween.Completed:Connect(function()
            MainFrame.Visible = false
            AnimasiBerjalan = false
        end)
    end
end

-- A. Respon Ketukan Tombol Melayang (Utama untuk Android / Klik PC)
FloatingButton.MouseButton1Click:Connect(ToggleMenu)

-- B. Respon Tombol Fisik Keyboard (Otomatis Aktif jika nanti Anda main di PC/Komputer)
UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == Enum.KeyCode.Insert or input.KeyCode == Enum.KeyCode.RightShift then
        ToggleMenu()
    end
end)

-- Jalankan animasi kemunculan pertama kali (Intro)
task.wait(0.2)
TweenService:Create(MainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {BackgroundTransparency = 0}):Play()
TweenService:Create(HeaderLabel, TweenInfo.new(0.5), {BackgroundTransparency = 0, TextTransparency = 0}):Play()
for _, btn in ipairs(TombolList) do
    TweenService:Create(btn, TweenInfo.new(0.3), {BackgroundTransparency = 0, TextTransparency = 0}):Play()
end
