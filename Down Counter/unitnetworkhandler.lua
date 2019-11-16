local sync_teammate_progress_original = UnitNetworkHandler.sync_teammate_progress
   
function UnitNetworkHandler:sync_teammate_progress(type_index, enabled, tweak_data_id, timer, success, sender, ...)
    local sender_peer = self._verify_sender(sender)
        if not self._verify_gamestate(self._gamestate_filter.any_ingame) or not sender_peer then
            return
        end
        if type_index and tweak_data_id and success and type_index == 1 and (tweak_data_id == "doctor_bag" or tweak_data_id == "firstaid_box") then
            managers.hud:reset_teammate_revives(managers.hud:teammate_panel_from_peer_id(sender_peer:id()))
        end
        return sync_teammate_progress_original(self, type_index, enabled, tweak_data_id, timer, success, sender, ...)
end