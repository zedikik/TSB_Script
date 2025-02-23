print("injected")
local TeleportService = game:GetService("TeleportService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local trashCanFolder = workspace.Map.Trash
local camera = workspace.CurrentCamera

local localPlayer = Players.LocalPlayer
local playerGui = localPlayer.PlayerGui
local mouse = localPlayer:GetMouse()

local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/zedikik/RayField/refs/heads/main/RayField.lua'))() -- https://sirius.menu/rayfield
if not Rayfield then return end
Rayfield:Notify({
	Title = "Tsb Script",
	Content = "Loading",
	Duration = 6.5,
	Image = 4483362458,
})

local msgToDebug = {}
local killWorking = false
local selectedChar = ""

local function fixes()
	task.defer(function()
		if not _G.killWorkChars then
			_G.killWorkChars = {"Hunter", "Cyborg", "Ninja", "Esper", "Blade"}
			_G.killActivated = false
			_G.killAntiFling = true
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

			_G.ultEspActivated = false
			_G.absoluteImmortalEsp = true
			_G.deathCounterEsp = true

			_G.targetActivated = false
			_G.targetSafeActivated = true
			_G.targetAutoAfk = false
			_G.targetPredict = false
			_G.targetNeedTp = false
			_G.targetTarget = nil
			_G.targetQuotes = 1 -- 1 is basic target, 2 is smart target (tp only if has skills)
			_G.targetSafeProp = 30
			_G.targetSafeQuotes = 2 -- 1 is basic (15hp prop void); 2 is absolute safe (15hp prop void * CFrame.Angles(-89.5, 0,0)

			_G.autoGetIceBoss = false

			_G.walkSpeed = 24
			_G.jumpPower = 50
			_G.autoRotateActivated = false
			_G.walkActivated = false
			_G.jumpActivated = false

			_G.adminWarning = false
			_G.adminFriend = false

			_G.awcActivated = false

			_G.disableIntoAnimation = false

			_G.customM1Anim = "10469493270"
			_G.customM2Anim = "10469630950"
			_G.customM3Anim = "10469639222"
			_G.customM4Anim = "10469643643"
			_G.customM1sActivated = false
			_G.customM1sConnection = nil

			_G.absoluteImmortal = false
			_G.absoluteImmortalLoaded = false
			_G.absoluteImmortalCon = {}
			_G.absoluteImmortalCon2 = nil
			_G.absoluteImmortalCon3 = nil
			_G.absoluteImmortalCopy = nil
			_G.absoluteImmortalNeedTP = true
			_G.absoluteImmortalReactionTime = 1 -- 0.1 for good fps
			_G.absoluteImmortalTPQuotes = 0 -- 0 is default (CFrame.new(100000000, 100000000, 100000000)), 2 is custom
			_G.absoluteImmortalCustomTP = CFrame.new(0,0,0) -- custom tp cframe
			_G.absoluteImmortalCopySpeedMultipler = 15 -- 1 is default
			_G.absoluteImmortalAntiVelocity = true -- anti fling after tp to copy
			_G.absoluteImmortalSmartMode = true -- checking all animation and timings for it, line 131
			_G.absoluteImmortalDebug = true -- idk whats it

			_G.trashGrabberWorking = false
			_G.trashGrabberReactionTime = 0.05 -- very low value bad for fps
			_G.trashGrabberSearchMode = 1 -- 1 is nearest(magnitude), 2 is raycast
			_G.trashGrabberMode = 1 -- 1 is basic(tp char), 2 is absolute Immortal
			_G.trashGrabberSafeMode = true -- cancel teleport if near players
			_G.trashGrabberSafeModeDistance = 50 -- safe mode distance to check
		end
	end)
end
fixes()

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
	DisableBuildWarnings = true, -- Prevents Rayfield from warning when the script has a version mismatch with the interface

	ConfigurationSaving = {
		Enabled = false,
		FolderName = "Skuff_TSB_Script", -- Create a custom folder for your hub/game
		FileName = "config"
	},

	Discord = {
		Enabled = false, -- Prompt the user to join your Discord server if their executor supports it
		Invite = "noinvitelink", -- The Discord invite code, do not include discord.gg/. E.g. discord.gg/ ABCD would be ABCD
		RememberJoins = true -- Set this to false to make them join the discord every time they load it up
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
		local trSection = Tab:CreateSection("In testing Functions")

		local trashCanGrabberBind = Tab:CreateKeybind({
			Name = "Trashcan Grabber",
			CurrentKeybind = "T",
			HoldToInteract = false,
			Flag = "trashCanGrabberBind", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
			Callback = function(Keybind)
				print(Keybind)
				trashGrabberFUNC()
			end,
		})

		local trashCanGrabberReactionTimeSlider = Tab:CreateSlider({
			Name = "Trashcan Grabber Reaction Time (low value is bad for fps)",
			Range = {.01, 5},
			Increment = 0.01,
			Suffix = "Second",
			CurrentValue = _G.trashGrabberReactionTime,
			Flag = "trashCanGrabberSlider", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
			Callback = function(Value)
				print(Value)
				_G.trashGrabberReactionTime = Value
			end,
		})

		local trashCanGrabberSearchModeDropdown = Tab:CreateDropdown({
			Name = "TrashCan Grabber Search Mode",
			Options = {"Nearest (Magnitude)", "Raycast (First on way)"},
			CurrentOption = {""},
			MultipleOptions = false,
			Flag = "trashCanGrabberSearchModeDropdown", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
			Callback = function(Opt)
				local option = nil
				for i, v in Opt do
					if not option or option == nil then
						option = v
					end
				end
				if option and option ~= nil then
					if string.match(option, "Nearest") then
						_G.trashGrabberSearchMode = 1
					else
						_G.trashGrabberSearchMode = 2
					end
				else
					warn(option)
				end
			end,
		})

		local trashCanGrabberModeDropdown = Tab:CreateDropdown({
			Name = "TrashCan Grabber Grab Mode",
			Options = {"Basic (TP character)", "Smart (Use Absolute Immortal)"},
			CurrentOption = {""},
			MultipleOptions = false,
			Flag = "trashCanGrabberModeDropdown", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
			Callback = function(Opt)
				local option = nil
				for i, v in Opt do
					if not option or option == nil then
						option = v
					end
				end
				if option and option ~= nil then
					if string.match(option, "Basic") then
						_G.trashGrabberMode = 1
					else
						_G.trashGrabberMode = 2
					end
				else
					warn(option)
				end
			end,
		})

		local TrashcanGrabberSafeModeToggle = Tab:CreateToggle({
			Name = "Trashcan Grabber Safe Mode",
			CurrentValue = _G.trashGrabberSafeMode,
			Flag = "TrashcanGrabberSafeModeToggle", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
			Callback = function(Value)
				print(Value)
				_G.trashGrabberSafeMode = Value
			end,
		})

		local TrashcanGrabberSafeModeDistanceSlider = Tab:CreateSlider({
			Name = "Trashcan Grabber Safe Mode Distance",
			Range = {1, 10000},
			Increment = 1,
			Suffix = "Studs",
			CurrentValue = _G.trashGrabberSafeModeDistance,
			Flag = "trashCanGrabberSlider", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
			Callback = function(Value)
				print(Value)
				_G.trashGrabberSafeModeDistance = Value
			end,
		})


		local otherSection = Tab:CreateSection("Other functions")

		local manualVoidBind = Tab:CreateKeybind({
			Name = "Manual void tp",
			CurrentKeybind = "",
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
			Increment = .1,
			Suffix = "Second",
			CurrentValue = _G.voidManualWait,
			Flag = "voidManualTimeSlider", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
			Callback = function(Value)
				print(Value)
				_G.voidManualWait = Value
			end,
		})

		local tpAllBind = Tab:CreateKeybind({
			Name = "Bring All (Teleport to all players on map)",
			CurrentKeybind = "",
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
			CurrentKeybind = "",
			HoldToInteract = false,
			Flag = "tpBind", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
			Callback = function(Keybind)
				print(Keybind)
				local character = localPlayer.Character
				local rootPart = character:FindFirstChild("HumanoidRootPart")

				if character and rootPart then
					local mousePos = mouse.Hit.Position
					rootPart.CFrame = CFrame.new(mousePos, Vector3(0,0,0))
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
			CurrentValue = _G.walkSpeed,
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
			CurrentValue = _G.jumpPower,
			Flag = "jumpPowerSlider", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
			Callback = function(Value)
				print(Value)
				_G.jumpPower = Value
				_G.jumpActivated = true
			end,
		})

		local autoRotateToggle = Tab2:CreateToggle({
			Name = "Auto Rotate",
			CurrentValue = _G.autoRotateActivated,
			Flag = "autoRotateToggle", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
			Callback = function(Value)
				print(Value)
				_G.autoRotateActivated = Value
			end,
		})
	end

	local function setupTab3()
		local ultEspToggle = Tab3:CreateToggle({
			Name = "Ult Esp",
			CurrentValue = _G.ultEspActivated,
			Flag = "ultEspToggle", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
			Callback = function(Value)
				print(Value)
				_G.ultEspActivated = Value
			end,
		})

		local absoluteImmortalEspToggle = Tab3:CreateToggle({
			Name = "IFrames Esp",
			CurrentValue = _G.absoluteImmortalEsp,
			Flag = "absoluteImmortalEspToggle", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
			Callback = function(Value)
				print(Value)
				_G.absoluteImmortalEsp = Value
			end,
		})

		local deathCounterEspToggle = Tab3:CreateToggle({
			Name = "Death Counter Esp",
			CurrentValue = _G.deathCounterEsp,
			Flag = "deathCounterEspToggle", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
			Callback = function(Value)
				print(Value)
				_G.deathCounterEsp = Value
			end,
		})

		local otherSection = Tab3:CreateSection("Other Visuals")

		local disableIntroToggle = Tab3:CreateToggle({
			Name = "Disable Intro Animation",
			CurrentValue = _G.disableIntoAnimation,
			Flag = "DIAToggle", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
			Callback = function(Value)
				print(Value)
				_G.disableIntoAnimation = Value
			end,
		})
	end

	local function setupTab4()
		local wallSection = Tab4:CreateSection("Wall Combo Exploits")

		local autoWallComboToggle = Tab4:CreateToggle({
			Name = "Auto Wall Combo",
			CurrentValue = _G.awcActivated,
			Flag = "AWCToggle", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
			Callback = function(Value)
				print(Value)
				_G.awcActivated = Value
			end,
		})

		local otherSection = Tab4:CreateSection("Exploits")

		local antiDeathCounterToggle = Tab4:CreateToggle({
			Name = "Anti Death Counter",
			CurrentValue = _G.adcActivated,
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
			CurrentValue = _G.voidKillActivated,
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

		local absoluteImmortalSection = Tab4:CreateSection("Absolute Immortal Exploit")


		local absoluteImmortalToggle = Tab4:CreateToggle({
			Name = "Absolute Immortal Toggle",
			CurrentValue = _G.absoluteImmortal,
			Flag = "absoluteImmortalToggle", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
			Callback = function(Value)
				print(Value)
				_G.absoluteImmortal = Value
				_G.absoluteImmortalNeedTP = _G.absoluteImmortal
			end,
		})

		local absoluteImmortalQuickBind = Tab4:CreateKeybind({
			Name = "Absolute Immortal Quick Toggle Bind",
			CurrentKeybind = "",
			HoldToInteract = false,
			Flag = "absoluteImmortalQuickBind", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
			Callback = function(Keybind)
				print(Keybind)
				_G.absoluteImmortal = not _G.absoluteImmortal
				_G.absoluteImmortalNeedTP = _G.absoluteImmortal
				absoluteImmortalToggle:Set(_G.absoluteImmortal)
			end,
		})

		local absoluteImmortalAntiFlingToggle = Tab4:CreateToggle({
			Name = "Absolute Immortal Anti Fling Toggle",
			CurrentValue = _G.absoluteImmortalAntiVelocity,
			Flag = "absoluteImmortalAntiFlingToggle", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
			Callback = function(Value)
				print(Value)
				_G.absoluteImmortalAntiVelocity = Value
			end,
		})

		local absoluteImmortalSmartToggle = Tab4:CreateToggle({
			Name = "Absolute Immortal Smart Toggle",
			CurrentValue = _G.absoluteImmortalSmartMode,
			Flag = "absoluteImmortalSmartToggle", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
			Callback = function(Value)
				print(Value)
				_G.absoluteImmortalSmartModeg = Value
			end,
		})

		local absoluteImmortalSlider = Tab4:CreateSlider({
			Name = "Absolute Immortal Reaction Time (low value is bad for fps)",
			Range = {.01, 5},
			Increment = 0.1,
			Suffix = "Second",
			CurrentValue = _G.absoluteImmortalReactionTime ,
			Flag = "absoluteImmortalSlider", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
			Callback = function(Value)
				print(Value)
				_G.absoluteImmortalReactionTime = Value
			end,
		})

		local absoluteImmortalSpeedSlider = Tab4:CreateSlider({
			Name = "Absolute Immortal Speed Multipler",
			Range = {1, 1000},
			Increment = 1,
			Suffix = "Multipler",
			CurrentValue = _G.absoluteImmortalCopySpeedMultipler,
			Flag = "absoluteImmortalSpeedSlider", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
			Callback = function(Value)
				print(Value)
				_G.absoluteImmortalCopySpeedMultipler = Value
			end,
		})

		local absoluteImmortalTPQuotesDropdown = Tab4:CreateDropdown({
			Name = "Absolute Immortal TP Quotes",
			Options = {"Basic (CFrame.new(100000000, 100000000, 100000000))"},
			CurrentOption = {"Basic (CFrame.new(100000000, 100000000, 100000000))"},
			MultipleOptions = false,
			Flag = "absoluteImmortalTPQuotesDropdown", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
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
						_G.absoluteImmortalTPQuotes = 0
					end
				else
					warn(option)
				end
			end,
		})

		local absoluteImmortalDebugToggle = Tab4:CreateToggle({
			Name = "Absolute Immortal Debug Toggle",
			CurrentValue = _G.absoluteImmortalSmartMode,
			Flag = "absoluteImmortalDebugToggle", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
			Callback = function(Value)
				print(Value)
				_G.absoluteImmortalDebug = Value
			end,
		})


		local targetSection = Tab4:CreateSection("Target Exploit")


		local targetToggle = Tab4:CreateToggle({
			Name = "Target Toggle",
			CurrentValue = _G.targetActivated,
			Flag = "targetToggle", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
			Callback = function(Value)
				print(Value)
				_G.targetActivated = Value
			end,
		})

		local targetInput = Tab4:CreateInput({
			Name = "Target Name (can be shorted) (if dropdown not working)",
			CurrentValue = tostring(_G.targetTarget),
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

		local targetPredictToggle = Tab4:CreateToggle({
			Name = "Target Predict Toggle",
			CurrentValue = _G.targetActivated,
			Flag = "targetPredictToggle", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
			Callback = function(Value)
				print(Value)
				_G.targetPredict = Value
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
						_G.targetQuotes = 2
					end
				else
					warn(option)
				end
			end,
		})


		local targetSafeModeToggle = Tab4:CreateToggle({
			Name = "Target Safe Mode",
			CurrentValue = _G.targetSafeActivated,
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
			CurrentValue = _G.targetSafeProp,
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
			CurrentValue = _G.killActivated,
			Flag = "KillToggle", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
			Callback = function(Value)
				print(Value)
				_G.killActivated = Value
			end,
		})

		local killAntiFlingToggle = Tab4:CreateToggle({
			Name = "Toggle Kill Stealer Anti Fling",
			CurrentValue = _G.killAntiFling,
			Flag = "KillToggle", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
			Callback = function(Value)
				print(Value)
				_G.killAntiFling = Value
			end,
		})

		local killWhiteListToggle = Tab4:CreateToggle({
			Name = "Whitelist (do not kill ur friends)",
			CurrentValue = _G.killWhitelist,
			Flag = "KillWhiteList", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
			Callback = function(Value)
				print(Value)
				_G.killWhitelist = Value
			end,
		})

		local killSafeSelfToggle = Tab4:CreateToggle({
			Name = "Safe Self (Do not steal, if u has lower than Safe Prop hp)",
			CurrentValue = _G.killSafeSelf,
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
			CurrentValue = _G.killSafeProp,
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
			CurrentValue = _G.killStealProp,
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
			CurrentValue = _G.autoGetIceBoss,
			Flag = "AGIBToggle", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
			Callback = function(Value)
				print(Value)
				_G.autoGetIceBoss = Value
			end,
		})

		local m1Section = Tab5:CreateSection("Custom M1s")

		local customM1Dropdown = Tab5:CreateDropdown({
			Name = "Custom Animation for M1",
			Options = {"KJ", "The Strongest Hero", "Hero Hunter", "Destructive Cyborg", "Deadly Ninja", "Brutal Demon", "Blade Master", "Wild Physchic", "Martial Artist", "Tech Prodigy"},
			CurrentOption = {"The Strongest Hero"},
			MultipleOptions = false,
			Flag = "customM1Dropdown", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
			Callback = function(Opt)
				local option = nil
				for i, v in Opt do
					if not option or option == nil then
						option = v
					end
				end
				if option and option ~= nil then
					if string.match(option, "Strongest") then
						print("Saitama")
						_G.customM1Anim = "10469493270"

					elseif string.match(option, "Hunter") then
						print("garou")
						_G.customM1Anim = "13532562418"

					elseif string.match(option, "Cyborg") then
						print("genos")
						_G.customM1Anim = "13491635433"

					elseif string.match(option, "Ninja") then
						print("sonic")
						_G.customM1Anim = "13370310513"

					elseif string.match(option, "Demon") then
						print("metal bite")
						_G.customM1Anim = "14004222985"

					elseif string.match(option, "Blade") then
						print("blaed")
						_G.customM1Anim = "15259161390"

					elseif string.match(option, "Physchic") then
						print("tatsu")
						_G.customM1Anim = "16515503507"

					elseif string.match(option, "Artist") then
						print("siruy")
						_G.customM1Anim = "17889458563"

					elseif string.match(option, "Tech") then
						print("tech")
						_G.customM1Anim = "123005629431309"

					elseif string.match(option, "KJ") then
						print("jk")
						_G.customM1Anim = "10469493270"
					else
						warn(option)
					end
				else
					warn(option)
				end
			end,
		})

		local customM2Dropdown = Tab5:CreateDropdown({
			Name = "Custom Animation for M2",
			Options = {"KJ", "The Strongest Hero", "Hero Hunter", "Destructive Cyborg", "Deadly Ninja", "Brutal Demon", "Blade Master", "Wild Physchic", "Martial Artist", "Tech Prodigy"},
			CurrentOption = {"The Strongest Hero"},
			MultipleOptions = false,
			Flag = "customM2Dropdown", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
			Callback = function(Opt)
				local option = nil
				for i, v in Opt do
					if not option or option == nil then
						option = v
					end
				end
				if option and option ~= nil then
					if string.match(option, "Strongest") then
						print("Saitama")
						_G.customM2Anim = "10469630950"

					elseif string.match(option, "Hunter") then
						print("garou")
						_G.customM2Anim = "13532600125"

					elseif string.match(option, "Cyborg") then
						print("genos")
						_G.customM2Anim = "13296577783"

					elseif string.match(option, "Ninja") then
						print("sonic")
						_G.customM2Anim = "13390230973"

					elseif string.match(option, "Demon") then
						print("metal bite")
						_G.customM2Anim = "13997092940"

					elseif string.match(option, "Blade") then
						print("blaed")
						_G.customM2Anim = "15240216931"

					elseif string.match(option, "Physchic") then
						print("tatsu")
						_G.customM2Anim = "16515520431"

					elseif string.match(option, "Artist") then
						print("siruy")
						_G.customM2Anim = "17889461810"

					elseif string.match(option, "Tech") then
						print("tech")
						_G.customM2Anim = "100059874351664"

					elseif string.match(option, "KJ") then
						print("jk")
						_G.customM2Anim = "17325513870"
					else
						warn(option)
					end
				else
					warn(option)
				end
			end,
		})

		local customM3Dropdown = Tab5:CreateDropdown({
			Name = "Custom Animation for M3",
			Options = {"KJ", "The Strongest Hero", "Hero Hunter", "Destructive Cyborg", "Deadly Ninja", "Brutal Demon", "Blade Master", "Wild Physchic", "Martial Artist", "Tech Prodigy"},
			CurrentOption = {"The Strongest Hero"},
			MultipleOptions = false,
			Flag = "customM3Dropdown", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
			Callback = function(Opt)
				local option = nil
				for i, v in Opt do
					if not option or option == nil then
						option = v
					end
				end
				if option and option ~= nil then
					if string.match(option, "Strongest") then
						print("Saitama")
						_G.customM3Anim = "10469639222"

					elseif string.match(option, "Hunter") then
						print("garou")
						_G.customM3Anim = "13532604085"

					elseif string.match(option, "Cyborg") then
						print("genos")
						_G.customM3Anim = "13295919399"

					elseif string.match(option, "Ninja") then
						print("sonic")
						_G.customM3Anim = "13378751717"

					elseif string.match(option, "Demon") then
						print("metal bite")
						_G.customM3Anim = "14001963401"

					elseif string.match(option, "Blade") then
						print("blaed")
						_G.customM3Anim = "15240176873"

					elseif string.match(option, "Physchic") then
						print("tatsu")
						_G.customM3Anim = "16515448089"

					elseif string.match(option, "Artist") then
						print("siruy")
						_G.customM3Anim = "17889471098"

					elseif string.match(option, "Tech") then
						print("tech")
						_G.customM3Anim = "104895379416342"

					elseif string.match(option, "KJ") then
						print("jk")
						_G.customM3Anim = "17325522388"
					else
						warn(option)
					end
				else
					warn(option)
				end
			end,
		})

		local customM4Dropdown = Tab5:CreateDropdown({
			Name = "Custom Animation for M4",
			Options = {"KJ", "The Strongest Hero", "Hero Hunter", "Destructive Cyborg", "Deadly Ninja", "Brutal Demon", "Blade Master", "Wild Physchic", "Martial Artist", "Tech Prodigy"},
			CurrentOption = {"The Strongest Hero"},
			MultipleOptions = false,
			Flag = "customM4Dropdown", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
			Callback = function(Opt)
				local option = nil
				for i, v in Opt do
					if not option or option == nil then
						option = v
					end
				end
				if option and option ~= nil then
					if string.match(option, "Strongest") then
						print("Saitama")
						_G.customM4Anim = "10469643643"

					elseif string.match(option, "Hunter") then
						print("garou")
						_G.customM4Anim = "13294471966"

					elseif string.match(option, "Cyborg") then
						print("genos")
						_G.customM4Anim = "13295936866"

					elseif string.match(option, "Ninja") then
						print("sonic")
						_G.customM4Anim = "13378708199"

					elseif string.match(option, "Demon") then
						print("metal bite")
						_G.customM4Anim = "14136436157"

					elseif string.match(option, "Blade") then
						print("blaed")
						_G.customM4Anim = "15162694192"

					elseif string.match(option, "Physchic") then
						print("tatsu")
						_G.customM4Anim = "16552234590"

					elseif string.match(option, "Artist") then
						print("siruy")
						_G.customM4Anim = "17889290569"

					elseif string.match(option, "Tech") then
						print("tech")
						_G.customM4Anim = "134775406437626"

					elseif string.match(option, "KJ") then
						print("jk")
						_G.customM4Anim = "17325537719"
					else
						warn(option)
					end
				else
					warn(option)
				end
			end,
		})

		local customM1Toggle = Tab5:CreateToggle({
			Name = "Activate Custom M1s Animations",
			CurrentValue = _G.customM1sActivated,
			Flag = "customM1Toggle", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
			Callback = function(Value)
				print(Value)
				_G.customM1sActivated = Value
			end,
		})
	end

	local function setupTab6()
		local tpSection = Tab6:CreateSection("Main Teleports")

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

		local tp2Section = Tab6:CreateSection("Jail Teleports")

		local smallJail = Tab6:CreateButton({
			Name = "Small Jail",
			Callback = function()
				localPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(438, 439, -375)
			end,
		})
		local bigJailBind = Tab6:CreateKeybind({
			Name = "Small Jail TP Bind",
			CurrentKeybind = "",
			HoldToInteract = false,
			Flag = "SmallJailBind", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
			Callback = function(Keybind)
				print(Keybind)
				localPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(438, 439, -375)
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

		local tpSection = Tab6:CreateSection("Other Teleports")

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
			CurrentValue = _G.adminWarning,
			Flag = "ACFAToggle", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
			Callback = function(Value)
				print(Value)
				_G.adminWarning = Value
			end,
		})

		local autoCheckAdminsFriendsToggle = Tab7:CreateToggle({
			Name = "Check for Admins Friends?",
			CurrentValue = _G.adminFriend,
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

function debugMSG(typeMSG, textMSG)
	if typeMSG ~= 3 and not _G.absoluteImmortalDebug then return end
	if not typeMSG then typeMSG = 2 end
	if type(textMSG) == "table" then
		for i, v in pairs(textMSG) do
			debugMSG(typeMSG, v)
		end
		return true
	end

	if msgToDebug[textMSG] then
		task.delay(math.random(1.5, 5), function()
			if typeMSG == 1 then
				print(textMSG)
				return true
			elseif typeMSG == 2 then
				warn(textMSG)
				return true
			elseif typeMSG == 3 then
				error(textMSG)
				return true
			end
		end)
	else
		if typeMSG == 1 then
			print(textMSG)
			return true
		elseif typeMSG == 2 then
			warn(textMSG)
			return true
		elseif typeMSG == 3 then
			error(textMSG)
			return true
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
				if _G.deathCounterEsp == true then
					highlight.Enabled = true
					highlight.FillColor = Color3.fromRGB(255, 0, 0)
				else
					if highlight.FillColor == Color3.fromRGB(255, 0, 0) then
						highlight.Enabled = false
					end
				end
			else
				if highlight.FillColor == Color3.fromRGB(255, 0, 0) then
					highlight.Enabled = false
				end
			end

			if player.Character:FindFirstChild("AbsoluteImmortal") then
				if _G.absoluteImmortalEsp == true then
					highlight.Enabled = true
					highlight.FillColor = Color3.fromRGB(0, 255, 255)
				else
					if highlight.FillColor == Color3.fromRGB(0, 255, 255) then
						highlight.Enabled = false
					end
				end
			else
				if highlight.FillColor == Color3.fromRGB(0, 255, 255) then
					highlight.Enabled = false
				end
			end

			if player.Character:GetAttribute("Ulted") and player.Character:GetAttribute("Ulted") == true then
				highlight.Enabled = true
				highlight.FillColor = Color3.fromRGB(255, 255, 0)
			else
				if highlight.FillColor == Color3.fromRGB(255, 255, 0) then
					highlight.Enabled = false
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
		task.wait(1.5)
		repeat
			localPlayer.Character:MoveTo(object["Root"].Position)    
		until task.wait(0.5) and localPlayer.Character:GetAttribute("IceBoss") == true
	end
end

local function checkForAdmins(player)
	if _G.adminWarning == false then return end

	local admins = require(game:GetService("ReplicatedStorage"):WaitForChild("Info")).Admins;
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

local function customM1s(humanoid)
	if _G.customM1sActivated == false then return end
	if _G.customM1sConnection ~= nil then return end

	local clicks = {
		["M1"] = {
			"10469493270",
			"13532562418",
			"13491635433",
			"13370310513",
			"14004222985",
			"15259161390",
			"16515503507",
			"17889458563",
			"123005629431309",
			"17325510002",
		},

		["M2"] = {
			"10469630950",
			"13532600125",
			"13296577783",
			"13390230973",
			"13997092940",
			"15240216931",
			"16515520431",
			"17889461810",
			"100059874351664",
			"17325513870",
		},

		["M3"] = {
			"10469639222",
			"13532604085",
			"13295919399",
			"13378751717",
			"14001963401",
			"15240176873",
			"16515448089",
			"17889471098",
			"104895379416342",
			"17325522388",
		},

		["M4"] = {
			"10469643643",
			"13294471966",
			"13295936866",
			"13378708199",
			"14136436157",
			"15162694192",
			"16552234590",
			"17889290569",
			"134775406437626",
			"17325537719",
		},
	};

	_G.customM1sConnection = humanoid.AnimationPlayed:Connect(function(animationTrack)
		if _G.customM1sActivated == true then
			local isM1Anim = false
			local isM2Anim = false
			local isM3Anim = false
			local isM4Anim = false
			for i, v in pairs(clicks.M1) do
				if v == string.split(tostring(animationTrack.Animation.AnimationId), "rbxassetid://")[2] then
					isM1Anim = true
					break
				end
			end
			for i, v in pairs(clicks.M2) do
				if v == string.split(tostring(animationTrack.Animation.AnimationId), "rbxassetid://")[2] then
					isM1Anim = true
					break
				end
			end
			for i, v in pairs(clicks.M3) do
				if v == string.split(tostring(animationTrack.Animation.AnimationId), "rbxassetid://")[2] then
					isM1Anim = true
					break
				end
			end
			for i, v in pairs(clicks.M4) do
				if v == string.split(tostring(animationTrack.Animation.AnimationId), "rbxassetid://")[2] then
					isM1Anim = true
					break
				end
			end

			if isM1Anim then
				local anim = Instance.new("Animation")
				anim.AnimationId = "rbxassetid://" .. _G.customM1Anim
				local loadedAnim = humanoid:LoadAnimation(anim)

				loadedAnim.Priority = Enum.AnimationPriority.Action2
				loadedAnim:Play()

				print("play")

				loadedAnim.Ended:Connect(function()
					anim:Destroy()
				end)

			elseif isM2Anim then
				local anim = Instance.new("Animation")
				anim.AnimationId = "rbxassetid://" .. _G.customM2Anim
				local loadedAnim = humanoid:LoadAnimation(anim)

				loadedAnim.Priority = Enum.AnimationPriority.Action2
				loadedAnim:Play()
				print("play")

				loadedAnim.Ended:Connect(function()
					anim:Destroy()
				end)

			elseif isM3Anim then
				local anim = Instance.new("Animation")
				anim.AnimationId = "rbxassetid://" .. _G.customM3Anim
				local loadedAnim = humanoid:LoadAnimation(anim)

				loadedAnim.Priority = Enum.AnimationPriority.Action2
				loadedAnim:Play()
				print("play")

				loadedAnim.Ended:Connect(function()
					anim:Destroy()
				end)

			elseif isM4Anim then
				local anim = Instance.new("Animation")
				anim.AnimationId = "rbxassetid://" .. _G.customM4Anim
				local loadedAnim = humanoid:LoadAnimation(anim)

				loadedAnim.Priority = Enum.AnimationPriority.Action2
				loadedAnim:Play()
				print("play")

				loadedAnim.Ended:Connect(function()
					anim:Destroy()
				end)
			else
				warn(tostring(animationTrack.Animation.AnimationId))
			end
		end
	end)
end

local function absoluteImmortalFUNC(slate)
	if not slate then slate = 1 end

	if slate == 1 then
		if not localPlayer.Character then return end
		if not _G.absoluteImmortal then return end
		if _G.absoluteImmortalLoaded then return end
		_G.absoluteImmortalLoaded = true

		local function cc()
			local funcs = {}
			local function aa()
				local func = function()
					localPlayer.Character:GetAttributeChangedSignal("Combo"):Connect(function()
						_G.absoluteImmortalNeedTP = false
						local v1 = localPlayer.Character:GetAttribute("Combo")
						task.defer(function()
							repeat
								task.wait(_G.absoluteImmortalReactionTime or 0.05)
							until localPlayer.Character:GetAttribute("Combo") ~= v1
							_G.absoluteImmortalNeedTP = true
						end)
					end)
				end

				local func2 = function()
					for i, v in pairs(playerGui.Hotbar.Backpack.Hotbar:GetChildren()) do
						if v:IsA("TextButton") then
							if not v:FindFirstChild("Cooldown") then
								task.defer(function()
									repeat
										task.wait(_G.absoluteImmortalReactionTime or 0.05)
									until (v and v:FindFirstChild("Cooldown"))
									_G.absoluteImmortalNeedTP = false
									task.wait()
								end)
							end
						end
					end
				end
				table.insert(funcs, func)
				table.insert(funcs, func2)
			end
			aa()

			_G.absoluteImmortalCon = funcs
		end

		local function bb()
			if not _G.absoluteImmortalCopy then
				task.defer(function()
					local ccoppy = nil
					if localPlayer.Character then
						ccoppy = localPlayer.Character:Clone()
					else
						ccoppy = workspace.Live[localPlayer.Name]
					end

					ccoppy.Archivable = false
					ccoppy.Parent = workspace.Camera
					_G.absoluteImmortalCopy = ccoppy

					if _G.absoluteImmortalCon2 then _G.absoluteImmortalCon2:Disconnect() end
					_G.absoluteImmortalCon2 = RunService.Heartbeat:Connect(function(delta)
						local char = localPlayer.Character
						if not _G.absoluteImmortalCopy then _G.absoluteImmortalCon2:Disconnect() return end
						if not char:FindFirstChildOfClass("Humanoid") or not _G.absoluteImmortalCopy:FindFirstChildOfClass("Humanoid") then _G.absoluteImmortalCon2:Disconnect() return end

						for _, desc in char:GetDescendants() do
							if desc:IsA("BasePart") then
								desc.CanCollide = char:FindFirstChild("RagdollSim", true) ~= nil
							end
						end

						for _, desc in _G.absoluteImmortalCopy:GetDescendants() do
							if desc:IsA("BasePart") then
								desc.CanCollide = char:FindFirstChild("RagdollSim", true) ~= nil
								desc.Transparency = 0.5
							end
						end

						_G.absoluteImmortalCopy.Humanoid.Health = 100
						_G.absoluteImmortalCopy.Humanoid.AutoRotate = true
						_G.absoluteImmortalCopy.Head.Anchored = char.Head.Anchored
						_G.absoluteImmortalCopy.Humanoid.WalkSpeed = char.Humanoid.WalkSpeed
						camera.CameraSubject = _G.absoluteImmortalCopy:WaitForChild("Humanoid")

						_G.absoluteImmortalCopy.Humanoid:ChangeState(char.Humanoid:GetState())

						if char:FindFirstChild("RagdollSim") == nil then
							if _G.absoluteImmortalCopy:FindFirstChild("Humanoid") then
								_G.absoluteImmortalCopy.Humanoid:Move(localPlayer.Character.Humanoid.MoveDirection)
							end
							_G.absoluteImmortalCopy:TranslateBy(_G.absoluteImmortalCopy.Humanoid.MoveDirection * delta * (_G.absoluteImmortalCopySpeedMultipler or 1))
						end

						if _G.absoluteImmortalAntiVelocity == true then
							task.defer(function()
								for i, v in pairs(localPlayer.Character:GetDescendants()) do
									if v:IsA("BasePart") then
										v.Velocity = Vector3.new(0,0,0)
										v.AssemblyLinearVelocity = Vector3.new(0,0,0)
										v.AssemblyAngularVelocity = Vector3.new(0,0,0)
										v.RotVelocity = Vector3.new(0, 0, 0)
									end
								end
							end)
							task.defer(function()
								for i, v in pairs(_G.absoluteImmortalCopy:GetDescendants()) do
									if v:IsA("BasePart") then
										v.Velocity = Vector3.new(0,0,0)
										v.AssemblyLinearVelocity = Vector3.new(0,0,0)
										v.AssemblyAngularVelocity = Vector3.new(0,0,0)
										v.RotVelocity = Vector3.new(0, 0, 0)
									end
								end
							end)

							localPlayer.Character.HumanoidRootPart.Velocity = Vector3.new(0,0,0)
							localPlayer.Character.HumanoidRootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
							localPlayer.Character.HumanoidRootPart.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
							localPlayer.Character.RotVelocity = Vector3.new(0, 0, 0)

							_G.absoluteImmortalCopy.HumanoidRootPart.Velocity = Vector3.new(0,0,0)
							_G.absoluteImmortalCopy.HumanoidRootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
							_G.absoluteImmortalCopy.HumanoidRootPart.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
							_G.absoluteImmortalCopy.RotVelocity = Vector3.new(0, 0, 0)
						end
					end)

					task.defer(function()
						repeat
							task.wait(_G.absoluteImmortalReactionTime or 0.05)
						until not _G.absoluteImmortalCon2 or _G.absoluteImmortalCon2 == nil
						if _G.absoluteImmortalCopy then
							_G.absoluteImmortalCopy:Destroy()
							_G.absoluteImmortalCopy = nil
						end
					end)
				end)
			end
		end

		bb()

		task.defer(function()
			if _G.absoluteImmortalSmartMode == true then
				cc()
				for i, v in pairs(_G.absoluteImmortalCon) do
					v()
				end
			end
		end)
	elseif slate == 2 then
		_G.absoluteImmortalLoaded = false

		if _G.absoluteImmortalCon then
			for i = #_G.absoluteImmortalCon, 1, -1 do
				table.remove(_G.absoluteImmortalCon, i)
			end
			_G.absoluteImmortalCon = nil
		end
		if _G.absoluteImmortalCon2 then
			_G.absoluteImmortalCon2:Disconnect()
			_G.absoluteImmortalCon2 = nil
		end
		if _G.absoluteImmortalCopy then
			if _G.absoluteImmortalCopy:FindFirstChild("HumanoidRootPart") and localPlayer.Character:FindFirstChild("HumanoidRootPart") then
				localPlayer.Character.HumanoidRootPart.CFrame = _G.absoluteImmortalCopy.HumanoidRootPart.CFrame
			end
			_G.absoluteImmortalCopy:Destroy()
			_G.absoluteImmortalCopy = nil
		end
		if camera then
			camera.CameraSubject = localPlayer.Character:WaitForChild("Humanoid")
		end
	else
		debugMSG(2, {"slate =", slate})
	end
end

function trashGrabberFUNC()
	if not localPlayer.Character then return end
	if _G.trashGrabberWorking == true then return end
	_G.trashGrabberWorking = true

	local nearestTrashCan 

	if _G.trashGrabberSearchMode == 1 then
		local nearestDistance = math.huge

		for i, v in pairs(trashCanFolder:GetChildren()) do
			local root = v:WaitForChild("Trashcan")
			local distance = (localPlayer.Character.HumanoidRootPart.Position - root.Position).Magnitude

			local can = true

			if _G.trashGrabberSafeMode == true then
				for i, v in pairs(Players:GetPlayers()) do
					if v:IsA("Player") and v ~= localPlayer then
						if v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
							if v.Character.HumanoidRootPart and root.Position then
								if (v.Character.HumanoidRootPart.Position - root.Position).Magnitude < (_G.trashGrabberSafeModeDistance or 50) then
									can = false
								end
							end
						end
					end
				end
			else
				can = true
			end
			distance = math.floor(distance)

			if root.Transparency ~= 1 then
				if (can and can == true) and distance < nearestDistance then
					nearestTrashCan = v
					nearestDistance = distance
				else
					warn("can:", can, "distance:", distance < nearestDistance, "distance:", distance, "nearestdistance:", nearestDistance)
				end
			else
				warn("transparency 1")
			end
		end

	elseif _G.trashGrabberSearchMode == 2 then
		-- raycast

	else
		warn(_G.trashGrabberSearchMode)
	end

	if not nearestTrashCan then warn("nearest trash can not found"); _G.trashGrabberWorking = false return end


	local oldCFrame = localPlayer.Character.HumanoidRootPart.CFrame

	if _G.trashGrabberMode == 1 then
		print(1)
		local cf = nearestTrashCan:WaitForChild("Trashcan").CFrame
		repeat
			task.wait(_G.trashGrabberReactionTime or 0.05)
			localPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(cf.Position.X, cf.Position.Y, cf.Position.Z + 5), Vector3.new(cf.Position.X, localPlayer.Character.HumanoidRootPart.Position.Y, cf.Position.Z))
		until localPlayer.Character:GetAttribute("HasTrashcan") and (localPlayer.Character:GetAttribute("HasTrashcan") ~= false and localPlayer.Character:GetAttribute("HasTrashcan") ~= nil)
		localPlayer.Character.HumanoidRootPart.CFrame = oldCFrame

	elseif _G.trashGrabberMode == 2 then
		warn(2)
		local cf = nearestTrashCan:WaitForChild("Trashcan").CFrame

		repeat
			task.wait(_G.trashGrabberReactionTime or 0.05)
			_G.absoluteImmortal = true
			_G.absoluteImmortalTPQuotes = 1
			_G.absoluteImmortalCustomTP = cf
			absoluteImmortalFUNC()
		until localPlayer.Character:GetAttribute("HasTrashcan") and (localPlayer.Character:GetAttribute("HasTrashcan") ~= false and localPlayer.Character:GetAttribute("HasTrashcan") ~= nil)

		_G.absoluteImmortal = false
		_G.absoluteImmortalTPQuotes = 0
		_G.absoluteImmortalCustomTP = CFrame.new(0,0,0)
		absoluteImmortalFUNC()

		localPlayer.Character.HumanoidRootPart.CFrame = oldCFrame
	else
		warn(_G.trashGrabberMode)
	end

	_G.trashGrabberWorking = false
end


RunService.Heartbeat:Connect(function(delta)
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
			localPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(1, -494, 1) * CFrame.Angles(-89.5, 0,0)

			_G.killActivated = false

			_G.targetNeedTp = false

			absoluteImmortalFUNC(2)
		end

		if _G.adcNeedCustomTp == true then
			if localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") then
				localPlayer.Character.HumanoidRootPart.CFrame = _G.adcCusomCFrame
			end

			_G.killActivated = false

			_G.voidNeedTp = false
			_G.targetNeedTp = false

			absoluteImmortalFUNC(2)
		end

		if _G.voidNeedTp == true then
			localPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(1, 205, 1)

			_G.targetNeedTp = false

			absoluteImmortalFUNC(2)
		end

		if _G.targetActivated == true then
			if _G.targetNeedTp == true then
				if _G.targetTarget ~= "" and _G.targetTarget.Character then
					if _G.targetSafeActivated == true then
						if localPlayer.Character.Humanoid.Health > _G.targetSafeProp then
							if _G.targetPredict == true then
								local cf = _G.targetTarget.Character.HumanoidRootPart.CFrame
								localPlayer.Character.HumanoidRootPart.CFrame = (_G.targetTarget.Character.Humanoid.MoveDirection * delta * (_G.targetTarget.Character.Humanoid.WalkSpeed / 5 or 1))
							else
								local cf = _G.targetTarget.Character.HumanoidRootPart.CFrame
								localPlayer.Character.HumanoidRootPart.CFrame = cf - (cf.LookVector * 3.5) + _G.targetTarget.Character.Humanoid.MoveDirection
							end
						else
							if _G.targetSafeQuotes == 1 then
								localPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(1, -490, 1)
							else
								localPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(1, -494, 1) * CFrame.Angles(-89.5, 0,0)
							end
						end
					else
						local cf = _G.targetTarget.Character.HumanoidRootPart.CFrame
						localPlayer.Character.HumanoidRootPart.CFrame = cf - (cf.LookVector * 3.5) + _G.targetTarget.Character.Humanoid.MoveDirection
					end
				end
			end
		end

		if _G.absoluteImmortal then
			task.defer(function()
				if _G.absoluteImmortalCopy then
					if _G.absoluteImmortalNeedTP then
						if localPlayer.Character:FindFirstChild("HumanoidRootPart") then
							local tpCFrame
							if _G.absoluteImmortalTPQuotes == 0 then
								tpCFrame = CFrame.new(math.random(90000000, 100000000),math.random(90000000, 100000000),math.random(90000000, 100000000))
							elseif _G.absoluteImmortalTPQuotes == 1 then
								local tpCFrame1 = CFrame.new(math.random(90000000, 100000000),math.random(90000000, 100000000),math.random(90000000, 100000000))
								tpCFrame = (_G.absoluteImmortalCustomTP or tpCFrame1)
							else
								warn(_G.absoluteImmortalTPQuotes)
							end
							localPlayer.Character.HumanoidRootPart.CFrame = tpCFrame or _G.absoluteImmortalCopy.HumanoidRootPart.CFrame

							if _G.absoluteImmortalAntiVelocity == true then
								task.defer(function()
									for i, v in pairs(localPlayer.Character:GetDescendants()) do
										if v:IsA("BasePart") then
											v.Velocity = Vector3.new(0,0,0)
											v.AssemblyLinearVelocity = Vector3.new(0,0,0)
											v.AssemblyAngularVelocity = Vector3.new(0,0,0)
											v.RotVelocity = Vector3.new(0, 0, 0)
										end
									end
								end)
								task.defer(function()
									for i, v in pairs(_G.absoluteImmortalCopy:GetDescendants()) do
										if v:IsA("BasePart") then
											v.Velocity = Vector3.new(0,0,0)
											v.AssemblyLinearVelocity = Vector3.new(0,0,0)
											v.AssemblyAngularVelocity = Vector3.new(0,0,0)
											v.RotVelocity = Vector3.new(0, 0, 0)
										end
									end
								end)

								localPlayer.Character.HumanoidRootPart.Velocity = Vector3.new(0,0,0)
								localPlayer.Character.HumanoidRootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
								localPlayer.Character.HumanoidRootPart.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
								localPlayer.Character.HumanoidRootPart.RotVelocity = Vector3.new(0, 0, 0)

								_G.absoluteImmortalCopy.HumanoidRootPart.Velocity = Vector3.new(0,0,0)
								_G.absoluteImmortalCopy.HumanoidRootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
								_G.absoluteImmortalCopy.HumanoidRootPart.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
								_G.absoluteImmortalCopy.HumanoidRootPart.RotVelocity = Vector3.new(0, 0, 0)
							end
						else
							debugMSG(2, "localPlayer.Character.HumanoidRootPart is not exists")
						end
					else
						if _G.absoluteImmortalCopy:FindFirstChild("HumanoidRootPart") and localPlayer.Character:FindFirstChild("HumanoidRootPart") then
							if (_G.absoluteImmortalCopy.HumanoidRootPart.CFrame.Position.X > 89999999 and _G.absoluteImmortalCopy.HumanoidRootPart.CFrame.Position.Y > 89999999 and _G.absoluteImmortalCopy.HumanoidRootPart.CFrame.Position.Z > 89999999) then
								absoluteImmortalFUNC(2)
								_G.absoluteImmortalCopy.HumanoidRootPart.CFrame = CFrame.new(149, 440, 29)
								localPlayer.Character.HumanoidRootPart.CFrame = _G.absoluteImmortalCopy.HumanoidRootPart.CFrame

								if _G.absoluteImmortalAntiVelocity == true then
									task.defer(function()
										for i, v in pairs(localPlayer.Character:GetDescendants()) do
											if v:IsA("BasePart") then
												v.Velocity = Vector3.new(0,0,0)
												v.AssemblyLinearVelocity = Vector3.new(0,0,0)
												v.AssemblyAngularVelocity = Vector3.new(0,0,0)
											end
										end
									end)
									localPlayer.Character.HumanoidRootPart.Velocity = Vector3.new(0,0,0)
									localPlayer.Character.HumanoidRootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
									localPlayer.Character.HumanoidRootPart.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
									localPlayer.Character.HumanoidRootPart.RotVelocity = Vector3.new(0, 0, 0)
								end
							else
								localPlayer.Character.HumanoidRootPart.CFrame = _G.absoluteImmortalCopy.HumanoidRootPart.CFrame
							end
						end
						if _G.absoluteImmortalCopy:FindFirstChild("Humanoid") then
							_G.absoluteImmortalCopy.Humanoid:Move(localPlayer.Character.Humanoid.MoveDirection)
						end
						_G.absoluteImmortalCopy:TranslateBy(_G.absoluteImmortalCopy.Humanoid.MoveDirection * 1)
					end
				else
					_G.absoluteImmortalLoaded = false
					task.defer(absoluteImmortalFUNC)
					debugMSG(1, "_G.absoluteImmortalCopy = ".._G.absoluteImmortalCopy)
					debugMSG(2, {"_G.absoluteImmortalCopy == nil", "or started not correctly"})
				end
			end)

			absoluteImmortalFUNC()
		else
			absoluteImmortalFUNC(2)
		end

		--[[if localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") then
			if (localPlayer.Character.HumanoidRootPart.CFrame.Position.X > 89999999 and localPlayer.Character.HumanoidRootPart.CFrame.Position.Y > 89999999 and localPlayer.Character.HumanoidRootPart.CFrame.Position.Z > 89999999) and (not _G.absoluteImmortalCopy or _G.absoluteImmortalCopy == nil) then
				localPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(149, 440, 29)
			end
		end]]
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

		if _G.killActivated == true and _G.killAntiFling == true then
			task.defer(function()
				for i, v in pairs(localPlayer.Character:GetDescendants()) do
					if v:IsA("BasePart") then
						v.Velocity = Vector3.new(0,0,0)
						v.AssemblyLinearVelocity = Vector3.new(0,0,0)
						v.AssemblyAngularVelocity = Vector3.new(0,0,0)
					end
				end
			end)
			localPlayer.Character.HumanoidRootPart.Velocity = Vector3.new(0,0,0)
			localPlayer.Character.HumanoidRootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
			localPlayer.Character.HumanoidRootPart.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
		end
	end

	if localPlayer.Character then
		if localPlayer.Character:FindFirstChild("Communicate") then
			if _G.awcActivated == true then
				local args = {Goal = "Wall Combo";}
				workspace.Live.IlllIIIIllllIIIIIII3.Communicate:FireServer(unpack({args}))
			end
		end
	end

	if localPlayer.Character then
		if localPlayer.Character:FindFirstChild("Humanoid") then
			local humanod = localPlayer.Character:FindFirstChildOfClass("Humanoid")
			if humanod then
				if _G.customM1sActivated == true then
					customM1s(humanod)
				end
			end
		end
	end
end)

local function onPlrAdded(plr)
	task.defer(function()
		checkForAdmins(plr)
	end)
	plr.CharacterAdded:Connect(hlChar)

	if _G.killWhiteList == true then
		if not plr:IsFriendsWith(localPlayer.UserId) then
			plr.CharacterAdded:Connect(onCharAdded)
			if plr.Character then
				task.defer(function()onCharAdded(plr.Character);end)
				task.defer(function()hlChar(plr.Character);end)
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

	if character:FindFirstChild("Communicate") then
		if _G.disableIntoAnimation == true then
			local args = {Goal = "Disable Intro";}
			character.Communicate:FireServer(unpack({args}))
		end
	end
end)

task.defer(function()
	while task.wait(5) do
		if _G.adminWarning == true then
			for i , v in pairs(Players:GetPlayers()) do
				checkForAdmins(v)
			end
		end
	end
end)

Rayfield:Notify({
	Title = "Tsb Script",
	Content = "Loaded",
	Duration = 6.5,
	Image = 4483362458,
})	
