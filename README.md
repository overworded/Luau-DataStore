
# 💾 Luau DataStore 💾

DataStores in Luau for Roblox that can handle more values than strings and numbers!
## Features

 - Saves values such as, but not limited to, Numbers, Strings, Vector3s, Color3s, CFrames, and so on..
 - Doesnt save data if there is no change detected.

## Usage / Examples

#### Creating a DataStore object:
```luau
local DataStoreClass = require(DATASTORE.LUAU PATH)

local DataStore = DataStoreClass.new("DATA STORE NAME")
```

#### Setting a DataStore template:
```luau
-- if no data is found for the key in the DataStore
-- when loaded, it will use the template instead!

local Template = {
  StringValue = "This is a string!";
  NumberValue = 1;
  Vector3Value = Vector3.new(1,0,3);
}

DataStore:SetTemplate(Template)
```

#### Creating a DataStoreClient in the DataStore:
```luau
-- client key can be a string or number.
local Client = DataStore:CreateClient("CLIENT KEY")
```

#### Loading a DataStoreClients Data:
```luau
Client:Load()
```

#### Saving a DataStoreClients Data:
```luau
Client:Save()
```

#### Accessing a DataStoreClients Data:
```luau
Client.Data -- the table of data for the client
-- its as simple as that!
```

#### Removing a DataStoreClients from a DataStore:
```luau
DataStore:DestroyClient("CLIENT KEY")

-- does not delete the key and data from robloxs datastores,
-- only removes from the local datastore.
```

#### Example:
```luau
-- we are going to simulate saving player data,
-- since thats what most people use DataStores for.

local Players = game:GetService("Players")

local DataStoreClass = require(DATASTORE CLASS PATH)

local Template = {
	StringValue = "This is a string!";
	NumberValue = 1;
	Vector3Value = Vector3.new(1,0,3);
}

local DataStore = DataStoreClass.new("Players")

DataStore:SetTemplate(Template)

local function OnPlayerAdded(Player: Player)
	local Client = DataStore:CreateClient(Player.UserId)

	Client:Load()

	-- if you remember, the data wont save if
	-- we dont make any changes to it
	-- so lets do that here

	Client.Data.NumberValue += 2

	-- the NumberValue in the client should now be 3
end

local function OnPlayerRemoving(Player: Player)
	local Client = DataStore.Clients[Player.UserId]

	Client:Save()

	DataStore:DestoryClient(Player.UserId)
end

Players.PlayerAdded:Connect(OnPlayerAdded)
Players.PlayerRemoving:Connect(OnPlayerRemoving)
```
## FAQ

#### Why is my data not saving?

Robloxs DataStore service could be down, or your data hasnt changed from the template values.

#### Why cant I save this value?

You should be able to save any value you add to the Types list, double check if your desired value is there.

