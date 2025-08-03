function patch(config)
	local blueprints = {
		{ item = "wr_zeroMissionSpacePirateDoor", },
		{ item = "wr_zeroMissionSpacePirateDoor", parameters = { elementalType = "fire" } },
		{ item = "wr_zeroMissionSpacePirateDoor", parameters = { elementalType = "ice" } },
		{ item = "wr_zeroMissionSpacePirateDoor", parameters = { elementalType = "poison" } },
		{ item = "wr_zeroMissionSpacePirateDoor", parameters = { elementalType = "electric" } },
		{ item = "wr_zeroMissionZebesDoor", },
		{ item = "wr_zeroMissionZebesDoor",       parameters = { elementalType = "fire" } },
		{ item = "wr_zeroMissionZebesDoor",       parameters = { elementalType = "ice" } },
		{ item = "wr_zeroMissionZebesDoor",       parameters = { elementalType = "poison" } },
		{ item = "wr_zeroMissionZebesDoor",       parameters = { elementalType = "electric" } },
	}
	for _, v in ipairs(blueprints) do
		table.insert(config.defaultBlueprints.tier1, v)
	end

	return config
end
