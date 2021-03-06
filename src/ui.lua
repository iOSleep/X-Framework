-- ui.lua
-- Author: cndy1860
-- Date: 2018-12-24
-- Descrip: 基于wui的ui配置
if CFG.COMPATIBLE then
	return
end


local wui = require 'wui.wui'
local cjson = require 'cjson'

--style缩放参数(包括字体大小)，以保证在任何比例的分辨下，UI都能按照开发分辨率的样式完整的呈现，若比例大于开发分辨率，两边留白
local ratio = (CFG.DST_RESOLUTION.height * CFG.DEV_RESOLUTION.width / CFG.DEV_RESOLUTION.height) / CFG.DST_RESOLUTION.width

local showwingFlag = true

local _gridList = {
	{
		tag = "选择任务",
		checkedList = {1},
		--当singleCheck为true时，通过USER[singleParamKey]设置值，否则用USER[list[i].paramKey]设置
		--当singleCheck为true时，list每一项对应的值优先取list[i].value，value为nil时直接取title的值
		--当singleCheck为false时，list中，由checkedList标记的项的值优先取list[i].value，value为nil时值为true
		singleCheck = true,
		singleBindParam = "USER.TASK_NAME",
		list = {
			{title = '自动联赛'},
			{title = '自动天梯'},
			{title = '自动巡回'},
			{title = '特殊抽球'},
			{title = '标准抽球'},
			{title = '箱式抽球'},
		},
		style = {
			lineSpacing = 14 * ratio,
			width = 160 * ratio,
			height = 60 * ratio,
			fontSize = 24 * ratio,
			color = '#333333',
			checkedColor = '#ffffff',
			disabledColor = '#BBBBBB',
			borderColor = '#666666',
			checkedBorderColor = '#ffb200',
			backgroundColor = '#ffffff',
			checkedBackgroundColor = '#ffb200',
			icon = ''
		}
	},
	{
		tag = "任务次数",
		checkedList = {4},
		singleCheck = true,
		singleBindParam = "USER.REPEAT_TIMES",
		list = {
			{title = '次数', disabled = true, value = 0},
			{title = '1', value = 1},
			{title = '2', value = 2},
			{title = '5', value = 5},
			{title = '10', value = 10},
			{title = '20', value = 20},
			{title = '50', value = 50},
			{title = '无限', value = 9999},
		},
		style = {
			lineSpacing = 14 * ratio,
			width = 50 * ratio,
			height = 40 * ratio,
			fontSize = 16 * ratio * ratio,
			color = '#999999',
			checkedColor = '#ffffff',
			disabledColor = '#BBBBBB',
			borderColor = '#999999',
			checkedBorderColor = '#ffb200',
			backgroundColor = '#ffffff',
			checkedBackgroundColor = '#ffb200',
			icon = '',
		}
	},
	{
		tag = "选择功能",
		checkedList = {1},
		singleCheck = false,
		singleParamKey = nil,
		list = {
			{title = '球员续约', bindParam = "USER.REFRESH_CONCTRACT"},
			{title = '等待恢复', bindParam = "USER.RESTORED_ENERGY"},
			{title = '购买能量', bindParam = "USER.BUY_ENERGY"},
			{title = '开场换人', bindParam = "USER.ALLOW_SUBSTITUTE"},
			{title = '自动重启', bindParam = "USER.ALLOW_RESTART"},
		},
		style = {
			lineSpacing = 14 * ratio,
			width = 160 * ratio,
			height = 60 * ratio,
			fontSize = 24 * ratio,
			color = '#333333',
			checkedColor = '#333333',
			disabledColor = '#BBBBBB',
			borderColor = '#F6F6F6',
			checkedBorderColor = '#ffb200',
			backgroundColor = '#F6F6F6',
			checkedBackgroundColor = '#FFFFFF',
			--icon = ''
		}
	},
	{
		tag = "抽球位置",
		checkedList = {1},
		singleCheck = true,
		singleBindParam = "USER.DRAW_REGULAR_POSATION",
		list = {
			{title = '前锋'},
			{title = '中场'},
			{title = '后卫'},
		},
		style = {
			lineSpacing = 14 * ratio,
			width = 70 * ratio,
			height = 30 * ratio,
			fontSize = 14 * ratio,
			color = '#333333',
			checkedColor = '#ffffff',
			disabledColor = '#BBBBBB',
			borderColor = '#666666',
			checkedBorderColor = '#ffb200',
			backgroundColor = '#ffffff',
			checkedBackgroundColor = '#ffb200',
			icon = ''
		}
	},
	{
		tag = "抽球类型",
		checkedList = {1},
		singleCheck = true,
		singleBindParam = "USER.DRAW_BALL_SINGLE",
		list = {
			{title = '单抽', value = true},
			{title = '十连', value = false},
		},
		style = {
			lineSpacing = 14 * ratio,
			width = 70 * ratio,
			height = 30 * ratio,
			fontSize = 14 * ratio,
			color = '#333333',
			checkedColor = '#ffffff',
			disabledColor = '#BBBBBB',
			borderColor = '#666666',
			checkedBorderColor = '#ffb200',
			backgroundColor = '#ffffff',
			checkedBackgroundColor = '#ffb200',
			icon = ''
		}
	},
	{
		tag = "替补1",
		checkedList = {2},
		singleCheck = true,
		singleBindParam = "USER.SUBSTITUTE_INDEX_LIST[1].fieldIndex",
		list = {
			{title = 'P1', disabled = true},
			{title = '1', value = 1},
			{title = '2', value = 2},
			{title = '3', value = 3},
			{title = '4', value = 4},
			{title = '5', value = 5},
			{title = '6', value = 6},
			{title = '7', value = 7},
			{title = '8', value = 8},
			{title = '9', value = 9},
			{title = '10', value = 10},
			{title = '11', value = 11},
		},
		style = {
			lineSpacing = 14 * ratio,
			width = 36 * ratio,
			height = 30 * ratio,
			fontSize = 10 * ratio,
			color = '#333333',
			checkedColor = '#333333',
			disabledColor = '#BBBBBB',
			borderColor = '#F6F6F6',
			checkedBorderColor = '#ffb200',
			backgroundColor = '#F6F6F6',
			checkedBackgroundColor = '#FFFFFF',
			icon = ''
		}
	},
	{
		tag = "状态1",
		checkedList = {1},
		singleCheck = true,
		singleBindParam = "USER.SUBSTITUTE_INDEX_LIST[1].substituteCondition",
		list = {
			{title = "好一档", value = 1},
			{title = "好两档", value = 2},
			{title = "主力红", value = 0},
		},
		style = {
			lineSpacing = 14 * ratio,
			width = 50 * ratio,
			height = 30 * ratio,
			fontSize = 10 * ratio,
			color = '#333333',
			checkedColor = '#333333',
			disabledColor = '#BBBBBB',
			borderColor = '#F6F6F6',
			checkedBorderColor = '#ffb200',
			backgroundColor = '#F6F6F6',
			checkedBackgroundColor = '#FFFFFF',
			icon = ''
		}
	},
	{
		tag = "替补2",
		checkedList = {3},
		singleCheck = true,
		singleBindParam = "USER.SUBSTITUTE_INDEX_LIST[2].fieldIndex",
		list = {
			{title = 'P2', disabled = true},
			{title = '1', value = 1},
			{title = '2', value = 2},
			{title = '3', value = 3},
			{title = '4', value = 4},
			{title = '5', value = 5},
			{title = '6', value = 6},
			{title = '7', value = 7},
			{title = '8', value = 8},
			{title = '9', value = 9},
			{title = '10', value = 10},
			{title = '11', value = 11},
		},
		style = {
			lineSpacing = 14 * ratio,
			width = 36 * ratio,
			height = 30 * ratio,
			fontSize = 10 * ratio,
			color = '#333333',
			checkedColor = '#333333',
			disabledColor = '#BBBBBB',
			borderColor = '#F6F6F6',
			checkedBorderColor = '#ffb200',
			backgroundColor = '#F6F6F6',
			checkedBackgroundColor = '#FFFFFF',
			icon = ''
		}
	},
	{
		tag = "状态2",
		checkedList = {1},
		singleCheck = true,
		singleBindParam = "USER.SUBSTITUTE_INDEX_LIST[2].substituteCondition",
		list = {
			{title = "好一档", value = 1},
			{title = "好两档", value = 2},
			{title = "主力红", value = 0},
		},
		style = {
			lineSpacing = 14 * ratio,
			width = 50 * ratio,
			height = 30 * ratio,
			fontSize = 10 * ratio,
			color = '#333333',
			checkedColor = '#333333',
			disabledColor = '#BBBBBB',
			borderColor = '#F6F6F6',
			checkedBorderColor = '#ffb200',
			backgroundColor = '#F6F6F6',
			checkedBackgroundColor = '#FFFFFF',
			icon = ''
		}
	},
	{
		tag = "替补3",
		checkedList = {4},
		singleCheck = true,
		singleBindParam = "USER.SUBSTITUTE_INDEX_LIST[3].fieldIndex",
		list = {
			{title = 'P3', disabled = true},
			{title = '1', value = 1},
			{title = '2', value = 2},
			{title = '3', value = 3},
			{title = '4', value = 4},
			{title = '5', value = 5},
			{title = '6', value = 6},
			{title = '7', value = 7},
			{title = '8', value = 8},
			{title = '9', value = 9},
			{title = '10', value = 10},
			{title = '11', value = 11},
		},
		style = {
			lineSpacing = 14 * ratio,
			width = 36 * ratio,
			height = 30 * ratio,
			fontSize = 10 * ratio,
			color = '#333333',
			checkedColor = '#333333',
			disabledColor = '#BBBBBB',
			borderColor = '#F6F6F6',
			checkedBorderColor = '#ffb200',
			backgroundColor = '#F6F6F6',
			checkedBackgroundColor = '#FFFFFF',
			icon = ''
		}
	},
	{
		tag = "状态3",
		checkedList = {1},
		singleCheck = true,
		singleBindParam = "USER.SUBSTITUTE_INDEX_LIST[3].substituteCondition",
		list = {
			{title = "好一档", value = 1},
			{title = "好两档", value = 2},
			{title = "主力红", value = 0},
		},
		style = {
			lineSpacing = 14 * ratio,
			width = 50 * ratio,
			height = 30 * ratio,
			fontSize = 10 * ratio,
			color = '#333333',
			checkedColor = '#333333',
			disabledColor = '#BBBBBB',
			borderColor = '#F6F6F6',
			checkedBorderColor = '#ffb200',
			backgroundColor = '#F6F6F6',
			checkedBackgroundColor = '#FFFFFF',
			icon = ''
		}
	},
	{
		tag = "替补4",
		checkedList = {5},
		singleCheck = true,
		singleBindParam = "USER.SUBSTITUTE_INDEX_LIST[4].fieldIndex",
		list = {
			{title = 'P4', disabled = true},
			{title = '1', value = 1},
			{title = '2', value = 2},
			{title = '3', value = 3},
			{title = '4', value = 4},
			{title = '5', value = 5},
			{title = '6', value = 6},
			{title = '7', value = 7},
			{title = '8', value = 8},
			{title = '9', value = 9},
			{title = '10', value = 10},
			{title = '11', value = 11},
		},
		style = {
			lineSpacing = 14 * ratio,
			width = 36 * ratio,
			height = 30 * ratio,
			fontSize = 10 * ratio,
			color = '#333333',
			checkedColor = '#333333',
			disabledColor = '#BBBBBB',
			borderColor = '#F6F6F6',
			checkedBorderColor = '#ffb200',
			backgroundColor = '#F6F6F6',
			checkedBackgroundColor = '#FFFFFF',
			icon = ''
		}
	},
	{
		tag = "状态4",
		checkedList = {1},
		singleCheck = true,
		singleBindParam = "USER.SUBSTITUTE_INDEX_LIST[4].substituteCondition",
		list = {
			{title = "好一档", value = 1},
			{title = "好两档", value = 2},
			{title = "主力红", value = 0},
		},
		style = {
			lineSpacing = 14 * ratio,
			width = 50 * ratio,
			height = 30 * ratio,
			fontSize = 10 * ratio,
			color = '#333333',
			checkedColor = '#333333',
			disabledColor = '#BBBBBB',
			borderColor = '#F6F6F6',
			checkedBorderColor = '#ffb200',
			backgroundColor = '#F6F6F6',
			checkedBackgroundColor = '#FFFFFF',
			icon = ''
		}
	},
	{
		tag = "替补5",
		checkedList = {6},
		singleCheck = true,
		singleBindParam = "USER.SUBSTITUTE_INDEX_LIST[5].fieldIndex",
		list = {
			{title = 'P5', disabled = true},
			{title = '1', value = 1},
			{title = '2', value = 2},
			{title = '3', value = 3},
			{title = '4', value = 4},
			{title = '5', value = 5},
			{title = '6', value = 6},
			{title = '7', value = 7},
			{title = '8', value = 8},
			{title = '9', value = 9},
			{title = '10', value = 10},
			{title = '11', value = 11},
		},
		style = {
			lineSpacing = 14 * ratio,
			width = 36 * ratio,
			height = 30 * ratio,
			fontSize = 10 * ratio,
			color = '#333333',
			checkedColor = '#333333',
			disabledColor = '#BBBBBB',
			borderColor = '#F6F6F6',
			checkedBorderColor = '#ffb200',
			backgroundColor = '#F6F6F6',
			checkedBackgroundColor = '#FFFFFF',
			icon = ''
		}
	},
	{
		tag = "状态5",
		checkedList = {1},
		singleCheck = true,
		singleBindParam = "USER.SUBSTITUTE_INDEX_LIST[5].substituteCondition",
		list = {
			{title = "好一档", value = 1},
			{title = "好两档", value = 2},
			{title = "主力红", value = 0},
		},
		style = {
			lineSpacing = 14 * ratio,
			width = 50 * ratio,
			height = 30 * ratio,
			fontSize = 10 * ratio,
			color = '#333333',
			checkedColor = '#333333',
			disabledColor = '#BBBBBB',
			borderColor = '#F6F6F6',
			checkedBorderColor = '#ffb200',
			backgroundColor = '#F6F6F6',
			checkedBackgroundColor = '#FFFFFF',
			icon = ''
		}
	},
	{
		tag = "替补6",
		checkedList = {7},
		singleCheck = true,
		singleBindParam = "USER.SUBSTITUTE_INDEX_LIST[6].fieldIndex",
		list = {
			{title = 'P6', disabled = true},
			{title = '1', value = 1},
			{title = '2', value = 2},
			{title = '3', value = 3},
			{title = '4', value = 4},
			{title = '5', value = 5},
			{title = '6', value = 6},
			{title = '7', value = 7},
			{title = '8', value = 8},
			{title = '9', value = 9},
			{title = '10', value = 10},
			{title = '11', value = 11},
		},
		style = {
			lineSpacing = 14 * ratio,
			width = 36 * ratio,
			height = 30 * ratio,
			fontSize = 10 * ratio,
			color = '#333333',
			checkedColor = '#333333',
			disabledColor = '#BBBBBB',
			borderColor = '#F6F6F6',
			checkedBorderColor = '#ffb200',
			backgroundColor = '#F6F6F6',
			checkedBackgroundColor = '#FFFFFF',
			icon = ''
		}
	},
	{
		tag = "状态6",
		checkedList = {1},
		singleCheck = true,
		singleBindParam = "USER.SUBSTITUTE_INDEX_LIST[6].substituteCondition",
		list = {
			{title = "好一档", value = 1},
			{title = "好两档", value = 2},
			{title = "主力红", value = 0},
		},
		style = {
			lineSpacing = 14 * ratio,
			width = 50 * ratio,
			height = 30 * ratio,
			fontSize = 10 * ratio,
			color = '#333333',
			checkedColor = '#333333',
			disabledColor = '#BBBBBB',
			borderColor = '#F6F6F6',
			checkedBorderColor = '#ffb200',
			backgroundColor = '#F6F6F6',
			checkedBackgroundColor = '#FFFFFF',
			icon = ''
		}
	},
	{
		tag = "替补7",
		checkedList = {8},
		singleCheck = true,
		singleBindParam = "USER.SUBSTITUTE_INDEX_LIST[7].fieldIndex",
		list = {
			{title = 'P7', disabled = true},
			{title = '1', value = 1},
			{title = '2', value = 2},
			{title = '3', value = 3},
			{title = '4', value = 4},
			{title = '5', value = 5},
			{title = '6', value = 6},
			{title = '7', value = 7},
			{title = '8', value = 8},
			{title = '9', value = 9},
			{title = '10', value = 10},
			{title = '11', value = 11},
		},
		style = {
			lineSpacing = 14 * ratio,
			width = 36 * ratio,
			height = 30 * ratio,
			fontSize = 10 * ratio,
			color = '#333333',
			checkedColor = '#333333',
			disabledColor = '#BBBBBB',
			borderColor = '#F6F6F6',
			checkedBorderColor = '#ffb200',
			backgroundColor = '#F6F6F6',
			checkedBackgroundColor = '#FFFFFF',
			icon = ''
		}
	},
	{
		tag = "状态7",
		checkedList = {1},
		singleCheck = true,
		singleBindParam = "USER.SUBSTITUTE_INDEX_LIST[7].substituteCondition",
		list = {
			{title = "好一档", value = 1},
			{title = "好两档", value = 2},
			{title = "主力红", value = 0},
		},
		style = {
			lineSpacing = 14 * ratio,
			width = 50 * ratio,
			height = 30 * ratio,
			fontSize = 10 * ratio,
			color = '#333333',
			checkedColor = '#333333',
			disabledColor = '#BBBBBB',
			borderColor = '#F6F6F6',
			checkedBorderColor = '#ffb200',
			backgroundColor = '#F6F6F6',
			checkedBackgroundColor = '#FFFFFF',
			icon = ''
		}
	},
	{
		tag = "清空缓存",
		checkedList = {3},
		singleCheck = true,
		singleBindParam = "USER.DROP_CACHE",
		list = {
			{title = "清空缓存", disabled = true},
			{title = "开启", value = true},
			{title = "关闭", value = false},
		},
		style = {
			lineSpacing = 1 * ratio,
			width = 80 * ratio,
			height = 40 * ratio,
			fontSize = 16 * ratio,
			color = '#333333',
			checkedColor = '#333333',
			disabledColor = '#ffb200',
			borderColor = '#F6F6F6',
			checkedBorderColor = '#ffb200',
			backgroundColor = '#F6F6F6',
			checkedBackgroundColor = '#ffb200',
			icon = ''
		}
	},
	{
		tag = "缓存模式",
		checkedList = {3},
		singleCheck = true,
		singleBindParam = "CFG.ALLOW_CACHE",
		list = {
			{title = "缓存模式", disabled = true},
			{title = "开启", value = true},
			{title = "关闭", value = false},
		},
		style = {
			lineSpacing = 1 * ratio,
			width = 80 * ratio,
			height = 40 * ratio,
			fontSize = 16 * ratio,
			color = '#333333',
			checkedColor = '#333333',
			disabledColor = '#ffb200',
			borderColor = '#F6F6F6',
			checkedBorderColor = '#ffb200',
			backgroundColor = '#F6F6F6',
			checkedBackgroundColor = '#ffb200',
			icon = ''
		}
	},
	{
		tag = "日志记录",
		checkedList = {3},
		singleCheck = true,
		singleBindParam = "CFG.WRITE_LOG",
		list = {
			{title = "日志记录", disabled = true},
			{title = "开启", value = true},
			{title = "关闭", value = false},
		},
		style = {
			lineSpacing = 14 * ratio,
			width = 80 * ratio,
			height = 40 * ratio,
			fontSize = 16 * ratio,
			color = '#333333',
			checkedColor = '#333333',
			disabledColor = '#ffb200',
			borderColor = '#F6F6F6',
			checkedBorderColor = '#ffb200',
			backgroundColor = '#F6F6F6',
			checkedBackgroundColor = '#ffb200',
			icon = ''
		}
	},
}

