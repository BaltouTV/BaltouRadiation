ESX = exports["es_extended"]:getSharedObject()

local isInRadiationZone = false
local currentPercentage = 0

-- Fonction pour ajouter les blips et les zones de radiation
function addRadiationBlips()
    for _, zone in pairs(Config.RadiationZones) do
        -- Ajouter un blip
        local blip = AddBlipForRadius(zone.position, zone.radius)
        SetBlipColour(blip, 66) -- Jaune
        SetBlipAlpha(blip, 128) -- Semi-transparent
    end
end

-- Vérifier si le joueur possède l'item antiradiationmask
function hasAntiRadiationMask(callback)
    ESX.TriggerServerCallback('checkAntiRadiationMask', function(hasMask)
        callback(hasMask)
    end)
end

-- Appeler la fonction pour ajouter les blips et les zones de radiation
Citizen.CreateThread(function()
    addRadiationBlips()


    while true do
        Citizen.Wait(1000) -- Vérifie toutes les secondes

        local playerPed = PlayerPedId()
        local playerPos = GetEntityCoords(playerPed)

        isInRadiationZone = false
        local closestDistance = nil
        local closestZone = nil

        for _, zone in pairs(Config.RadiationZones) do
            local distance = #(playerPos - zone.position)
            if distance <= zone.radius then
                isInRadiationZone = true
                if not closestDistance or distance < closestDistance then
                    closestDistance = distance
                    closestZone = zone
                end
            end
        end

        if isInRadiationZone and closestZone then
            hasAntiRadiationMask(function(hasMask)
                if not hasMask then
                    -- Calculer le pourcentage de proximité à l'épicentre
                    local percentage = 100 * (1 - (closestDistance / closestZone.radius))
                    currentPercentage = percentage
                    -- Réduire les points de vie en fonction de la distance à l'épicentre
                    ApplyRadiationDamage(playerPed, percentage)
                    -- Appliquer les effets visuels et sonores
                    ApplyRadiationEffects()
                    -- Envoyer le pourcentage de radiation à l'interface utilisateur NUI
                    SendNUIMessage({
                        type = "updateRadiation",
                        percentage = percentage,
                        showIcon = true
                    })
                else
                    -- Si le joueur a le masque antiradiation, désactiver les effets de radiation
                    RemoveRadiationEffects()
                    currentPercentage = 0
                    SendNUIMessage({
                        type = "updateRadiation",
                        percentage = 0,
                        showIcon = true -- Toujours afficher l'icône même avec le masque
                    })
                end
            end)
        else
            -- Si le joueur sort de la zone, enlever les effets
            RemoveRadiationEffects()
            currentPercentage = 0
            SendNUIMessage({
                type = "updateRadiation",
                percentage = 0,
                showIcon = false
            })
        end
    end
end)

function ApplyRadiationDamage(playerPed, percentage)
    local health = GetEntityHealth(playerPed)
    local damage = 1 + (9 * (percentage / 100)) -- Augmente les dégâts en fonction de la proximité à l'épicentre
    -- Vérifier que la santé est supérieure à 0 pour éviter de tuer le joueur instantanément
    if health > 0 then
        -- Utiliser une alternative pour infliger des dégâts
        SetEntityHealth(playerPed, health - math.floor(damage))
        -- Afficher des messages de débogage
        print("Applying radiation damage. Health: " .. health .. " Damage: " .. damage)
    else
        print("Player health is zero or below.")
    end
end

function ApplyRadiationEffects()
    -- Appliquer les effets visuels
    if not AnimpostfxIsRunning("DrugsMichaelAliensFightIn") then
        StartScreenEffect("DrugsMichaelAliensFightIn", 0, true)
    end
    -- Appliquer les effets sonores via NUI
    SendNUIMessage({
        type = "playSound",
        sound = "radiation_sound"
    })
end

function RemoveRadiationEffects()
    -- Retirer les effets visuels
    if AnimpostfxIsRunning("DrugsMichaelAliensFightIn") then
        StopScreenEffect("DrugsMichaelAliensFightIn")
    end
    -- Arrêter les effets sonores via NUI
    SendNUIMessage({
        type = "stopSound",
        sound = "radiation_sound"
    })
end
