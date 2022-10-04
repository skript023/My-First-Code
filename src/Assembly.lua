----------------------------------------------CT2 [Main Menu Checkbox List]------------------------------------------------------
GodmodeAssembler = [[
        [ENABLE]
        {$lua}
        local Godmode = true;
        gmode=true
        local co = Asynchronous(function()
        -- Check if isRunning is false..
        while (Godmode == true) do
                -- Do your single-tick of work here..
                PLAYER.SET_PLAYER_INVINCIBLE(true)
                if gmode == false then
                PLAYER.SET_PLAYER_INVINCIBLE(false)
                isRunning = false;
                break
                end
                Async();
        end
        end);
        AsyncStart(co,1000)
        [DISABLE]
        {$lua}
        gmode = false
]]

AutohealScript = [[
        [ENABLE]
        {$lua}
        AutoHealPlayer(true)
        [DISABLE]
        {$lua}
        AutoHealPlayer(false)
]]

HealthRegenScript = [[
        [ENABLE]
        {$lua}
        HealthRegeneration(true)

        [DISABLE]
        {$lua}
        HealthRegeneration(false)
]]

NeverWantedScript = [[
        [ENABLE]
        {$lua}
        NoWantedTimer = createTimer()
        NoWantedTimer.Interval = 1500-- 1.5 seconds
        NoWantedTimer.OnTimer = function()
        PLAYER.SET_PLAYER_WANTED_LEVEL(0)
        end
        [DISABLE]
        {$lua}
        NoWantedTimer.Destroy();
        PLAYER.SET_PLAYER_WANTED_LEVEL(0)
]]

NoRagdollScript = [[
        [ENABLE]
        {$lua}

        PLAYER.SET_PLAYER_NO_RAGDOLL(true)
        [DISABLE]
        {$lua}
        PLAYER.SET_PLAYER_NO_RAGDOLL(false)
]]

NoCollitionScript = [[
        [ENABLE]
        {$lua}

        THREAD.LOOPING(NoCollision,true,-1,2000)
        [DISABLE]
        {$lua}
        THREAD.LOOPING(NoCollision,false,0.25,2000)
]]

InfiniteAmmoScript = [[
        [ENABLE]
        {$lua}
        InfiniteAmmoLoop(true)
        [DISABLE]
        {$lua}
        InfiniteAmmoLoop(false)
]]

BurstScript = [[
        [ENABLE]
        {$lua}
        set.int("[[[[WorldPTR]+8]+10D8]+20]+120",10)
        set.float("[[[[WorldPTR]+8]+10D8]+20]+124",0.200000003)
        [DISABLE]
        {$lua}
        set.int("[[[[WorldPTR]+8]+10D8]+20]+120",1)
        set.float("[[[[WorldPTR]+8]+10D8]+20]+124",0)
]]

SetAimAssistedScript = [[
        [ENABLE]
        {$lua}
        SetAssistedAim(true)
        {$asm}
        [DISABLE]
        {$lua}
        SetAssistedAim(false)
        {$asm}
]]

AllMissionLivesScript = [[
        [ENABLE]
        {$lua}
        AllMissionLives(true)
        [DISABLE]
        {$lua}
        AllMissionLives(false)
]]

CrewCutToZeroScript = [[
        [ENABLE]
        {$lua}
        RemoveCrewCutToZero(true)
        [DISABLE]
        {$lua}
        RemoveCrewCutToZero(false)
]]

RemoveCrewCutScript = [[
        [ENABLE]
        {$lua}
        CasinoHeistCrewRemove(true)
        [DISABLE]
        {$lua}
        CasinoHeistCrewRemove(false)
]]

SuperJumpScript = [[
        [ENABLE]
        {$lua}
        g_frameTimer.Enabled = true
        g_superJump = true
        [DISABLE]
        {$lua}
        g_frameTimer.Enabled = false
        g_superJump = false

]]

ExplosiveAmmoScript = [[
        [ENABLE]
        {$lua}
        g_frameTimer.Enabled = true
        g_explosiveAmmo = true
        [DISABLE]
        {$lua}
        g_frameTimer.Enabled = false
        g_explosiveAmmo = false
]]

FlammingAmmoScript = [[
        [ENABLE]
        {$lua}
        g_frameTimer.Enabled = true
        g_flamingAmmo = true
        [DISABLE]
        {$lua}
        g_frameTimer.Enabled = false
        g_flamingAmmo = false

]]

ExplotiveFistScript = [[
        [ENABLE]
        {$lua}
        g_frameTimer.Enabled = true
        g_flamingFists = true
        [DISABLE]
        {$lua}
        g_frameTimer.Enabled = false
        g_flamingFists = false
]]

AntiKickScript = [==[
        [ENABLE]
        {$lua}
        AntiAFKLobby(true)
        [DISABLE]
        {$lua}
        AntiAFKLobby(false)
]==]

BulletproofScript = [[
        [ENABLE]
        {$lua}
        NoDamageToPlayer(true)
        [DISABLE]
        {$lua}
        NoDamageToPlayer(false)
]]

WaterproofScript = [[
        [ENABLE]
        {$lua}

        set.int("[[WorldPTR]+8]+188",0x1000000)
        [DISABLE]
        {$lua}
        set.int("[[WorldPTR]+8]+188",4194316)
]]

KillAllEnemiesScript = [[
        [ENABLE]
        {$lua}
        THREAD.YIELD(Kill_Enemy,true,0,1000)
        [DISABLE]
        {$lua}
        THREAD.YIELD(Kill_Enemy,false,0,1000)
]]

KillAllNPCScript = [[
        [ENABLE]
        {$lua}
        THREAD.YIELD(Kill_All_Ped,true,0,1000)
        [DISABLE]
        {$lua}
        THREAD.YIELD(Kill_All_Ped,false,0,1000)
]]

KillAllPoliceScript = [[
        [ENABLE]
        {$lua}
        THREAD.YIELD(Kill_Police,true,0,1000)
        [DISABLE]
        {$lua}
        THREAD.YIELD(Kill_Police,false,0,1000)
]]

DestroyAllVehicleScript = [[
        [ENABLE]
        {$lua}
        THREAD.YIELD(Destroy_All_Veh,true,-999,3000)
        [DISABLE]
        {$lua}
        THREAD.YIELD(Destroy_All_Veh,false,0,3000)
]]

HealAllVehicleScript = [[
        [ENABLE]
        {$lua}
        THREAD.YIELD(Destroy_All_Veh,true,1000,3000)
        [DISABLE]
        {$lua}
        THREAD.YIELD(Destroy_All_Veh,false,1000,3000)
]]

DestroyNPCVehicleScript = [[
        [ENABLE]
        {$lua}
        THREAD.YIELD(Destroy_Npc_Veh,true,-999,1000)
        [DISABLE]
        {$lua}
        THREAD.YIELD(Destroy_Npc_Veh,false,0,1000)
]]

DestroyEnemiesCarScript = [[
        [ENABLE]
        {$lua}
        THREAD.YIELD(Kill_Enemy_Veh,true,-999,1000)
        [DISABLE]
        {$lua}
        THREAD.YIELD(Kill_Enemy_Veh,false,0,1000)
]]





