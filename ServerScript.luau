local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local DataStoreService = game:GetService("DataStoreService")
local HttpService = game:GetService("HttpService")

-- =========================================================
-- НАСТРОЙКИ
-- =========================================================

local ADMINS = {
	[4737727205] = true,
}

local MAX_LOG_HISTORY = 200

local MAX_SCRIPT_LENGTH = 20000

local MAX_PERSONAL_SAVES = 100
local MAX_PUBLIC_SAVES = 200

local PERSONAL_DATASTORE_NAME =
	"AdminConsoleScripts_Personal_V2"

local PUBLIC_DATASTORE_NAME =
	"AdminConsoleScripts_Public_V2"

local personalScriptStore =
	DataStoreService:GetDataStore(
		PERSONAL_DATASTORE_NAME
	)

local publicScriptStore =
	DataStoreService:GetDataStore(
		PUBLIC_DATASTORE_NAME
	)

local PUBLIC_KEY = "PublicScripts"

-- =========================================================
-- REMOTE INFRASTRUCTURE
-- =========================================================

local remoteFolder =
	ReplicatedStorage:FindFirstChild(
		"AdminConsole"
	)

if not remoteFolder then

	remoteFolder = Instance.new("Folder")

	remoteFolder.Name =
		"AdminConsole"

	remoteFolder.Parent =
		ReplicatedStorage

end

local function getOrCreateRemote(
	className,
	name
)

	local remote =
		remoteFolder:FindFirstChild(name)

	if remote then
		return remote
	end

	remote =
		Instance.new(className)

	remote.Name =
		name

	remote.Parent =
		remoteFolder

	return remote

end

local executeRemote =
	getOrCreateRemote(
		"RemoteEvent",
		"ExecuteCommand"
	)

local logRemote =
	getOrCreateRemote(
		"RemoteEvent",
		"LogUpdate"
	)

local saveRemote =
	getOrCreateRemote(
		"RemoteEvent",
		"SaveScript"
	)

local deleteRemote =
	getOrCreateRemote(
		"RemoteEvent",
		"DeleteScript"
	)

local renameRemote =
	getOrCreateRemote(
		"RemoteEvent",
		"RenameScript"
	)

local getScriptsRemote =
	getOrCreateRemote(
		"RemoteFunction",
		"GetScripts"
	)

-- =========================================================
-- ADMIN
-- =========================================================

local function isAdmin(player)

	return player
		and ADMINS[player.UserId] == true

end

-- =========================================================
-- SERVER LOG
-- =========================================================

local serverLog = {}

local function pushLog(
	player,
	text,
	kind
)

	kind = kind or "info"

	local entry = {

		time = os.date(
			"%H:%M:%S"
		),

		player =
			player
			and player.Name
			or "SERVER",

		text =
			tostring(text),

		kind =
			kind,

	}

	table.insert(
		serverLog,
		entry
	)

	if #serverLog >
		MAX_LOG_HISTORY then

		table.remove(
			serverLog,
			1
		)

	end

	print(
		string.format(
			"[AdminConsole][%s][%s] %s",
			entry.time,
			entry.player,
			entry.text
		)
	)

	for _, plr in ipairs(
		Players:GetPlayers()
		) do

		if isAdmin(plr) then

			logRemote:FireClient(
				plr,
				entry
			)

		end

	end

end

-- =========================================================
-- DATASTORE HELPERS
-- =========================================================

local function getPlayerKey(player)

	return "Player_"
		.. tostring(player.UserId)

end

local function normalizeDatabase(data)

	if type(data) ~= "table" then
		return {}
	end

	return data

end

-- =========================================================
-- PERSONAL
-- =========================================================

local function getPersonalScripts(player)

	local success, result =
		pcall(function()

			return personalScriptStore:GetAsync(
				getPlayerKey(player)
			)

		end)

	if not success then

		warn(
			"[AdminConsole] Personal GetAsync error:",
			result
		)

		return nil, result

	end

	return normalizeDatabase(result), nil

end

local function savePersonalScripts(
	player,
	scripts
)

	local success, result =
		pcall(function()

			return personalScriptStore:SetAsync(
				getPlayerKey(player),
				scripts
			)

		end)

	if not success then

		warn(
			"[AdminConsole] Personal SetAsync error:",
			result
		)

	end

	return success, result

end

-- =========================================================
-- PUBLIC
-- =========================================================

local function getPublicScripts()

	local success, result =
		pcall(function()

			return publicScriptStore:GetAsync(
				PUBLIC_KEY
			)

		end)

	if not success then

		warn(
			"[AdminConsole] Public GetAsync error:",
			result
		)

		return nil, result

	end

	return normalizeDatabase(result), nil

