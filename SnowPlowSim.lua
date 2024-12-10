local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "User | Snow Plow Simulator",
   LoadingTitle = "Snow Plow Simulator",
   LoadingSubtitle = "by Nalo",
   Theme = "DarkBlue",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "NaloSnow", -- Create a custom folder for your hub/game
      FileName = "SnowPlow"
   },
   Discord = {
      Enabled = true,
      Invite = "noinvitelink", -- The Discord invite code, do not include discord.gg/. E.g. discord.gg/ABCD would be ABCD
      RememberJoins = true -- Set this to false to make them join the discord every time they load it up
   },
   KeySystem = true, -- Set this to true to use our key system
   KeySettings = {
      Title = "Nalo Hub | Snow Plow Simulator",
      Subtitle = "Key System",
      Note = "Get the key from the Discord; discord.gg/ChangeThis",
      FileName = "NaloSnowPlowKey", -- It is recommended to use something unique as other scripts using Rayfield may overwrite your key file
      SaveKey = true, -- The user's key will be saved, but if you change the key, they will be unable to use your script
      GrabKeyFromSite = false, -- If this is true, set Key below to the RAW site you would like Rayfield to get the key from
      Key = {"oMI2e9ZjRG"} -- List of keys that will be accepted by the system, can be RAW file links (pastebin, github etc) or simple strings ("hello","key22")
   }
})

local AutoFarmTab = Window:CreateTab("Autofarm", nil) -- Title, Image
local Autoclick = AutoFarmTab:CreateSection("Autofarm")

local EggTab = Window:CreateTab("Eggs", nil) -- Title, Image
local Autoegg = EggTab:CreateSection("Auto Open Eggs")

local TeleportTab = Window:CreateTab("Teleport", nil) -- Title, Image
local Teleports = TeleportTab:CreateSection("Teleport")

local MiscTab = Window:CreateTab("Misc", nil) -- Title, Image
local Miscellaneous = MiscTab:CreateSection("Miscellaneous")

local autoclickerRunning = false
local eggToBuy = "Basic Egg"

local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- ----------------------------------------------------
-- [[                    FARM TAB                    ]]
-- ----------------------------------------------------

local Toggle = AutoFarmTab:CreateToggle({
   Name = "Autofarm Snow",
   CurrentValue = false,
   Flag = "Autosnow", -- Unique flag for configuration saving
   Callback = function(Value)
      -- Reference to the remote event
      local Remote = game:GetService("ReplicatedStorage").Events.e8eGb8RgRXFcug8q
      local Folder = workspace.HitParts

      -- Function to get the first valid part from the folder
      local function getFirstPartName()
         -- Loop through all children in the HitParts folder
         for _, child in ipairs(Folder:GetChildren()) do
             if child:IsA("BasePart") then  -- Check if the child is a part
                 return child.Name  -- Return the name of the first part found
             end
         end
         return nil  -- Return nil if no parts are found in the folder
      end

      autoclickerRunning = Value -- Update the state of the autoclicker

      -- Function to start autoclicking
      if Value then
         task.spawn(function()
            while autoclickerRunning do
                local hitPartName = getFirstPartName()  -- Get the first part name

                if hitPartName then
                   local hitPart = Folder:FindFirstChild(hitPartName)  -- Ensure the part still exists

                   -- If the part exists, fire the remote event
                   if hitPart then
                       local args = {
                           [1] = hitPart,  -- Use the part itself
                           [2] = "Snow8",
                           [3] = "GoldenFlame"
                       }

                       Remote:FireServer(unpack(args))  -- Fire the remote
                   else
                       warn("The part no longer exists: " .. hitPartName)
                   end
                else
                   warn("No valid part found in HitParts folder.")
                end

                task.wait(0.1)  -- Wait for 0.1 seconds before the next iteration
            end
         end)
      end
   end,
})

-- ----------------------------------------------------
-- [[                    EGG TAB                     ]]
-- ----------------------------------------------------

