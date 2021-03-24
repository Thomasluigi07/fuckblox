local server = "putip"; local serverport = 53640; local playerName = "Thomas"; local id = 1

function onDisconnection(peer, lostConnection)
	if lostConnection then
		game:SetMessage("You have lost the connection to the game", "LostConnection", "LostConnection")
	else
		game:SetMessage("This game has shut down", "Kick", "Kick")
	end
end

function failed(peer, errcode, why)
	game:SetMessage("Failed to connect to the Game.")
end

function rejected()
	game:SetMessage("Connection rejected by the server.")
end

idled = false
function onPlayerIdled(time)
	if time > 5*60 then
		game:SetMessage(string.format("You were disconnected for being idle %d minutes", time/60), "Idle", "Idle")
		client:Disconnect()
		if not idled then
			idled = true
		end
	end
end



local suc, err = pcall(function()

	game:SetMessage("Connecting to Server")

	client = Instance.new("NetworkClient", game)
	player = game.Players:createLocalPlayer(0)

	player.Name = playerName
	player.userId = id

	client.ConnectionAccepted:connect(function(ip,replicator)
		replicator:SendMarker().Received:connect(function()
			game:ClearMessage()
			while game:service("RunService").Stepped:wait() do
				replicator:SendMarker()
			end
		end)
	
		replicator.Disconnection:connect(onDisconnection)
		
	end)
end)


if not suc then
	game:SetMessage(err)
end

function connected(url, replicator)
	local suc, err = pcall(function()
		game:SetMessageBrickCount()
		local marker = replicator:SendMarker()
	end)
	
	if not suc then
		game:SetMessage(err)
	end
	
	marker.Recieved:wait()
	
	local suc, err = pcall(function()
		game:ClearMessage()
	end)
	
	if not suc then
		game:SetMessage(err)
	end
end

local suc, err = pcall(function()
	client.ConnectionAccepted:connect(connected)
	client.ConnectionRejected:connect(rejected)
	client.ConnectionFailed:connect(failed)
	client:connect(server, serverport, 0, 20)
end)

if not suc then
	local x = Instance.new("Message")
	x.Text = err
	x.Parent = workspace
	wait(math.huge)
end

while true do
	wait(0.001)
	replicator:SendMarker()
end