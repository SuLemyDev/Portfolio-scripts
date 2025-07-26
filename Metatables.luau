local HumanNames = {
    "Brain",
    "Sofie",
    "Britani"
}


type Person = {
    Name: string,
    Model: Model,
    Chips: number
}

local ClassHuman = {}
ClassHuman.__index = ClassHuman

ClassHuman.__mul = function(human1, human2)
    local randomname = Random.new():NextInteger(1, #HumanNames)
    local currName = HumanNames[randomname]

    print(string.format("%s was born", currName))
    return ClassHuman.new(0, currName)
end

ClassHuman.__concat = function(human1, human2)
    return ClassHuman.new(human1.Age + human2.Age, human1.Name .. human2.Name)
end


ClassHuman.TellMeAge = function(self)
    print(string.format("Hi, my age is %s", self.Age))
end

ClassHuman.TellMeName = function(self)
    print(string.format("Hi, my name is %s", self.Name))
end


function ClassHuman.new(Age, name): Person
    local self = setmetatable({}, ClassHuman)
    
    self.Name = name
    self.Age = Age
    self.Chips = 15
    
    return self
end

local human = ClassHuman.new(18, "Elk")
local human2 = ClassHuman.new(5, "Sofie")


local Mutant = human .. human2
Mutant:TellMeName()

local baby = human * human2

baby:TellMeAge()
baby:TellMeName()

human:TellMeAge()