local Dropdown = EggTab:CreateDropdown({
   Name = "Select Egg",
   Options = {
      "Basic Egg",
      "Spotty Egg",
      "Snow Egg",
      "Jungle Egg",
      "Desert Egg",
      "Swamp Egg",
      "Lava Egg",
      "Farm Egg",
      "Candy Egg",
      "Galaxy Egg",
      "Golden Snow Egg",
      "Golden Desert Egg",
      "Golden Jungle Egg",
      "Golden Farm Egg",
      "Golden Swamp Egg",
      "Golden Lava Egg",
      "Golden Candy Egg"
   },
   CurrentOption = "Basic Egg", -- Set this to a single string
   MultipleOptions = false, -- Ensure only one option is selectable
   Flag = "selectEggDropdown", -- Unique flag for configuration saving
   Callback = function(Option)
      -- Extract the first value from the table
      local selectedEgg = Option[1] or Option -- Fallback to Option if it's not a table
      print(selectedEgg) -- Output the selected egg name

      -- Use the selected egg name to find the object
      eggToBuy = selectedEgg
   end,
})



--local Label = EggTab:CreateLabel("Selecting an egg will purchase it without confirmation!", "circle-alert", Color3.fromRGB(255, 255, 255), false)

local Button = EggTab:CreateButton({
   Name = "Purchase Egg",
   Callback = function()
      local args = {
         [1] = workspace.Eggs:FindFirstChild(eggToBuy)
      }

      -- Fire the remote
      game:GetService("ReplicatedStorage").EggSystemRemotes.HatchServer:InvokeServer(unpack(args))
   end
})

-- ----------------------------------------------------
-- [[                  TELEPORT TAB                  ]]
-- ----------------------------------------------------

Label = TeleportTab:CreateLabel("Coming Soon!", "party-popper", Color3.fromRGB(255, 255, 255), false)

-- ----------------------------------------------------
-- [[                    MISC TAB                    ]]
-- ----------------------------------------------------
local Toggle = MiscTab:CreateToggle({
   Name = "Disable Snow Effect",
   CurrentValue = false,
   Flag = "DisableSnow", -- Unique flag for configuration saving
   Callback = function(Value)
      if Value then
         game:GetService("Workspace").Camera.BlizzardBlock.SnowEmitter.Rate = 0
      else
         game:GetService("Workspace").Camera.BlizzardBlock.SnowEmitter.Rate = 100
      end
   end,
})

