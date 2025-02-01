local npc = script.Parent
local humanoid = npc:FindFirstChildOfClass("Humanoid")
local animator = humanoid:FindFirstChildOfClass("Animator")
local idleAnimation = Instance.new("Animation")
local walkAnimation = Instance.new("Animation")

idleAnimation.AnimationId = "rbxassetid://86009867840635"
walkAnimation.AnimationId = "rbxassetid://79993454165762"

local idleTrack = animator:LoadAnimation(idleAnimation)
idleTrack.Looped = true
local walkTrack = animator:LoadAnimation(walkAnimation)
walkTrack.Looped = true

local waypoints = {Vector3.new(0,0,0), Vector3.new(10,0,0), Vector3.new(10,0,10), Vector3.new(0,0,10)}
local currentWaypoint = 1
local chaseRange = 10

function moveToNextWaypoint()
	local target = waypoints[currentWaypoint]
	humanoid:MoveTo(target)
	walkTrack:Play()
	humanoid.MoveToFinished:Wait()
	walkTrack:Stop()
	idleTrack:Play()

	currentWaypoint = currentWaypoint % #waypoints + 1
	wait(2)
	moveToNextWaypoint()
end

function findPlayer()
	while true do
		wait(0.5)
		local players = game.Players:GetPlayers()
		for _, player in pairs(players) do
			if player.Character then
				local char = player.Character
				local root = char:FindFirstChild("HumanoidRootPart")
				local npcRoot = npc:FindFirstChild("HumanoidRootPart")
				if root and npcRoot then
					local distance = (npcRoot.Position - root.Position).magnitude
					if distance <= chaseRange then
						chasePlayer(root, player)
					end
				end
			end
		end
	end
end

function chasePlayer(target, player)
	while (npc.HumanoidRootPart.Position - target.Position).magnitude <= chaseRange do
		humanoid:MoveTo(target.Position)
		walkTrack:Play()
		humanoid.MoveToFinished:Wait()
		if (npc.HumanoidRootPart.Position - target.Position).magnitude <= 2 then
			damagePlayer(player)
		end
	end
	walkTrack:Stop()
	idleTrack:Play()
end

function damagePlayer(player)
	local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
	if humanoid then
		humanoid.Health = humanoid.Health - 1
	end
end

idleTrack:Play()
spawn(findPlayer)
moveToNextWaypoint()
