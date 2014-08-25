local Entity = require("Entity")
local Animation = require("Animation")
local BoxCollider = require("BoxCollider")

local DoubleJumpPickup = class("DoubleJumpPickup", Entity)

function DoubleJumpPickup:initialize(x, y, prop)
	self.x, self.y = x, y+10
	self.z = 2
	self.taken = Preferences.static:get("has_djump", false)
	self.collider = BoxCollider(16, 16, 0, -9)
	self.dir = tonumber(prop.dir)

	if self.taken then
		local sprite = Resources.static:getImage("pickup_taken.png")
		self.anim = Animation(sprite, 40, 40, 0.1)
	else
		local sprite = Resources.static:getImage("pickup.png")
		self.anim = Animation(sprite, 40, 40, 0.1)
	end
end

function DoubleJumpPickup:update(dt)
	self.anim:update(dt)
end

function DoubleJumpPickup:draw()
	self.anim:draw(self.x, self.y, 0, self.dir, 1, 20, 20)
end

function DoubleJumpPickup:onCollide(collider)
	if self.taken == false and collider.name == "player" then
		Preferences.static:set("has_djump", true)
		self.anim._image = Resources.static:getImage("pickup_taken.png")
		self.taken = true
	end
end

return DoubleJumpPickup
