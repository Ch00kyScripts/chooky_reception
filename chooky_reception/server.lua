ESX = exports.es_extended:getSharedObject()

-- Verificar job count
ESX.RegisterServerCallback('esx_recepcionista:getJobCount', function(source, cb, job)
    local players = ESX.GetExtendedPlayers('job', job)
    local count = #players
    
    if Config.Debug then
        print(string.format('[^3RECEPCIONISTA^7] Job %s tiene %d jugadores online', job, count))
    end
    
    cb(count)
end)

-- Enviar mensaje
RegisterServerEvent('esx_recepcionista:sendMessage')
AddEventHandler('esx_recepcionista:sendMessage', function(job, locationName, message)
    local sourcePlayer = ESX.GetPlayerFromId(source)
    if not sourcePlayer then return end
    
    local players = ESX.GetExtendedPlayers('job', job)
    local sentCount = 0
    
    for _, player in ipairs(players) do
        TriggerClientEvent('esx:showAdvancedNotification', player.source, 
            locationName, 
            "📨 Nuevo mensaje de recepción", 
            message, 
            'CHAR_CHAT_CALL', 
            7, 
            'info'
        )
        sentCount = sentCount + 1
    end
    
    if Config.Debug then
        print(string.format('[^2RECEPCIONISTA^7] Mensaje enviado a %d jugadores de %s', sentCount, job))
    end
    
    -- Confirmación al remitente
    TriggerClientEvent('esx:showNotification', source, '✅ Mensaje enviado a ' .. sentCount .. ' agentes', 'success')
end)

-- Comando para ver jobs online (admin)
RegisterCommand('checkjob', function(source, args)
    if source > 0 then
        local xPlayer = ESX.GetPlayerFromId(source)
        if xPlayer.getGroup() ~= 'admin' then
            return
        end
    end
    
    local job = args[1] or 'police'
    local players = ESX.GetExtendedPlayers('job', job)
    
    print('[^3RECEPCIONISTA^7] Jugadores con job ' .. job .. ': ' .. #players)
    for _, player in ipairs(players) do
        print('  - ' .. GetPlayerName(player.source) .. ' (ID: ' .. player.source .. ')')
    end
end, true)