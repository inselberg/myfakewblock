--Platanius
--Gunry-Rashgarroth
-- class erzeugen
myfakewblock = LibStub("AceAddon-3.0"):NewAddon("myfakewblock", "AceConsole-3.0","AceEvent-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale("myfakewblock",true)

local defaults = {
    profile =  {
        log ={}

    },
}


local options = {
    name = "myfakewblock",
    handler = myfakewblock,
    type = 'group',
    args = {
       cmds = {
		type = "group",
		name = "ueber", -- L["About"],
		cmdInline = true,
		order = 1,

		args = {
			debug = {
				order = 1,
				type = "execute",
				name = "debug ",
				desc = "",
				func = "debug",
				guiHidden = true,
				},



			info = {
				order = 1,
				type = "execute",
				name = "info ",
				desc = "description zeugs",
				func = "Info",
				guiHidden = true,
				},

			list = {
				order = 1,
				type = "execute",
				name = "list ",
				desc = "description zeugs",
				func = "list",
				guiHidden = true,
				},


			bl = {
				order = 1,
				type = "execute",
				name = "info ",
				desc = "",
				func = "ShowBlacklist",
				guiHidden = true,
				},



			test = {
				order = 1,
				type = "execute",
				name = "info ",
				desc = "description zeugs",
				func = "Test",
				guiHidden = true,
				},

			add = {
				type = "input",
				name = "Message",
				desc = "add user to blacklist",
				usage = "<Your message>",
				get = "GetMessage",
				set = "AddNameToBlacklist",
			},

			del = {
				type = "input",
				name = "Message",
				desc = "del user from blacklist",
				usage = "<Your message>",
				get = "GetMessage",
				set = "DelNameFromBlacklist",
			},


			gui = {
				order = 3,
				type = "execute",
				name = "gui stuff",
				desc = "gui test",
				func = "GuiCheck",
				guiHidden = true,
				},



			}, -- args
		}, -- cmds




		} -- args

} -- options



---------------------------------------------------------------------------
--
--
function myfakewblock:OnInitialize()

	self.db = LibStub("AceDB-3.0"):New("myfakewblockDB",default,true)
	--self.db:SetProfil(UnitName("player"))

    -- Called when the addon is loaded
    LibStub("AceConfig-3.0"):RegisterOptionsTable("myfakewblock", options)

    self.optionsFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("myfakewblock", "myfakewblock")

    self:RegisterChatCommand("myfakewblock", "ChatCommand")
    self:RegisterChatCommand("mfw", "ChatCommand")


    -- ini var
	self.log = self.db.profile.log

	if self.log == nil then
		self.log = {}


		local blname = self:GetBlListItemName()
		self.log[blname] = {}
		self.log["log"] = {}
	end

	--self.timetable = self.db.char.timetable
	--if self.timetable == nil then self.timetable = {} end



end



function myfakewblock:ChatCommand(input)
    if not input or input:trim() == "" then
 --       LibStub("AceConfigDialog-3.0"):Open("mil")
		self:Info()
		UIErrorsFrame:AddMessage(GetSubZoneText(), 1.0, 1.0, 1.0, 5.0)
    else
        LibStub("AceConfigCmd-3.0").HandleCommand(myfakewblock, "mfw", "myfakewblock", input)
    end
end






-- Called when the addon is enabled
function myfakewblock:OnEnable()
	-- myfunctions einbinden
	self.f = cFunctions.create()

	self:Print("enabled")
	self:Info()

	self:RegisterEvent("CHAT_MSG_WHISPER")
    self:RegisterEvent("CHAT_MSG_CHANNEL")
	self:RegisterEvent("CHAT_MSG_PARTY")


	--ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL",xxxmsgFilter)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL",myfakewblock.msgFilter)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_PARTY",myfakewblock.msgFilter)

end


function myfakewblock:OnDisable()
    -- Called when the addon is disabled
	ChatFrame_RemoveMessageEventFilter("CHAT_MSG_CHANNEL",myfakewblock.msgFilter)
	ChatFrame_RemoveMessageEventFilter("CHAT_MSG_PARTY",myfakewblock.msgFilter)
end

function myfakewblock:GetMessage(info)
    return self.message
end


-- server u bl hinzufuegen
-- GetRealmName()
function myfakewblock:AddNameToBlacklist(info, value)
local blname = self:GetBlListItemName()
	if ( value == nil ) or (value == "")
	then self:Print("add <playername>")
	else
		self:Print("'"..value.."' added to "..blname)
		local bl = self.log[blname]
		bl = self.f:AddUniqueToTable(bl,value)
		self.log[blname] = bl
		self.db.profile.log = self.log

	end

end

function myfakewblock:DelNameFromBlacklist(info, value)
local blname = self:GetBlListItemName()
if ( value == nil ) or (value == "")
	then self:Print("del <playername>")
	else
		local bl = self.log[blname]
		if self.f:indexof(bl,value) > -1 then
			self:Print("'"..value.."' deleted from "..blname)
			self.f:DeleteFromTable(bl,value)
			self.log[blname] = bl
		end
	end

end


-- EVENTS



function myfakewblock:CHAT_MSG_WHISPER(event,msg,autor)
	self:cmw(autor,msg)
end

function myfakewblock:CHAT_MSG_CHANNEL(event,msg,autor)
--	self:cmp(msg,autor)
end


function myfakewblock:CHAT_MSG_PARTY(event,msg,autor)
--	self:cmp(msg,autor)
end

---------------------------------------------------------------------------

function xxxmsgFilter(self, event, msg, author, ...)
--	print(msg)
	local NewMessage = '*'..msg

	return false, NewMessage, author, ...
end

