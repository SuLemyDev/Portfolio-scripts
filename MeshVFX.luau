--[[ || THE SCRIPT HAS BEEN DEVELOPED ||
            SULEMYDEV
        || CONTACT US ||
    TELEGRAM -> @SuLemyDev
    DISCORD -> sukunadeveloper
]]--





--|| HELP VARIABLES ||--
local sp = task.spawn
local del = task.delay
local def = task.defer
local w = task.wait

--|| SERVICES ||--
local ReplicatedStorage = game:GetService("ReplicatedStorage")


local meshVFX = {}
meshVFX.__index = meshVFX

export type loop = {
    Enabled: boolean,
    repeatings: number?,
}

export type MeshVFX = {
    waitTime: number,
    Decal: Decal,
    IDs: {string},
    Folder: () -> Part?,
    Play: (self: MeshVFX) -> (),
    looped: loop
}


function meshVFX.Create(Decal: Decal, IDs:  table, looped: loop, FPS: number, Folder: Part?) : MeshVFX
    assert(typeof(Decal) == "Instance", "Decal is not Instance")
    assert(typeof(IDs) == "table", "IDs is not table")
    assert(typeof(looped) == "table", "looped is not table")
    assert(typeof(FPS) == "number", "FPS is not number")



    local self = setmetatable({}, meshVFX)
    self.waitTime = math.round((1/FPS) * 10^3) / 10^3 :: number
    self.Decal = Decal :: Decal
    self.IDs = IDs :: table
    self.looped = looped
    self.Folder = function()
        if Folder then
            return Folder:: Part
        else
            return nil
        end
    end

    return self
end

meshVFX.Play = function(self: MeshVFX)
    if self.looped.Enabled == true then
        for i=1, self.looped.repeatings or math.huge do
            for i, id in ipairs(self.IDs) do
                self.Decal.Texture = id
                task.wait(self.waitTime)
            end
        end
    elseif self.looped.Enabled == false then
        for i, v in ipairs(self.IDs) do
            self.Decal.Texture = v
            task.wait(self.waitTime)
        end
    end
end


return meshVFX
