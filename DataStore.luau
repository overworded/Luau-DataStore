local DataStoreService = game:GetService("DataStoreService")

local UtilityModule = require(script.Parent.Utility)
local TypesModule = require(script.Parent.Types)

--- // Types \\ ---

export type DataStoreClient = {
	Key: number | string,
	LastSave: number,
	Data: {[string]: any},
	DataString: string,
	DataStore: DataStore?
}

export type DataStore = {
	Name: string,
	Clients: {[number | string]: DataStoreClient},
	Template: {any}?,
	AutoSaveInterval: number,
	AutoSaveClientInterval: number,
}

local Client = {}
Client.__index = Client

local DataStore = {}
DataStore.__index = DataStore

--- // Data Store Client \\ ---

function Client.new(Key: string | number): DataStoreClient
	local self = setmetatable({}, Client)

	self.Key = Key

	self.DataStore = nil

	self.Data = nil
	self.DataString = nil
	self.LastSave = nil

	return self
end

function Client:Set(Data: {any})
	self.Data = Data
	self.DataString = UtilityModule.Stringify(Data)
	self.LastSave = tick()
end

function Client:Save(): boolean
	local NewDataString = UtilityModule.Stringify(self.Data)
	
	if NewDataString == self.DataString then -- data not changed
		return true
	end

	local Success: boolean, Response: string = pcall(
		self.DataStore.DataStore.SetAsync,
		self.DataStore.DataStore,
		self.Key,
		NewDataString
	)

	if not Success then
		warn(`Failed to load save data for {self.Key}. Reason: {Response}`)
		return Success, Response
	end
	
	self.DataString = NewDataString
	self.LastSave = tick()

	print(`Saved data for {self.Key}:`, self.Data)

	return Success
end

function Client:Load(): boolean
	local Success: boolean, Response: string = pcall(
		self.DataStore.DataStore.GetAsync,
		self.DataStore.DataStore,
		self.Key
	)

	if not Success then
		warn(`Failed to load data for {self.Key}. Reason: {Response}`)
		return Success
	end

	if Response ~= nil then
		self:Set(UtilityModule.Parse(Response))
		self.DataString = Response
	else
		if self.DataStore.Template then
			self.Data = table.clone(self.DataStore.Template)
			self.DataString = UtilityModule.Stringify(self.Data)
			print(`Applied default data for {self.Key}.`)
		end
	end

	self.LastSave = tick()

	return Success
end

--- // Data Store \\ ---

function DataStore.new(Name: string): DataStore
	local self = setmetatable({}, DataStore)

	self.Name = Name
	self.DataStore = DataStoreService:GetDataStore(Name)
	self.AutoSaveInterval = 300 -- how many seconds between starting auto save loops
	self.AutoSaveClientInterval = 250 -- how many seconds between auto saving a client
	self.Clients = {}
	self.Template = nil

	return self
end

function DataStore:SetTemplate(Data: {any})
	self.Template = Data
end

-- creates a client object and puts it into the datastores clients dictionary
function DataStore:CreateClient(Key: string | number): DataStoreClient
	if self.Clients[Key] then
		warn("Key already exists in loaded DataStore.")
		return
	end

	local NewClient: DataStoreClient = Client.new(Key)

	NewClient.DataStore = self

	self.Clients[Key] = NewClient

	return NewClient
end

-- removes client from datastores client dictionary and call destroy method on the client
function DataStore:DestroyClient(Key: string | number)
	local TargetClient = self.Clients[Key]

	if not TargetClient then
		warn("Client key not found in loaded DataStore.")
		return
	end

	TargetClient:Destroy()

	self.Clients[Key] = nil
end

return DataStore
