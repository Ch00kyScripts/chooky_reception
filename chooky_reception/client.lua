local npcs = {}
local blips = {}
local currentLocation = nil -- GUARDAR LA UBICACIÓN ACTUAL

-- ==================== DEBUG SYSTEM ====================
local function DebugPrint(message)
    if Config.Debug then
        print('[^1ESX_RECEPCIONISTA DEBUG^7] ' .. message)
    end
end

-- ==================== ESX LOAD ====================
CreateThread(function()
    while not ESX do
        Wait(100)
        ESX = exports.es_extended:getSharedObject()
    end
    Wait(1000)
    CreateNPCs()
end)

-- ==================== NPC CREATION ====================
function CreateNPCs()
    for i, location in ipairs(Config.Locations) do
        local modelHash = joaat(location.npcModel)
        RequestModel(modelHash)
        
        local timeout = 0
        while not HasModelLoaded(modelHash) and timeout < 100 do
            Wait(50)
            timeout = timeout + 1
        end
        
        if HasModelLoaded(modelHash) then
            local ped = CreatePed(4, modelHash, 
                location.coords.x, location.coords.y, location.coords.z, 
                location.coords.w, false, true
            )
            
            if DoesEntityExist(ped) then
                SetEntityAsMissionEntity(ped, true, true)
                SetBlockingOfNonTemporaryEvents(ped, true)
                SetPedFleeAttributes(ped, 0, 0)
                SetPedCombatAttributes(ped, 46, true)
                SetPedDiesWhenInjured(ped, false)
                FreezeEntityPosition(ped, true)
                SetEntityInvincible(ped, true)
                TaskStandStill(ped, -1)
                
                exports.ox_target:addLocalEntity(ped, {
                    {
                        name = 'recepcionista_' .. i,
                        icon = 'fa-solid fa-comments',
                        label = 'Hablar con ' .. location.npcName,
                        distance = 2.5,
                        onSelect = function()
                            currentLocation = location -- GUARDAR UBICACIÓN
                            OpenReceptionUI(location)
                        end
                    }
                })
                
                npcs[i] = ped
                
                if location.blip.enabled then
                    local blip = AddBlipForCoord(location.coords.x, location.coords.y, location.coords.z)
                    SetBlipSprite(blip, location.blip.sprite)
                    SetBlipColour(blip, location.blip.color)
                    SetBlipScale(blip, location.blip.scale)
                    SetBlipAsShortRange(blip, true)
                    BeginTextCommandSetBlipName("STRING")
                    AddTextComponentString(location.blip.label)
                    EndTextCommandSetBlipName(blip)
                    blips[i] = blip
                end
                
                DebugPrint("✅ NPC " .. i .. " creado: " .. location.npcName)
            end
        end
    end
end

-- ==================== UI FUNCTIONS ====================
function OpenReceptionUI(location)
    ESX.TriggerServerCallback('esx_recepcionista:getJobCount', function(playersOnline)
        if playersOnline == 0 then
            -- ✅ USA EL MENSAJE PERSONALIZADO DE LA UBICACIÓN
            ESX.ShowNotification(location.noServiceMessage, 'error')
            return
        end
        
        SetNuiFocus(true, true)
        SendNUIMessage({
            action = 'open',
            locationName = location.name,
            npcName = location.npcName,
            maxLength = Config.MaxMessageLength,
            colors = Config.UIColor,
            job = location.job,
            location = location.name
        })
    end, location.job)
end

-- ==================== NUI CALLBACKS ====================
RegisterNUICallback('sendMessage', function(data, cb)
    if currentLocation then -- USAR LA UBICACIÓN GUARDADA
        DebugPrint("Enviando mensaje para job: " .. currentLocation.job)
        TriggerServerEvent('esx_recepcionista:sendMessage', 
            currentLocation.job, 
            currentLocation.name, 
            data.message
        )
    end
    
    CloseUI()
    cb('ok')
end)

RegisterNUICallback('cancel', function(_, cb)
    CloseUI()
    cb('ok')
end)

function CloseUI()
    SetNuiFocus(false, false)
    SendNUIMessage({ action = 'close' })
    currentLocation = nil -- LIMPIAR UBICACIÓN
end

-- ==================== CLEANUP ====================
AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        for _, ped in ipairs(npcs) do
            if DoesEntityExist(ped) then
                DeleteEntity(ped)
            end
        end
        for _, blip in ipairs(blips) do
            if DoesBlipExist(blip) then
                RemoveBlip(blip)
            end
        end
    end
end)

-- ==================== DEBUG COMMAND ====================
RegisterCommand('testrecepcion', function()
    DebugPrint("=== TEST DE SISTEMA ===")
    DebugPrint("NPCs creados: " .. #npcs)
    
    for i, ped in ipairs(npcs) do
        if DoesEntityExist(ped) then
            local coords = GetEntityCoords(ped)
            DebugPrint(string.format("NPC %d en: %.2f, %.2f, %.2f", i, coords.x, coords.y, coords.z))
        end
    end
end, false)