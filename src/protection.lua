


function ProtectionMenu()
local id_protection = Struct.ProtectionMenu.ItemIndex;
	switch(id_protection,
		{
			[0] = function ()
				NotificationPopUpMapRockstar("Protection",[[~a~~s~ Anti Apartment Invite]])
				if ReadAct("Anti Apartment Invite")==false then SetList("Anti Apartment Invite",true)
				elseif ReadAct("Anti Apartment Invite")==true then SetList("Anti Apartment Invite",false)
				end 
			end,
			[1] = function ()
				NotificationPopUpMapRockstar("Protection",[[~a~~s~ Anti Kick Protection]])
				if ReadAct("Anti Kick Protection")==false then SetList("Anti Kick Protection",true)
				elseif ReadAct("Anti Kick Protection")==true then SetList("Anti Kick Protection",false)
				end
			end,
			[2] = function ()
				NotificationPopUpMapRockstar("Protection",[[~a~~s~ Anti CEO Ban]])
				if ReadAct("Anti CEO Ban")==false then SetList("Anti CEO Ban",true)
				elseif ReadAct("Anti CEO Ban")==true then SetList("Anti CEO Ban",false)
				end
			end,
			[3] = function ()
				NotificationPopUpMapRockstar("Protection",[[~a~~s~ Anti CEO Kick]])
				if ReadAct("Anti CEO Kick")==false then SetList("Anti CEO Kick",true)
				elseif ReadAct("Anti CEO Kick")==true then SetList("Anti CEO Kick",false)
				end
			end,
			[4] = function ()
				NotificationPopUpMapRockstar("Protection",[[~a~~s~ Anti Vehicle Kick]])
				if ReadAct("Anti Vehicle Kick")==false then SetList("Anti Vehicle Kick",true)
				elseif ReadAct("Anti Vehicle Kick")==true then SetList("Anti Vehicle Kick",false)
				end
			end,
			[5] = function ()
				NotificationPopUpMapRockstar("Protection",[[~a~~s~ Anti Force Mission]])
				if ReadAct("Anti Force Mission")==false then SetList("Anti Force Mission",true)
				elseif ReadAct("Anti Force Mission")==true then SetList("Anti Force Mission",false)
				end
			end,
			[6] = function ()
				NotificationPopUpMapRockstar("Protection",[[~a~~s~ Anti Passive Mode Block]])
				if ReadAct("Anti Passive Mode Block")==false then SetList("Anti Passive Mode Block",true)
				elseif ReadAct("Anti Passive Mode Block")==true then SetList("Anti Passive Mode Block",false)
				end
			end,
			[7] = function ()
				NotificationPopUpMapRockstar("Protection",[[~a~~s~ Anti Sound Notification Spam]])
				if ReadAct("Anti Sound Notif")==false then SetList("Anti Sound Notif",true)
				elseif ReadAct("Anti Sound Notif")==true then SetList("Anti Sound Notif",false)
				end
			end,
			[8] = function ()
				NotificationPopUpMapRockstar("Protection",[[~a~~s~ Anti Animation Freeze]])
				if ReadAct("Clear Ped Task")==false then SetList("Clear Ped Task",true)
				elseif ReadAct("Clear Ped Task")==true then SetList("Clear Ped Task",false)
			  	end
			end,
			[9] = function ()
				NotificationPopUpMapRockstar("Protection",[[~a~~s~ Anti Network PTFX]])
				if ReadAct("Network PTFX")==false then SetList("Network PTFX",true)
				elseif ReadAct("Network PTFX")==true then SetList("Network PTFX",false)
			  	end
			end,
			[10] = function ()
				NotificationPopUpMapRockstar("Protection",[[~a~~s~ Request Control Event]])
				if ReadAct("Request Control Event")==false then SetList("Request Control Event",true)
				elseif ReadAct("Request Control Event")==true then SetList("Request Control Event",false)
			  	end
			end,
			[11] = function ()
				NotificationPopUpMapRockstar("Protection",[[~a~~s~ Anti Ragdoll Request]])
				if ReadAct("Ragdoll Request Block")==false then SetList("Ragdoll Request Block",true)
				elseif ReadAct("Ragdoll Request Block")==true then SetList("Ragdoll Request Block",false)
			  	end
			end,
			[12] = function ()
				NotificationPopUpMapRockstar("Protection",[[~a~~s~ Report Check Activated]])
				if ReadAct('Block Reports')==false then SetList('Block Reports',true)
				elseif ReadAct('Block Reports')==true then SetList('Block Reports',false)
			   end
			end,
			[13] = function ()
				NotificationPopUpMapRockstar("Protection",[[~a~~s~ Block Reports]])
				if ReadAct('Increment Stat Event')==false then SetList('Increment Stat Event',true)
				elseif ReadAct('Increment Stat Event')==true then SetList('Increment Stat Event',false)
			   end
			end,
			[14] = function ()
				NotificationPopUpMapRockstar("Protection",[[~a~~s~ Anti Report Cash Spawn Event]])
				if ReadAct('Report Cash Spawn Event')==false then SetList('Report Cash Spawn Event',true)
				elseif ReadAct('Report Cash Spawn Event')==true then SetList('Report Cash Spawn Event',false)
			   end
			end,
			[15] = function ()
				NotificationPopUpMapRockstar("Protection",[[~a~~s~ Anti Report Cash Spawn Event]])
				if ReadAct('Request Pickup')==false then SetList('Request Pickup',true)
				elseif ReadAct('Request Pickup')==true then SetList('Request Pickup',false)
			   end
			end,
			[16] = function ()
				NotificationPopUpMapRockstar("Protection",[[~a~~s~ Anti Vehicle Component Control]])
				if ReadAct('Vehicle Component Control')==false then SetList('Vehicle Component Control',true)
				elseif ReadAct('Vehicle Component Control')==true then SetList('Vehicle Component Control',false)
			   end
			end,
			[17] = function ()
				NotificationPopUpMapRockstar("Protection",[[~a~~s~ Anti Remot Teleport]])
				if ReadAct('Remot Teleport Disable')==false then SetList('Remot Teleport Disable',true)
				elseif ReadAct('Remot Teleport Disable')==true then SetList('Remot Teleport Disable',false)
			   end
			end,
			[18] = function ()
				NotificationPopUpMapRockstar("Protection",[[~a~~s~ Anti Weather Control]])
				if ReadAct('Weather Event')==false then SetList('Weather Event',true)
				elseif ReadAct('Weather Event')==true then SetList('Weather Event',false)
			   end
			end,
			[19] = function ()
				NotificationPopUpMapRockstar("Protection",[[~a~~s~ Anti Game Clock Control]])
				if ReadAct('Game Clock Event')==false then SetList('Game Clock Event',true)
				elseif ReadAct('Game Clock Event')==true then SetList('Game Clock Event',false)
			   end
			end,
			[20] = function ()
				NotificationPopUpMapRockstar("Protection",[[~a~~s~ Anti Remove All Weapon]])
				if ReadAct('Remove All Weapon')==false then SetList('Remove All Weapon',true)
				elseif ReadAct('Remove All Weapon')==true then SetList('Remove All Weapon',false)
			   end
			end,
			[21] = function ()
				NotificationPopUpMapRockstar("Protection",[[~a~~s~ Anti Remote Remove Weapon]])
				if ReadAct('Remot Remove Weapon')==false then SetList('Remot Remove Weapon',true)
				elseif ReadAct('Remot Remove Weapon')==true then SetList('Remot Remove Weapon',false)
			   end
			end,
			[22] = function ()
				NotificationPopUpMapRockstar("Protection",[[~a~~s~ Anti Alter Wanted Level]])
				if ReadAct('Alter Wanted Level')==false then SetList('Alter Wanted Level',true)
				elseif ReadAct('Alter Wanted Level')==true then SetList('Alter Wanted Level',false)
			   end
			end,
			[23] = function ()
				NotificationPopUpMapRockstar("Protection",[[~a~~s~ Anti Scripted Game Event]])
				if ReadAct('Scripted Game Event')==false then SetList('Scripted Game Event',true)
				elseif ReadAct('Scripted Game Event')==true then SetList('Scripted Game Event',false)
			   end
			end,
			[24] = function ()
				NotificationPopUpMapRockstar("Protection",[[~a~~s~ Anti Explosion Blame]])
				if ReadAct('Explosion Block')==false then SetList('Explosion Block',true)
				elseif ReadAct('Explosion Block')==true then SetList('Explosion Block',false)
			   end
			end,
			[25] = function ()
				NotificationPopUpMapRockstar("Protection",[[~a~~s~ Anti Kick Votes]])
				if ReadAct('Kick Votes')==false then SetList('Kick Votes',true)
				elseif ReadAct('Kick Votes')==true then SetList('Kick Votes',false)
			   end
			end,
			[26] = function ()
				NotificationPopUpMapRockstar("Protection",[[~a~~s~ Anti Network Check Code CRCS]])
				if ReadAct('Check Code CRCS')==false then SetList('Check Code CRCS',true)
				elseif ReadAct('Check Code CRCS')==true then SetList('Check Code CRCS',false)
			   end
			end,
		}

	)
end