local function generateGridID(gridTag)
	return string.format("grid_%s", gridTag)
end

local function parserGridID(gridID)
	return string.sub(gridID, 6, -1)
end

--从_gridList获取list，并过滤掉不需要的参数
local function generateGridList(gridTag)
	for k, v in pairs(_gridList) do
		if v.tag == gridTag then
			local tmpList = tbCopy(v.list)
			for _k, _v in pairs(tmpList) do
				if _v.value then
					_v.value = nil
				end
				if _v.paramKey then
					_v.paramKey = nil
				end
			end
			return tmpList
		end
	end
end

--从_gridList获取style
local function generateGridStyle(gridTag)
	for k, v in pairs(_gridList) do
		if v.tag == gridTag then
			return tbCopy(v.style)
		end
	end
end

local function setGridChecked(gridTag, checkedList)
	for k, v in pairs(_gridList) do
		if v.tag == gridTag then
			v.checkedList = checkedList
			break
		end
	end
end

local function loadGridChecked()
	Log("loadGridChecked")
	
	for k, v in pairs(_gridList) do
		local storeList = cjson.decode(storage.get(v.tag, '[0]'))	--{0}表示没有数据
		
		if v.singleCheck then		--单选
			if #storeList >= 1 and storeList[1] ~= 0 then		--有存储数据，使用存储数据，否则使用默认
				Log("load last singleCheck selection: "..v.tag)
				v.checkedList = storeList
			end
			
			for _k, _v in pairs(v.list) do	--先全部置为unchecked
				_v.checked = false
			end
			
			for _k, _v in pairs(v.list) do
				for __k, __v in pairs(v.checkedList) do
					if __v == _k then
						_v.checked = true
						break		--仅一个有效
					end
				end
			end
		else					--多选
			if #storeList == 0 or (#storeList >= 1 and storeList[1] ~= 0) then		--有存储数据，使用存储数据，否则使用默认
				Log("load last selection: "..v.tag)
				v.checkedList = storeList
			end
			
			for _k, _v in pairs(v.list) do	--先全部置为unchecked
				_v.checked = false
			end
			
			for _k, _v in pairs(v.list) do
				for __k, __v in pairs(v.checkedList) do
					if __v == _k then
						_v.checked = true
					end
				end
			end
		end
	end
