    local init_original = HUDTeammate.init
    local set_health_original = HUDTeammate.set_health
 
    function HUDTeammate:init(...)
        init_original(self, ...)
        self:_init_revivecount()
    end
	
    function HUDTeammate:_init_revivecount()
	self._setting_prefix = self._main_player and "PLAYER_" or "TEAM_"
        self._revives_counter = self._player_panel:child("radial_health_panel"):text({
            name = "revives_counter",
            visible = not managers.groupai:state():whisper_mode(),
            text = "0",
            layer = 1,
            color = Color.white,
            w = self._player_panel:child("radial_health_panel"):w(),
            x = 0,
            y = 0,
            h = self._player_panel:child("radial_health_panel"):h(),
            vertical = "center",
            align = "center",
            font_size = 16,
            font = tweak_data.hud_players.ammo_font
        })
        self._revives_count = 0
    end
   
    function HUDTeammate:increment_revives()
        if self._revives_counter then
            self._revives_count = self._revives_count + 1
            self._revives_counter:set_text(tostring(self._revives_count))
        end
    end
   
    function HUDTeammate:reset_revives()
        if self._revives_counter then
            self._revives_count = 0
            if not self._main_player then
                self._revives_counter:set_text(tostring(self._revives_count))
          else
                self._revives_counter:set_text(tostring(managers.modifiers:modify_value("PlayerDamage:GetMaximumLives", (Global.game_settings.one_down and 2 or tweak_data.player.damage.LIVES_INIT) + (self._main_player and managers.player:upgrade_value("player", "additional_lives", 0) or 0))-1))
            end
        end
    end
  
    function HUDTeammate:set_revive_visibility(visible)
        if self._revives_counter then
            self._revives_counter:set_visible( Downcount:GetOption(self._setting_prefix .. "down") and not managers.groupai:state():whisper_mode() and visible and not self._is_in_custody)
        end
    end
   
    function HUDTeammate:set_health(data)
        if data.revives then
            self._revives_counter:set_color(Color.white)
            if self._main_player then             
                self._revives_counter:set_text(tostring(data.revives - 1))
            end
            self:set_player_in_custody(data.revives - 1 < 0)
        end
        return set_health_original(self, data)
    end

    function HUDTeammate:set_hud_mode(mode)
        self:set_revive_visibility(not (mode == "stealth"))
    end

    function HUDTeammate:set_player_in_custody(incustody)
        self._is_in_custody = incustody
        self:set_revive_visibility(not incustody)
    end
