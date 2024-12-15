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
	_G.killactivated = false
	_G.killSafeSelf = true
	_G.killSafeProp = 15
	_G.killStealProp = 15
	_G.killChargeUp = false 
	_G.killKilling = false

	_G.adcActivated = false -- anti death counter
	_G.adcWorking = false
	_G.isDeath = false -- check if player anim == 11343250001 (death counter anim)
	_G.adcQuotes = 1 -- wait time (1 = no wait; 2 = 4 seconds fakeout; 3 = 8 seconds long fakeout)
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

local killStealPropSlider = Tab2:CreateSlider({
	Name = "Steal
