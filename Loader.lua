print("injected")
local TeleportService = game:GetService("TeleportService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local localPlayer = Players.LocalPlayer
local playerGui = localPlayer.PlayerGui
local mouse = localPlayer:GetMouse()
local camera = workspace.CurrentCamera

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
if not Rayfield then return end
Rayfield:Notify({
	Title = "Tsb Script",
	Content = "Loading",
	Duration = 6.5,
	Image = 4483362458,
})

local killWorking = false
local selectedChar = ""
local M1sAnimations = {
	-- kj
	"17325510002",
	"17325513870",
	"17325522388",
	"17325537719",
	-- saitama
	"10469493270",
	"10469630950",
	"10469639222",
	"10469643643",
	-- garou
	"13532562418",
	"13532600125",
	"13532604085",
	"13294471966",
	-- genos
	"13491635433",
	"13296577783",
	"13295919399",
	"13295936866",
	-- sonic
	"13370310513",
	"13390230973",
	"13378751717",
	"13378708199",
	-- metal bite
	"14004222985",
	"13997092940",
	"14001963401",
	"14136436157",
	-- blade master
	"15259161390",
	"15240216931",
	"15240176873",
	"15162694192",
	-- tatsumaki
	"16515503507",
	"16515520431",
	"16515448089",
	"16552234590",
	-- suriy
	"17889458563",
	"17889461810",
	"17889471098",
	"17889290569",
	-- child emperor
	"123005629431309",
	"100059874351664",
	"104895379416342",
	"134775406437626",
}


if not _G.killWorkChars then
	_G.killWorkChars = {"Hunter", "Cyborg", "Ninja", "Esper", "Blade"}
	_G.killactivated = false
	_G.killChargeUp = false 
	_G.killKilling = false
	_G.killWhiteList = true
	_G.killSafeSelf = true
	_G.killSafeProp = 15
	_G.killStealProp = 15

	_G.adcActivated = false -- anti death counter
	_G.adcNeedTp = false
	_G.adcNeedCustomTp = false
	_G.adcCusomCFrame = CFrame.new(-66, 30, 20356) 
	_G.adcWorking = false
	_G.isDeath = false -- check if player anim == 11343250001 (death counter anim)
	_G.adcQuotes = 1 -- 1 is void, 2 is punish
	_G.punishLoc = 1 -- 1 is Death Counter room, 2 is Atomic room, 3 is Upper Baseplate, 4 is Lower Baseplate

	_G.voidKillActivated = false -- auto void kill activated
	_G.voidNeedTp = false
	_G.voidKilling = false 
	_G.voidKillQuotes = 2 -- wait time (1 = default time; 2 = smart wait)
	_G.voidKillPunishQuotes = 1 -- 💀💀💀 (1 is teleport to teleports; 2 is absolute dead)
	_G.voidKillPunishTpLocation = 1 -- 1 is Death Counter room, 2 is Atomic room, 3 is Upper Baseplate, 4 is Lower Baseplate

	_G.hitboxColor = Color3.new(255, 0, 0)

	_G.ultEspActivated = false -- move is balde; MainWind in head, AbsoluteImmortal in char; GlowingArm is genos; AbsoluteImmortal is sonic, move is sonic; AbsoluteImmortal is batter, aura1 in head  is batter; AbsoluteImmortal is blade, Move is blade; Headeffectspace is tatsu, AbsoluteImmortal is tatsu, 5aura1 in head  is tatsu; 

	_G.tatsuUltActivated = false
	_G.tatsuUltWorking = false
	_G.tatsuUltQuotes = 2 -- 1 is bring all; 2 is void kill all;

	_G.targetActivated = false
	_G.targetAutoAfk = false
	_G.targetNeedTp = false
	_G.targetTarget = nil
	_G.targetQuotes = 1 -- 1 is basic target, 2 is smart target (tp only if has skills)
	_G.targetSafeActivated = true
	_G.targetSafeProp = 30
	_G.targetSafeQuotes = 2 -- 1 is basic (15hp prop void); 2 is absolute safe (15hp prop void * CFrame.Angles(0, 90, 0)

	_G.autoGetIceBoss = false

	_G.snowballBooster = false
	_G.snowballPlayer = nil

	_G.firstM1 = "The Strongest Hero" -- The Strongest Hero  is default
	_G.secondM1 = "The Strongest Hero" -- The Strongest Hero  is default
	_G.thirdM1 = "The Strongest Hero" -- The Strongest Hero  is default
	_G.fourthM1 = "The Strongest Hero" -- The Strongest Hero  is default
	_G.M1sActivated = false

	_G.walkSpeed = 16
	_G.jumpPower = 50
	_G.walkActivated = false
	_G.jumpActivated = false
end

if not workspace:FindFirstChild("VoidPlate") then
	local voidPlate = Instance.new("Part")
	voidPlate.Parent = game.Workspace
	voidPlate.Name = "VoidPlate"
	voidPlate.Anchored = true
	voidPlate.Material = Enum.Material.ForceField
	voidPlate.Size = Vector3.new(1027, 1, 770)
	voidPlate.CFrame = CFrame.new(0, -496, 0)
end

local Window = Rayfield:CreateWindow({
	Name = "Tsb Script",
	Icon = 0, -- Icon in Topbar. Can use Lucide Icons (string) or Roblox Image (number). 0 to use no icon (default).
	LoadingTitle = "Interface",
	LoadingSubtitle = "by skuff",
	Theme = "Default", -- Check https://docs.sirius.menu/rayfield/configuration/themes

	DisableRayfieldPrompts = false,
	DisableBuildWarnings = false, -- Prevents Rayfield from warning when the script has a version mismatch with the interface

	ConfigurationSaving = {
		Enabled = false,
		FolderName = "Tsb_Script", -- Create a custom folder for your hub/game
		FileName = "config"
	},

	KeySystem = true, -- Set this to true to use our key system
	KeySettings = {
		Title = "Tsb script",
		Subtitle = "Key System",
		Note = "Key is Skuff", -- Use this to tell the user how to get a key
		FileName = "TSBScrKey", -- It is recommended to use something unique as other scripts using Rayfield may overwrite your key file
		SaveKey = true, -- The user's key will be saved, but if you change the key, they will be unable to use your script
		GrabKeyFromSite = false, -- If this is true, set Key below to the RAW site you would like Rayfield to get the key from
		Key = {"Skuff", "skuff", "SKUFF", "skuf", "SKUF"} -- List of keys that will be accepted by the system, can be RAW file links (pastebin, github etc) or simple strings ("hello","key22")
	}
})

local Tab = Window:CreateTab("Main", "rewind")
local Tab2 = Window:CreateTab("Player", "rewind")
local Tab3 = Window:CreateTab("Visuals", "rewind")
local Tab4 = Window:CreateTab("Attacks", "rewind")
local Tab5 = Window:CreateTab("Moveset", "rewind")
local Tab6 = Window:CreateTab("Teleports", "rewind")
local Tab7 = Window:CreateTab("Server", "rewind")

local MainSection = Tab:CreateSection("Main")
local playerSection = Tab2:CreateSection("Player")
local vilualSection = Tab3:CreateSection("Visuals")
local exploitSection = Tab3:CreateSection("Exploits")
local locationsSection = Tab5:CreateSection("Locations")

local targetDropdown

local function setupUI()
	local function setupTab()
		local unloadUI = Tab:CreateButton({
			Name = "Unload UI",
			Callback = function()
				Rayfield:Destroy()
			end,
		})

		local debugSection = Tab:CreateSection("Debug functions")

		local manualVoidBind = Tab:CreateKeybind({
			Name = "Manual void tp",
			CurrentKeybind = "R",
			HoldToInteract = false,
			Flag = "ManualVoitBind", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
			Callback = function(Keybind)
				print(Keybind)
				if _G.voidNeedTp == false and _G.voidKilling == false then
					local oldCFrame = localPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame

					_G.voidNeedTp = true
					_G.voidKilling = true
					task.wait(4)
					_G.voidKilling = false
					_G.voidNeedTp = false

					localPlayer.Character.HumanoidRootPart.CFrame = oldCFrame
				else
					warn("already void killing or in void")
				end
			end,
		})
		local tpAllBind = Tab:CreateKeybind({
			Name = "Bring All (Teleport to all players on map)",
			CurrentKeybind = "Z",
			HoldToInteract = false,
			Flag = "bringAllBind", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
			Callback = function(Keybind)
				print(Keybind)
				local oldCFrame = localPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame

				local chars = {}
				for i, v in pairs(Players:GetPlayers()) do
					if v and v.Character then
						if v ~= localPlayer then
							if not v:IsFriendsWith(localPlayer.UserId) then
								print(v.Name)
								table.insert(chars, v.Character)
							end
						end
					end
				end

				for i, v in pairs(chars) do
					if localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("HumanoidRootPart") then
						localPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame = v:FindFirstChild("HumanoidRootPart").CFrame
						task.wait(0.15)
					end
				end

				localPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame = oldCFrame
			end,
		})
		local tpBind = Tab:CreateKeybind({
			Name = "TP Bind (Teleport to Mouse Position)",
			CurrentKeybind = "T",
			HoldToInteract = false,
			Flag = "tpBind", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
			Callback = function(Keybind)
				print(Keybind)
				local character = localPlayer.Character
				local rootPart = character:FindFirstChild("HumanoidRootPart")

				if character and rootPart then

				end
			end,
		})
	end

	local function setupTab2()
		local walkSpeedSlider = Tab2:CreateSlider({
			Name = "WalkSpeed Slider",
			Range = {0, 1500},
			Increment = 1,
			Suffix = "Speed",
			CurrentValue = 16,
			Flag = "walkSpeedSlider", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
			Callback = function(Value)
				print(Value)
				_G.walkSpeed = Value
				_G.walkActivated = true
			end,
		})

		local jumpPowerSlider = Tab2:CreateSlider({
			Name = "WalkSpeed Slider",
			Range = {0, 2500},
			Increment = 1,
			Suffix = "Power",
			CurrentValue = 50,
			Flag = "jumpPowerSlider", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
			Callback = function(Value)
				print(Value)
				_G.jumpPower = Value
				_G.jumpActivated = true
			end,
		})
	end

	local function setupTab3()
		local hitboxToggle = Tab3:CreateToggle({
			Name = "Show Hitboxes",
			CurrentValue = false,
			Flag = "hitboxToggle", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
			Callback = function(Value)
				print(Value)
				if Value == true then
					for i, v in pairs(Players:GetPlayers()) do
						if v.Character then
							for i, c in pairs(v.Character:GetChildren()) do
								if string.match(string.lower(c.Name), "hitbox") then
									v.Transparency = 0
									v.Color = _G.hitboxColor
								end
							end
						end
					end
				else
					for i, v in pairs(Players:GetPlayers()) do
						if v.Character then
							for i, c in pairs(v.Character:GetChildren()) do
								if string.match(string.lower(c.Name), "hitbox") then
									v.Transparency = 1
									v.Color = Color3.fromRGB(193, 193, 193)
								end
							end
						end
					end
				end
			end,
		})

		local hitboxColor = Tab3:CreateColorPicker({
			Name = "Hitbox Color",
			Color = Color3.fromRGB(255,0,0),
			Flag = "HitboxColor", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
			Callback = function(Value)
				local color = nil
				local split = string.split(tostring(Value), ", ")
				print(Value, Color3.new(Value))

				local C3 = Color3.new(0, 0, 0)
				local r, g, b = math.round(tonumber(split[1])*255), math.round(tonumber(split[2])*255), math.round(tonumber(split[3])*255)
				color = Color3.new(r,g,b)

				if color then
					_G.hitboxColor = color
				else
					_G.hitboxColor = Color3.fromRGB(255,0,0)
				end

				for i, v in pairs(Players:GetPlayers()) do
					if v.Character then
						for i, c in pairs(v.Character:GetChildren()) do
							if string.match(string.lower(c.Name), "hitbox") then
								v.Color = _G.hitboxColor
							end
						end
					end
				end
			end
		})
	end

	local function setupTab4()
		local otherSection = Tab4:CreateSection("Other Exploits")

		local snowballBoosterToggle = Tab4:CreateToggle({
			Name = "Snowball Booster",
			CurrentValue = false,
			Flag = "SBToggle", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
			Callback = function(Value)
				print(Value)
				_G.snowballBooster = Value
			end,
		})

		local otherSection = Tab4:CreateSection("Main Exploits")

		local antiDeathCounterToggle = Tab4:CreateToggle({
			Name = "Anti Death Counter",
			CurrentValue = false,
			Flag = "ADCToggle", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
			Callback = function(Value)
				print(Value)
				_G.adcActivated = Value
			end,
		})

		local deathCounterDropdown = Tab4:CreateDropdown({
			Name = "Anti Death Counter Quotes",
			Options = {"Void Kill ur Enemy (Bypass Death Counter)", "Punish ur Enemy (teleport him to selected place)"},
			CurrentOption = {"Void Kill ur Enemy (Bypass Death Counter)"},
			MultipleOptions = false,
			Flag = "deathDropdown", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
			Callback = function(Opt)
				local option = nil
				for i, v in Opt do
					if not option or option == nil then
						option = v
					end
				end
				if option and option ~= nil then
					if string.match(option, "Void") then
						_G.adcQuotes = 1
					else
						_G.adcQuotes = 2
					end
				else
					warn(option)
				end
			end,
		})

		local deathPunishLocDropdown = Tab4:CreateDropdown({
			Name = "Anti Death Counter Punish Location",
			Options = {"Death Counter Room", "Atomic Slash Room", "Upper Baseplate", "Lower Baseplate"},
			CurrentOption = {"Death Counter Room"},
			MultipleOptions = false,
			Flag = "deathPunishLocDropdown", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
			Callback = function(Opt)
				local option = nil
				for i, v in Opt do
					if not option or option == nil then
						option = v
					end
				end
				if option and option ~= nil then
					if string.match(option, "Death") then
						_G.punishLoc = 1
						_G.adcCusomCFrame = CFrame.new(-66, 30, 20356)

					elseif string.match(option, "Atomic") then
						_G.punishLoc = 2
						_G.adcCusomCFrame = CFrame.new(1050, 140, 23010)

					elseif string.match(option, "Upper") then
						_G.punishLoc = 3
						_G.adcCusomCFrame = CFrame.new(1060, 405, 22887)

					elseif string.match(option, "Lower") then
						_G.punishLoc = 4
						_G.adcCusomCFrame = CFrame.new(1060, 20, 22887)
					end
				else
					warn(option)
				end
			end,
		})


		local autoVoidToggle = Tab4:CreateToggle({
			Name = "Auto Void Kill",
			CurrentValue = false,
			Flag = "AVToggle", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
			Callback = function(Value)
				print(Value)
				_G.voidKillActivated = Value
			end,
		})

		local voidDropdown = Tab4:CreateDropdown({
			Name = "Void Kill Quotes",
			Options = {"1 (Default Wait Time)", "2 (Smart Wait Time)"},
			CurrentOption = {"2 (Smart Wait Time)"},
			MultipleOptions = false,
			Flag = "voidDropdown", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
			Callback = function(Opt)
				local option = nil
				for i, v in Opt do
					if not option or option == nil then
						option = v
					end
				end
				if option and option ~= nil then
					if string.match(option, "Default") then
						print("Default")
						_G.voidKillQuotes = 1
					else
						print("Smart")
						_G.voidKillQuotes = 2
					end
				else
					warn(option)
				end
			end,
		})

		local bringSection = Tab4:CreateSection("Bring Exploit")


		local tatsuBringToggle = Tab4:CreateToggle({
			Name = "Tatsumaki Ult",
			CurrentValue = false,
			Flag = "tatsuUltToggle", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
			Callback = function(Value)
				print(Value)
				_G.tatsuUltActivated = Value
			end,
		})

		local tatsuUltQuotesDropdown = Tab4:CreateDropdown({
			Name = "Tatsumaki Ult Quotes",
			Options = {"Bring All", "Void Kill all"},
			CurrentOption = {"Void Kill all"},
			MultipleOptions = false,
			Flag = "tatsuUltQuotesDropdown", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
			Callback = function(Opt)
				local option = nil
				for i, v in Opt do
					if not option or option == nil then
						option = v
					end
				end
				if option and option ~= nil then
					if string.match(option, "Bring") then
						print("Bring")
						_G.tatsuUltQuotes = 1
					else
						print("Void")
						_G.tatsuUltQuotes = 2
					end
				else
					warn(option)
				end
			end,
		})

		local targetSection = Tab4:CreateSection("Target Exploit")


		local targetToggle = Tab4:CreateToggle({
			Name = "Target Toggle",
			CurrentValue = false,
			Flag = "targetToggle", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
			Callback = function(Value)
				print(Value)
				_G.targetActivated = Value
			end,
		})

		local targetInput = Tab4:CreateInput({
			Name = "Target Name (can be shorted) (if dropdown not working)",
			CurrentValue = "",
			PlaceholderText = "PlayerName",
			RemoveTextAfterFocusLost = false,
			Flag = "targetInput",
			Callback = function(Text)
				local player = nil
				for i, v in pairs(Players:GetPlayers()) do
					if string.match(string.lower(v.Name), string.lower(Text)) then
						player = v
					end
				end
				if player and player ~= localPlayer then
					print(player.Name)
					_G.targetTarget = player
				else
					print("nil target")
					_G.targetTarget = ""
				end
			end,
		})

		local targetQuotesDropdown = Tab4:CreateDropdown({
			Name = "Target Mode Quotes",
			Options = {"Basic (auto tp to Player)", "Smart (tp if u has a 1/2/3/4 skill)"},
			CurrentOption = {"Basic (auto tp to Player)"},
			MultipleOptions = false,
			Flag = "targetQuotesDropdown", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
			Callback = function(Opt)
				local option = nil
				for i, v in Opt do
					if not option or option == nil then
						option = v
					end
				end
				if option and option ~= nil then
					if string.match(option, "Basic") then
						print("Basic")
						_G.targetQuotes = 1
					else
						print("smart")
						_G.targetQuotes = 1
					end
				else
					warn(option)
				end
			end,
		})


		local targetSafeModeToggle = Tab4:CreateToggle({
			Name = "Target Safe Mode",
			CurrentValue = false,
			Flag = "targetSafeModeToggle", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
			Callback = function(Value)
				print(Value)
				_G.targetSafeActivated = Value
			end,
		})

		local targetSafePropSlider = Tab4:CreateSlider({
			Name = "Safe Prop",
			Range = {1, 100},
			Increment = 1,
			Suffix = "Health",
			CurrentValue = 30,
			Flag = "targetSafeProp", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
			Callback = function(Value)
				print(Value)
				_G.targetSafeProp = Value
			end,
		})

		local targetSafeModeQuotesDropdown = Tab4:CreateDropdown({
			Name = "Target Safe Mode Quotes",
			Options = {"Basic (Tp to invisible platform)", "Smart (Tp to invisible platform with angles)"},
			CurrentOption = {"Smart (Tp to invisible platform with angles)"},
			MultipleOptions = false,
			Flag = "targetSafeQuotesDropdown", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
			Callback = function(Opt)
				local option = nil
				for i, v in Opt do
					if not option or option == nil then
						option = v
					end
				end
				if option and option ~= nil then
					if string.match(option, "Basic") then
						print("Basic")
						_G.targetSafeQuotes = 1
					else
						print("Smart")
						_G.targetSafeQuotes = 2
					end
				else
					warn(option)
				end
			end,
		})

		local killFarmSection = Tab4:CreateSection("Kills Farm (afk kill stealer)")


		local killToggle = Tab4:CreateToggle({
			Name = "Toggle Kill Stealer",
			CurrentValue = false,
			Flag = "KillToggle", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
			Callback = function(Value)
				print(Value)
				_G.killActivated = Value
			end,
		})

		local killWhiteListToggle = Tab4:CreateToggle({
			Name = "Whitelist (do not kill ur friends)",
			CurrentValue = true,
			Flag = "KillWhiteList", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
			Callback = function(Value)
				print(Value)
				_G.killWhitelist = Value
			end,
		})

		local killSafeSelfToggle = Tab4:CreateToggle({
			Name = "Safe Self (Do not steal, if u has lower than Safe Prop hp)",
			CurrentValue = true,
			Flag = "KillSafeSelf", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
			Callback = function(Value)
				print(Value)
				_G.killSafeSelf = Value
			end,
		})

		local killSafePropSlider = Tab4:CreateSlider({
			Name = "Safe Prop",
			Range = {0, 100},
			Increment = 1,
			Suffix = "Health",
			CurrentValue = 15,
			Flag = "KillSafeProp", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
			Callback = function(Value)
				print(Value)
				_G.killSafeProp = Value
			end,
		})

		local killStealPropSlider = Tab4:CreateSlider({
			Name = "Steal Prop",
			Range = {1, 100},
			Increment = 1,
			Suffix = "Health",
			CurrentValue = 15,
			Flag = "KillStealProp", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
			Callback = function(Value)
				print(Value)
				_G.killStealProp = Value
			end,
		})
	end

	local function setupTab5()
		local snowSection = Tab5:CreateSection("Snow Section")

		local autoGetIceBossToggle = Tab5:CreateToggle({
			Name = "Auto Get Frozen Soul",
			CurrentValue = false,
			Flag = "AGIBToggle", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
			Callback = function(Value)
				print(Value)
				_G.autoGetIceBoss = Value
			end,
		})

		local snowSection = Tab5:CreateSection("Snow Section")

		local firstM1Dropdown = Tab5:CreateDropdown({
			Name = "First M1",
			Options = {"The Strongest Hero", "Hero Hunter", "Destructive Cyborg", "Deadly Ninja", "Brutal Demon", "Blade Master", "Wild Psychic", "Martial Artist", "Tech Prodigy", "KJ"},
			CurrentOption = {"The Strongest Hero"},
			MultipleOptions = false,
			Flag = "firstM1Dropdown", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
			Callback = function(Opt)
				local option = nil
				for i, v in Opt do
					if not option or option == nil then
						option = v
					end
				end
				if option and option ~= nil then
					_G.firstM1 = option
					print(_G.firstM1)
				else
					warn(option)
				end
			end,
		})

		local secondM1Dropdown = Tab5:CreateDropdown({
			Name = "Second M1",
			Options = {"The Strongest Hero", "Hero Hunter", "Destructive Cyborg", "Deadly Ninja", "Brutal Demon", "Blade Master", "Wild Psychic", "Martial Artist", "Tech Prodigy", "KJ"},
			CurrentOption = {"The Strongest Hero"},
			MultipleOptions = false,
			Flag = "secondM1Dropdown", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
			Callback = function(Opt)
				local option = nil
				for i, v in Opt do
					if not option or option == nil then
						option = v
					end
				end
				if option and option ~= nil then
					_G.secondM1 = option
					print(_G.secondM1)
				else
					warn(option)
				end
			end,
		})

		local thirdM1Dropdown = Tab5:CreateDropdown({
			Name = "Third M1",
			Options = {"The Strongest Hero", "Hero Hunter", "Destructive Cyborg", "Deadly Ninja", "Brutal Demon", "Blade Master", "Wild Psychic", "Martial Artist", "Tech Prodigy", "KJ"},
			CurrentOption = {"The Strongest Hero"},
			MultipleOptions = false,
			Flag = "thirdM1Dropdown", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
			Callback = function(Opt)
				local option = nil
				for i, v in Opt do
					if not option or option == nil then
						option = v
					end
				end
				if option and option ~= nil then
					_G.thirdM1 = option
					print(_G.thirdM1)
				else
					warn(option)
				end
			end,
		})

		local fourthM1Dropdown = Tab5:CreateDropdown({
			Name = "Fourt M1",
			Options = {"The Strongest Hero", "Hero Hunter", "Destructive Cyborg", "Deadly Ninja", "Brutal Demon", "Blade Master", "Wild Psychic", "Martial Artist", "Tech Prodigy", "KJ"},
			CurrentOption = {"The Strongest Hero"},
			MultipleOptions = false,
			Flag = "thirdM1Dropdown", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
			Callback = function(Opt)
				local option = nil
				for i, v in Opt do
					if not option or option == nil then
						option = v
					end
				end
				if option and option ~= nil then
					_G.fourthM1 = option
					print(_G.fourthM1)
				else
					warn(option)
				end
			end,
		})

		local customM1sToggle = Tab5:CreateToggle({
			Name = "Apply Custom M1s",
			CurrentValue = false,
			Flag = "customM1sToggle", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
			Callback = function(Value)
				print(Value)
				_G.M1sActivated = Value
			end,
		})

	end

	local function setupTab6()
		local MapCenter = Tab6:CreateButton({
			Name = "Map Center",
			Callback = function()
				localPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(149, 440, 29)
			end,
		})
		local mapCenterBind = Tab6:CreateKeybind({
			Name = "Map Center TP Bind",
			CurrentKeybind = "",
			HoldToInteract = false,
			Flag = "mapCenterBind", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
			Callback = function(Keybind)
				print(Keybind)
				localPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(149, 440, 29)
			end,
		})

		local voidPlate = Tab6:CreateButton({
			Name = "Void Platform",
			Callback = function()
				localPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(0, -493, 0)
			end,
		})
		local voidPlatBind = Tab6:CreateKeybind({
			Name = "Void Platform TP Bind",
			CurrentKeybind = "",
			HoldToInteract = false,
			Flag = "voidPlatBind", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
			Callback = function(Keybind)
				print(Keybind)
				localPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(0, -493, 0)
			end,
		})

		local DeathCounterRoom = Tab6:CreateButton({
			Name = "Death Counter Room",
			Callback = function()
				localPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-66, 30, 20356)
			end,
		})
		local deathRoomBind = Tab6:CreateKeybind({
			Name = "Death Counter Room TP Bind",
			CurrentKeybind = "",
			HoldToInteract = false,
			Flag = "deathRoomBind", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
			Callback = function(Keybind)
				print(Keybind)
				localPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-66, 30, 20356)
			end,
		})

		local AtomicSlashRoom = Tab6:CreateButton({
			Name = "Atomic Slash Room",
			Callback = function()
				localPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(1050, 140, 23010)
			end,
		})
		local atomicSlashBind = Tab6:CreateKeybind({
			Name = "Atomic Slash Room TP Bind",
			CurrentKeybind = "",
			HoldToInteract = false,
			Flag = "atomicSlashBind", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
			Callback = function(Keybind)
				print(Keybind)
				localPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(1050, 140, 23010)
			end,
		})

		local UpperBaseplate = Tab6:CreateButton({
			Name = "Upper Baseplate",
			Callback = function()
				localPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(1060, 405, 22887)
			end,
		})
		local upperBaseplateBind = Tab6:CreateKeybind({
			Name = "Upper Baseplate TP Bind",
			CurrentKeybind = "",
			HoldToInteract = false,
			Flag = "upperBaseplateBind", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
			Callback = function(Keybind)
				print(Keybind)
				localPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(1060, 405, 22887)
			end,
		})

		local LowerBaseplate = Tab6:CreateButton({
			Name = "Lower Baseplate",
			Callback = function()
				localPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(1060, 20, 22887)
			end,
		})
		local lowerBaseplateBind = Tab6:CreateKeybind({
			Name = "Lower Baseplate TP Bind",
			CurrentKeybind = "",
			HoldToInteract = false,
			Flag = "lowerBaseplateBind", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
			Callback = function(Keybind)
				print(Keybind)
				localPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(1060, 20, 22887)
			end,
		})

		local weakestDummy = Tab6:CreateButton({
			Name = "Weakest Dummy",
			Callback = function()
				localPlayer.Character.HumanoidRootPart.CFrame = workspace.Live["Weakest Dummy"].HumanoidRootPart.CFrame
			end,
		})
		local weakestDummyBind = Tab6:CreateKeybind({
			Name = "Weakest Dummy TP Bind",
			CurrentKeybind = "",
			HoldToInteract = false,
			Flag = "weakestDummyBind", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
			Callback = function(Keybind)
				print(Keybind)
				localPlayer.Character.HumanoidRootPart.CFrame = workspace.Live["Weakest Dummy"].HumanoidRootPart.CFrame
			end,
		})

		local playersSSection = Tab6:CreateSection("Players Teleports (Cooming Soon)")

	end

	local function setupTab7()
		local rejoinButton = Tab7:CreateButton({
			Name = "Rejoin Current Server",
			Callback = function()
				local Rejoin = coroutine.create(function()
					local Success, ErrorMessage = pcall(function()
						TeleportService:Teleport(game.PlaceId, localPlayer)
					end)

					if ErrorMessage and not Success then
						warn(ErrorMessage)
					end
				end)
				coroutine.resume(Rejoin)
			end,
		})
	end

	setupTab()
	setupTab2()
	setupTab3()
	setupTab4()
	setupTab5()
	setupTab6()
	setupTab6()
	setupTab7()
