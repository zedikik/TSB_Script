local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local localPlayer = Players.LocalPlayer
local playerGui = localPlayer.PlayerGui
local camera = workspace.CurrentCamera

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
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
	_G.killactivated = false
	_G.killWhiteList = true
	_G.killSafeSelf = true
	_G.killSafeProp = 15
	_G.killStealProp = 15
	_G.killChargeUp = false 
	_G.killKilling = false

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

	_G.hitboxColor = Color3.new(255, 0, 0)
end

if not workspace:FindFirstChild("VoidPlate") then
	local voidPlate = Instance.new("Part", workspace)
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
		Enabled = true,
		FolderName = "Tsb_Script", -- Create a custom folder for your hub/game
		FileName = "config"
	},

	KeySystem = true, -- Set this to true to use our key system
	KeySettings = {
		Title = "Key",
		Subtitle = "Key System",
		Note = "Key is Skuff", -- Use this to tell the user how to get a key
		FileName = "Key", -- It is recommended to use something unique as other scripts using Rayfield may overwrite your key file
		SaveKey = true, -- The user's key will be saved, but if you change the key, they will be unable to use your script
		GrabKeyFromSite = false, -- If this is true, set Key below to the RAW site you would like Rayfield to get the key from
		Key = {"Skuff", "skuff"} -- List of keys that will be accepted by the system, can be RAW file links (pastebin, github etc) or simple strings ("hello","key22")
	}
})

local Tab = Window:CreateTab("Main", "rewind")
local Tab2 = Window:CreateTab("Visuals", "rewind")
local Tab3 = Window:CreateTab("Attacks", "rewind")
local Tab4 = Window:CreateTab("Teleports", "rewind")

local Section = Tab:CreateSection("Main")
local section2 = Tab2:CreateSection("Visuals")
local Section3 = Tab3:CreateSection("Exploits")
local Section4 = Tab4:CreateSection("Locations")


