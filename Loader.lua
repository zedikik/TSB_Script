local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local localPlayer = Players.LocalPlayer
local playerGui = localPlayer.PlayerGui

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
	_G.adcWorking = false
	_G.isDeath = false -- check if player anim == 11343250001 (death counter anim)
	_G.adcQuotes = 1 -- wait time (1 = no wait; 2 = 4 seconds fakeout; 3 = 8 seconds long fakeout)

	_G.voidKillActivated = false -- auto void kill activated
	_G.voidKilling = false 
	_G.voidKillQuotes = 1 -- wait time (1 = no wait; 2 = wait anim end)
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
local Tab2 = Window:CreateTab("Attacks", "rewind")

local Section = Tab:CreateSection("Main")

local Section2 = Tab2:CreateSection("Exploits")

local antiDeathCounterToggle = Tab2:CreateToggle({
	Name = "Anti Death Counter",
	CurrentValue = false,
	Flag = "ADCToggle", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
	Callback = function(Value)
		print(Value)
		_G.adcActivated = Value
	end,
})

local autoVoidToggle = Tab2:CreateToggle({
	Name = "Auto Void Kill",
	CurrentValue = false,
	Flag = "AVToggle", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
	Callback = function(Value)
		print(Value)
		_G.voidKillActivated = Value
	end,
})

local Section3 = Tab2:CreateSection("Kills Farm (afk kill stealer)")


local killToggle = Tab2:CreateToggle({
	Name = "Toggle Kill Stealer",
	CurrentValue = false,
	Flag = "KillToggle", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
	Callback = function(Value)
		print(Value)
		_G.killActivated = Value
	end,
})

local killWhiteListToggle = Tab2:CreateToggle({
	Name = "Whitelist (do not kill ur friends)",
	CurrentValue = true,
	Flag = "KillWhiteList", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
	Callback = function(Value)
		print(Value)
		_G.killWhitelist = Value
	end,
})

local killSafeSelfToggle = Tab2:CreateToggle({
	Name = "Safe Self (Do not steal, if u has lower than Safe Prop hp)",
	CurrentValue = true,
	Flag = "KillSafeSelf", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
	Callback = function(Value)
		print(Value)
		_G.killSafeSelf = Value
	end,
})

local killSafePropSlider = Tab2:CreateSlider({
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

local killStealPropSlider = Tab2:CreateSlider({
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


local Button = Tab:CreateButton({
	Name = "Unload UI",
	Callback = function()
		Rayfield:Destroy()
	end,
})

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

	if _G.adcQuotes == 1 then
		task.wait(0)

	elseif _G.adcQuotes == 2 then
		task.wait(4)

	elseif _G.adcQuotes == 3 then
		task.wait(8)

	else
		warn(_G.adcQuotes)
	end
	local oldCFrame = localPlayer.Character.HumanoidRootPart.CFrame
	localPlayer.Character.HumanoidRootPart.Anchored = true
	localPlayer.Character.Humanoid.AutoRotate = false

	for i, v in pairs(playerGui:GetDescendants()) do
		if v:IsA("ScreenGui") and v.Name == "Death" then
			v.Enabled = false
		end
	end

	repeat
		_G.adcNeedTp = true
	until task.wait(2)
	_G.adcNeedTp = false
	print("antis")

	localPlayer.Character.HumanoidRootPart.CFrame = oldCFrame
	localPlayer.Character.HumanoidRootPart.Anchored = false
	localPlayer.Character.Humanoid.AutoRotate = true

	_G.adcWorking = false
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


RunService.Heartbeat:Connect(function()
	if localPlayer.Character then
		if _G.adcNeedTp == true then
			localPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(1, -496, 1)

			if _G.killActivated == true then
				_G.killActivated = false
				killToggle:Set(false)
			end
		end
	end

	if localPlayer.Character then
		local isDeathCountered = getPlayingAnim(11343250001)
		_G.isDeath = isDeathCountered
		
		if _G.voidKillActivated == true and _G.voidKilling == false then
			local voidAnims = {"12273188754", "12309835105"} -- rbxassetid://14516273501

			local isAnim
			for i, v in voidAnims do
				isAnim = getPlayingAnim(v)
				if isAnim == true then
					break
				end
			end
			if isAnim == true then
				print(isAnim, "Void anim") -- rbxassetid://12273188754, 
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
			warn(localPlayer.Character:GetAttribute("Character"), "has = false")
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
