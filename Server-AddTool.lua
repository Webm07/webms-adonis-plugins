--[[ 
	Made by Awesomewebm
	Give credit if possible but DO NOT STEAL THIS AND UPLOAD IT AS YOUR OWN
]]

server = nil
service = nil

return function()
	
	
	server.Commands.AddTool = {
		Prefix = server.Settings.Prefix;
		Commands = {"addtool";};
		Args = {};
		Hidden = false;
		Description = "Adds a tool to the tools list";
		Fun = false;
		AdminLevel = "Moderators";
		Function = function(plr,args,data)
			if plr.Character then
				for _, v in pairs(plr.Character:GetChildren()) do if v:IsA("Tool") then
						local tool = v:Clone()
						tool.Archivable = true
						print(typeof(server.Settings.Storage))
						tool.Parent = game:FindFirstChild(server.Settings.Storage.Name)
						local ind = Instance.new("IntValue",tool)
						ind.Name = "ADONIS_ADDED"
						server.Functions.Hint("\'"..tool.name.."\' was added to the tool list",{plr})
					end
				end

			end
		end
	};

	server.Commands.DelTool = {
		Prefix = server.Settings.Prefix;
		Commands = {"deltool";};
		Args = {"name/all"};
		Hidden = false;
		Description = "Removes a tool added to the tools list (Does Not Remove Default Tools)";
		Fun = false;
		AdminLevel = "Moderators";
		Function = function(plr,args,data)
			for i, tool in next,server.Settings.Storage:GetChildren() do if (tool:IsA("Tool") or tool:IsA("HopperBin") ) and tool:FindFirstChild("ADONIS_ADDED") then
					if args[1]:lower() == "all" or tool.Name:lower():sub(1,#args[1])==args[1]:lower() then 
						tool:Destroy()
					end
				end

			end
			server.Functions.Hint("Tool(s) were removed from the added tools",{plr})
		end
	};

	server.Commands.AddedTools = {
		Prefix = server.Settings.Prefix;
		Commands = {"addedtools";};
		Args = {};
		Hidden = false;
		Description = "Gets a list of tools added using "..server.Settings.Prefix.."addtool";
		Fun = false;
		AdminLevel = "Moderators";
		Function = function(plr,args,data)
			local prefix = server.Settings.Prefix
			local split = server.Settings.SplitKey
			local specialPrefix = server.Settings.SpecialPrefix
			local num = 0
			local children = {
				server.Core.Bytecode([[Object:ResizeCanvas(false, true, false, false, 5, 5)]]);
			}

			for i, v in next,server.Settings.Storage:GetChildren() do 
				if (v:IsA("Tool") or v:IsA("HopperBin") ) and v:FindFirstChild("ADONIS_ADDED") then
					table.insert(children, {
						Class = "TextLabel";
						Size = UDim2.new(1, -10, 0, 30);
						Position = UDim2.new(0, 5, 0, 30*num);
						BackgroundTransparency = 1;
						TextXAlignment = "Left";
						Text = "  "..v.Name;
						ToolTip = v:GetFullName();
						Children = {
							{
								Class = "TextButton";
								Size = UDim2.new(0, 80, 1, -4);
								Position = UDim2.new(1, -82, 0, 2);
								Text = "Spawn";
								OnClick = server.Core.Bytecode([[
										client.Remote.Send("ProcessCommand", "]]..prefix..[[give]]..split..specialPrefix..[[me]]..split..v.Name..[[");
									]]);
							}
						};
					})

					num = num+1;
				end 
			end

			server.Remote.MakeGui(plr, "Window", {
				Name = "ToolList";
				Title = "Added Tools";
				Size  = {300, 300};
				MinSize = {150, 100};
				Content = children;
				Ready = true;
			})
		end

	};

end
