-- api.lua
-- Author: cndy1860
-- Date: 2019-01-17
-- Descrip: 转换叉叉引擎新旧api，可以在1.9引擎上使用2.0的api接口，只封装了较为常用的一些关键接口
if not (string.sub(getEngineVersion(), 1, 3) == "1.9" and {true} or {false})[1] then
	return
end

--比较比是否相等
local function compareTable(srcTb, dstTb)
	local getAbsLen = function (tb)
		local count = 0
		for k, _ in pairs(tb) do
			count = count + 1
		end
		return count
	end
	
	if srcTb == nil or dstTb == nil then
		return false
	end
	
	if getAbsLen(srcTb) ~= getAbsLen(dstTb) then
		return false
	end
	
	equalFlag = false
	
	for k, v in pairs(srcTb) do
		if type(v) == "table" then
			local exsitFlag = false
			for _k, _v in pairs(dstTb) do
				if _k == k and type(_v) == "table" then
					exsitFlag = true
					if not compareTb(v, _v) then
						return false
					end
					break
				end
			end
			
			if not exsitFlag then
				return false
			end
		else
			if v ~= dstTb[k] then
				return false
			end
		end
	end
	
	return true
end


-------------伪类Point--------------
Point = {}

local eqPoint = {
	__eq = function(o1, o2)
		return compareTable(o1, o2)
	end
}

local mtPoint = {
	__call = function(self, ...)
		local x, y = unpack({...})
		return setmetatable({x = x, y = y}, eqPoint)
	end
}

setmetatable(Point, mtPoint)
Point.INVALID = Point(-1, -1)
Point.ZERO = Point(0, 0)


-------------伪类Rect--------------
Rect = {}

local eqRect = {
	__eq = function(o1, o2)
		return compareTable(o1, o2)
	end
}

local mtRect = {
	__call = function(self, ...)
		local x, y, width, height = unpack({...})
		return setmetatable({x = x, y = y, width = width, height = height}, eqRect)
	end
}

setmetatable(Rect, mtRect)
Rect.ZERO = Rect(0, 0, 0, 0)


-------------伪类Size--------------
Size = {}

local eqSize = {
	__eq = function(o1, o2)
		return compareTable(o1, o2)
	end
}

local mtSize = {
	__call = function(self, ...)
		local width, height = unpack({...})
		return setmetatable({width = width, height = height}, eqSize)
	end
}

setmetatable(Size, mtSize)
Size.INVALID = Size(-1, -1)
Size.ZERO = Size(0, 0)


-------------lua扩展--------------
function log(content)
	sysLog(content)
end

function sleep(ms)
	mSleep(ms)
end


-------------xmod--------------
xmod = {}

xmod.PLATFORM_IOS = 'iOS'
xmod.PLATFORM_ANDROID ='Android'
xmod.PLATFORM = (getOSType() == "android" and xmod.PLATFORM_ANDROID or xmod.PLATFORM_IOS)

xmod.PRODUCT_CODE_DEV = 1
xmod.PRODUCT_CODE_XXZS = 2
xmod.PRODUCT_CODE_IPA = 3
xmod.PRODUCT_CODE_KUWAN	= 4
xmod.PRODUCT_CODE_SPIRIT = 5

xmod.VERSION_NAME = getEngineVersion()

xmod.PROCESS_MODE_EMBEDDED = 0
xmod.PROCESS_MODE_STANDALONE = 2
xmod.PROCESS_MODE = ((xmod.PLATFORM == xmod.PLATFORM_ANDROID and  getRuntimeMode() == 2) and xmod.PROCESS_MODE_STANDALONE or xmod.PROCESS_MODE_EMBEDDED)

function xmod.getPublicPath()
	return '[public]'
end

function xmod.exit()
	lua_exit()
end

function xmod.restart()
	lua_restart()
end


-------------UI--------------
UI = {}

UI.TOAST = {}
UI.TOAST.LENGTH_SHORT = 0
UI.TOAST.LENGTH_LONG = 1
function UI.toast(msg, length)
	toast(msg)
end


-------------screen--------------
screen = {}

screen.LANDSCAPE_RIGHT = 1
screen.LANDSCAPE_LEFT = 2

function screen.init(orientation)
	init("0", orientation)
end

function screen.getOrientation()
	return getScreenDirection()
end

function screen.getSize()
	local width, height = getScreenSize()
	return Size(width, height)
end

function screen.keep(value)
	keepScreen(value)
end

function screen.snapshot(path, rect, quality)
	snapshot(path, rect.x, rect.y, rect.x + rect.width, rect.y + rect.height, quality)
end

