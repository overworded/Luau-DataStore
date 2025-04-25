local HTTP = game:GetService("HttpService")
local Types = require(script.Parent.Types)

local Module = {}

-- types

local function ToValue(String: string)
	local Table = string.split(String, ":")
	if #Table < 2 then return String end
	return Types[Table[1]].new(table.unpack(string.split(Table[2], ",")))
end

local function ToString(Value: number | string | Color3 | Vector3 | CFrame)
	local Type = typeof(Value)
	if Type == "number" or Type == "string" then return Value end
	return `{Type}:{tostring(Value)}`
end

-- table

local function Compress(Table: {any})
	local Compressed = {}
	
	for Index: number,Value: any in next,Table do
		if type(Value) == "table" then
			Value = Compress(Value)
		else
			Value = ToString(Value)
		end

		Compressed[Index] = Value
	end
	
	return Compressed
end

local function DeCompress(Table: {any})
	local DeCompressed = {}

	for Index: number,Value: any in next,Table do
		if type(Value) == "table" then
			Value = DeCompress(Value)
		else
			Value = ToValue(Value)
		end

		DeCompressed[Index] = Value
	end

	return DeCompressed
end

-- json

function Module.Stringify(Table: {any})
	return HTTP:JSONEncode(Compress(Table))
end

function Module.Parse(Table: {any})
	return DeCompress(HTTP:JSONDecode(Table))
end

return Module
