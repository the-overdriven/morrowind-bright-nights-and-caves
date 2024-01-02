local cf = mwse.loadConfig("Gamma", {gam = 1, sat = 1, lum = 1})
local GAM
local function registerModConfig() local tpl = mwse.mcm.createTemplate("Gamma")	tpl:saveOnClose("Gamma", cf)	tpl:register()		local p0 = tpl:createPage()		local var = mwse.mcm.createTableVariable
GAM = mge.shaders.find{name = "Gamma"}
p0:createDecimalSlider{label = "Gamma", max = 5, variable = var{id = "gam", table = cf}, callback = function() GAM.gamma = cf.gam end}
p0:createDecimalSlider{label = "Saturation", max = 5, variable = var{id = "sat", table = cf}, callback = function() GAM.saturation = cf.sat end}
p0:createDecimalSlider{label = "Luminance", max = 5, variable = var{id = "lum", table = cf}, callback = function() GAM.luminance = cf.lum end}
end		event.register("modConfigReady", registerModConfig)

local function getDayTime()
    local hour = tes3.worldController.hour.value
    local wc = tes3.worldController.weatherController

    local sunriseBegin = wc.sunriseHour
    local sunriseDuration = wc.sunsetDuration
    local sunriseEnd = sunriseBegin + sunriseDuration

    local sunsetBegin = wc.sunsetHour
    local sunsetDuration = wc.sunsetDuration
    local sunsetEnd = sunsetBegin + sunsetDuration

    if (hour >= sunriseBegin and hour < sunriseEnd) then
        return "sunrise"
    elseif (hour >= sunriseEnd and hour < sunsetBegin) then
        return "day"
    elseif (hour >= sunsetBegin and hour < sunsetEnd) then
        return "sunset"
    else
        return "night"
    end
end

local function cellChangedCallback(e)
	if (e.cell.isOrBehavesAsExterior and getDayTime() == "day") then
		-- decrease luminance in exteriors when it is day
		GAM.luminance = 1.10
	else
		-- increase luminance in interiors, or when it is night
		GAM.luminance = 1.50
	end
end

event.register(tes3.event.cellChanged, cellChangedCallback)
