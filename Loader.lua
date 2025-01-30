print("injected")
local TeleportService = game:GetService("TeleportService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local localPlayer = Players.LocalPlayer
local playerGui = localPlayer.PlayerGui
local mouse = localPlayer:GetMouse()
local camera = workspace.CurrentCamera

local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/zedikik/RayField/refs/heads/main/RayField.lua'))() -- https://sirius.menu/rayfield
if not Rayfield then return end
Rayfield:Notify({
	Title = "Tsb Script",
	Content = "Loading",
	Duration = 6.5,
	Image = 4483362458,
})

local killWorking = false
local selectedChar = ""

if not _G.killWorkChars then
	_G.killWorkChars = {"Hunter", "Cyborg", "Ninja", "Esper", "Blade"}
	_G.killActivated = false
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
	_G.voidManualWait = 4
	_G.voidKillQuotes = 2 -- wait time (1 = default time; 2 = smart wait)
	_G.voidKillPunishQuotes = 1 -- 💀💀💀 (1 is teleport to teleports; 2 is absolute dead)
	_G.voidKillPunishTpLocation = 1 -- 1 is Death Counter room, 2 is Atomic room, 3 is Upper Baseplate, 4 is Lower Baseplate

	_G.hitboxColor = Color3.new(255, 0, 0)

	_G.ultEspActivated = false

	_G.savageBringActivated = false
	_G.savageBringWorking = false
	_G.savageBringQuotes = 2 -- 1 is bring all; 2 is void kill all;

	_G.brutalBeatdownActivated = false
	_G.brutalBeatdownWorking = false
	_G.brutalBeatdownQuotes = 2 -- 1 is bring all; 2 is void kill all;

	_G.targetActivated = false
	_G.targetAutoAfk = false
	_G.targetNeedTp = false
	_G.targetTarget = nil
	_G.targetQuotes = 1 -- 1 is basic target, 2 is smart target (tp only if has skills)
	_G.targetSafeActivated = true
	_G.targetSafeProp = 30
	_G.targetSafeQuotes = 2 -- 1 is basic (15hp prop void); 2 is absolute safe (15hp prop void * CFrame.Angles(0, 90, 0)

	_G.autoGetIceBoss = false

	_G.walkSpeed = 16
	_G.jumpPower = 50
	_G.walkActivated = false
	_G.jumpActivated = false

	_G.autoRotateActivated = false

	_G.safeMode = false
	_G.safeModeNeedTP = false
	_G.safeModeLoc = CFrame.new()
	_G.safeModeProp = 17

	_G.adminWarning = false
	_G.adminFriend = false
end

if not workspace:FindFirstChild("VoidPlate") then
	local voidPlate = Instance.new("Part")
	voidPlate.Parent = game.Workspace
	voidPlate.Name = "VoidPlate"
	voidPlate.Anchored = true
	voidPlate.Material = Enum.Material.ForceField
	voidPlate.Size = Vector3.new(1027, 5, 770)
	voidPlate.CFrame = CFrame.new(0, -497, 0)
end

local Window = Rayfield:CreateWindow({
	Name = "Tsb Script",
	Icon = 0, -- Icon in Topbar. Can use Lucide Icons (string) or Roblox Image (number). 0 to use no icon (default).
	LoadingTitle = "Interface",
	LoadingSubtitle = "by skuff",
	Theme = "Default", -- Check https://docs.sirius.menu/rayfield/configuration/themes

	DisableRayfieldPrompts = true,
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
		Key = {"Skuff", "skuff", "SKUFF", "skuf", "SKUF", "Skuf"} -- List of keys that will be accepted by the system, can be RAW file links (pastebin, github etc) or simple strings ("hello","key22")
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
					task.wait(_G.voidManualWait)
					_G.voidKilling = false
					_G.voidNeedTp = false

					localPlayer.Character.HumanoidRootPart.CFrame = oldCFrame
				else
					warn("already void killing or in void")
				end
			end,
		})
		local manualWaitSlider = Tab:CreateSlider({
			Name = "Manual Void Wait Time",
			Range = {0, 100},
			Increment = 1,
			Suffix = "Second",
			CurrentValue = 4,
			Flag = "voidManualTimeSlider", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
			Callback = function(Value)
				print(Value)
				_G.voidManualWait = Value
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
							table.insert(chars, v.Character)
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
			Name = "JumpPower Slider",
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

		local autoRotateToggle = Tab2:CreateToggle({
			Name = "Auto Rotate",
			CurrentValue = false,
			Flag = "autoRotateToggle", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
			Callback = function(Value)
				print(Value)
				_G.autoRotateActivated = Value
			end,
		})

		local safeSection = Tab2:CreateSection("Safe Mode")

		local safeModeToggle = Tab2:CreateToggle({
			Name = "Safe Mode Toggle",
			CurrentValue = false,
			Flag = "SMToggle", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
			Callback = function(Value)
				print(Value)
				_G.safeModeActivated = Value
			end,
		})

		local safeModeLocationsDropdown = Tab2:CreateDropdown({
			Name = "Safe Mode TP Location",
			Options = {"Map Center", "Void Platform", "Death Counter Room", "Atomic Slash Room", "Upper Baseplate", "Lower Baseplate"},
			CurrentOption = {"Void Platform"},
			MultipleOptions = false,
			Flag = "safeModeLocationDropdown", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
			Callback = function(Opt)
				local option = nil
				for i, v in Opt do
					if not option or option == nil then
						option = v
					end
				end
				if option and option ~= nil then
					if string.match(option, "Map") then
						_G.safeModeLoc = CFrame.new(149, 440, 29)
					elseif string.match(option, "Void") then
						_G.safeModeLoc = CFrame.new(0, -493, 0)
					elseif string.match(option, "Death") then
						_G.safeModeLoc = CFrame.new(-66, 30, 20356)
					elseif string.match(option, "Atomic") then
						_G.safeModeLoc = CFrame.new(1050, 140, 23010)
					elseif string.match(option, "Upper") then
						_G.safeModeLoc = CFrame.new(1060, 405, 22887)
					elseif string.match(option, "Lower") then
						_G.safeModeLoc = CFrame.new(1060, 20, 22887)
					else
						warn(option)
					end
				else
					warn(option)
				end
			end,
		})

		local safeModePropSlider = Tab2:CreateSlider({
			Name = "Safe Mode Prop",
			Range = {1, 100},
			Increment = 1,
			Suffix = "HP",
			CurrentValue = 17,
			Flag = "safeModePropSlider", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
			Callback = function(Value)
				print(Value)
				_G.safeModeProp = Value
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

		local ultEspToggle = Tab3:CreateToggle({
			Name = "Ult Esp",
			CurrentValue = false,
			Flag = "ultEspToggle", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
			Callback = function(Value)
				print(Value)
				_G.ultEspActivated = Value
			end,
		})
	end

	local function setupTab4()
		local otherSection = Tab4:CreateSection("Exploits")

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
			CurrentValue = true,
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
		
		local bigJail = Tab6:CreateButton({
			Name = "Big Jail",
			Callback = function()
				localPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(284, 439, 467)
			end,
		})
		local bigJailBind = Tab6:CreateKeybind({
			Name = "Big Jail TP Bind",
			CurrentKeybind = "",
			HoldToInteract = false,
			Flag = "bigJailBind", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
			Callback = function(Keybind)
				print(Keybind)
				localPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(284, 439, 467)
			end,
		})
		
		local biggestJail = Tab6:CreateButton({
			Name = "Biggest Jail",
			Callback = function()
				localPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(378, 439, 457)
			end,
		})
		local biggestJailBind = Tab6:CreateKeybind({
			Name = "Biggest Jail TP Bind",
			CurrentKeybind = "",
			HoldToInteract = false,
			Flag = "bigJailBind", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
			Callback = function(Keybind)
				print(Keybind)
				localPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(378, 439, 457)
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

		local autoCheckAdminsToggle = Tab7:CreateToggle({
			Name = "Auto Check for Admins",
			CurrentValue = false,
			Flag = "ACFAToggle", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
			Callback = function(Value)
				print(Value)
				_G.adminWarning = Value
			end,
		})

		local autoCheckAdminsFriendsToggle = Tab7:CreateToggle({
			Name = "Check for Admins Friends?",
			CurrentValue = false,
			Flag = "ACFAToggle", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
			Callback = function(Value)
				print(Value)
				_G.adminFriend = Value
			end,
		})
	end

	setupTab()
	setupTab2()
	setupTab3()
	setupTab4()
	setupTab5()
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
		if _G.killActivated == false then return end
		if math.floor(char.Humanoid.Health) > _G.killStealProp then return end
		if _G.killSafeSelf == true and localPlayer.Character.Humanoid.Health <= _G.killSafeProp then return end
		if _G.killKilling == true then warn("already") return end
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

	player.Character.Changed:Connect(function()
		if _G.ultEspActivated == true then
			if player.Character:FindFirstChild("Counter") then
				highlight.Enabled = true
				highlight.FillColor = Color3.fromRGB(255, 0, 0)
			else
				if player.Character:GetAttribute("Ulted") and player.Character:GetAttribute("Ulted") == true then
					highlight.Enabled = true
					highlight.FillColor = Color3.fromRGB(255, 255, 0)
				else
					highlight.Enabled = false
					highlight.FillColor = Color3.fromRGB(255, 255, 0)
				end
			end
		else
			highlight.Enabled = false
		end
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

local function bringAll()

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

local function checkForAdmins(player)
	if _G.adminWarning == false then return end

	local admins = {0, 4041635170, 1241352401, 3350014406, 3891230967, 681405668, 1001242712, 138249029, 3414432341, 339633571, 1059541187, 995625009, 1148708686, 33963357, 58214194, 747447782, 2039323684, 430966809, 202693941, 3673381374};
	local admin = false
	local friend = false

	for i, v in pairs(admins) do
		if player.UserId == v then
			admin = true
			friend = false
		end

		if _G.adminFriend == true then
			if player:IsFriendsWith(v) and player.UserId ~= v then
				admin = true
				friend = true
			end
		end
	end

	if admin == true then
		if friend == false then
			Rayfield:Notify({
				Title = "💀💀💀",
				Content = player.DisplayName.." (@"..player.Name..") is admin, be careful now! 💀",
				Duration = 6.5,
				Image = 4483362458,
			})
		else
			Rayfield:Notify({
				Title = "💀💀💀",
				Content = player.DisplayName.." (@"..player.Name..") is admin's friend, be careful now! 💀",
				Duration = 6.5,
				Image = 4483362458,
			})
		end
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
			localPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(1, -494, 1) * CFrame.Angles(90, 0, 0)

			if _G.killActivated == true then
				_G.killActivated = false
			end

			if _G.safeModeNeedTP == true then
				_G.safeModeNeedTP = false
			end

			if _G.targetNeedTp == false then
				_G.targetNeedTp = false
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

			if _G.safeModeNeedTP == true then
				_G.safeModeNeedTP = false
			end

			if _G.targetActivated == true then
				_G.targetActivated = false
				_G.targetNeedTp = false
			end
		end

		if _G.safeMode == true and _G.safeModeNeedTP == true and _G.safeModeLoc ~= CFrame.new() then
			local humanoid = localPlayer.Character:FindFirstChild("Humanoid")

			if humanoid then
				if math.floor(humanoid.Health) <= _G.safeModeProp then
					if localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") then
						localPlayer.Character.HumanoidRootPart.CFrame = _G.safeModeLoc
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
					end
				end
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
								localPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(1, -494, 1) * CFrame.Angles(75, 0, 0)
							end
						end
					else
						local cf = _G.targetTarget.Character.HumanoidRootPart.CFrame
						localPlayer.Character.HumanoidRootPart.CFrame = cf - (cf.LookVector * 3.5) + _G.targetTarget.Character.Humanoid.MoveDirection
					end
				end
			end
		end
	end

	if localPlayer.Character then
		local humanoid = localPlayer.Character:FindFirstChildOfClass("Humanoid")

		local allAnims = geyPlayingAnims()
		local isDeathCountered = getPlayingAnim("11343250001")
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
		if not plr:IsFriendsWith(localPlayer.UserId) then
			plr.CharacterAdded:Connect(onCharAdded)
			if plr.Character then
				onCharAdded(plr.Character)
				hlChar(plr.Character)
			end
		end
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

local humanoid = localPlayer.Character:WaitForChild("Humanoid")
humanoid.Changed:Connect(function()
	if _G.walkActivated == true then
		humanoid.WalkSpeed = _G.walkSpeed
	end

	if _G.jumpActivated == true then
		humanoid.JumpPower = _G.jumpPower
	end

	if _G.autoRotateActivated == true then
		humanoid.AutoRotate = true
	end
end)
localPlayer.CharacterAdded:Connect(function(character)
	local humanoid = character:WaitForChild("Humanoid")
	humanoid.Changed:Connect(function()
		if _G.walkActivated == true then
			humanoid.WalkSpeed = _G.walkSpeed
		end

		if _G.jumpActivated == true then
			humanoid.JumpPower = _G.jumpPower
		end

		if _G.autoRotateActivated == true then
			humanoid.AutoRotate = true
		end
	end)
end)

while task.wait(5) do
	for i , v in pairs(Players:GetPlayers()) do
		checkForAdmins(v)
	end
	Players.PlayerAdded:Connect(function(player)
		checkForAdmins(player)
	end)
end

Rayfield:Notify({
	Title = "Tsb Script",
	Content = "Loaded",
	Duration = 6.5,
	Image = 4483362458,
})