local Button = MiscTab:CreateButton({
   Name = "Equip Best Pets",
   Callback = function()
      -- Debugging: Check if the button was clicked
      print("Equip Best Pets button clicked!")

      -- Reference to the player's GUI
      local player = game.Players.LocalPlayer
      local playerGui = player:WaitForChild("PlayerGui")
      local mainGui = playerGui:WaitForChild("Main")
      local inventoryFrame = mainGui:WaitForChild("Inventory")
      local petsHolder = inventoryFrame:WaitForChild("PetsHolder")
      local itemsFrame = petsHolder:WaitForChild("Items")

      -- Table to store pets and their CoinMult values, along with their model instances
      local pets = {}
      game:GetService("ReplicatedStorage").EggSystemRemotes.UnequipAll:InvokeServer()

      -- Loop through each child of the Items frame (which are the pets)
      for _, item in pairs(itemsFrame:GetChildren()) do
         -- Check if the child is an ImageButton (this would be the pet container)
         if item:IsA("ImageButton") then
            -- Debugging: Check if we are finding a ViewportFrame
            local viewportFrame = item:FindFirstChild("ViewportFrame")
            if viewportFrame then
               -- Find the model inside the ViewportFrame
               local model = viewportFrame:FindFirstChildOfClass("Model")
               if model then
                  -- Check if the model has the CoinMult value
                  local coinMult = model:FindFirstChild("CoinMult")
                  if coinMult and coinMult:IsA("NumberValue") then
                     -- Debugging: Output pet name and multiplier
                     print("Found pet: " .. model.Name .. " with CoinMult: " .. coinMult.Value)

                     -- Add the pet name and its CoinMult value to the pets table (include model instance)
                     table.insert(pets, {
                        Name = model.Name,  -- The name of the pet (e.g., "Dog", "Cat")
                        CoinMult = coinMult.Value,  -- The multiplier value of the pet
                        Model = model  -- The model instance
                     })
                  else
                     print("No CoinMult found for model: " .. model.Name)
                  end
               else
                  print("No model found in ViewportFrame for item: " .. item.Name)
               end
            else
               print("No ViewportFrame found in item: " .. item.Name)
            end
         end
      end

      -- Debugging: Output the number of pets found
      print("Total pets found: " .. #pets)

      -- If no pets were found, exit the function
      if #pets == 0 then
         print("No pets to equip.")
         return
      end

      -- Sort the pets by CoinMult in descending order (highest multiplier first)
      table.sort(pets, function(a, b)
         return a.CoinMult > b.CoinMult
      end)

      -- Debugging: Output the sorted pets
      print("Sorted pets by CoinMult (descending):")
      for i, pet in ipairs(pets) do
         print(i .. ". " .. pet.Name .. " with CoinMult: " .. pet.CoinMult)
      end

      -- Equip the best 4 pets, ensuring uniqueness
      local topPets = {}
      local equippedPetNames = {}  -- Keep track of equipped pet names to avoid duplicates

      for i = 1, math.min(4, #pets) do
         local petName = pets[i].Name
         
         -- Avoid duplicates by checking if the pet name is already in the equipped list
         if not equippedPetNames[petName] then
            table.insert(topPets, pets[i].Model.Name)  -- Get the name of the top pet (from its model)
            equippedPetNames[petName] = true  -- Mark this pet as equipped
         end
      end

      -- Debugging: Output the pets being equipped
      print("Equipping the best pets:")
      for _, petName in pairs(topPets) do
         print("Equipping pet: " .. petName)
         -- Call the remote to equip the pet
         local args = { petName }
         local success, error = pcall(function()
            game:GetService("ReplicatedStorage").EggSystemRemotes.EquipPet:InvokeServer(unpack(args))
         end)
         
         if success then
            print("Successfully equipped: " .. petName)
            
            -- Now, update the UI to reflect the equipped pet
            for _, item in pairs(itemsFrame:GetChildren()) do
               if item:IsA("ImageButton") then
                  -- Check if this ImageButton corresponds to the equipped pet
                  local viewportFrame = item:FindFirstChild("ViewportFrame")
                  if viewportFrame then
                     local model = viewportFrame:FindFirstChildOfClass("Model")
                     if model and model.Name == petName then
                        -- Set the Equipped BoolValue to true
                        local equippedValue = item:FindFirstChild("Equipped")
                        if equippedValue then
                           equippedValue.Value = true
                        end

                        -- Make the EquippedIcon visible
                        local equippedIcon = item:FindFirstChild("EquippedIcon")
                        if equippedIcon then
                           equippedIcon.Visible = true
                        end

                        print("UI updated: " .. petName .. " is now equipped.")
                     end
                  end
               end
            end
         else
            print("Failed to equip: " .. petName .. " | Error: " .. error)
         end
      end
   end
})

local Player = MiscTab:CreateSection("Local Player")

local Slider = MiscTab:CreateSlider({
   Name = "Walk Speed",
   Range = {1, 350},
   Increment = 1,
   Suffix = "Speed",
   CurrentValue = 16,
   Flag = "sliderws", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Value)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = (Value)
   end,
})

local Slider = MiscTab:CreateSlider({
   Name = "Jump Power",
   Range = {1, 350},
   Increment = 1,
   Suffix = "Power",
   CurrentValue = 16,
   Flag = "sliderjp", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Value)
        game.Players.LocalPlayer.Character.Humanoid.JumpPower = (Value)
   end,
})

