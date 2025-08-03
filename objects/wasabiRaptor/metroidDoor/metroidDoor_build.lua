function build(directory, config, parameters, level, seed)
	local doorKind = (parameters.damageSourceKind or config.damageSourceKind) or
		(parameters.elementalType or config.elementalType)
	local hitType = (parameters.hitType or config.hitType)
	if hitType then
		doorKind = (doorKind or "") .. hitType
	end
	local directives = parameters.directives or config.directives

	if doorKind then
		parameters.shortdescription = config.shortdescription .. (" (%s)"):format(doorKind)
		parameters.inventoryIcon = config.inventoryIcon .. directives .. config.doorDirectives[doorKind]
		parameters.color = doorKind
	else
		parameters.inventoryIcon = config.inventoryIcon .. directives .. config.doorDirectives.default
		parameters.color = "default"
	end

	return config, parameters
end
