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
	_G.killWhiteList = true
	_G.killactivated = true -- false to disable
	_G.killSafeSelf = true -- false to disable
	_G.killSafeProp = 15
	_G.killChargeUp = false 
	_G.killKilling = false
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
		FileName = "Big Hub"
	},

	KeySystem = true, -- Set this to true to use our key system
	KeySettings = {
		Title = "Key",
		Subtitle = "Key System",
		Note = "No method of obtaining the key is provided", -- Use this to tell the user how to get a key
		FileName = "Key", -- It is recommended to use something unique as other scripts using Rayfield may overwrite your key file
		SaveKey = true, -- The user's key will be saved, but if you change the key, they will be unable to use your script
		GrabKeyFromSite = false, -- If this is true, set Key below to the RAW site you would like Rayfield to get the key from
		Key = {"Skuff"} -- List of keys that will be accepted by the system, can be RAW file links (pastebin, github etc) or simple strings ("hello","key22")
	}
})

local Tab = Window:CreateTab("Main", "rewind")
local Tab2 = Window:CreateTab("Attacks", "rewind")

local Section = Tab:CreateSection("Main")
local Section2 = Tab2:CreateSection("Kills Farm (afk kill stealer)")


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


local Button = Tab:CreateButton({
	Name = "Unload UI",
	Callback = function()
		Rayfield:Destroy()
	end,
})

local function onCharAdded(char)
	char:WaitForChild("Humanoid"):GetPropertyChangedSignal("Health"):Connect(function()
		if not char:FindFirstChild("HumanoidRootPart") then return end
		if math.floor(char.Humanoid.Health) > 15 and (math.floor(char.Humanoid.Health) ~= 0 or math.floor(char.Humanoid.Health) ~= 1) then return end
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
							["Tool"] = localPlayer.Backpack:WaitForChild("Crushing Pull")
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

RunService.Heartbeat:Connect(function()
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