local Warning = MiscTab:CreateSection("Warning")
Label = MiscTab:CreateLabel('"Equip Best Pets" can bug the inventory UI', "circle-alert", Color3.fromRGB(255, 255, 255), false)



-- Webhook Test


--[[
Rayfield:Notify({
   Title = "Thank you for using ",
   Content = "Very cool gui",
   Duration = 5,
   Image = 13047715178,
   Actions = { -- Notification Buttons
      Ignore = {
         Name = "Okay!",
         Callback = function()
         print("The user tapped Okay!")
      end
   },
},
}) 
]]--

--[[
local Button = MainTab:CreateButton({
   Name = "Infinite Jump Toggle",
   Callback = function()
       --Toggles the infinite jump between on or off on every script run
_G.infinjump = not _G.infinjump

if _G.infinJumpStarted == nil then
	--Ensures this only runs once to save resources
	_G.infinJumpStarted = true
	
	--Notifies readiness
	game.StarterGui:SetCore("SendNotification", {Title="Youtube Hub"; Text="Infinite Jump Activated!"; Duration=5;})

	--The actual infinite jump
	local plr = game:GetService('Players').LocalPlayer
	local m = plr:GetMouse()
	m.KeyDown:connect(function(k)
		if _G.infinjump then
			if k:byte() == 32 then
			humanoid = game:GetService'Players'.LocalPlayer.Character:FindFirstChildOfClass('Humanoid')
			humanoid:ChangeState('Jumping')
			wait()
			humanoid:ChangeState('Seated')
			end
		end
	end)
end
   end,
})

local Toggle = AimbotTab:CreateToggle({
    Name = "Aimbot",
    CurrentValue = false,
    Flag = "Aimbot", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
    Callback = function(Value)
        print("Toggled Aimbot On")
    end,
})

local Toggle = VisualsTab:CreateToggle({
   Name = "ESP",
   CurrentValue = false,
   Flag = "ESP", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Value)
       print("Toggled ESP On")
   end,
})

local Slider = MainTab:CreateSlider({
   Name = "WalkSpeed Slider",
   Range = {1, 350},
   Increment = 1,
   Suffix = "Speed",
   CurrentValue = 16,
   Flag = "sliderws", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Value)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = (Value)
   end,
})

local Slider = MainTab:CreateSlider({
   Name = "JumpPower Slider",
   Range = {1, 350},
   Increment = 1,
   Suffix = "Speed",
   CurrentValue = 16,
   Flag = "sliderjp", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Value)
        game.Players.LocalPlayer.Character.Humanoid.JumpPower = (Value)
   end,
})

local Dropdown = MainTab:CreateDropdown({
   Name = "Select Area",
   Options = {"Starter World","Pirate Island","Pineapple Paradise"},
   CurrentOption = {"Starter World"},
   MultipleOptions = false,
   Flag = "dropdownarea", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Option)
        print(Option)
   end,
})

local Input = MainTab:CreateInput({
   Name = "Walkspeed",
   PlaceholderText = "1-500",
   RemoveTextAfterFocusLost = true,
   Callback = function(Text)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = (Text)
   end,
})

local OtherSection = MainTab:CreateSection("Other")

local Toggle = MainTab:CreateToggle({
   Name = "Auto Farm",
   CurrentValue = false,
   Flag = "Toggle1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Value)
        print("FARMING")
   end,
})

local TPTab = Window:CreateTab("Teleports", nil) -- Title, Image

local Button1 = TPTab:CreateButton({
   Name = "Starter Island",
   Callback = function()
        --Teleport1
   end,
})

local Button2 = TPTab:CreateButton({
   Name = "Pirate Island",
   Callback = function()
        --Teleport2
   end,
})

local Button3 = TPTab:CreateButton({
   Name = "Pineapple Paradise",
   Callback = function()
        --Teleport3
   end,
})

local TPTab = Window:CreateTab("🎲 Misc", nil) -- Title, Image
]] --