end

local function savePublicScripts(
	scripts
)

	local success, result =
		pcall(function()

			return publicScriptStore:SetAsync(
				PUBLIC_KEY,
				scripts
			)

		end)

	if not success then

		warn(
			"[AdminConsole] Public SetAsync error:",
			result
		)

	end

	return success, result

end

-- =========================================================
-- STRING HELPERS
-- =========================================================

local function cleanName(name)

	name = tostring(
		name or ""
	)

	name = name:gsub(
		"[%c]",
		""
	)

	name = name:gsub(
		"^%s+",
		""
	)

	name = name:gsub(
		"%s+$",
		""
	)

	if name == "" then

		name =
			"Untitled"

	end

	if #name > 50 then

		name =
			string.sub(
				name,
				1,
				50
			)

	end

	return name

end

local function countLines(code)

	if code == "" then
		return 1
	end

	local count = 1

	for _ in string.gmatch(
		code,
		"\n"
		) do

		count += 1

	end

	return count

end

local function findScript(
	scripts,
	id
)

	for index, scriptData in ipairs(
		scripts
		) do

		if scriptData.id == id then

			return scriptData, index

		end

	end

	return nil, nil

end

-- =========================================================
-- EXECUTION OUTPUT
-- =========================================================

local function runWithCapturedOutput(
	fn
)

	local captured = {}

	local originalPrint = print
	local originalWarn = warn

	local function capturedPrint(...)

		local args = {...}

		for i, value in ipairs(args) do

			args[i] =
				tostring(value)

		end

		table.insert(
			captured,
			table.concat(
				args,
				"\t"
			)
		)

		originalPrint(...)

	end

	local function capturedWarn(...)

		local args = {...}

		for i, value in ipairs(args) do

			args[i] =
				tostring(value)

		end

		table.insert(
			captured,
			"[warn] "
				.. table.concat(
					args,
					"\t"
				)
		)

		originalWarn(...)

	end

	print = capturedPrint
	warn = capturedWarn

	local ok, result =
		pcall(fn)

	print =
		originalPrint

	warn =
		originalWarn

	return ok, result, captured

end

-- =========================================================
-- EXECUTE COMMAND
-- =========================================================

executeRemote.OnServerEvent:Connect(
	function(player, code)

		if not isAdmin(player) then

			pushLog(
				player,
				"Попытка выполнить команду без прав доступа.",
				"error"
			)

			return

		end

		if typeof(code) ~= "string" then
			return
		end

		if #code >
			MAX_SCRIPT_LENGTH then

			pushLog(
				player,
				"Команда слишком длинная и была отклонена.",
				"error"
			)

			return

		end

		local trimmed =
			code:gsub(
				"^%s+",
				""
			):gsub(
			"%s+$",
			""
		)

		if trimmed == "" then
			return
		end

		pushLog(
			player,
			"> " .. code,
			"info"
		)

		local chunk,
		compileError =
			loadstring(code)

		if not chunk then

			pushLog(
				player,
				"Ошибка компиляции: "
					.. tostring(
						compileError
					),
				"error"
			)

			return

		end

		local ok,
		result,
		captured =
			runWithCapturedOutput(
				chunk
			)

		for _, line in ipairs(
			captured
			) do

			pushLog(
				player,
				line,
				"info"
			)

		end

		if ok then

			if result ~= nil then

				pushLog(
					player,
					"Результат: "
						.. tostring(result),
					"success"
				)

			else

				pushLog(
					player,
					"Выполнено успешно.",
					"success"
				)

			end

		else

			pushLog(
				player,
				"Ошибка выполнения: "
					.. tostring(result),
				"error"
			)

		end

	end
)

-- =========================================================
-- GET SAVED SCRIPTS
-- =========================================================

getScriptsRemote.OnServerInvoke =
	function(player)

		if not isAdmin(player) then
			return {}
		end

		local personalScripts,
		personalError =
		getPersonalScripts(player)

		local publicScripts,
		publicError =
		getPublicScripts()

		if not personalScripts then

			pushLog(
				player,
				"Не удалось загрузить личные сохранения: "
				.. tostring(
					personalError
				),
				"error"
			)

			personalScripts = {}

		end

		if not publicScripts then

			pushLog(
				player,
				"Не удалось загрузить общественные сохранения: "
				.. tostring(
					publicError
				),
				"error"
			)

			publicScripts = {}

		end

		-- =====================================================
		-- ADD SAVE TYPES
		-- =====================================================

		for _, scriptData in ipairs(
			personalScripts
			) do

			scriptData.saveType =
			"Personal"

		end

		for _, scriptData in ipairs(
			publicScripts
			) do

			scriptData.saveType =
			"Public"

		end

		-- =====================================================
		-- MERGE
		-- =====================================================

		local result = {}

		for _, scriptData in ipairs(
			personalScripts
			) do

			table.insert(
				result,
				scriptData
			)

		end

		for _, scriptData in ipairs(
			publicScripts
			) do

			table.insert(
				result,
				scriptData
			)

		end

		return result

	end