end

local function submitGridChecked()
	for k, v in pairs(_gridList) do
		--设置对应的USER值
		if v.singleCheck then		--单选
			--setValueByStrKey(v.singleBindParam, false)
			for _k, _v in pairs(v.list) do
				--prt(_v)
				for __k, __v in pairs(v.checkedList) do
					if __v == _k then
						if type(_v.value) == "boolean" then
							setValueByStrKey(v.singleBindParam, _v.value)
							Log("________commit set "..v.singleBindParam.."="..tostring(_v.value))
						else
							setValueByStrKey(v.singleBindParam, _v.value or _v.title)
							Log("________commit set "..v.singleBindParam.."="..(_v.value or _v.title))
						end
						
						break
					end
				end
			end
		else						--多选
			for _k, _v in pairs(v.list) do
				setValueByStrKey(_v.bindParam, false)
			end
			
			for _k, _v in pairs(v.list) do
				for __k, __v in pairs(v.checkedList) do
					if __v == _k then
						setValueByStrKey(_v.bindParam, true)
						Log("________commit set ".._v.bindParam.."=true")
						break
					end
				end
			end
		end
		
		--保存当前checkedList数据
		local storeStr = cjson.encode(v.checkedList)
		Log("save user selection: "..v.tag)
		storage.put(v.tag, storeStr)
	end
	
	storage.commit()
