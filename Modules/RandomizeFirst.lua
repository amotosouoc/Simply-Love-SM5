local t = {}

t["ScreenSelectMusic"] = Def.ActorFrame {
	ModuleCommand=function(self)
		if not ThemePrefs.Get("RandomizeFirst") then return end
		if STATSMAN:GetStagesPlayed() > 0 then return end

		local style = GAMESTATE:GetCurrentStyle()
		local stepsType = style:GetStepsType()
		local groupName = ThemePrefs.Get("RandomFirstGroup") or "ALL SONGS" 
		local wheel = SCREENMAN:GetTopScreen():GetMusicWheel()
		local allSongs = {} 
		if groupName == "" then return end
		if groupName == "ALL SONGS" then
			allSongs = SONGMAN:GetAllSongs()
		else
			allSongs = SONGMAN:GetSongsInGroup(groupName)
		end
		if not allSongs or #allSongs == 0 then return end
		local candidates = {}
		for _, song in ipairs(allSongs) do
			local steps = song:GetStepsByStepsType(stepsType)
			if steps and #steps > 0 then
				table.insert(candidates, song)
			end
		end

		if #candidates == 0 then return end

		local t = GetTimeSinceStart()
		local ms = math.floor(t * 1000)
		local idx = (ms % #candidates) + 1
		
		wheel:SelectSong(candidates[idx])
		wheel:Move(1)
		wheel:Move(-1)
		wheel:Move(0)
	end
}

return t
