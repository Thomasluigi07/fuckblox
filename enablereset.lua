function onChatted(msg, speaker)
    
    source = string.lower(speaker.Name)
    msg = string.lower(msg)
    -- Note: This one is NOT caps sensitive

    if msg == "!!!reset" or msg == ";ec" then
       speaker.Character.Humanoid.Health = 0
        local funnysound = Instance.new("Sound")
        funnysound.Volume = 1
        funnysound.Parent = speaker.Character.Head
        funnysound.SoundId = "rbxasset://sounds/19_dollar_fortnite_card.mp3"
        funnysound:play()
    end
end

function onPlayerEntered(newPlayer)
        newPlayer.Chatted:connect(function(msg) onChatted(msg, newPlayer) end) 
end
 
game.Players.ChildAdded:connect(onPlayerEntered)