end
setupUI()


local function geyPlayingAnims()
	local anims = {}
	local humanoid = localPlayer.Character:FindFirstChildOfClass("Humanoid")
	if humanoid then
		for _, v in pairs(humanoid:GetPlayingAnimationTracks()) do
			if v.Animation then
				table.insert(anims, v.Animation)
			end
		end
	end
	return anims
end

local function getPlayingAnim(animId)
	if not animId then return end
	if type(animId) ~= "string" then animId = tostring(animId) end

	if localPlayer.Character then
		local humanoid = localPlayer.Character:FindFirstChildOfClass("Humanoid")
		if humanoid and (humanoid.Health ~= 0 and humanoid.Health ~= 1) then
			local animator = humanoid:WaitForChild("Animator")
			for _, animation in pairs(humanoid:GetPlayingAnimationTracks()) do
				if animation then
					local animationId = animation.Animation.AnimationId
					local split = string.split(tostring(animationId), "rbxassetid://")
					if split and split[2] then
						if split[2] == animId then -- 11343250001
							return true
						end
					end
				end
			end
			if animator then
				for _, animation in pairs(animator:GetPlayingAnimationTracks()) do
					if animation then
						local animationId = animation.Animation.AnimationId
						local split = string.split(tostring(animationId), "rbxassetid://")
						if split and split[2] then
							if split[2] == animId then
								return true
							end
						end
					end
				end
			end
		end
	end

	return false
