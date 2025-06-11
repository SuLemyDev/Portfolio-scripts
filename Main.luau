local ragdoll = require(game.ServerScriptService.Ragdoll)
local cd = false
local canpunch = false
local Debris = game:GetService("Debris")



game.ReplicatedStorage.Power.OnServerEvent:Connect(function(plr, module, mode, pearlLong)
	local Settings = require(module)
	if Settings["Abilities"] then
		local abs = Settings["Abilities"]
		if abs["GOKU"] then
			local goky = abs["GOKU"]
			local Time = goky["Time"]
			local char = plr.Character
			local touchPlayers = {}
			local hrp = char:FindFirstChild("HumanoidRootPart")
			local hitbox = require(game.ReplicatedStorage.HitboxModule)
			local hb = hitbox.Create(Vector3.new(20,20,40),CFrame.new(hrp.Position + hrp.CFrame.LookVector * 20),nil,"pos",hrp.Orientation)
			
			hb.Touched:Connect(function(hit)
				if hit.Parent and hit.Parent:FindFirstChild("Humanoid") and hit.Parent.Name ~= plr.Name and not table.find(touchPlayers, hit.Parent.Name) then
					table.insert(touchPlayers, hit.Parent.Name)
					local uiclone = game.ReplicatedStorage.ToolsForAbilities.Goku.GOKU:Clone()
					Debris:AddItem(uiclone, Time)
					local echar = hit.Parent
					local eplr = game.Players:GetPlayerFromCharacter(hit.Parent)
					
					if eplr then
						uiclone.Parent = eplr.PlayerGui
					end
					
					local sound = game.ReplicatedStorage.ToolsForAbilities.Goku.AKH:Clone()
					sound.Parent = echar.HumanoidRootPart
					sound:Play()
					
					ragdoll.Start(echar)
					
					local att = Instance.new("Attachment", echar:FindFirstChild("HumanoidRootPart"))
					local velocity = Instance.new("LinearVelocity")
					velocity.MaxForce = math.huge
					velocity.VelocityConstraintMode = Enum.VelocityConstraintMode.Line
					velocity.LineDirection = (hrp.CFrame.LookVector + Vector3.new(0,1.5,0))
					velocity.LineVelocity = 50
					velocity.Attachment0 = att
					velocity.Parent = echar:FindFirstChild("HumanoidRootPart")
					game.Debris:AddItem(velocity,0.2)
					task.wait(1.5)
					ragdoll.Stop(echar)
					game:GetService("Debris"):AddItem(sound, 5.001)
				end
			end)
			
			
			
		elseif abs["RUN"] then
			local locscritp = script.Transformers.Camera:Clone()
			local Tool = plr.Character:FindFirstChild("RUNNER!") or plr.Backpack:FindFirstChild("RUNNER!")
			local animtrack = plr.Character:FindFirstChild("Humanoid"):LoadAnimation(Tool["RUN!!!"])
			local soundp = Tool:FindFirstChild("LocalScript"):FindFirstChild("Sound")
			local runSFX = Tool:FindFirstChild("Handle"):FindFirstChild("Runing")
			local LineForce = Instance.new("LinearVelocity",plr.Character:FindFirstChild("HumanoidRootPart"))
			local vfx = game.ReplicatedStorage.VFX.Runner.Runer
			local start = vfx.Start:Clone()
			local idle = vfx.Idle:Clone()
			local End = vfx.End:Clone()
			local wind = vfx.Wind:Clone()
			local wind2 = vfx.Wind2:Clone()
			LineForce.VelocityConstraintMode = Enum.VelocityConstraintMode.Line
			LineForce.RelativeTo = Enum.ActuatorRelativeTo.Attachment0
			LineForce.Attachment0 = plr.Character:FindFirstChild("HumanoidRootPart").RootAttachment
			plr.Character:FindFirstChild("HumanoidRootPart").RootAttachment.CFrame = plr.Character:FindFirstChild("HumanoidRootPart").RootAttachment.CFrame * CFrame.Angles(0,math.rad(90),0)
			start.Parent = plr.Character:FindFirstChild("HumanoidRootPart")
			idle.Parent = plr.Character:FindFirstChild("HumanoidRootPart")
			End.Parent = plr.Character:FindFirstChild("HumanoidRootPart")
			
			
			animtrack:GetMarkerReachedSignal("Start"):Connect(function()
				for i,v in ipairs(start:GetDescendants()) do
					if v:IsA("ParticleEmitter") then
						v:Emit(v:GetAttribute("EmitCount"))
					end
				end
			end)
			animtrack:GetMarkerReachedSignal("Idle"):Connect(function()
				wind.Parent = plr.Character:FindFirstChild("HumanoidRootPart")
				wind2.Parent = plr.Character:FindFirstChild("HumanoidRootPart")
				runSFX:Play()
				for i,v in ipairs(idle:GetDescendants()) do
					if v:IsA("ParticleEmitter") then
						v.Enabled = true
					end
				end
			end)
			
			animtrack:GetMarkerReachedSignal("End"):Connect(function()
				runSFX:Stop()
				for i,v in ipairs(End:GetDescendants()) do
					if v:IsA("ParticleEmitter") then
						v:Emit(v:GetAttribute("EmitCount"))
					end
				end
			end)
			
			local val = Instance.new("IntValue", plr.Character)
			val.Name = "Ragdoll"
			local num = 100
			LineForce.MaxForce = 100000
			soundp.Parent = plr.Character:FindFirstChild("HumanoidRootPart")
			soundp:Play()
			plr.Character:FindFirstChild("HumanoidRootPart").Anchored = true
			animtrack:Play()
			LineForce.Parent = plr.Character:FindFirstChild("HumanoidRootPart")
			task.wait(0.84)
			plr.Character:FindFirstChild("HumanoidRootPart").Anchored = false
			plr.Character.Humanoid.JumpPower = 0
			LineForce.LineVelocity = 300
			soundp.Parent = Tool:FindFirstChild("LocalScript")
			locscritp.Parent = plr.Character
			task.wait(0.18)
			
			for i = 4, 0, -0.016 do
				if i > 2 then
					LineForce.LineVelocity =  100
					plr.Character.Humanoid.WalkSpeed = 0
					plr.Character.Humanoid.JumpPower = 50
				elseif i <= 1.5 then
					if num <= 75 then
						wind:Destroy()
						wind2:Destroy()
						for i,v in ipairs(idle:GetDescendants()) do
							if v:IsA("ParticleEmitter") then
								v.Enabled = false
							end
						end
					end
					num -= 1.1
					LineForce.LineVelocity =  num
				end

				tostring(i)
				task.wait(0.016)
			end
			val:Destroy()
			plr.Character:FindFirstChild("HumanoidRootPart").RootAttachment.CFrame = plr.Character:FindFirstChild("HumanoidRootPart").RootAttachment.CFrame * CFrame.Angles(0,math.rad(-90),0)
			start:Destroy()
			idle:Destroy()
			locscritp:Destroy()
			LineForce:Destroy()
			plr.Character.Humanoid.WalkSpeed = 16
			plr.Character.Humanoid.JumpPower = 50
			task.wait(2)
			End:Destroy()
		elseif abs["Vanishing"] then

			local sound = script.Vanishing.Sound:Clone()
			local vanim = script.Vanishing.Animation
			local animtr = plr.Character:FindFirstChild("Humanoid"):LoadAnimation(vanim)
			local AVFX = script.Vanishing.VFX.AVFX:Clone()
			local tab = workspace.Spawns:GetChildren()
			local val = Instance.new("IntValue", plr.Character)
			val.Name = "Ragdoll"
			sound.Parent = plr.Character:FindFirstChild("HumanoidRootPart")
			animtr:Play()
			sound:Play()
			AVFX.Parent = plr.Character:FindFirstChild("HumanoidRootPart")
			plr.Character:FindFirstChild("HumanoidRootPart").Anchored = true
			task.wait(1)

			for i, part in plr.Character:GetDescendants() do
				if part:IsA("BasePart") then
					game:GetService("TweenService"):Create(part, TweenInfo.new(1), {Transparency = 1}):Play()

				end
				if part:IsA("MeshPart") or part:IsA("UnionOperation") then
					game:GetService("TweenService"):Create(part, TweenInfo.new(1), {Transparency = 1}):Play()

				end
			end

			plr.Character.Head.face.Transparency = 1
			if plr.Character:FindFirstChildOfClass("Tool") then

				plr.Character:FindFirstChildOfClass("Tool").Handle.Transparency = 1
			elseif plr.Backpack:FindFirstChildOfClass("Tool") then
				plr.Backpack:FindFirstChildOfClass("Tool").Handle.Transparency = 1

			end
			task.wait(1.5)
			AVFX.ParticleEmitter.Enabled = false

			wait(abs["Vanishing"]["Time"])
			plr.Character:FindFirstChild("HumanoidRootPart").CFrame = tab[math.random(1, #tab)].CFrame
			plr.Character:FindFirstChild("HumanoidRootPart").Anchored = false
			val:Destroy()
			sound:Destroy()
			for i, part in plr.Character:GetChildren() do
				if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
					game:GetService("TweenService"):Create(part, TweenInfo.new(0), {Transparency = 0}):Play()

				end
			end
			plr.Character.Head.face.Transparency = 0
			if plr.Character:FindFirstChildOfClass("Tool") then

				plr.Character:FindFirstChildOfClass("Tool").Handle.Transparency = 0
				plr.Character:FindFirstChildOfClass("Tool").Glove.Transparency = 0
			elseif plr.Backpack:FindFirstChildOfClass("Tool") then
				plr.Backpack:FindFirstChildOfClass("Tool").Handle.Transparency = 0

			end
			AVFX:Destroy()
		elseif abs["CaveDiver"] then
			local tool = plr.Character:FindFirstChild("CaveDiver")
			tool.Handle.Slam:Play()
			local parts = game.ReplicatedStorage.Blocks.Cave:Clone()
			local animIn = parts.In
			local animOut = parts.Out
			local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
			local hum = plr.Character:FindFirstChild("Humanoid")
			plr.Character:FindFirstChild("CaveDiver"):FindFirstChild("Glove"):FindFirstChild("Sound"):Play()
			hum.AutoRotate = false
			local head = plr.Character:FindFirstChild("Head")
			local torso = plr.Character:FindFirstChild("Torso")
			local bodyV = Instance.new("BodyVelocity")
			local val = Instance.new("IntValue", plr.Character)
			--Idle
			local a = game.ReplicatedStorage:FindFirstChild("VFX"):FindFirstChild("CaveDiver"):Clone()
			local hitted = false
			local ragdoll = require(game.ServerScriptService.Ragdoll)
			local sound = Instance.new("Sound")
			sound.SoundId = "rbxassetid://112977535537816"
			sound.RollOffMaxDistance = 500
			local weld = Instance.new("WeldConstraint")
			weld.Parent = plr.Character
			weld.Part0 = hrp
			weld.Part1 = a
			a.CFrame = hrp.CFrame * CFrame.new(0,-2.8,0)
			a.Anchored = false
			a.Parent = hrp
			--VFX Enter
			for i,v in ipairs(a.Enter:GetChildren()) do
				if v:IsA("ParticleEmitter") then
					v:Emit(v:GetAttribute("EmitCount"))
					task.wait(0.001)
				end
			end
			val.Name = "Ragdoll"
			hum:FindFirstChild("Animator"):LoadAnimation(animIn):Play()
			hum.WalkSpeed = 0
			hum.JumpPower = 0
			parts.Position = hrp.Position + hrp.CFrame.LookVector * 5 + Vector3.new(0,-2.8,0)
			parts.Orientation = Vector3.new(0,hrp.Orientation.Y,90)
			parts.Parent = workspace
			hrp.Anchored = true


			task.wait(1.5)
			for i,v in ipairs(plr.Character:GetDescendants()) do
				if v:IsA("BasePart") then
					v.Transparency = 1
					head:FindFirstChild("face").Transparency = 1
				end
			end
			task.wait(0.5)
			hum.AutoRotate = true
			hrp.Anchored = false
			task.wait(0.3)

			--VFX Idle
			for i,v in ipairs(a.Idle:GetChildren()) do
				if v:IsA("ParticleEmitter") then
					v.Enabled = true
				end
			end


			bodyV.P = 999999999
			bodyV.MaxForce = Vector3.new(8,8,8) * math.huge
			bodyV.Parent = hrp
			for i = 3.5, 0, -0.016 do
				bodyV.Velocity = hrp.CFrame.LookVector*35
				head.CanCollide = false
				torso.CanCollide = false
				hrp.Touched:Connect(function(hit)
					if hit.Parent and hit.Parent:FindFirstChild("Humanoid") and hitted == false then
						hitted = true
						local echar = hit.Parent
						local ehrp = hit.Parent:FindFirstChild("HumanoidRootPart")
						local eplr = game.Players:GetPlayerFromCharacter(hit.Parent)
						local ehum = hit.Parent:FindFirstChild("Humanoid")
						sound.Parent = ehrp
						sound:Play()
						hrp.Anchored = true
						head.CanCollide = true
						torso.CanCollide = true
						bodyV:Destroy()
						hum.WalkSpeed = 16
						hum.JumpPower = 50
						hum:LoadAnimation(animOut):Play()
						task.wait(0.01)
						for i,v in ipairs(plr.Character:GetDescendants()) do
							if v:IsA("BasePart") then
								v.Transparency = 0
								head:FindFirstChild("face").Transparency = 0
								hrp.Transparency = 1
							end
						end
						--Idle enabled false
						for i,v in ipairs(a.Idle:GetChildren()) do
							if v:IsA("ParticleEmitter") then
								v.Enabled = false
							end
						end

						--Attack VFX
						for i,v in ipairs(a.Attack:GetChildren()) do
							if v:IsA("ParticleEmitter") then
								v:Emit(v:GetAttribute("EmitCount"))
							end
						end


						if eplr then
							ragdoll.Start(echar, eplr)
						else
							ragdoll.Start(echar)
						end
						ehum.Health -= 15
						local bodyforce = Instance.new("BodyVelocity", ehrp)
						bodyforce.MaxForce = Vector3.new(8,8,8) * math.huge
						bodyforce.Velocity = Vector3.new(0,60,0)
						local bodyrot = Instance.new("BodyAngularVelocity", ehrp)
						bodyrot.MaxTorque = Vector3.new(8,8,8) * math.huge
						bodyrot.P = 10000
						bodyrot.AngularVelocity = Vector3.new(10,10,10)
						game:GetService("Debris"):AddItem(bodyrot, 0.2)
						game:GetService("Debris"):AddItem(bodyforce, 0.2)
						task.wait(2.3)
						parts:Destroy()
						hrp.Anchored = false
						val:Destroy()
						a:Destroy()
						weld:Destroy()
						sound:Destroy()
						if eplr then
							ragdoll.Stop(echar, eplr)
						else
							ragdoll.Stop(echar)
						end
					end
					task.wait(0.1)
				end)
				task.wait(0.016)
			end
			if hitted == false then
				hitted = true
				hrp.Anchored = true
				head.CanCollide = true
				torso.CanCollide = true
				bodyV:Destroy()
				hum.WalkSpeed = 16
				hum.JumpPower = 50
				hum:LoadAnimation(animOut):Play()
				task.wait(0.01)
				for i,v in ipairs(plr.Character:GetDescendants()) do
					if v:IsA("BasePart") then
						v.Transparency = 0
						head:FindFirstChild("face").Transparency = 0
						hrp.Transparency = 1
					end
				end


				-- Idle false 2
				for i,v in ipairs(a.Idle:GetChildren()) do
					if v:IsA("ParticleEmitter") then
						v.Enabled = false
					end
				end


				task.wait(2.3)
				parts:Destroy()
				hrp.Anchored = false
				val:Destroy()
				a:Destroy()
				weld:Destroy()
				sound:Destroy()
			end

		elseif abs["Steve"] then
			local vfx = game.ReplicatedStorage.VFX:FindFirstChild("Steve"):Clone()
			local value = Instance.new("IntValue", plr.Character)
			value.Name = "Freezed"
			vfx.Parent = plr.Character
			local weldc = Instance.new("WeldConstraint")
			weldc.Parent = plr.Character
			weldc.Part0 = plr.Character:FindFirstChild("HumanoidRootPart")
			weldc.Part1 = vfx
			vfx.Position = plr.Character:FindFirstChild("HumanoidRootPart").Position + Vector3.new(0,-3.5,0)
			task.wait(14.9)
			value:Destroy()
			vfx:Destroy()
			weldc:Destroy()
		elseif abs["GUN"] then

			local model =  game.ReplicatedStorage.ToolsForAbilities.Minigun:Clone()
			local SitSound = game.ReplicatedStorage:FindFirstChild("ToolsForAbilities"):FindFirstChild("Sounds"):FindFirstChild("Minigun"):FindFirstChild("SitSound"):Clone()
			local SeakSound = game.ReplicatedStorage:FindFirstChild("ToolsForAbilities"):FindFirstChild("Sounds"):FindFirstChild("Minigun"):FindFirstChild("SeakSound"):Clone()
			local Founded = game.ReplicatedStorage:FindFirstChild("ToolsForAbilities"):FindFirstChild("Sounds"):FindFirstChild("Minigun"):FindFirstChild("Founded"):Clone()
			local SeakEnd = game.ReplicatedStorage:FindFirstChild("ToolsForAbilities"):FindFirstChild("Sounds"):FindFirstChild("Minigun"):FindFirstChild("SeakingEnd"):Clone()
			local Hold = plr.Character:FindFirstChild("Humanoid"):FindFirstChild("Animator"):LoadAnimation(model.Anims.Hold)
			local Start = plr.Character:FindFirstChild("Humanoid"):FindFirstChild("Animator"):LoadAnimation(model.Anims.Start)
			local Shot = plr.Character:FindFirstChild("Humanoid"):FindFirstChild("Animator"):LoadAnimation(model.Anims.Shot)

			local duration = 0.07
			local all = 0
			local t = 0
			local function calcul(p0,p1,t)
				return Vector3.new(
					p0.X + t * (p1.X - p0.X),
					p0.Y + t * (p1.Y - p0.Y),
					p0.Z + t * (p1.Z - p0.Z)
				)
			end

			Start:Play()
			SitSound.Parent = plr.Character
			SeakSound.Parent = plr.Character
			Founded.Parent = plr.Character
			SeakEnd.Parent = plr.Character
			SitSound:Play()
			plr.Character:FindFirstChild("HumanoidRootPart").Anchored = true
			plr.Character:FindFirstChild("Humanoid").WalkSpeed, plr.Character:FindFirstChild("Humanoid").JumpPower = 0,0
			plr.Character:FindFirstChild("Humanoid").AutoRotate = false
			task.wait(0.167)
			SitSound:Destroy()
			SeakSound:Play()
			task.wait(0.815)
			SeakSound:Destroy()
			Founded:Play()
			task.wait(0.452)
			Founded:Destroy()
			SeakEnd:Play()
			local weld = Instance.new("Weld")
			weld.Parent = model.Stick
			weld.Part0 = plr.Character:FindFirstChild("Right Arm")
			weld.Part1 = model.Stick
			weld.C1 = CFrame.Angles(math.rad(-30),math.rad(-50),math.rad(75)) * plr.Character:FindFirstChild("Right Arm").RightShoulderAttachment.CFrame
			model.Parent = plr.Character
			task.wait(0.5)
			Shot:Play()
			SeakEnd:Destroy()
			plr.Character:FindFirstChild("HumanoidRootPart").Anchored = false
			plr.Character:FindFirstChild("Humanoid").AutoRotate = true
			local value = Instance.new("StringValue", plr.Character)
			value.Name = "Ragdoll"
			local vfx = game.ReplicatedStorage.VFX:FindFirstChild("Ava"):Clone()
			local sound = vfx["Pistol Shoot"]
			local cicle = 0
			while task.wait(0.05) do
				cicle += 0.05
				sound:Play()
				while t <= 1 do
					local P0 = model:FindFirstChild("YeahDad").CFrame
					local P1 = plr.Character:FindFirstChild("HumanoidRootPart").Position + plr.Character:FindFirstChild("HumanoidRootPart").CFrame.LookVector * 50
					vfx.Parent = workspace
					local Bezier = calcul(P0, P1, t)
					vfx.Position = Bezier
					t+= task.wait(0.005) / duration
					--print(t)
					local reg3 = Region3.new(vfx.Position-vfx.Size,vfx.Position+vfx.Size)
					local GettingParts = workspace:FindPartsInRegion3(reg3, nil, math.huge)
					for i,v in ipairs(GettingParts) do
						if v.Parent and v.Parent:FindFirstChild("Humanoid") and v.Parent.Name ~= plr.Name and v.Parent:FindFirstChild("Humanoid").Health > 0 then
							v.Parent:FindFirstChild("Humanoid").Health -= 1
						end
					end

				end
				if cicle >= 2 then
					vfx:Destroy()
					plr.Character:FindFirstChild("Humanoid").WalkSpeed, plr.Character:FindFirstChild("Humanoid").JumpPower = 16,50
					Shot:Stop()
					model:Destroy()
					value:Destroy()
					plr.Character:FindFirstChild("Humanoid").AutoRotate = true
					break
				end
				if t >= 1 then
					t = 0
				end
			end

		elseif abs["CallMe"] then
			if plr.Character:FindFirstChild("Humanoid").Health > 0 then
				local model = game.ReplicatedStorage.ToolsForAbilities:FindFirstChild("CallMeHand"):Clone()
				local anim = model:FindFirstChild("Anims"):FindFirstChild("Hum")
				local animtrack = plr.Character:FindFirstChild("Humanoid"):LoadAnimation(anim)
				local eSound = game.ReplicatedStorage:FindFirstChild("ToolsForAbilities"):FindFirstChild("Sounds"):FindFirstChild("CallMeHand"):FindFirstChild("Explosion"):Clone()
				local memeSound = game.ReplicatedStorage:FindFirstChild("ToolsForAbilities"):FindFirstChild("Sounds"):FindFirstChild("CallMeHand"):FindFirstChild("Meme"):Clone()
				local deb = false
				local ragdoll = require(game.ServerScriptService.Ragdoll)
				local value = Instance.new("StringValue", plr.Character)
				value.Name = "Ragdoll"
				memeSound.Parent = plr.Character
				memeSound:Play()
				plr.Character:FindFirstChild("HumanoidRootPart").Anchored = true
				plr.Character:FindFirstChild("Humanoid").AutoRotate = false
				animtrack:Play()
				task.wait(2.43)
				local weldconst = Instance.new("WeldConstraint")
				weldconst.Part0 = plr.Character:FindFirstChild("Right Arm")
				weldconst.Part1 = model.Palm
				weldconst.Parent = model.Palm
				model.Palm.CFrame = plr.Character:FindFirstChild("Right Arm").RightGripAttachment.WorldCFrame * CFrame.Angles(0,math.rad(180),math.rad(180))
				model.Parent = plr.Character
				for i,enemy in ipairs(game.Players:GetPlayers()) do
					if enemy.Name ~= plr.Name then
						local pos1 = enemy.Character:FindFirstChild("HumanoidRootPart").Position
						local pos2 = plr.Character:FindFirstChild("HumanoidRootPart").Position
						local dist = (pos2 - pos1).Magnitude
						if dist <= 35 then
							local explore = Instance.new("Explosion")
							explore.Parent = enemy.Character
							explore.Position = pos1
							explore.BlastRadius = 2
							explore.Visible = true
							explore.DestroyJointRadiusPercent = 0
							explore.Hit:Connect(function(hit)
								if hit.Parent and hit.Parent:FindFirstChild("Humanoid") and hit.Parent.Name ~= plr.Name and deb == false then
									deb = true
									local eplr = game.Players:GetPlayerFromCharacter(hit.Parent)
									local echar = hit.Parent
									local ehrp = echar:FindFirstChild("HumanoidRootPart")
									if eplr then
										ragdoll.Start(echar, eplr)
									else
										ragdoll.Start(echar)
									end
									local direct = (ehrp.CFrame.Position - plr.Character:FindFirstChild("HumanoidRootPart").CFrame.Position).Unit
									local force = Instance.new("BodyVelocity", ehrp)
									force.MaxForce = Vector3.new(8,8,8) * math.huge
									force.Velocity = (direct + Vector3.new(0,3,0)).Unit * 50 + plr.Character:FindFirstChild("HumanoidRootPart").CFrame.lookVector * 25
									game:GetService("Debris"):AddItem(force, 0.2)
									eSound.Parent = hit.Parent:FindFirstChild("Torso")
									eSound:Play()
									hit.Parent:FindFirstChild("Humanoid"):TakeDamage(30)
									task.wait(1.5)
									if eplr then
										ragdoll.Stop(echar, eplr)
									else
										ragdoll.Stop(echar)
									end
								end
							end)
						end
					end
				end

				task.wait(1.05)
				weldconst:Destroy()
				value:Destroy()
				model:Destroy()
				plr.Character:FindFirstChild("HumanoidRootPart").Anchored = false
				plr.Character:FindFirstChild("Humanoid").AutoRotate = true
				task.wait(0.5)
				memeSound:Destroy()
			end
		elseif abs["Washing"] then
			local ragdoll = require(game.ServerScriptService.Ragdoll)
			local model = game.ServerStorage.Models.WashingMashine:Clone()
			model.Parent = workspace
			local primary =  model.HumanoidRootPart
			primary.CFrame = plr.Character:FindFirstChild("HumanoidRootPart").CFrame
			model:FindFirstChild("PlaceWashing"):Play()
			for i,v in pairs(primary.Explosion:GetDescendants()) do
				if v:IsA("ParticleEmitter") then
					task.wait(0.000001)
					v:Emit(1)
				end
			end
			local hitbox = Instance.new("Part", workspace)
			hitbox.Transparency = 1
			hitbox.Size = Vector3.new(30,30,30)
			hitbox.CanCollide = false
			hitbox.Anchored = true
			hitbox.CFrame = primary.CFrame
			hitbox.Name = "WashingHitbox"
			local washing = false
			local notwashining = false
			task.wait(0.5)
			hitbox.Touched:Connect(function(hit)
				if hit.Parent and hit.Parent:FindFirstChild("Humanoid") and hit.Parent.Name ~= plr.Name and washing == false and not hit.Parent:FindFirstChild("Washining") and not hit.Parent:FindFirstChild("Freezed") then
					washing = true
					local WashiningProtect = Instance.new("IntValue", hit.Parent)
					WashiningProtect.Name = "Freezed"
					local eChar = hit.Parent
					local ehrp = eChar:FindFirstChild("HumanoidRootPart")
					local ePlr = game.Players:GetPlayerFromCharacter(eChar)
					hitbox:Destroy()
					for i,v in pairs(eChar:GetDescendants()) do
						if v:IsA("BasePart")then
							v.Transparency = 1
						end
					end
					model.OTDSound:Play()
					model.AnimationController.Animator:LoadAnimation(model.Animations.OpenTheDoor):Play()
					task.wait(0.45)
					ehrp.Anchored = true
					ehrp.CFrame = primary.CFrame
					model.Washining:Play()
					model.AnimationController.Animator:LoadAnimation(model.Animations.Washing):Play()
					for i,v in pairs(primary.Idle:GetDescendants()) do
						if v:IsA("ParticleEmitter") then
							task.wait(0.001)
							v.Enabled = true
						end
					end
					for i = 5, 0, -0.1 do
						eChar:FindFirstChild("Humanoid").Health -= 1
						ehrp.Anchored = true
						if not eChar or eChar:FindFirstChild("Humanoid").Health <= 15 then
							break
						end
						task.wait(0.1)
					end
					ehrp.Anchored = false
					for i,v in pairs(eChar:GetDescendants()) do
						if v:IsA("BasePart") and v.Name ~= "HumanoidRootPart" then
							v.Transparency = 0
						end
					end
					local force = Instance.new("BodyVelocity", ehrp)
					force.MaxForce = Vector3.new(8,8,8) * math.huge
					force.Velocity = (ehrp.Position-primary.Position + Vector3.new(0,1.8,0)).Unit * 50 + primary.CFrame.LookVector * 25
					game:GetService("Debris"):AddItem(force, 0.2)
					if eChar then
						ragdoll.Start(eChar)
					elseif ePlr then
						ragdoll.Start(eChar, ePlr)
					end
					model.YoureDone:Play()
					task.wait(1.3)
					WashiningProtect:Destroy()
					if eChar then
						ragdoll.Stop(eChar)
					elseif ePlr then
						ragdoll.Stop(eChar, ePlr)
					end
					model:Destroy()
					washing = false
				else
					if not plr.Character or not plr then
						if hitbox and washing == false then
							hitbox:Destroy()
							if model and washing == false then
								model:Destroy()
							end
						end
					end
					if notwashining == false and washing == false then
						notwashining = true
						task.wait(20)
						if hitbox and washing == false then
							hitbox:Destroy()
							if model and washing == false then
								model:Destroy()
							end
						end
						notwashining = false
					end
				end
			end)

		elseif abs["Skull"] then
			local skull = game.ReplicatedStorage:FindFirstChild("NPC's"):FindFirstChild("Skull"):Clone()
			local hitbox = Instance.new("Part")
			local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
			local hum = plr.Character:FindFirstChild("Humanoid")
			local skullhrp = skull.HumanoidRootPart
			local idle = skull:FindFirstChild("Skull1"):FindFirstChild("Idle")
			local start = skull:FindFirstChild("Skull1"):FindFirstChild("Start")
			local deb = false
			local hitted = false
			local ragdoll = require(game.ServerScriptService.Ragdoll)
			local hitted2 = false
			local val = 0

			-- IDLE ENABLED

			for i,v in ipairs(idle:GetChildren()) do
				if v:IsA("ParticleEmitter") then
					v.Enabled = true
				end
			end


			skull.HumanoidRootPart.Position = hrp.Position + plr.Character:FindFirstChild("HumanoidRootPart").CFrame.LookVector * 2 + Vector3.new(0,-2,0)
			skull.Parent = workspace
			hitbox.Position = hrp.Position + plr.Character:FindFirstChild("HumanoidRootPart").CFrame.LookVector
			hitbox.Size = Vector3.new(70,50,70)
			hitbox.CanCollide = false
			hitbox.Transparency = 1
			hitbox.Parent = workspace
			hitbox.Anchored = true

			hitbox.Touched:Connect(function(hit)
				if hit.Parent and hit.Parent:FindFirstChild("Humanoid") and hit.Parent.Name ~= plr.Name and deb == false then
					deb = true
					hitted = true
					hitbox:Destroy()

					-- IDLE DISABLED
					for i,v in ipairs(idle:GetChildren()) do
						if v:IsA("ParticleEmitter") then
							v.Enabled = false
						end
					end

					--START ENABLED

					for i,v in ipairs(start:GetChildren()) do
						if v:IsA("ParticleEmitter") then
							v.Enabled = true
						end
					end
					local ehrp = hit.Parent:FindFirstChild("HumanoidRootPart")
					skull.HumanoidRootPart.SkullSound:Play()
					local animtrack = skull.AnimationController.Animator:LoadAnimation(skull.Animation)
					animtrack:Play()
					for i = 9.5, 0, -0.1 do
						--i = tostring(i)
						if skull and val == 0 then
							game:GetService("TweenService"):Create(skullhrp, TweenInfo.new(1.5), {CFrame = ehrp.CFrame}):Play()
							skullhrp.Orientation = ehrp.Orientation
						elseif not skull then
							break
						end
						skullhrp.Touched:Connect(function(hit2)
							if hit2.Parent and hit2.Parent:FindFirstChild("Humanoid") and hitted2 == false and hit2.Parent.Name ~= plr.Name and skull then
								hitted2 = true
								val = 0
								local eshrp = hit2.Parent:FindFirstChild("HumanoidRootPart")
								local eshum = hit2.Parent:FindFirstChild("Humanoid")
								local esplr = game.Players:GetPlayerFromCharacter(hit2.Parent)
								local eschar = hit2.Parent
								local crunchanim = skull.AnimationController.Animator:LoadAnimation(skull.CrunchAnim)
								for i,v in ipairs(start:GetChildren()) do
									if v:IsA("ParticleEmitter") then
										v.Enabled = false
									end
								end
								crunchanim:Play()
								crunchanim:GetMarkerReachedSignal("Scale"):Connect(function()
									skullhrp.CFrame = skullhrp.CFrame * CFrame.new(0,2,0)
									animtrack:Stop()
									skull.HumanoidRootPart.SkullSound:Stop()
									for i,v in pairs(skull:GetDescendants()) do
										if v:IsA("BasePart") then
											game:GetService("TweenService"):Create(v, TweenInfo.new(0.15), {Size = v.Size * 4}):Play()
											v.Color = Color3.new(1, 0, 0.0156863)
										end
									end
								end)
								crunchanim:GetMarkerReachedSignal("Marker"):Connect(function()
									for i,v in ipairs(skull.Skull1.Attack:GetDescendants()) do
										if v:IsA("ParticleEmitter") then
											v:Emit(v:GetAttribute("EmitCount"))
										end
									end
									eshum.Health = 0
									skullhrp.CrunchSound:Play()
								end)
								crunchanim:GetMarkerReachedSignal("E ndTime"):Connect(function()
									skull:Destroy()
								end)

								
							end
						end)
						task.wait(0.1)
					end
					if skull then
						skull:Destroy()
					end
				elseif not hit.Parent:FindFirstChild("Humanoid") and deb == false then
					if hitted == false then
						task.wait(20)
						if hitbox and hitted == false then
							hitbox:Destroy()
						end
						if skull and hitted == false then
							skull:Destroy()
						end
					end
				end
			end)
		elseif abs["Minecraft"] then
			if mode == "EnderPearl" then
				local throw = require(game.ReplicatedStorage.ModuleThrow)
				local fold = game.ReplicatedStorage.ToolsForAbilities.Minecrafting
				local toolPearl = fold.Ender:Clone()
				local modelPearl = fold.PearlModel:Clone()
				local hum = plr.Character:FindFirstChild("Humanoid")
				local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
				local ModHrp = modelPearl.HumanoidRootPart
				
				local exit = 0
				
				local glove = plr.Character:FindFirstChild("Minecrafting")
				glove.Parent = plr.Backpack
				
				local deb = false
				local JumpAndSpeed = {hum.WalkSpeed, hum.JumpPower}
				
				local value = Instance.new("IntValue", plr.Character)
				value.Name = "Ragdoll"
				
				local anender = fold.AnEnderPearl:Clone()
				anender.Parent = hrp
				local teleported = fold.Teleported:Clone()
				teleported.Parent = hrp
				
				
				local anim = Instance.new("Animation")
				anim.AnimationId = "rbxassetid://125565705031206"
				local animtrack = plr.Character.Humanoid:LoadAnimation(anim)
				
				toolPearl.Parent = plr.Character
				animtrack:Play()
				plr.Character.Humanoid.WalkSpeed = 0
				plr.Character.Humanoid.JumpPower = 0
				animtrack:GetMarkerReachedSignal("Throw"):Connect(function()
					toolPearl:Destroy()
					modelPearl.HumanoidRootPart.CFrame = plr.Character:FindFirstChild("Right Arm").CFrame
					modelPearl.Parent = workspace
					throw.Throw(modelPearl.HumanoidRootPart, plr.Character, pearlLong)
					anender:Play()
					game:GetService("Debris"):AddItem(anender, 2)
					ModHrp.Touched:Connect(function(hit)
						if hit.Name == "Grass" and deb == false then
							deb = true
							hrp.CFrame = CFrame.new(ModHrp.Position.X, ModHrp.Position.Y + 2, ModHrp.Position.Z)
							teleported:Play()
							game:GetService("Debris"):AddItem(teleported, 2)
							hrp.Anchored = false
						end
					end)
				end)
				animtrack:GetMarkerReachedSignal("AnimEnd"):Connect(function()
					task.wait(0.5)
					plr.Character.Humanoid.WalkSpeed = 16
					plr.Character.Humanoid.JumpPower = 50
					value:Destroy()
				end)
				
			elseif mode == "Jump" then
				local hum = plr.Character:FindFirstChild("Humanoid")
				local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
				local vfx = game.ReplicatedStorage.VFX.Minecrafting.Wind.Att.a1:Clone()
				local sound = game.ReplicatedStorage.ToolsForAbilities.Minecrafting.WindBurst:Clone()
				local hitbox = require(game.ReplicatedStorage.HitboxModule)
				local hb = hitbox.Create(Vector3.new(20,20,20), hrp.CFrame, nil)
				hitbox.Touch(hb, hrp.Position, 50, -hrp.CFrame.LookVector, plr, "minus")
				sound.Parent = hrp
				vfx.Parent = hrp.RootAttachment
				
				
				sound:Play()
				local velocity = Instance.new("LinearVelocity", hrp)
				velocity.Attachment0 = hrp.RootAttachment
				velocity.VelocityConstraintMode = Enum.VelocityConstraintMode.Vector
				velocity.MaxForce = 8 * math.huge
				velocity.VectorVelocity = Vector3.new(0,100,0)
				vfx:Emit(100)
				game:GetService("Debris"):AddItem(velocity, 0.2)
				game:GetService("Debris"):AddItem(vfx, 5)
				game:GetService("Debris"):AddItem(sound, 1.2)
				
			elseif mode == "TNT" then
				local model = game.ReplicatedStorage.ToolsForAbilities.Minecrafting.TNTModel:Clone()
				local meshpart = model.TNT
				local modhrp = model.HumanoidRootPart
				local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
				local explodeSound = game.ReplicatedStorage.ToolsForAbilities.Minecrafting.ExplodeTNT:Clone()
				local FuseSound = game.ReplicatedStorage.ToolsForAbilities.Minecrafting.FuseTNT:Clone()
				local blockVFX = game.ReplicatedStorage.VFX.Minecrafting.Boom:Clone()
				local plrtable = {}
				
				model.Parent = workspace
				modhrp.CFrame = hrp.CFrame + hrp.CFrame.LookVector * 2.5
				modhrp.Orientation = hrp.Orientation
				
				
				FuseSound.Parent = modhrp
				FuseSound:Play()
				for i = 1.5, 0, -0.5 do
					game:GetService("TweenService"):Create(model.TNT, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Size = model.TNT.Size - Vector3.new(1.2)})
					model.TNT.TextureID = ""
					task.wait(0.25)
					game:GetService("TweenService"):Create(model.TNT, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Size = model.TNT.Size + Vector3.new(1.2)})
					model.TNT.TextureID = "rbxassetid://105445807472272"
					task.wait(0.25)
				end
				
				explodeSound.Parent = blockVFX
				explodeSound:Play()
				blockVFX.Parent = workspace
				blockVFX.CFrame = modhrp.CFrame
				for i,v in ipairs(blockVFX.Attachment:GetChildren()) do
					if v:IsA("ParticleEmitter") then
						task.wait()
						v:Emit(v:GetAttribute("EmitCount"))
					end
				end
				
				local explos = Instance.new("Explosion")
				explos.Parent = workspace
				explos.Position = modhrp.Position
				explos.BlastRadius = 10
				explos.DestroyJointRadiusPercent = 0
				explos.Visible = false
				model:Destroy()
				explos.Hit:Connect(function(hit)
					if hit.Parent and hit.Parent:FindFirstChild("Humanoid") and not table.find(plrtable, hit.Parent.Name) then
						table.insert(plrtable, hit.Parent.Name)
						local echar = hit.Parent
						local eplr = game.Players:GetPlayerFromCharacter(echar)
						local ehrp = echar:FindFirstChild("HumanoidRootPart")
						local ehum = echar:FindFirstChild("Humanoid")
						if echar then
							ragdoll.Start(echar)
						else
							ragdoll.Start(echar, eplr)
						end
						local bv = Instance.new("BodyVelocity", ehrp)
						bv.MaxForce = Vector3.new(8,8,8) * math.huge
						local dir = (ehrp.CFrame.Position).Unit
						bv.Velocity = (dir + Vector3.new(0,0.5,0)).Unit * 200 + -ehrp.CFrame.LookVector * 25
						game:GetService("Debris"):AddItem(bv, 0.2)
					end
				end)
				task.wait(4.5)
				explodeSound:Destroy()
				explos:Destroy()
				FuseSound:Destroy()
				blockVFX:Destroy()
				print("Ended")
				
			end
		
		end

	end
end)