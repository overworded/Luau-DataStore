-- using the method :SetTemplate() on a DataStore object with this template will work. you will be able to save/load it.
-- can support other types you just have to add them to Types.luau
-- supports numbers and strings by default, do not add them to the types
return {
	Color = Color3.new(0.96, 0.55, 0.93);
	Vector = Vector3.new(1,-50,123);
	CoordFrame = CFrame.new(5,1,3);
	Number = 164;
	String = "This is a string!";
}
