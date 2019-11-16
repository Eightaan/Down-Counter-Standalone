local set_whisper_mode_original = GroupAIStateBase.set_whisper_mode
 
function GroupAIStateBase:set_whisper_mode(enabled, ...)
  set_whisper_mode_original(self, enabled, ...)
  
    if (enabled) then
	
    managers.hud:set_hud_mode("stealth")
    else
    managers.hud:set_hud_mode("loud")
    end

end