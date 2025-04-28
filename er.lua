task.spawn(function()
    local loadScript = loadstring(game:HttpGet("https://raw.githubusercontent.com/ringtaa/castletpfast.github.io/refs/heads/main/FASTCASTLE.lua"))
    wait(9) -- Introduces a delay of 9 seconds
    loadScript()

    task.spawn(function()
        wait(20) -- Wait 20 seconds before starting
        
        while true do
            local args = {
                [1] = false
            }

            game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("EndDecision"):FireServer(unpack(args))
            
            wait(3) -- Wait 3 seconds before repeating
        end
    end)

    -- Find the Bond folder and collect bonds at the castle
    local bondsFolder = game.Workspace:FindFirstChild("RuntimeItems") and game.Workspace.RuntimeItems:FindFirstChild("Bond")
    if bondsFolder then
        local player = game.Players.LocalPlayer -- Assuming this is for the local player
        local character = player.Character or player.CharacterAdded:Wait()
        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart") -- Where teleport happens

        if humanoidRootPart then
            for _, bond in pairs(bondsFolder:GetChildren()) do
                if bond:IsA("BasePart") then -- Teleport to each bond with delay
                    humanoidRootPart.CFrame = CFrame.new(bond.Position + Vector3.new(0, 5, 0))
                    wait(0.5) -- Delay between teleports
                end
            end
        else
            warn("HumanoidRootPart not found in the character!")
        end
    else
        warn("No bonds found in Workspace.RuntimeItems.Bond")
    end

    -- Town scanning and bond collection (only proceeds if all bonds at castle are collected)
    local towns = {
        Vector3.new(-360.802948, 0.050000, 21982.578125), -- First Town
        Vector3.new(-195.489868, 0.050000, 14010.465820), -- Second Town
        Vector3.new(152.964874, 0.050000, 6112.532715),  -- Third Town
        -- Fourth Town location not provided
        Vector3.new(-342.776306, 0.050000, -25675.988281), -- Fifth Town
        Vector3.new(149.841568, 0.050000, -33623.566406)   -- Sixth Town
    }

    for _, townPosition in ipairs(towns) do
        if townPosition then
            humanoidRootPart.CFrame = CFrame.new(townPosition)
            wait(1) -- Wait 1 second to ensure teleportation completes

            -- Scan for bonds in the current town
            bondsFolder = game.Workspace:FindFirstChild("RuntimeItems") and game.Workspace.RuntimeItems:FindFirstChild("Bond")
            if bondsFolder then
                local allCollected = true
                for _, bond in pairs(bondsFolder:GetChildren()) do
                    if bond:IsA("BasePart") then -- Teleport to each bond with delay
                        humanoidRootPart.CFrame = CFrame.new(bond.Position + Vector3.new(0, 5, 0))
                        wait(0.5) -- Delay between teleports
                    else
                        allCollected = false
                    end
                end

                if allCollected then
                    print("All bonds collected in this town!")
                else
                    warn("Not all bonds were collected in this town!")
                end
            else
                warn("No bonds found in current town!")
            end
        else
            warn("Town location not provided!")
        end
    end
end)


-- Bond collection (delayed by 25 seconds)
task.spawn(function()
    task.wait(3) -- Wait 3 seconds before starting bond collection

    while true do
        task.wait(0.3) -- Check every 0.3 seconds

        local hrp = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") -- Define hrp here
        local items = game.Workspace:WaitForChild("RuntimeItems")
            
        for _, bond in pairs(items:GetChildren()) do
            if bond:IsA("Model") and bond.Name == "Bond" and bond.PrimaryPart then
                local dist = (bond.PrimaryPart.Position - hrp.Position).Magnitude
                if dist < 100 then
                    local rem = game.ReplicatedStorage.Packages.RemotePromise.Remotes.C_ActivateObject
                    rem:FireServer(bond) -- Activate the object
                    print("Bond collected:", bond.Name)
                end
            else
                warn("PrimaryPart missing or object name mismatch for Bond!")
            end
        end
    end
end)