-- =========================================================
-- SAVE SCRIPT
-- =========================================================

saveRemote.OnServerEvent:Connect(
	function(player, scriptData)

		if not isAdmin(player) then
			return
		end

		if typeof(scriptData) ~= "table" then
			return
		end

		-- =====================================================
		-- TYPE
		-- =====================================================

		local saveType =
			tostring(
				scriptData.saveType
				or "Personal"
			)

		if saveType ~= "Personal"
			and saveType ~= "Public" then

			saveType =
				"Personal"

		end

		local name =
			cleanName(
				scriptData.name
			)

		local code =
			tostring(
				scriptData.code
				or ""
			)

		local existingId =
			scriptData.id

		-- =====================================================
		-- LENGTH
		-- =====================================================

		if #code >
			MAX_SCRIPT_LENGTH then

			pushLog(
				player,
				"Скрипт слишком длинный. Максимум: "
					.. MAX_SCRIPT_LENGTH
					.. " символов.",
				"error"
			)

			return

		end

		-- =====================================================
		-- LOAD DATABASE
		-- =====================================================

		local scripts
		local errorMessage

		if saveType == "Public" then

			scripts,
			errorMessage =
				getPublicScripts()

		else

			scripts,
			errorMessage =
				getPersonalScripts(
					player
				)

		end

		if not scripts then

			pushLog(
				player,
				"Ошибка загрузки сохранений: "
					.. tostring(
						errorMessage
					),
				"error"
			)

			return

		end

		local now =
			os.time()

		-- =====================================================
		-- EDIT EXISTING
		-- =====================================================

		if existingId then

			local existing, index =
				findScript(
					scripts,
					tostring(
						existingId
					)
				)

			if existing then

				-- Personal save всегда принадлежит
				-- конкретному игроку.

				if saveType == "Personal"
					and existing.ownerUserId
					and existing.ownerUserId
					~= player.UserId then

					pushLog(
						player,
						"Нельзя изменять чужое личное сохранение.",
						"error"
					)

					return

				end

				existing.name =
					name

				existing.code =
					code

				existing.lines =
					countLines(code)

				existing.updatedAt =
					now

				existing.updatedBy =
					player.Name

				existing.saveType =
					saveType

				local success
				local result

				if saveType == "Public" then

					success,
					result =
						savePublicScripts(
							scripts
						)

				else

					success,
					result =
						savePersonalScripts(
							player,
							scripts
						)

				end

				if success then

					pushLog(
						player,
						string.format(
							"%s сохранение обновлено: \"%s\" | %d строк",
							saveType,
							name,
							existing.lines
						),
						"success"
					)

				else

					pushLog(
						player,
						"Ошибка сохранения: "
							.. tostring(
								result
							),
						"error"
					)

				end

				return

			end

		end

		-- =====================================================
		-- LIMIT
		-- =====================================================

		local limit

		if saveType == "Public" then

			limit =
				MAX_PUBLIC_SAVES

		else

			limit =
				MAX_PERSONAL_SAVES

		end

		if #scripts >= limit then

			pushLog(
				player,
				string.format(
					"Достигнут лимит %s сохранений: %d",
					saveType,
					limit
				),
				"error"
			)

			return

		end

		-- =====================================================
		-- CREATE NEW
		-- =====================================================

		local newScript = {

			id =
				HttpService:GenerateGUID(
					false
				),

			name =
				name,

			code =
				code,

			lines =
				countLines(code),

			saveType =
				saveType,

			createdAt =
				now,

			updatedAt =
				now,

			createdBy =
				player.Name,

			updatedBy =
				player.Name,

			ownerUserId =
				player.UserId,

		}

		table.insert(
			scripts,
			newScript
		)

		local success
		local result

		if saveType == "Public" then

			success,
			result =
				savePublicScripts(
					scripts
				)

		else

			success,
			result =
				savePersonalScripts(
					player,
					scripts
				)

		end

		if success then

			pushLog(
				player,
				string.format(
					"%s скрипт сохранён: \"%s\" | %d строк",
					saveType,
					name,
					newScript.lines
				),
				"success"
			)

		else

			pushLog(
				player,
				"Ошибка сохранения: "
					.. tostring(
						result
					),
				"error"
			)

		end

	end
)