end

local function onCharAdded(char)
	char:WaitForChild("Humanoid"):GetPropertyChangedSignal("Health"):Connect(function()
		if not char:FindFirstChild("HumanoidRootPart") then return end
		if not _G.killactivated or _G.killactivated == false then return end
		if math.floor(char.Humanoid.Health) <= _G.killStealProp and (math.floor(char.Humanoid.Health) ~= 0 or math.floor(char.Humanoid.Health) ~= 1) then return end
		if _G.killSafeSelf == true and localPlayer.Character.Humanoid.Health <= _G.killSafeProp then return end
		if _G.killKilling == true then return end
		if _G.killChargeUp == true then return end
		if killWorking == false then return end

		if selectedChar ~= "" or selectedChar ~= nil then
			if selectedChar == "Cyborg" then
				if not playerGui.Hotbar.Backpack.Hotbar["4"].Base:FindFirstChild("Cooldown") then
					_G.killKilling = true

					coroutine.wrap(function()
						local s = tick()
						while tick() - s < 1.65 do
							local cf = char.HumanoidRootPart.CFrame
							localPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(cf.Position.X, cf.Position.Y, cf.Position.Z + 65) + char.Humanoid.MoveDirection * char.Humanoid.WalkSpeed * 1.25, Vector3.new(char.HumanoidRootPart.Position.X, localPlayer.Character.HumanoidRootPart.Position.Y, char.HumanoidRootPart.Position.Z))
							task.wait()
						end
					end)()

					task.wait(0.25)
					localPlayer.Character.Communicate:FireServer({
						["Goal"] = "Console Move",
						["Tool"] = localPlayer.Backpack:WaitForChild("Jet Dive")
					})

					task.wait(4)

					_G.killKilling = false

				elseif not playerGui.Hotbar.Backpack.Hotbar["3"].Base:FindFirstChild("Cooldown") then
					_G.killChargeUp = true
					localPlayer.Character.Communicate:FireServer({
						["Goal"] = "Console Move",
						["Tool"] = localPlayer.Backpack:WaitForChild("Blitz Shot")
					})
					task.wait(2.5)
					_G.killChargeUp = false
					_G.killKilling = true

					coroutine.wrap(function()
						repeat
							local cf = char.HumanoidRootPart.CFrame
							localPlayer.Character.HumanoidRootPart.CFrame = CFrame.lookAt(cf.Position + Vector3.new(30, 30, 0), cf.Position + char.Humanoid.MoveDirection * char.Humanoid.WalkSpeed * 1.25)
							task.wait()
						until _G.killKilling == false
					end)()

					task.wait(1.25)
					_G.killKilling = false
				elseif not playerGui.Hotbar.Backpack.Hotbar["2"].Base:FindFirstChild("Cooldown") then
					_G.killChargeUp = true
					localPlayer.Character.Communicate:FireServer({
						["Goal"] = "Console Move",
						["Tool"] = localPlayer.Backpack:WaitForChild("Ignition Burst")
					})
					task.wait(1)
					_G.killChargeUp = false
					_G.killKilling = true

					coroutine.wrap(function()
						repeat
							local cf = char.HumanoidRootPart.CFrame
							localPlayer.Character.HumanoidRootPart.CFrame = cf - (cf.LookVector * 7) + char.Humanoid.MoveDirection
							task.wait()
						until _G.killKilling == false
					end)()

					task.wait(1.25)
					_G.killKilling = false
				end

			elseif selectedChar == "Hunter" then
				if not playerGui.Hotbar.Backpack.Hotbar["1"].Base:FindFirstChild("Cooldown") then
					_G.killKilling = true

					coroutine.wrap(function()
						repeat
							local cf = char.HumanoidRootPart.CFrame
							localPlayer.Character.HumanoidRootPart.CFrame = cf - (cf.LookVector * 3.5) + char.Humanoid.MoveDirection
							task.wait()
						until _G.killKilling == false
					end)()

					localPlayer.Character.Communicate:FireServer({
						["Goal"] = "Console Move",
						["Tool"] = localPlayer.Backpack:WaitForChild("Flowing Water")
					})

					task.wait(2)
					_G.killKilling = false

				elseif not playerGui.Hotbar.Backpack.Hotbar["2"].Base:FindFirstChild("Cooldown") then
					_G.killKilling = true

					coroutine.wrap(function()
						repeat
							local cf = char.HumanoidRootPart.CFrame
							localPlayer.Character.HumanoidRootPart.CFrame = cf - (cf.LookVector * 3.5) + char.Humanoid.MoveDirection
							task.wait()
						until _G.killKilling == false
					end)()

					localPlayer.Character.Communicate:FireServer({
						["Goal"] = "Console Move",
						["Tool"] = localPlayer.Backpack:WaitForChild("Lethal Whirlwind Stream")
					})

					task.wait(2)
					_G.killKilling = false

				elseif not playerGui.Hotbar.Backpack.Hotbar["3"].Base:FindFirstChild("Cooldown") then
					_G.killKilling = true

					coroutine.wrap(function()
						repeat
							local cf = char.HumanoidRootPart.CFrame
							localPlayer.Character.HumanoidRootPart.CFrame = cf - (cf.LookVector * 1) + char.Humanoid.MoveDirection
							task.wait()
						until _G.killKilling == false
					end)()

					localPlayer.Character.Communicate:FireServer({
						["Goal"] = "Console Move",
						["Tool"] = localPlayer.Backpack:WaitForChild([[Hunter's Grasp]])
					})

					task.wait(2)
					_G.killKilling = false

				end

			elseif selectedChar == "Ninja" then
				if not playerGui.Hotbar.Backpack.Hotbar["1"].Base:FindFirstChild("Cooldown") then
					_G.killChargeUp = true
					localPlayer.Character.Communicate:FireServer({
						["Goal"] = "Console Move",
						["Tool"] = localPlayer.Backpack:WaitForChild("Flash Strike")
					})
					task.wait(0.1)
					_G.killChargeUp = false
					_G.killKilling = true

					coroutine.wrap(function()
						repeat
							local cf = char.HumanoidRootPart.CFrame
							localPlayer.Character.HumanoidRootPart.CFrame = cf - (cf.LookVector * 8) + char.Humanoid.MoveDirection
							task.wait()
						until _G.killKilling == false
					end)()

					task.wait(1)
					_G.killKilling = false

				elseif not playerGui.Hotbar.Backpack.Hotbar["2"].Base:FindFirstChild("Cooldown") then
					if char.Humanoid.Health < 12 then
						_G.killChargeUp = true
						localPlayer.Character.Communicate:FireServer({
							["Goal"] = "Console Move",
							["Tool"] = localPlayer.Backpack:WaitForChild("Whirlwind Kick")
						})
						task.wait(0.4)
						_G.killChargeUp = false
						_G.killKilling = true

						coroutine.wrap(function()
							repeat
								local cf = char.HumanoidRootPart.CFrame
								localPlayer.Character.HumanoidRootPart.CFrame = cf - (cf.LookVector * 1) + char.Humanoid.MoveDirection
								task.wait()
							until _G.killKilling == false
						end)()

						task.wait(1.5)
						_G.killKilling = false
					end

				elseif not playerGui.Hotbar.Backpack.Hotbar["4"].Base:FindFirstChild("Cooldown") then
					_G.killKilling = true

					coroutine.wrap(function()
						repeat
							local cf = char.HumanoidRootPart.CFrame
							localPlayer.Character.HumanoidRootPart.CFrame = cf - (cf.LookVector * 7) + char.Humanoid.MoveDirection
							task.wait()
						until _G.killKilling == false
					end)()

					localPlayer.Character.Communicate:FireServer({
						["Goal"] = "Console Move",
						["Tool"] = localPlayer.Backpack:WaitForChild("Explosive Shuriken")
					})

					task.wait(2)
					_G.killKilling = false

				elseif not playerGui.Hotbar.Backpack.Hotbar["3"].Base:FindFirstChild("Cooldown") then
					_G.killKilling = true

					coroutine.wrap(function()
						repeat
							local cf = char.HumanoidRootPart.CFrame
							localPlayer.Character.HumanoidRootPart.CFrame = cf - (cf.LookVector * 0) + char.Humanoid.MoveDirection
							task.wait()
						until _G.killKilling == false
					end)()

					localPlayer.Character.Communicate:FireServer({
						["Goal"] = "Console Move",
						["Tool"] = localPlayer.Backpack:WaitForChild("Scatter")
					})

					task.wait(4)
					_G.killKilling = false

				else
					warn("CD")
				end

			elseif selectedChar == "Esper" then
				if not playerGui.Hotbar.Backpack.Hotbar["1"].Base:FindFirstChild("Cooldown") then
					if char.Humanoid.Health <= 13 then
						_G.killKilling = true

						coroutine.wrap(function()
							repeat
								local cf = char.HumanoidRootPart.CFrame
								localPlayer.Character.HumanoidRootPart.CFrame = cf - (cf.LookVector * 4.5) + char.Humanoid.MoveDirection
								task.wait()
							until _G.killKilling == false
						end)()

						task.wait(0.25)

						localPlayer.Character.Communicate:FireServer({
							["Goal"] = "Console Move",
							["CrushingPull"] = char,
							["Tool"] = localPlayer.Backpack:WaitForChild("Crushing Pull"),
							["ToolName"] = "Crushing Pull"
						})

						task.wait(2)
						_G.killKilling = false
					end


				elseif not playerGui.Hotbar.Backpack.Hotbar["3"].Base:FindFirstChild("Cooldown") then
					if char.Humanoid.Health <= 12 then
						_G.killChargeUp = true
						localPlayer.Character.Communicate:FireServer({
							["Goal"] = "Console Move",
							["Tool"] = localPlayer.Backpack:WaitForChild("Stone Coffin")
						})
						task.wait(0.15)
						_G.killChargeUp = false
						_G.killKilling = true

						coroutine.wrap(function()
							repeat
								local cf = char.HumanoidRootPart.CFrame
								localPlayer.Character.HumanoidRootPart.CFrame = cf - (cf.LookVector * 3) + char.Humanoid.MoveDirection
								task.wait()
							until _G.killKilling == false
						end)()

						task.wait(1.5)
						_G.killKilling = false
					end

				elseif not playerGui.Hotbar.Backpack.Hotbar["4"].Base:FindFirstChild("Cooldown") then
					if char.Humanoid.Health <= 13 then
						_G.killChargeUp = true
						localPlayer.Character.Communicate:FireServer({
							["Goal"] = "Console Move",
							["Tool"] = localPlayer.Backpack:WaitForChild("Expulsive Push")
						})
						task.wait(1)
						localPlayer.Character.Communicate:FireServer({
							["Goal"] = "Console Move",
							["Tool"] = localPlayer.Backpack:WaitForChild("Expulsive Push")
						})
						_G.killChargeUp = false
						_G.killKilling = true

						coroutine.wrap(function()
							repeat
								local cf = char.HumanoidRootPart.CFrame
								localPlayer.Character.HumanoidRootPart.CFrame = cf - (cf.LookVector * 1.5) + char.Humanoid.MoveDirection
								task.wait()
							until _G.killKilling == false
						end)()

						task.wait(1.5)
						_G.killKilling = false
					end

				elseif not playerGui.Hotbar.Backpack.Hotbar["2"].Base:FindFirstChild("Cooldown") then
					if char.Humanoid.Health <= 8 then
						_G.killKilling = true
						localPlayer.Character.Communicate:FireServer({
							["Goal"] = "Console Move",
							["Tool"] = localPlayer.Backpack:WaitForChild("Windstorm Fury")
						})

						coroutine.wrap(function()
							repeat
								local cf = char.HumanoidRootPart.CFrame
								localPlayer.Character.HumanoidRootPart.CFrame = cf - (cf.LookVector * 1.5) + char.Humanoid.MoveDirection
								task.wait()
							until _G.killKilling == false
						end)()

						task.wait(1.5)
						_G.killKilling = false
					end

				else
					warn("CD")
				end

			elseif selectedChar == "Blade" then
				if not playerGui.Hotbar.Backpack.Hotbar["1"].Base:FindFirstChild("Cooldown") then
					_G.killChargeUp = true
					localPlayer.Character.Communicate:FireServer({
						["Goal"] = "Console Move",
						["Tool"] = localPlayer.Backpack:WaitForChild("Quick Slice")
					})
					task.wait(0.2)
					_G.killChargeUp = false
					_G.killKilling = true

					coroutine.wrap(function()
						repeat
							local cf = char.HumanoidRootPart.CFrame
							localPlayer.Character.HumanoidRootPart.CFrame = cf - (cf.LookVector * 6) + char.Humanoid.MoveDirection
							task.wait()
						until _G.killKilling == false
					end)()

					task.wait(0.5)
					_G.killKilling = false

				elseif not playerGui.Hotbar.Backpack.Hotbar["2"].Base:FindFirstChild("Cooldown") then
					_G.killKilling = true

					coroutine.wrap(function()
						repeat
							local cf = char.HumanoidRootPart.CFrame
							localPlayer.Character.HumanoidRootPart.CFrame = cf - (cf.LookVector * 3) + char.Humanoid.MoveDirection
							task.wait()
						until _G.killKilling == false
					end)()

					localPlayer.Character.Communicate:FireServer({
						["Goal"] = "Console Move",
						["Tool"] = localPlayer.Backpack:WaitForChild("Atmos Cleave")
					})

					task.wait(2)
					_G.killKilling = false

				elseif not playerGui.Hotbar.Backpack.Hotbar["3"].Base:FindFirstChild("Cooldown") then
					_G.killKilling = true

					coroutine.wrap(function()
						repeat
							local cf = char.HumanoidRootPart.CFrame
							localPlayer.Character.HumanoidRootPart.CFrame = cf - (cf.LookVector * 6) + char.Humanoid.MoveDirection
							task.wait()
						until _G.killKilling == false
					end)()

					localPlayer.Character.Communicate:FireServer({
						["Goal"] = "Console Move",
						["Tool"] = localPlayer.Backpack:WaitForChild("Pinpoint Cut")
					})

					task.wait(1)
					_G.killKilling = false

				else
					warn("CD")
				end
			else
				warn(selectedChar, "changedchar")
			end
		end
	end)
end

local function hlChar(character)
	if not character then return end
	if character:IsA("Player") then character = character.Character end

	local player = Players:GetPlayerFromCharacter(character)
	local highlight = nil

	if not player then return end

	if not character:FindFirstChild("UltEsp") then
		highlight = Instance.new("Highlight", character)
		highlight.DepthMode = Enum.HighlightDepthMode.Occluded
		highlight.FillColor = Color3.fromRGB(255, 255, 0)
		highlight.FillTransparency = 0.5
		highlight.OutlineTransparency = 0.35
		highlight.Name = "UltEsp"

		highlight.Enabled = false
	else
		highlight = character:FindFirstChild("UltEsp")
	end

	if not highlight then return end

	local ultMoves = {
		"Death Counter",
		"Table Flip",
		"Serious Punch",
		"Omni Directional Punch",
		"",
		"",
		"",
		"",

		"",
		"",
		"",
		"",

		"",
		"",
		"",
		"",
	}

	player.Backpack.ChildAdded:Connect(function(child)
		if child.Name == "Death Counter" then
			highlight.Enabled = true
		end
		print("add", child.Name)
	end)
end


local function antiDeathCounter()
	if _G.adcActivated == false then return end
	if _G.isDeath == false then return end
	if _G.adcWorking == true then return end
	_G.adcWorking = true

	local oldCFrame = localPlayer.Character.HumanoidRootPart.CFrame
	localPlayer.Character.Humanoid.AutoRotate = false

	for i, v in pairs(playerGui:GetDescendants()) do
		if v:IsA("ScreenGui") and v.Name == "Death" then
			v.Enabled = false
		end
	end

	if _G.adcQuotes == 1 then
		repeat
			_G.adcNeedTp = true
		until task.wait(1)
		_G.adcNeedTp = false
		print("antis")

		if localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") then
			localPlayer.Character.HumanoidRootPart.CFrame = oldCFrame
			localPlayer.Character.Humanoid.AutoRotate = true
		end
		camera.CameraType = Enum.CameraType.Custom
	else
		repeat
			_G.adcNeedCustomTp = true
		until task.wait(1)
		_G.adcNeedCustomTp = false
	end

	_G.adcWorking = false
end

local function voidKill()
	if _G.voidKillActivated == false then return end
	if _G.voidKilling == true then return end
	if _G.isDeath == true then return end

	local oldCFrame = localPlayer.Character.HumanoidRootPart.CFrame
	local charAttribute = localPlayer.Character:GetAttribute("Character")

	_G.voidKilling = true

	if _G.voidKillQuotes == 1 then
		task.wait(0.3)
	else
		if localPlayer.Character:GetAttribute("Character") == "Hunter" then
			print("Hunter")
			task.wait(0.25)

		elseif localPlayer.Character:GetAttribute("Character") == "Batter" then
			print("Bat")
			task.wait(0.65)

		elseif localPlayer.Character:GetAttribute("Character") == "Blade" then
			print("Blade")
			task.wait(0.5)

		elseif localPlayer.Character:GetAttribute("Character") == "Esper" then
			print("Tatsu")
			task.wait(0.15)
		end
	end
	_G.voidNeedTp = true
	print("tp")

	if _G.voidKillQuotes == 1 then
		task.wait(4)
	else
		if localPlayer.Character:GetAttribute("Character") == "Hunter" then
			print("Hunter")
			task.wait(3)

		elseif localPlayer.Character:GetAttribute("Character") == "Batter" then
			print("Bat")
			task.wait(5)

		elseif localPlayer.Character:GetAttribute("Character") == "Blade" then
			print("Blade")
			task.wait(3)

		elseif localPlayer.Character:GetAttribute("Character") == "Esper" then
			print("Tatsu")
			task.wait(1.5)
		end
	end

	_G.voidNeedTp = false
	_G.voidKilling = false

	localPlayer.Character.HumanoidRootPart.CFrame = oldCFrame
end

local function tatsuUlt()
	print("func")
	if _G.tatsuUltActivated == false then warn("not activated") return end
	if _G.tatsuUltWorking == true then warn("already working") return end
	if not localPlayer.Character then warn("Char not found") return end
	print("skuf")
	_G.tatsuUltWorking = true
	print("ult")

	local chars = {}
	for i, v in pairs(Players:GetPlayers()) do
		if v and v.Character then
			if v ~= localPlayer then
				print(v.Name)
				table.insert(chars, v.Character)
			end
		end
	end

	local oldCFrame = localPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame

	task.wait(1)
	if chars[1] then
		print("bring all")
		for i, v in pairs(chars) do
			if localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("HumanoidRootPart") then
				localPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame = v:FindFirstChild("HumanoidRootPart").CFrame
				task.wait(0.15)
			end
		end

		--if _G.tatsuUltQuotes == 1 then
		localPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame = oldCFrame

		task.defer(function()
			task.wait(7)
			_G.tatsuUltWorking = false
		end)

		return true
		--[[else
			_G.voidNeedTp = true
			task.wait(2.5)
			_G.voidNeedTp = false
			print("voided")

			task.defer(function()
				task.wait(7)
				_G.tatsuUltWorking = false
			end)
			return true
		end]]
	else
		warn(#chars, chars[1], chars[2])
	end

	_G.tatsuUltWorking = false
	return false
end

local function target()
	if _G.targetActivated == false then return end
	if _G.targetTarget == nil then return end
	if not _G.targetTarget.Character then return end
	if not _G.targetTarget.Character.Humanoid then return end
	if _G.targetTarget.Character.Humanoid.Health == 0 or _G.targetTarget.Character.Humanoid.Health == 1 then return end
	print("target", _G.targetTarget.Name)

	local player = _G.targetTarget

	if player then
		if _G.targetQuotes == 1 then -- basic mode
			_G.targetNeedTp = true

		else -- smart mode
			repeat
				task.wait(0.5)
				if not playerGui.Hotbar.Backpack.Hotbar["1"].Base:FindFirstChild("Cooldown") then
					_G.targetNeedTp = true

				elseif not playerGui.Hotbar.Backpack.Hotbar["2"].Base:FindFirstChild("Cooldown") then
					_G.targetNeedTp = true

				elseif not playerGui.Hotbar.Backpack.Hotbar["3"].Base:FindFirstChild("Cooldown") then
					_G.targetNeedTp = true

				elseif not playerGui.Hotbar.Backpack.Hotbar["4"].Base:FindFirstChild("Cooldown") then
					_G.targetNeedTp = true
				else
					_G.targetNeedTp = false
					warn("CD")
				end
			until _G.targetActivated == false or _G.targetTarget == nil
			print(_G.targetActivated, _G.targetTarget)
		end
	else
		warn(player)
	end
end

local function autoGetIceBoss(object)
	if _G.autoGetIceBoss == false then return end

	if object.Name == "Frozen Lock" and object.Parent == workspace.Thrown then
		task.wait(3)
		repeat
			localPlayer.Character:MoveTo(object["Root"].Position)    
		until task.wait(0.5) and localPlayer.Character:GetAttribute("IceBoss") == true
	end
end

local function snowballBooster()
	if _G.snowballBooster == false then return end
	if _G.snowballBoosterNeedTp == true then return end
	local nearestPlayer = nil
	local nearestMagnutide = 9999
	local boosterDistance = 50

	for i, player in pairs(Players:GetPlayers()) do
		if player ~= localPlayer and player.Character.Humanoid and localPlayer.Character.Humanoid then
			if (player.Character.Humanoid.Health ~= 0 and player.Character.Humanoid.Health ~= 1) and (localPlayer.Character.Humanoid.Health ~= 0 and localPlayer.Character.Humanoid.Health ~= 1) then
				local distance = math.floor((player.Character.HumanoidRootPart.Position - localPlayer.Character.HumanoidRootPart.Position).Magnitude)

				if distance <= boosterDistance then
					if distance < nearestMagnutide then
						nearestPlayer = player
						nearestMagnutide = distance
					else
						warn("Ez bozo", distance, nearestMagnutide)
					end
				end
			end
		end
	end

	if nearestPlayer and nearestMagnutide then
		print(nearestPlayer, nearestMagnutide)
		_G.snowballPlayer = nearestPlayer
		_G.snowballBoosterNeedTp = true
		task.wait(2.5)
		_G.snowballBoosterNeedTp = false
		_G.snowballPlayer = nil
	end
end


RunService.Heartbeat:Connect(function()
	if localPlayer.Character then
		if _G.adcActivated == true then
			if _G.isDeath == true then
				antiDeathCounter()
			end
		end

		if _G.targetActivated == true and _G.targetTarget ~= "" and _G.targetTarget.Character  then
			target()
		end

		if _G.adcNeedTp == true then
			localPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(1, -490, 1)

			if _G.killActivated == true then
				_G.killActivated = false
			end

			if _G.targetActivated == true then
				_G.targetActivated = false
				_G.targetNeedTp = false
				_G.targetTarget = ""
			end

			if _G.snowballBooster == true then
				_G.snowballBooster = false
				_G.snowballPlayer = nil
			end
		end

		if _G.adcNeedCustomTp == true then
			if localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") then
				localPlayer.Character.HumanoidRootPart.CFrame = _G.adcCusomCFrame
			end

			if _G.killActivated == true then
				_G.killActivated = false
			end

			if _G.voidNeedTp == true then
				_G.voidNeedTp = false
			end

			if _G.targetActivated == true then
				_G.targetActivated = false
				_G.targetNeedTp = false
				_G.targetTarget = ""
			end
		end

		if _G.voidNeedTp == true then
			localPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(1, 205, 1)
			if _G.targetNeedTp == true then
				_G.targetNeedTp = false
			end
		end

		if _G.targetActivated == true then
			if _G.targetNeedTp == true then
				if _G.targetTarget ~= "" and _G.targetTarget.Character then
					if _G.targetSafeActivated == true then
						if localPlayer.Character.Humanoid.Health > _G.targetSafeProp then
							local cf = _G.targetTarget.Character.HumanoidRootPart.CFrame
							localPlayer.Character.HumanoidRootPart.CFrame = cf - (cf.LookVector * 3.5) + _G.targetTarget.Character.Humanoid.MoveDirection
						else
							if _G.targetSafeQuotes == 1 then
								localPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(1, -490, 1)
							else
								localPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(1, -492, 1) * CFrame.Angles(90, 0, 0)
							end
						end
					else
						local cf = _G.targetTarget.Character.HumanoidRootPart.CFrame
						localPlayer.Character.HumanoidRootPart.CFrame = cf - (cf.LookVector * 3.5) + _G.targetTarget.Character.Humanoid.MoveDirection
					end
				end
			end
		end

		if _G.snowballBoosterNeedTp == true and _G.snowballPlayer ~= nil then
			print(_G.snowballPlayer)
			local cf = _G.snowballPlayer.Character.HumanoidRootPart.CFrame
			localPlayer.Character.HumanoidRootPart.CFrame = cf - (cf.LookVector * 3.5) + _G.targetTarget.Character.Humanoid.MoveDirection
		end
	end

	if localPlayer.Character then
		local humanoid = localPlayer.Character:FindFirstChildOfClass("Humanoid")

		local allAnims = geyPlayingAnims()
		local isDeathCountered = getPlayingAnim("11343250001")
		local isSnowball = getPlayingAnim("128022763591042")
		local tatsuUltAct = getPlayingAnim("16734584478")
		_G.isDeath = isDeathCountered

		if _G.voidKillActivated == true then
			local voidAnims = {"12273188754"; "14004235777", "14046756619", "14705929107"; "15145462680", "15295895753"; "16139108718"; ""} -- rbxassetid://14516273501

			local isAnim = false
			for i, v in voidAnims do
				if isAnim == false then
					isAnim = getPlayingAnim(v)
				end
			end
			if _G.voidKillActivated == true and _G.voidKilling == false and isAnim == true then
				print("start func")
				voidKill()
			end
		end

		if tatsuUltAct == true and _G.tatsuUltActivated == true and _G.tatsuUltWorking == false then
			print("tATSU ULT")
			tatsuUlt()
		end

		if isSnowball == true and _G.snowballBooster == true then
			snowballBooster()
		end

		if _G.M1sActivated == true then
			local anim = false
			for i, v in pairs(allAnims) do
				local animId = v.AnimationId
				local split = string.split(tostring(animId), "rbxassetid://")
				animId = split[2]
				if anim == false or anim == nil then
					for _, c in pairs(M1sAnimations) do
						if anim == false or anim == nil then
							if animId == c then
								anim = v
							end
						end
					end
				end
			end
			if anim ~= false and anim ~= nil then
				print("has")
				anim:Stop()
				local anim2 = Instance.new("Animation", game.Players.LocalPlayer.Character)
				anim2.AnimationId = _G.firstM1
				local anim3 = humanoid:LoadAnimation(anim2)
				anim3:Play()
				anim2:Destroy()
			end
		end
	end

	if localPlayer.Character then
		local has = false
		for i, v in pairs(_G.killWorkChars) do
			if localPlayer.Character:GetAttribute("Character") == v then
				selectedChar = v
				has = true
			end
		end
		if not has or has == false then
			killWorking = false
		else
			killWorking = true
		end

		if _G.killActivated == false then
			killWorking = false
		end

		if _G.killActivated == true and killWorking == true and _G.killKilling == false and localPlayer.Character:FindFirstChild("HumanoidRootPart") then
			localPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(0, 200, 0)
		end
	end
end)

local function onPlrAdded(plr)
	plr.CharacterAdded:Connect(hlChar)

	if _G.killWhiteList == true then
		if plr:IsFriendsWith(localPlayer.UserId) then
			return
		end
	end

	plr.CharacterAdded:Connect(onCharAdded)
	if plr.Character then
		onCharAdded(plr.Character)
		hlChar(plr.Character)
	end
end

for _, plr in Players:GetPlayers() do
	hlChar(plr.Character)
	onPlrAdded(plr)
end
for _, part in workspace.Thrown:GetChildren() do
	autoGetIceBoss(part)
end
Players.PlayerAdded:Connect(onPlrAdded)
workspace.Thrown.ChildAdded:Connect(autoGetIceBoss)

local humanoid = localPlayer.Character:FindFirstChild("Humanoid")
humanoid.Changed:Connect(function()
	if _G.walkActivated == true then
		humanoid.WalkSpeed = _G.walkSpeed
	end

	if _G.jumpActivated == true then
		humanoid.JumpPower = _G.jumpPower
	end
end)
localPlayer.CharacterAdded:Connect(function(character)
	local humanoid = character:FindFirstChild("Humanoid")
	humanoid.Changed:Connect(function()
		if _G.walkActivated == true then
			humanoid.WalkSpeed = _G.walkSpeed
		end

		if _G.jumpActivated == true then
			humanoid.JumpPower = _G.jumpPower
		end
	end)
end)

Rayfield:Notify({
	Title = "Tsb Script",
	Content = "Loaded",
	Duration = 6.5,
	Image = 4483362458,
})
