local Room = require("Room")

local WorldData = class("WorldData")

function WorldData:initialize()
	local chunk = love.filesystem.load("data/maps/test.lua")
	local data = chunk()

	self._rooms = {}
	self._spawns = {}
	self._doors = {}
	self._fgtiles = {}
	self._bgtiles = {}
	self._xtiles, self._ytiles = 0, 0

	for i,v in ipairs(data.layers) do
		if v.name == "FG" then
			self._xtiles = v.width
			self._ytiles = v.height
			self._fgtiles = v.data
		elseif v.name == "BG" then
			self._bgtiles = v.data
		elseif v.name == "OBJ" then
			for j, o in ipairs(v.objects) do
				if o.type == "room" then
					local r = Room(o.x/TILEW, o.y/TILEW, o.width/TILEW, o.height/TILEW, o.name)
					table.insert(self._rooms, r)

				elseif o.type == "door" then
					local d = {x = o.x/TILEW, y = o.y/TILEW}
					table.insert(self._doors, d)

				elseif o.type == "spawn" then
					local s = {x = o.x/TILEW, y = o.y/TILEW, id = tonumber(o.name)}
					table.insert(self._spawns, s)
				end
			end
		end
	end

	-- Build rooms
	for i,v in ipairs(self._rooms) do
		for iy=v.y, v.y+v.h-1 do
			for ix=v.x, v.x+v.w-1 do
				local fg, bg = self:getTile(ix, iy)
				table.insert(v.fgtiles, fg)
				table.insert(v.bgtiles, bg)
			end
		end
	end
end

function WorldData:getRooms()
	return self._rooms
end

function WorldData:getSpawns()
	return self._spawns
end

function WorldData:getTile(x, y)
	return self._fgtiles[x + y*self._xtiles + 1], 
	       self._bgtiles[x + y*self._xtiles + 1]
end

function WorldData:getRoom(id)
	for i,v in ipairs(self._rooms) do
		if v.id == id then
			return v
		end
	end
end

return WorldData
