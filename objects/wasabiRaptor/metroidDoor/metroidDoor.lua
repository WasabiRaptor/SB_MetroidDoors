local old = {
	init = init,
	update = update,
	uninit = uninit,
	setupMaterialSpaces = setupMaterialSpaces,
	onInputNodeChange = onInputNodeChange,
	onNodeConnectionChange = onNodeConnectionChange,
}
function init()
	old.init()
	self.damageSourceKind = config.getParameter("damageSourceKind")
	self.elementalType = config.getParameter("elementalType")
	self.hitType = config.getParameter("hitType")

	local color = self.damageSourceKind or self.elementalType or "default"
	animator.setGlobalTag("doorDirectives", config.getParameter("doorDirectives")[color])
	animator.setGlobalTag("directives", config.getParameter("directives"))
	local lightColors = config.getParameter("doorLightColors")
	for _, v in ipairs(config.getParameter("doorLights")) do
		animator.setLightColor(v, lightColors[color])
	end
	for k, v in pairs(config.getParameter("doorLightPositions")) do
		animator.setLightPosition(k,v)
	end
	for _, v in ipairs(config.getParameter("enablePhysicsColissions")) do
		physics.setCollisionEnabled(v, true)
	end
end

function applyDamageRequest(damageRequest)
	if storage.state or (animator.animationStateTimer("doorState") < animator.stateCycle("doorState")) then return {} end -- don't do anything special if its open or the door is animating

	if self.damageSourceKind then
		if not (self.damageSourceKind == damageRequest.damageSourceKind) then
			animator.setAnimationState("doorState", storage.locked and "lockedHit" or "closedHit")
			return {}
		end
	elseif self.elementalType then
		if not (self.elementalType == root.elementalType(damageRequest.damageSourceKind)) then
			animator.setAnimationState("doorState", storage.locked and "lockedHit" or "closedHit")
			return {}
		end
	end
	if self.hitType then
		if not (self.hitType == damageRequest.hitType) then
			animator.setAnimationState("doorState", storage.locked and "lockedHit" or "closedHit")
			return {}
		end
	end

	self.sensorConfig.detectTimer = 5
	openDoor()
	return {}
end

function setupMaterialSpaces()
	self.closedMaterialSpaces = config.getParameter("closedMaterialSpaces")
	if not self.closedMaterialSpaces then
		self.closedMaterialSpaces = {}
		local metamaterial = "metamaterial:door"
		if object.isInputNodeConnected(0) then
			metamaterial = "metamaterial:lockedDoor"
		end
		local tube = config.getParameter("animationParts").tube
		if string.sub(tube, 1, 1) ~= "/" then
			tube = root.itemConfig(object.name()).directory .. tube
		end
		for i, space in ipairs(root.imageSpaces(tube, { 0, 0 }, config.getParameter("spaceScan"))) do
			table.insert(self.closedMaterialSpaces, { space, metamaterial })
		end
	end
	self.openMaterialSpaces = config.getParameter("openMaterialSpaces", {})
end

function onNodeConnectionChange(args)
	updateInteractive()
	updateCollisionAndWires()
	if object.isInputNodeConnected(0) then
		onInputNodeChange({ level = object.getInputNodeLevel(0), node = 0 })
	end
end

function onInputNodeChange(args)
	if args.node == 0 then
		if args.level then
			openDoor(storage.doorDirection)
		else
			closeDoor()
		end
	elseif args.node == 1 then
		if args.level then
			lockDoor(storage.doorDirection)
		else
			unlockDoor()
			if object.isInputNodeConnected(0) then
				onInputNodeChange({ level = object.getInputNodeLevel(0), node = 0 })
			end
		end
	end
end

function updateLight()
	for _, v in ipairs(config.getParameter("doorLights")) do
		animator.setLightActive(v, not storage.state)
	end
end