end

local globalStyle = {
	scroller = {
		flex = 1,
	},
}

local rootLayout = {
	view = 'div',
	class = 'div',
	style = {
		width = 750,
		['align-items'] = 'center',
		--['justify-content'] = 'flex-end',
		['justify-content'] = 'flex-start',
	},
	subviews = {
	}
}

loadGridChecked()

local pages = {
	{
		view = 'div',
		style = {
			width = 700 * ratio,
			['background-color'] = '#FFFFFF',
			['justify-content'] = 'center',
			['align-items'] = 'center'
		},
		subviews = {
			wui.GridSelect.createLayout({id = generateGridID("选择任务"), list = generateGridList("选择任务"),
					config = { single = true, totalWidth = 540  * ratio, gridStyle = generateGridStyle("选择任务")} }),
			{
				view = 'div',
				style = {
					width = 700 * ratio,
					['background-color'] = '#FFFFFF',
				},
				subviews = {
					{
						view = 'text',
						value = '\n ',
						style = {
							['background-color'] = '#FFFFFF',
							['font-size'] = 10 * ratio,
							color = '#5f5f5f'
						}
					},
				}
			},
			
			wui.GridSelect.createLayout({id = generateGridID("任务次数"), list = generateGridList("任务次数"),
					config = {single = true, totalWidth = 480 * ratio, gridStyle = generateGridStyle("任务次数")} }),
			{
				view = 'div',
				style = {
					width = 700 * ratio,
					['background-color'] = '#FFFFFF',
				},
				subviews = {
					{
						view = 'text',
						value = '\n ',
						style = {
							['background-color'] = '#FFFFFF',
							['font-size'] = 14 * ratio,
							color = '#5f5f5f'
						}
					},
				}
			},
			{
				view = 'div',
				style = {
					width = 700 * ratio,
					['background-color'] = '#FFFFFF',
					['justify-content'] = 'space-around',
					--['align-items'] = 'center',
					['flex-direction'] = 'row'
				},
				subviews = {
					wui.Button.createLayout({ id = 'btn_taskCancle', size = 'medium', text = "退出脚本" }),
					wui.Button.createLayout({ id = 'btn_taskOk', size = 'medium', text = "开始任务" })
				}
			}
		}
	},
	{
		view = 'scroller',
		class = 'scroller',
		style = {
			width = 700 * ratio,
			['background-color'] = '#FFFFFF',
			--['justify-content'] = 'center',
			['align-items'] = 'center'
		},
		subviews = {
			{
				view = 'div',
				style = {
					width = 700 * ratio,
					['background-color'] = '#FFFFFF',
					['justify-content'] = 'center',
					['align-items'] = 'center'
				},
				subviews = {
					{
						view = 'text',
						value = '\n请选择需要的功能\n\n',
						style = {
							['background-color'] = '#FFFFFF',
							['font-size'] = 26 * ratio,
							color = '#5f5f5f'
						}
					},
				}
			},
			
			wui.GridSelect.createLayout({id = generateGridID("选择功能"), list = generateGridList("选择功能"),
					config = {limit = #(generateGridList("选择功能")), totalWidth = 500 * ratio, gridStyle = generateGridStyle("选择功能")} }),
			{
				view = 'text',
				value = ' \n',
				style = {
					['background-color'] = '#FFFFFF',
					['font-size'] = 26 * ratio,
					color = '#5f5f5f'
				}
			},
			{
				view = 'div',
				style = {
					width = 500 * ratio,
					['background-color'] = '#FFFFFF',
					['flex-direction'] = 'row',
					['justify-content'] = 'flex-start',
				},
				subviews = 	{
					{
						view = 'text',
						value = '抽球位置		',
						style = {
							['background-color'] = '#FFFFFF',
							['font-size'] = 26 * ratio,
							color = '#5f5f5f'
						}
					},
					wui.GridSelect.createLayout({id = generateGridID("抽球位置"), list = generateGridList("抽球位置"),
							config = { single = true, totalWidth = 400  * ratio, gridStyle = generateGridStyle("抽球位置")} }),
				}
			},
			{
				view = 'text',
				value = ' \n',
				style = {
					['background-color'] = '#FFFFFF',
					['font-size'] = 10 * ratio,
					color = '#5f5f5f'
				}
			},
			{
				view = 'div',
				style = {
					width = 500 * ratio,
					['background-color'] = '#FFFFFF',
					['flex-direction'] = 'row',
					['justify-content'] = 'flex-start',
				},
				subviews = 	{
					{
						view = 'text',
						value = '抽球类型		',
						style = {
							['background-color'] = '#FFFFFF',
							['font-size'] = 26 * ratio,
							color = '#5f5f5f'
						}
					},
					wui.GridSelect.createLayout({id = generateGridID("抽球类型"), list = generateGridList("抽球类型"),
							config = { single = true, totalWidth = 318  * ratio, gridStyle = generateGridStyle("抽球类型")} }),
				}
			},
			{
				view = 'text',
				value = ' \n',
				style = {
					['background-color'] = '#FFFFFF',
					['font-size'] = 10 * ratio,
					color = '#5f5f5f'
				}
			},
			{
				view = 'div',
				style = {
					width = 500 * ratio,
					['background-color'] = '#FFFFFF',
					['flex-direction'] = 'row',
					['justify-content'] = 'flex-start',
					--['justify-content'] = 'center',
				},
				subviews = 	{
					{
						view = 'text',
						value = '抽球计时		',
						style = {
							['background-color'] = '#FFFFFF',
							['font-size'] = 26 * ratio,
							color = '#5f5f5f'
						}
					},
					{
						id = 'input_draw_ball',
						view = 'input',
						value = '13',
						--['placeholder'] = '请输入抽球点击等待时间',
						['type'] = 'number',
						['autofocus'] = false,
						['maxlength'] = 3,
						style = {
							width = 100,
							height = 30,
							['font-size'] = 22 * ratio,
							color = '#5f5f5f',
							['background-color'] = '#EEEEEE'
						}
					},
				}
			},
			{
				view = 'text',
				value = ' \n\n\n',
				style = {
					['background-color'] = '#FFFFFF',
					['font-size'] = 14 * ratio,
					color = '#5f5f5f'
				}
			},
		}
	},
	{
		view = 'div',
		style = {
			width = 700 * ratio,
			['background-color'] = '#FFFFFF',
			['justify-content'] = 'space-around',
		},
		subviews = {
			{
				view = 'text',
				value = ' ',
				style = {
					['font-size'] = 10 * ratio,
					color = '#5f5f5f'
				}
			},
			{
				view = 'div',
				style = {
					width = 700 * ratio,
					['background-color'] = '#FFFFFF',
					['flex-direction'] = 'row',
					--['justify-content'] = 'space-around',
					['justify-content'] = 'center',
				},
				subviews = {
					wui.GridSelect.createLayout({id = generateGridID("替补1"), list = generateGridList("替补1"),
							config = {single = true, totalWidth = 440 * ratio, gridStyle = generateGridStyle("替补1")}}),
					{
						view = 'text',
						value = '		',
						style = {
							['font-size'] = 20 * ratio,
							color = '#5f5f5f'
						}
					},
					wui.GridSelect.createLayout({id = generateGridID("状态1"), list = generateGridList("状态1"),
							config = {single = true, totalWidth = 160 * ratio, gridStyle = generateGridStyle("状态1")}}),
				},
			},
			{
				view = 'div',
				style = {
					width = 700 * ratio,
					['background-color'] = '#FFFFFF',
					['flex-direction'] = 'row',
					--['justify-content'] = 'space-around',
					['justify-content'] = 'center',
				},
				subviews = {
					wui.GridSelect.createLayout({id = generateGridID("替补2"), list = generateGridList("替补2"),
							config = {single = true, totalWidth = 440 * ratio, gridStyle = generateGridStyle("替补2")}}),
					{
						view = 'text',
						value = '		',
						style = {
							['font-size'] = 20 * ratio,
							color = '#5f5f5f'
						}
					},
					wui.GridSelect.createLayout({id = generateGridID("状态2"), list = generateGridList("状态2"),
							config = {single = true, totalWidth = 160 * ratio, gridStyle = generateGridStyle("状态2")}}),
				},
			},
			{
				view = 'div',
				style = {
					width = 700 * ratio,
					['background-color'] = '#FFFFFF',
					['flex-direction'] = 'row',
					--['justify-content'] = 'space-around',
					['justify-content'] = 'center',
				},
				subviews = {
					wui.GridSelect.createLayout({id = generateGridID("替补3"), list = generateGridList("替补3"),
							config = {single = true, totalWidth = 440 * ratio, gridStyle = generateGridStyle("替补3")}}),
					{
						view = 'text',
						value = '		',
						style = {
							['font-size'] = 20 * ratio,
							color = '#5f5f5f'
						}
					},
					wui.GridSelect.createLayout({id = generateGridID("状态3"), list = generateGridList("状态3"),
							config = {single = true, totalWidth = 160 * ratio, gridStyle = generateGridStyle("状态3")}}),
				},
			},
			{
				view = 'div',
				style = {
					width = 700 * ratio,
					['background-color'] = '#FFFFFF',
					['flex-direction'] = 'row',
					--['justify-content'] = 'space-around',
					['justify-content'] = 'center',
				},
				subviews = {
					wui.GridSelect.createLayout({id = generateGridID("替补4"), list = generateGridList("替补4"),
							config = {single = true, totalWidth = 440 * ratio, gridStyle = generateGridStyle("替补4")}}),
					{
						view = 'text',
						value = '		',
						style = {
							['font-size'] = 20 * ratio,
							color = '#5f5f5f'
						}
					},
					wui.GridSelect.createLayout({id = generateGridID("状态4"), list = generateGridList("状态4"),
							config = {single = true, totalWidth = 160 * ratio, gridStyle = generateGridStyle("状态4")}}),
				},
			},
			{
				view = 'div',
				style = {
					width = 700 * ratio,
					['background-color'] = '#FFFFFF',
					['flex-direction'] = 'row',
					--['justify-content'] = 'space-around',
					['justify-content'] = 'center',
				},
				subviews = {
					wui.GridSelect.createLayout({id = generateGridID("替补5"), list = generateGridList("替补5"),
							config = {single = true, totalWidth = 440 * ratio, gridStyle = generateGridStyle("替补5")}}),
					{
						view = 'text',
						value = '		',
						style = {
							['font-size'] = 20 * ratio,
							color = '#5f5f5f'
						}
					},
					wui.GridSelect.createLayout({id = generateGridID("状态5"), list = generateGridList("状态5"),
							config = {single = true, totalWidth = 160 * ratio, gridStyle = generateGridStyle("状态5")}}),
				},
			},
			{
				view = 'div',
				style = {
					width = 700 * ratio,
					['background-color'] = '#FFFFFF',
					['flex-direction'] = 'row',
					--['justify-content'] = 'space-around',
					['justify-content'] = 'center',
				},
				subviews = {
					wui.GridSelect.createLayout({id = generateGridID("替补6"), list = generateGridList("替补6"),
							config = {single = true, totalWidth = 440 * ratio, gridStyle = generateGridStyle("替补6")}}),
					{
						view = 'text',
						value = '		',
						style = {
							['font-size'] = 20 * ratio,
							color = '#5f5f5f'
						}
					},
					wui.GridSelect.createLayout({id = generateGridID("状态6"), list = generateGridList("状态6"),
							config = {single = true, totalWidth = 160 * ratio, gridStyle = generateGridStyle("状态6")}}),
				},
			},
			{
				view = 'div',
				style = {
					width = 700 * ratio,
					['background-color'] = '#FFFFFF',
					['flex-direction'] = 'row',
					--['justify-content'] = 'space-around',
					['justify-content'] = 'center',
				},
				subviews = {
					wui.GridSelect.createLayout({id = generateGridID("替补7"), list = generateGridList("替补7"),
							config = {single = true, totalWidth = 440 * ratio, gridStyle = generateGridStyle("替补7")}}),
					{
						view = 'text',
						value = '		',
						style = {
							['font-size'] = 20 * ratio,
							color = '#5f5f5f'
						}
					},
					wui.GridSelect.createLayout({id = generateGridID("状态7"), list = generateGridList("状态7"),
							config = {single = true, totalWidth = 160 * ratio, gridStyle = generateGridStyle("状态7")}}),
				},
			},
			{
				view = 'text',
				value = ' ',
				style = {
					['font-size'] = 20 * ratio,
					color = '#5f5f5f'
				}
			},
		}
	},
	{
		view = 'scroller',
		class = 'scroller',
		style = {
			width = 700 * ratio,
			['background-color'] = '#FFFFFF'
		},
		subviews = {
			{
				view = 'text',
				value = '1.脚本说明',
				style = {
					['padding-left'] = 20 * ratio,
					['padding-top'] = 20 * ratio,
					['padding-bottom'] = 2 * ratio,
					['font-size'] = 18 * ratio,
					color = '#5f5f5f'
				}
				
			},
			{
				view = 'text',
				value = '本脚本为“实况足球辅助”全分辨率测试版，采用了全新的全分辨架构，同时基于叉叉平台最新的2.0引擎开发，但2.0引擎目前还处于内测阶段，可能还'
				..'不太稳定，因此对脚本本身的稳定性也有一定影响。此内测版本免费测试使用，内测的目的是希望大家积极测试并反馈问题以便尽快修复和完善各个功能，故而'
				..'可能不会对测试版用户过多的基础操作指导，于此，主要推荐已经能熟练使用之前的正式版的玩家进行测试，有问题请及时在测试群里@我，最好有配图或者视频。'
				..'推荐使用小号测试',
				style = {
					['padding-left'] = 20 * ratio,
					['padding-right'] = 20 * ratio,
					['font-size'] = 16 * ratio,
					color = '#5f5f5f'
				}
			},
			{
				view = 'text',
				value = '2.功能说明',
				style = {
					['padding-left'] = 20 * ratio,
					['padding-top'] = 20 * ratio,
					['padding-bottom'] = 5 * ratio,
					['font-size'] = 18 * ratio,
					color = '#5f5f5f'
				}
			},
			{
				view = 'text',
				value = 'a.任务界面：可以选择任务类型，目前仅支持联赛教练模式和天梯教练模式，并可在下方选择循环运行的次数。\nb.功能界面：球员'
				..'续约为联赛模式时，如果出现球员合同耗尽的情况就自动续约；等待恢复为当能量耗尽时，脚本暂停100分钟等待能量恢复，然后再继续运行；购买能'
				..'量为能量耗尽时使用金币自动购买能量；开场换人是在开始比赛前，根据场上和替补席的球员状态自动调整阵容，具体的规则在“换人设置”页面中'
				..'设置；自动重启为当游戏闪退后者卡死时，可以自动重启游戏并继续任务，一般只推荐在root的手机或模拟器上使用\nc.换人设置：P1-P7为替补'
				..'席从上到下第1-7个替补球员，1-11是将场上球员严格按照从上到下，从左到右的顺序规则编为1-11号，每一个替补选择对应的更换位置，同时需设'
				..'置好换人条件，球员状态根据箭头方向分为5档，可设置当替补状态比场上球员好几档才更换，或者设置为只有当场上球员状态为红（箭头向下状态'
				..'极差）才进行更换，编号示意图如下：\n',
				style = {
					['padding-left'] = 20 * ratio,
					['padding-right'] = 20 * ratio,
					['font-size'] = 16 * ratio,
					color = '#5f5f5f'
				}
				
			},
			{
				view = 'image',
				src = 'xsp://substitute.jpg',
				resize = 'stretch',
				style = {
					width = 260 * ratio,
					height = 160 * ratio,
					['padding-left'] = 20 * ratio,
					['padding-bottom'] = 10 * ratio,
				}
			},
			{
				view = 'text',
				value = '3.高级功能',
				style = {
					['padding-left'] = 20 * ratio,
					['padding-top'] = 20 * ratio,
					['padding-bottom'] = 5 * ratio,
					['font-size'] = 18 * ratio,
					color = '#5f5f5f'
				}
			},
			{
				view = 'div',
				style = {
					width = 700 * ratio,
					['background-color'] = '#FFFFFF',
					['flex-direction'] = 'row',
					['justify-content'] = 'space-around',
					--['justify-content'] = 'center',
				},
				subviews = {
					wui.GridSelect.createLayout({id = generateGridID("清空缓存"), list = generateGridList("清空缓存"),
							config = {single = true, totalWidth = 250 * ratio, gridStyle = generateGridStyle("清空缓存")}}),
					{
						view = 'text',
						value = ' \n',
						style = {
							['font-size'] = 18 * ratio,
							color = '#5f5f5f'
						}
					},
					wui.GridSelect.createLayout({id = generateGridID("缓存模式"), list = generateGridList("缓存模式"),
							config = {single = true, totalWidth = 250 * ratio, gridStyle = generateGridStyle("缓存模式")}}),
				},
			},
			{
				view = 'text',
				value = ' \n',
				style = {
					['font-size'] = 10 * ratio,
					color = '#5f5f5f'
				}
			},
			{
				view = 'div',
				style = {
					width = 700 * ratio,
					['background-color'] = '#FFFFFF',
					['flex-direction'] = 'row',
					--['justify-content'] = 'space-start',
					['padding-left'] = 30 * ratio,
				},
				subviews = {
					wui.GridSelect.createLayout({id = generateGridID("日志记录"), list = generateGridList("日志记录"),
					config = {single = true, totalWidth = 250 * ratio, gridStyle = generateGridStyle("日志记录")}}),
				},
			},
			{
				view = 'text',
				value = ' \n\n\n',
				style = {
					['font-size'] = 18 * ratio,
					color = '#5f5f5f'
				}
			},
		}
	},
}

local tabPageConfig = {}
tabPageConfig.currentPage = 1
tabPageConfig.pageWidth = 700 * ratio
tabPageConfig.pageHeight = 400 * ratio
tabPageConfig.tabTitles = {
	{
		title = '任务选择',
	},
	{
		title = '功能设置',
	},
	{
		title = '换人设置',
	},
	{
		title = '使用教程',
	},
}

tabPageConfig.tabStyle = {
	backgroundColor = '#F0F0F0',
	titleColor = '#666666',
	activeTitleColor = '#3D3D3D',
	activeBackgroundColor = '#F0F0F0',
	isActiveTitleBold = true,
	iconWidth = 0,
	iconHeight = 0,
	width = 160 * ratio,
	height = 50 * ratio,
	fontSize = 24 * ratio,
	hasActiveBottom = true,
	activeBottomColor = '#FFC900',
	activeBottomHeight = 6,
	activeBottomWidth = 120,
	textPaddingLeft = 10,
	textPaddingRight = 10
}

tabPageConfig.wrapBackgroundColor= '#FFFFFF'

local context = UI.createContext(rootLayout, globalStyle)
local rootView = context:getRootView()

local tabPage = wui.TabPage.createView(context, { pages = pages, config = tabPageConfig })
rootView:addSubview(tabPage)

wui.TabPage.setOnSelectedCallback(tabPage, function (id, currentPage)
		print('wui.TabPage id: ' .. id)
		print('wui.TabPage currentPage: ' .. tostring(currentPage))
	end)

wui.Button.setOnClickedCallback(context:findView('btn_taskCancle'), function (id, action)
		printf('wui.Button %s click', id)
		
		uiClosedFlag = true
		context:close()
		xmod.exit()
	end
)

wui.Button.setOnClickedCallback(context:findView('btn_taskOk'), function (id, action)
		printf('wui.Button %s click', id)
		prt(USER.TASK_NAME)
		prt(USER.REPEAT_TIMES)
		
		for k, v in pairs(_gridList) do
			if v.tag == "选择任务" or v.tag == "任务次数" then
				checkedFlag = false
				for _k, _v in pairs(v.checkedList) do
					if not v.list[_v].disabled then
						checkedFlag = true
						break
					end
				end
				if not checkedFlag then
					Log("not checked TASK_NAME or TASK_REPEATE")
					return
				end
			end
		end
		
		submitGridChecked()
		
		
		local countTime = context:findView('input_draw_ball'):getAttr("value")
		if countTime then
			Log("抽球即使："..tonumber(countTime))
			USER.DRAW_STOP_TIME = tonumber(countTime)
		end
		
		showwingFlag = false
		context:close()
		
		return
	end
)

local function setGridDefualtCallbacks()
	for k, v in pairs(_gridList) do
		wui.GridSelect.setOnSelectedCallback(context:findView(generateGridID(v.tag)), function (id, index, checked, checkedList)
				print('wui.GridSelect index: ' .. tostring(index))
				print('wui.GridSelect checked: ' .. tostring(checked))
				for i, v in ipairs(checkedList) do
					print('> wui.GridSelect checkedList index: ' .. tostring(v))
				end
				prt(checkedList)
				setGridChecked(parserGridID(id), checkedList)
			end
		)
	end
end

function dispUI()
	if not IS_BREAKING_TASK then
		print('show view')
		context:show()
		showwingFlag = true
	else
		showwingFlag = false
		submitGridChecked()
	end
	
	context:findView('input_draw_ball'):setActionCallback(UI.ACTION.INPUT, function() end)
	
	while showwingFlag do
		sleep(200)
	end
	
	--prt(USER)
end


setGridDefualtCallbacks()
