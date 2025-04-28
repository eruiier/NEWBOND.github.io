task.spawn(function()
    local loadScript = loadstring(game:HttpGet("https://raw.githubusercontent.com/ringtaa/castletpfast.github.io/refs/heads/main/FASTCASTLE.lua"))
    wait(9) -- Introduces a delay of 9 seconds
    loadScript()

    -- Find the Bond folder
    local bondsFolder = game.Workspace:FindFirstChild("RuntimeItems") and game.Workspace.RuntimeItems:FindFirstChild("Bond")
    if bondsFolder then
        local player = game.Players.LocalPlayer -- Assuming this is for the local player
        local character = player.Character or player.CharacterAdded:Wait()
        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart") -- Where teleport happens

        if humanoidRootPart then
            for _, bond in pairs(bondsFolder:GetChildren()) do
                if bond:IsA("BasePart") then -- Teleport to each bond with delay
                    humanoidRootPart.CFrame = bond.CFrame
                    wait(0.6) -- Delay between teleports
                end
            end
        else
            warn("HumanoidRootPart not found in the character!")
        end
    else
        warn("No bonds found in Workspace.RuntimeItems.Bond")
    end
end)