-- =========================================================
-- DELETE SCRIPT
-- =========================================================

deleteRemote.OnServerEvent:Connect(
	function(player, id)

		if not isAdmin(player) then
			return
		end

		if typeof(id) ~= "string" then
			return
		end

		-- =====================================================
		-- PERSONAL
		-- =====================================================

		local personalScripts =
			getPersonalScripts(
				player
			)

		if personalScripts then

			local scriptData,
			index =
				findScript(
					personalScripts,
					id
				)

			if scriptData then

				-- Дополнительная проверка владельца.

				if scriptData.ownerUserId
					and scriptData.ownerUserId
					~= player.UserId then

					pushLog(
						player,
						"Нельзя удалить чужое личное сохранение.",
						"error"
					)

					return

				end

				table.remove(
					personalScripts,
					index
				)

				local success,
				result =
					savePersonalScripts(
						player,
						personalScripts
					)

				if success then

					pushLog(
						player,
						"Личное сохранение удалено: \""
							.. scriptData.name
							.. "\"",
						"success"
					)

				else

					pushLog(
						player,
						"Ошибка удаления: "
							.. tostring(result),
						"error"
					)

				end

				return

			end

		end

		-- =====================================================
		-- PUBLIC
		-- =====================================================

		local publicScripts =
			getPublicScripts()

		if not publicScripts then
			return
		end

		local scriptData,
		index =
			findScript(
				publicScripts,
				id
			)

		if not scriptData then
			return
		end

		table.remove(
			publicScripts,
			index
		)

		local success,
		result =
			savePublicScripts(
				publicScripts
			)

		if success then

			pushLog(
				player,
				"Общественное сохранение удалено: \""
					.. scriptData.name
					.. "\"",
				"success"
			)

		else

			pushLog(
				player,
				"Ошибка удаления: "
					.. tostring(result),
				"error"
			)

		end

	end
)

-- =========================================================
-- RENAME SCRIPT
-- =========================================================

renameRemote.OnServerEvent:Connect(
	function(player, id, newName)

		if not isAdmin(player) then
			return
		end

		if typeof(id) ~= "string" then
			return
		end

		newName =
			cleanName(newName)

		-- =====================================================
		-- PERSONAL
		-- =====================================================

		local personalScripts =
			getPersonalScripts(
				player
			)

		if personalScripts then

			local scriptData =
				findScript(
					personalScripts,
					id
				)

			if scriptData then

				if scriptData.ownerUserId
					and scriptData.ownerUserId
					~= player.UserId then

					pushLog(
						player,
						"Нельзя переименовать чужое личное сохранение.",
						"error"
					)

					return

				end

				local oldName =
					scriptData.name

				scriptData.name =
					newName

				scriptData.updatedAt =
					os.time()

				scriptData.updatedBy =
					player.Name

				local success,
				result =
					savePersonalScripts(
						player,
						personalScripts
					)

				if success then

					pushLog(
						player,
						string.format(
							"Личный скрипт переименован: \"%s\" → \"%s\"",
							oldName,
							newName
						),
						"success"
					)

				else

					pushLog(
						player,
						"Ошибка переименования: "
							.. tostring(result),
						"error"
					)

				end

				return

			end

		end

		-- =====================================================
		-- PUBLIC
		-- =====================================================

		local publicScripts =
			getPublicScripts()

		if not publicScripts then
			return
		end

		local scriptData =
			findScript(
				publicScripts,
				id
			)

		if not scriptData then
			return
		end

		local oldName =
			scriptData.name

		scriptData.name =
			newName

		scriptData.updatedAt =
			os.time()

		scriptData.updatedBy =
			player.Name

		local success,
		result =
			savePublicScripts(
				publicScripts
			)

		if success then

			pushLog(
				player,
				string.format(
					"Общественный скрипт переименован: \"%s\" → \"%s\"",
					oldName,
					newName
				),
				"success"
			)

		else

			pushLog(
				player,
				"Ошибка переименования: "
					.. tostring(result),
				"error"
			)

		end

	end
)

-- =========================================================
-- PLAYER JOIN
-- =========================================================

Players.PlayerAdded:Connect(
	function(player)

		if not isAdmin(player) then
			return
		end

		task.delay(
			2,
			function()

				if not player.Parent then
					return
				end

				for _, entry in ipairs(
					serverLog
					) do

					logRemote:FireClient(
						player,
						entry
					)

				end

			end
		)

	end
)

-- =========================================================
-- STARTUP
-- =========================================================

pushLog(
	nil,
	"Серверный обработчик консоли запущен.",
	"success"
)