function screen.matchColors(points, fuzzy)
	if points == nil or type(points) ~= "string" or string.len(points) == 0 then
		catchError(ERR_PARAM, "wrong points in matchColors")
	end
	
	local toPointsTable = function()
		local posTb = {}
		for x, y, c, dif in string.gmatch(points, "(-?%d+)|(-?%d+)|(%w+)%-?(%w*)") do
			if string.len(dif) > 0 then
				posTb[#posTb + 1] = {tonumber(x), tonumber(y), c, dif}
			else
				posTb[#posTb + 1] = {tonumber(x), tonumber(y), c}
			end
		end
		
		return posTb
	end
	
	local isColor = function(x,y,c,s)
		local fl,abs = math.floor,math.abs
		s = fl(0xff*(100-s)*0.01)
		local r,g,b = fl(c/0x10000),fl(c%0x10000/0x100),fl(c%0x100)
		local rr,gg,bb = getColorRGB(x,y)
		if abs(r-rr)<s and abs(g-gg)<s and abs(b-bb)<s then
			return true
		end
		return false
	end
	
	local posTb = toPointsTable()
	
	local matchFlag = false
	for k, v in pairs(posTb) do
		matchFlag = true
		if not isColor(v[1], v[2], v[3], fuzzy or CFG.DEFAULT_FUZZY) then
			matchFlag = false
			break
		end
	end
	
	return matchFlag
end

function screen.findColor(rect, color, globalFuzz, priority)
	--丢掉不常用的priority
	local x, y = findColor({rect.x, rect.y, rect.x + rect.width, rect.y + rect.height}, color, globalFuzz)
	return Point(x, y)
end

----丢掉不常用的priority,需要的话可自行分离，当limit>99时，分区进行查找，以解决1.9只能返回最多99点的问题
function screen.findColors(rect, color, globalFuzz, priority, limit)
	if limit ~= nil and limit > 99 then	--超过99点，进行分区findColors再汇总
		local split = 6		--分区阶数，将把rect分为split^2个区域分开扫描
		local x0, y0 = rect.x, rect.y
		local stepX, stepY = rect.width / split, rect.height / split
		
		--findColors结果汇总表
		local totalTb = {}
		
		for i = 1, split, 1 do
			for j = 1, split, 1 do
				local tmpArea = {
					math.floor(x0 + stepX * (j - 1)),
					math.floor(y0 + stepY * (i - 1)),
					math.floor(x0 + stepX * j),
					math.floor(y0 + stepY * i)
				}
				local tmpTb = findColors(tmpArea, color, globalFuzz or CFG.DEFAULT_FUZZY)
				if #tmpTb >= 99 then
					Log("get more then 99 point, please increase split !")
					return nil
				end
				for _, v in pairs(tmpTb) do
					table.insert(totalTb, v)
				end
				--Log(j.." x "..i.." insert "..#tmpTb)
			end
		end
		
		--Log("findColorsEx get total points: "..#posTb)
		
		--格式化为Point
		local pointsTb = {}
		for k, v in pairs(totalTb) do
			table.insert(pointsTb, Point(v.x, v.y))
		end
		
		return pointsTb
	else		--正常findColors
		local tmpTb = findColors({rect.x, rect.y, rect.x + rect.width, rect.y + rect.height}, color, globalFuzz or CFG.DEFAULT_FUZZY)
		local pointsTb = {}
		for k, v in pairs(tmpTb) do
			table.insert(pointsTb, Point(v.x, v.y))
		end
		
		return pointsTb
	end
end


-------------touch--------------
touch = {}

function touch.down(index, x, y)
	if type(x) == "number" then
		touchDown(index, x, y)
	elseif type(x) == "table" then
		touchDown(index, x.x, x.y)
	end
end

function touch.move(index, x, y)
	if type(x) == "number" then
		touchMove(index, x, y)
	elseif type(x) == "table" then
		touchMove(index, x.x, x.y)
	end
end

function touch.up(index, x, y)
	if type(x) == "number" then
		touchUp(index, x, y)
	elseif type(x) == "table" then
		touchUp(index, x.x, x.y)
	end
end


-------------storage--------------
storage = {
	map = {}
}

function storage.put(key, value)
	if type(key) ~= "string" then
		Log("faild storage.put, by wrong type key")
		return
	end
	
	if type(value) ~= "string" and type(value) ~= "number" and type(value) ~= "boolean" then
		Log("faild storage.put, by wrong type value")
		return
	end
	
	storage.map[key] = value
end

function storage.get(key, defaultValue)
	if type(key) ~= "string" then
		Log("faild storage.get, by wrong type key")
		return
	end
	
	if type(defaultValue) ~= "string" and type(defaultValue) ~= "number" and type(defaultValue) ~= "boolean" then
		Log("faild storage.get, by wrong type defaultValue")
		return
	end
	
	local value = getStringConfig(key, "NO_DATA")
	
	if value == "NO_DATA" then	--无保存数据直接使用defaultValue
		return defaultValue
	end
	
	if type(defaultValue) == "number" then
		value = tonumber(value)
	elseif type(defaultValue) == "boolean" then
		if value == "true" then
			value = true
		else
			value = false
		end
	end
	
	return value
end

function storage.commit()
	for key, value in pairs(storage.map) do
		setStringConfig(key, tostring(value))
	end
end

function storage.undo()
	storage.map = {}
end

function storage.purge()
	storage.map = {}
end


-------------task--------------
task = {}

function task.execTimer(delayMs, callback, ...)
	local args = { ... }
	setTimer(delayMs,callback, unpack(args))
end


-------------runtime--------------
runtime = {}

function runtime.vibrate()
	return vibrator()
end

function runtime.readClipboard()
	return readPasteboard()
end

function runtime.writeClipboard(content)
	writePasteboard(content)
end

function runtime.inputText(content)
	inputText(content)
end

function runtime.launchApp(appID)
	runApp(appID)
end

function runtime.killApp(appID)
	closeApp(appID)
end

function runtime.isAppRunning(appID)
	return appIsRunning(appID)
end

function runtime.getForegroundApp()
	return frontAppName()
end

