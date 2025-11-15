Config = {}

-- MODO DEBUG - Pon esto en true para ver mensajes en consola
Config.Debug = false
Config.MaxMessageLength = 200

-- Mensajes del sistema
Config.NoServiceMessage = "⚠️ Ahora no hay nadie de servicio. Por favor, intente más tarde."
Config.SendButtonText = "📨 Enviar mensaje"
Config.CancelButtonText = "❌ Cancelar"
Config.FormTitle = "📋 RECEPCIÓN"

-- **COORDENADAS DE PRUEBA EN EXTERIOR (cámbialas después)**
Config.Locations = {
    {
        name = "Policía Comisaría Central",
        coords = vector4(437.70,-980.16,29.68,96.38), -- COMISARÍA VANILLA
        job = "police",
        npcModel = "s_m_y_blackops_01",
        npcName = "👮 Recepcionista Laureano",
        noServiceMessage = "⚠️ No hay ningun agente en comisaria para atenderte.",
        blip = {
            enabled = false,
            sprite = 60,
            color = 3,
            scale = 0.8,
            label = "📞 Recepción Policia"
        }
    },
    {
        name = "Hospital",
        coords = vector4(307.44, -583.41, 42.27, 108.55), -- HOSPITAL VANILLA
        job = "ambulance",
        npcModel = "s_f_y_scrubs_01",
        npcName = "👩‍⚕️ Recepcionista María",
        noServiceMessage = "⚠️ No hay ems activos, pero puedes hablar con el MEDICO DE GUARDIA que esta en la sala de dentro.",
        blip = {
            enabled = false,
            sprite = 61,
            color = 1,
            scale = 0.8,
            label = "📞 Recepción Hospital"
        }
    }
}

-- Color del UI
Config.UIColor = {
    primary = "rgba(0, 0, 0, 1)",
    secondary = "rgb(231, 76, 60)"
}