--
-- FILTER!!! dummerweise wird self nicht mitübergeben darum "global" callen
--
function myfakewblock:msgFilter(event, msg, author, ...)
	if author ~= nil then
		nick=author
		p=string.find(nick,'|')
		if p ~= nil then nick=string.sub(str,1,p-1);end
		print(nick.."|"..msg);

		--server suchen
		server="***"
		p=string.find(nick,'-')
		if p ~= nil then
			str=nick
			nick=string.sub(str,1,p-1)
			server=string.sub(str,p+1,string.len(str))
		end
		print(nick.."|"..server.."|"..msg);



		if myfakewblock:isBlacklisted(nick) == true then print('..true');else print('..false');end

	--print(autor.."|"..msg.."|"..myfakewblock:isBlacklisted(author))

		if myfakewblock:isBlacklisted(nick) == true then
			local NewMessage = myfakewblock.f:ColorStr("red","[BL]")..msg
			return false, NewMessage, author, ...
		end
	end


end

---------------------------------------------------------------------------

--
--
--
function myfakewblock:GetBlListItemName()
	return "blacklist - "..GetRealmName()
end


function myfakewblock:cmp(msg,autor)
	self:Print('<'..autor..">"..msg)
end


--
--
--
function myfakewblock:Info()
	self:Print("info:")
	self:Print("..log length: "..#self.log["log"])
	self:ShowBlacklist()
	self.f:dummy()
end

function myfakewblock:list()
	self:Info()
end

--
--
--
function myfakewblock:GetDebugVar()
	return self.debugvar
end

function myfakewblock:debug()
	--self.f:dummy()

if self.debugvar == nil then self.debugvar = 1;else self.debugvar = (self.debugvar+1)%2;end;
	print("debug: "..self.debugvar)
end



--
--
--
function myfakewblock:ShowBlacklist()
	self:Print("show blacklist:")
	local bl = self.log[self:GetBlListItemName()]

	if bl == nil then
		self:Print("..blacklisted: nil")
	else
		self:Print("..blacklisted: "..#bl)
		for i,v in ipairs(bl) do
			self:Print(v)
		end
	end

end

--
-- nur suche bei aktuellen daten
--
function myfakewblock:isBlacklisted(name)
	local bl = self.log[self:GetBlListItemName()]
	local idx=self.f:indexof(bl,name)

	return idx>-1
	--return idx==-1
end


function myfakewblock:Test()
--	 myfakewblock:isBlacklisted(name)
	--self:ShowBlacklist()
	if self:isBlacklisted('inselberg') == false then
		print('isnt bl')
	end
	--print('...'..txt)
end


function myfakewblock:cmw(autor,msg)
	if autor ~= UnitName("player")	then
		self.log = self:AddToLog(self.log,autor,msg)

		if self.log["blacklisted"] and ( self.log["mute"] == 0 ) then
			p(self.log)
			SendChatMessage(self.log["rewhisp"],"WHISPER", nil,autor);
		end

	end

end


function p(log,tt)
	if tt == nil then tt = time() end
	local d = dt(tt)

	print("["..d.."] /w "..log["whisper"].." '"..log["whisp"].."'")
	if log["blacklisted"] then
		print("["..d.."] <bot>"..log["rewhisp"].."\n")
	end

end



function RandomChar()
 local r = math.random(3)

 local ch = ""
 if r == 1 then ch = string.char(65+math.random(0,25))
 elseif r == 2 then ch = string.lower(string.char(65+math.random(0,25)))
 else ch = math.random(0,9)
 end

 return ch

end


function RandomString(max)
  if ( max == nil )  or ( max < 8 ) then max = 12 end
  local str = ""

  local r = math.random(8,max)

  for i=1,r do
   str = str..RandomChar()
  end

  return str
end


--
--
--
function myfakewblock:AddToLog(tab,_name,_msg,_timedummy)
	if _timedummy == nil then _timedummy = time() end
	local t = _timedummy

	local bl = self.log[self:GetBlListItemName()]

	local mute = 0
	local log = tab["log"]
	if log == nil then log = {} end



	print("_name:".._name)

	local idx = self.f:indexof(bl,_name)

	tab["blacklisted"] = idx ~= -1

	if tab["blacklisted"] == true then

	local title = "whisper block"
	local str1st = "type '"..RandomString().."' in order to send your message"
	local str2nd = "wrong password!! "..str1st
	local str9th = "your message ist blocked .. try again in 5minutes"

	local item = {
		name = _name,
		msg = _msg,
		count = 1,
		lastw = t,
		mute = 0,
		banntime = 0
	}

	--print("--------------------------------");	print("/w ".._name.." '".._msg.."'")

	-- suche einträge
	local found = #log+1
	for i=1,#log do
		if string.lower(log[i]["name"]) == string.lower(_name) then

			found = i
			item = log[found]

			-- bannzeiten reseten
			if item["banntime"] > 0 then
				if t > item["banntime"] then
					item["banntime"] = 0
					item["count"] = 0
					item["first"] = t
				end
			end


			item["count"] = log[i]["count"]+1
			item["lastw"] = t - item["first"]
			item["msg"] = _msg


		end
	end

	if ( found == #log+1 )
	then item["first"] = t
	--else item["lastw"] = t - item["first"]

	end

	item["lastw"] = t - item["first"]


--	io.write(#log + 1..msg.."\n")

	str = str9th


	local count = item["count"]
	if count == 1
	then str = str1st
	elseif count <= 3 then str = str2nd
	else item["banntime"] = t + 300
	end

	if count > 6 then mute = 1 end

	log[found] = item
	tab["log"] = log

	tab["rewhisp"] = "["..title.." ON] "..str
	tab["banntime"] = item["banntime"]

	end -- idx
	tab["mute"] = mute
	tab["whisper"] = _name
	tab["whisp"] = _msg


	return tab
end