local function setupUI()
	local function setupTab()
		local Button = Tab:CreateButton({
			Name = "Unload UI",
			Callback = function()
				Rayfield:Destroy()
			end,
		})
	end

	local function setupTab2()
		local hitboxToggle = Tab2:CreateToggle({
			Name = "Show Hitboxes",
			CurrentValue = false,
			Flag = "hitboxToggle", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
			Callback = function(Value)
				print(Value)
				if Value == true then
					for i, v in pairs(localPlayer.Character:GetChildren()) do
						if string.match(v.Name, "Hitbox_") then
							v.Transparency = 0
							v.Color = _G.hitboxColor
						end
					end
				else
					for i, v in pairs(localPlayer.Character:GetChildren()) do
						if string.match(v.Name, "Hitbox_") then
							v.Transparency = 1
							v.Color = Color3.fromRGB(193, 193, 193) -- default color
						end
					end
				end
			end,
		})

		local hitboxColor = Tab2:CreateColorPicker({
			Name = "Hitbox Color",
			Color = Color3.fromRGB(255,0,0),
			Flag = "HitboxColor", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
			Callback = function(Value)
				local color = nil
				local split = string.split(tostring(Value), ", ")
				print(Value, Color3.new(Value))

				local C3 = Color3.new(0, 0, 0)
				local r, g, b = math.round(tonumber(split[1])*255), math.round(split[2]*255), math.round(split[3]*255)
				color = Color3.new(r,g,b)

				if color then
					_G.hitboxColor = color
				else
					_G.hitboxColor = Color3.fromRGB(255,0,0)
				end
			end
		})
	end

	local function setupTab3()
		local antiDeathCounterToggle = Tab3:CreateToggle({
			Name = "Anti Death Counter",
			CurrentValue = false,
			Flag = "ADCToggle", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
			Callback = function(Value)
				print(Value)
				_G.adcActivated = Value
			end,
		})

		local deathCounterDropdown = Tab3:CreateDropdown({
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

		local deathPunishLocDropdown = Tab3:CreateDropdown({
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


		local autoVoidToggle = Tab3:CreateToggle({
			Name = "Auto Void Kill",
			CurrentValue = false,
			Flag = "AVToggle", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
			Callback = function(Value)
				print(Value)
				_G.voidKillActivated = Value
			end,
		})

		local voidDropdown = Tab3:CreateDropdown({
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

		local Section3 = Tab3:CreateSection("Kills Farm (afk kill stealer)")

		local killToggle = Tab3:CreateToggle({
			Name = "Toggle Kill Stealer",
			CurrentValue = false,
			Flag = "KillToggle", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
			Callback = function(Value)
				print(Value)
				_G.killActivated = Value
			end,
		})

		local killWhiteListToggle = Tab3:CreateToggle({
			Name = "Whitelist (do not kill ur friends)",
			CurrentValue = true,
			Flag = "KillWhiteList", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
			Callback = function(Value)
				print(Value)
				_G.killWhitelist = Value
			end,
		})

		local killSafeSelfToggle = Tab3:CreateToggle({
			Name = "Safe Self (Do not steal, if u has lower than Safe Prop hp)",
			CurrentValue = true,
			Flag = "KillSafeSelf", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
			Callback = function(Value)
				print(Value)
				_G.killSafeSelf = Value
			end,
		})

		local killSafePropSlider = Tab3:CreateSlider({
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

		local killStealPropSlider = Tab3:CreateSlider({
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

	local function setupTab4()
		local MapCenter = Tab4:CreateButton({
			Name = "Map Center",
			Callback = function()
				localPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(149, 440, 29)
			end,
		})

		local voidPlate = Tab4:CreateButton({
			Name = "Void Platform",
			Callback = function()
				localPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(0, -493, 0)
			end,
		})

		local DeathCounterRoom = Tab4:CreateButton({
			Name = "Death Counter Room",
			Callback = function()
				localPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-66, 30, 20356)
			end,
		})

		local AtomicSlashRoom = Tab4:CreateButton({
			Name = "Atomic Slash Room",
			Callback = function()
				localPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(1050, 140, 23010)
			end,
		})

		local UpperBaseplate = Tab4:CreateButton({
			Name = "Upper Baseplate",
			Callback = function()
				localPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(1060, 405, 22887)
			end,
		})

		local LowerBaseplate = Tab4:CreateButton({
			Name = "Lower Baseplate",
			Callback = function()
				localPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(1060, 20, 22887)
			end,
		})
		
		local weakestDummy = Tab4:CreateButton({
			Name = "Weakest Dummy",
			Callback = function()
				localPlayer.Character.HumanoidRootPart.CFrame = workspace.Live["Weakest Dummy"].HumanoidRootPart.CFrame
			end,
		})

	end

	setupTab()
	setupTab2()
	setupTab3()
	setupTab4()
end
setupUI()


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
		if math.floor(char.Humanoid.Health) > _G.killStealProp and (math.floor(char.Humanoid.Health) ~= 0 or math.floor(char.Humanoid.Health) ~= 1) then return end
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
		task.wait(0.25)
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

	task.wait(4)

	_G.voidNeedTp = false
	_G.voidKilling = false

	localPlayer.Character.HumanoidRootPart.CFrame = oldCFrame
end


RunService.Heartbeat:Connect(function()
	if localPlayer.Character then
		if _G.adcNeedTp == true then
			localPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(1, -490, 1)

			if _G.killActivated == true then
				_G.killActivated = false
			end
		end

		if _G.adcNeedCustomTp == true then
			if localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") then
				localPlayer.Character.HumanoidRootPart.CFrame = _G.adcCusomCFrame
			end

			if _G.killActivated == true then
				_G.killActivated = false
			end
		end

		if _G.voidNeedTp == true then
			localPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(1, 205, 1)
		end
	end

	if localPlayer.Character then
		local isDeathCountered = getPlayingAnim("11343250001")
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
		if _G.adcActivated == true then
			if _G.isDeath == true then
				antiDeathCounter()
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
	if _G.killWhiteList == true then
		if plr:IsFriendsWith(localPlayer.UserId) then
			return
		end
	end

	plr.CharacterAdded:Connect(onCharAdded)
	if plr.Character then
		onCharAdded(plr.Character)
	end
end

for _, plr in Players:GetPlayers() do
	if _G.killWhiteList == true then
		if plr ~= localPlayer then
			if plr:IsFriendsWith(localPlayer.UserId) then
				return
			else
				onPlrAdded(plr)
			end
		end
	else
		onPlrAdded(plr)
	end
end
Players.PlayerAdded:Connect(onPlrAdded)

Rayfield:Notify({
	Title = "Tsb Script",
	Content = "Loaded",
	Duration = 6.5,
	Image = 4483362458,
})
