
    local init_original = HUDManager.init
    local set_mugshot_downed_original = HUDManager.set_mugshot_downed
    local set_mugshot_custody_original = HUDManager.set_mugshot_custody
    local set_mugshot_normal_original = HUDManager.set_mugshot_normal
    local set_player_condition_original = HUDManager.set_player_condition
	
    function HUDManager:init(...)
        init_original(self, ...)
    end
   
    function HUDManager:teammate_panel_from_peer_id(id)
        for panel_id, panel in pairs(self._teammate_panels or {}) do
            if panel._peer_id == id then
                return panel_id
            end
        end
    end
   
    function HUDManager:set_mugshot_downed(id)
        local panel_id = self:_mugshot_id_to_panel_id(id)
        local unit = self:_mugshot_id_to_unit(id)
        if panel_id and unit and unit:movement().current_state_name and unit:movement():current_state_name() == "bleed_out" then
            self._teammate_panels[panel_id]:increment_revives()
        end
        return set_mugshot_downed_original(self, id)
    end
   
    function HUDManager:set_mugshot_custody(id)
        local panel_id = self:_mugshot_id_to_panel_id(id)
        if panel_id then
            self._teammate_panels[panel_id]:reset_revives()
            self._teammate_panels[panel_id]:set_player_in_custody(true)
        end
        return set_mugshot_custody_original(self, id)
    end
 
    function HUDManager:set_mugshot_normal(id)
        local panel_id = self:_mugshot_id_to_panel_id(id)
        if panel_id then
            self._teammate_panels[panel_id]:set_player_in_custody(false)
        end
        return set_mugshot_normal_original(self, id)
    end
 
    function HUDManager:reset_teammate_revives(panel_id)
        if self._teammate_panels[panel_id] then
            self._teammate_panels[panel_id]:reset_revives()
        end
    end
   
    function HUDManager:set_hud_mode(mode)
        for _, panel in pairs(self._teammate_panels or {}) do
            panel:set_hud_mode(mode)
        end
    end
    
    function HUDManager:_mugshot_id_to_panel_id(id)
        for _, data in pairs(managers.criminals:characters()) do
            if data.data.mugshot_id == id then
                return data.data.panel_id
            end
        end
    end
 
    function HUDManager:_mugshot_id_to_unit(id)
        for _, data in pairs(managers.criminals:characters()) do
            if data.data.mugshot_id == id then
                return data.unit
            end
        end
    end
   
    function HUDManager:set_player_condition(icon_data, text)
        set_player_condition_original(self, icon_data, text)
        if icon_data == "mugshot_in_custody" then
            self._teammate_panels[self.PLAYER_PANEL]:set_player_in_custody(true)
        elseif icon_data == "mugshot_normal" then
            self._teammate_panels[self.PLAYER_PANEL]:set_player_in_custody(false)
        end
    end
