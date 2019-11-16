
_G.Downcount = _G.Downcount or {}
Downcount._path = ModPath
Downcount._data_path = SavePath .. "Downcount.txt"
Downcount._data = {} 

function Downcount:Save()
	local file = io.open( self._data_path, "w+" )
	if file then
		file:write( json.encode( self._data ) )
		file:close()
	end
end

function Downcount:Load()
	local file = io.open( self._data_path, "r" )
	if file then
		self._data = json.decode( file:read("*all") )
		file:close()
	end
end

function Downcount:GetOption(id)
		return self._data[id]
	end

Hooks:Add("LocalizationManagerPostInit", "LocalizationManagerPostInit_Downcount", function( loc )
	loc:load_localization_file( Downcount._path .. "Menu/En.txt")
end)

Hooks:Add( "MenuManagerInitialize", "MenuManagerInitialize_Downcount", function( menu_manager )

	MenuCallbackHandler.callback_PLAYER_down = function(self, item)
		Downcount._data.PLAYER_down = (item:value() == "on" and true or false)
		Downcount:Save()
	end
	MenuCallbackHandler.callback_TEAM_down = function(self, item)
		Downcount._data.TEAM_down = (item:value() == "on" and true or false)
		Downcount:Save()
	end
	Downcount:Load()

	MenuHelper:LoadFromJsonFile( Downcount._path .. "Menu/Downcount.txt", Downcount, Downcount._data )

end )
