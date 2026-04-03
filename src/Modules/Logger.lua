-- Path of Building
--
-- Module: Logger
-- Handles logging to both console and file
--

local Logger = {}

function Logger:Init(repoRoot)
	self.repoRoot = repoRoot or "."
	self.logsDir = self.repoRoot .. "/../logs"
	self.logFile = nil
	self.originalConPrintf = ConPrintf
	self.loggingEnabled = false

	-- Try to create logs directory
	self:EnsureLogsDir()

	-- Try to open log file with timestamp
	local timestamp = os.date("%Y-%m-%d_%H-%M-%S")
	self.logFilePath = self.logsDir .. "/pob_" .. timestamp .. ".log"

	-- Attempt to open the file; gracefully degrade if it fails
	local success, err = pcall(function()
		self.logFile = io.open(self.logFilePath, "w")
	end)

	if success and self.logFile then
		self.loggingEnabled = true
		self:Write("[" .. os.date("%Y-%m-%d %H:%M:%S") .. "] Logger initialized")
		self:Write("Log file: " .. self.logFilePath)
		self.originalConPrintf("Logger: File logging enabled at " .. self.logFilePath)
	else
		self.originalConPrintf("Logger: Could not open log file, console-only mode")
		self.logFile = nil
	end

	-- Override global ConPrintf to also write to file
	local logger = self
	ConPrintf = function(fmt, ...)
		local msg = string.format(tostring(fmt), ...)
		logger:OriginalConPrintf(msg)
		if logger.loggingEnabled then
			logger:Write("[" .. os.date("%H:%M:%S") .. "] " .. msg)
		end
	end
end

function Logger:EnsureLogsDir()
	-- Try to create the logs directory using os.execute if available
	-- Windows: use mkdir, Unix: use mkdir -p
	local success = false
	if os.execute then
		-- Try Windows mkdir first
		if os.execute("mkdir \"" .. self.logsDir .. "\" 2>nul") == 0 then
			success = true
		-- If that fails, try Unix mkdir -p
		elseif os.execute("mkdir -p \"" .. self.logsDir .. "\" 2>/dev/null") == 0 then
			success = true
		end
	end
	-- If os.execute not available or failed, we'll attempt to write anyway
	-- and let the file open fail gracefully
	return success
end

function Logger:OriginalConPrintf(msg)
	-- Call the original ConPrintf from SimpleGraphic
	if self.originalConPrintf then
		self.originalConPrintf(msg)
	end
end

function Logger:Write(msg)
	if self.logFile then
		self.logFile:write(msg .. "\n")
		self.logFile:flush()
	end
end

function Logger:Close()
	if self.logFile then
		self:Write("[" .. os.date("%Y-%m-%d %H:%M:%S") .. "] Logger closed")
		self.logFile:close()
		self.logFile = nil
	end
end

return Logger
