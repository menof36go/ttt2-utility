addons = {}
workshopMaps = {}
local maximumRecursionDepth = 6;
local function GetMapFiles(addon, directory, depth)
	depth = depth or 0
	if depth > maximumRecursionDepth then
		return
	end
	if (!addon.downloaded) then 
		return
	end
	if (!addon.mounted) then 
		return
	end
	if (!directory) then 
		directory = "" 
	end

    local title = addon.title
    
    if folders == nil then return end
    local files, folders = file.Find(directory .. "*", title)
    for k, v in pairs(folders) do
		GetMapFiles(addon, directory .. v .. "/", depth + 1)
    end

    for k, v in pairs(files) do
		if (string.sub(v, -4) == ".bsp") then
			workshopMaps[tostring(v)] = tostring(addon.wsid)
		end
    end
end

local function SetFileInfo(wsid)
    if !wsid or !addons[wsid] then
        return
    end
    steamworks.FileInfo(wsid, function(result)
        if result then
            addons[wsid]["description"] = result.description
            addons[wsid]["tags"] = result.tags
            addons[wsid]["owner"] = result.owner
            addons[wsid]["previewid"] = result.previewid
            addons[wsid]["ownername"] = result.ownername
            addons[wsid]["fileid"] = result.fileid
        end
    end)
end

function GetMapIconAsMaterial(map)
    --print("Map", map)
    if !map then
        return nil
    end
    local wsid = workshopMaps[map] or workshopMaps[map .. ".bsp"]
    --print("Workshop ID", wsid)
    if !wsid then
        return nil
    end
    return GetWorkshopIconAsMaterialByID(wsid)
end

function GetWorkshopIconAsMaterialByID(wsid)
    --print("By ID", wsid, addons[wsid], addons[wsid] and addons[wsid]["previewid"])
    if !wsid or !addons[wsid] or !addons[wsid]["previewid"] then
        return nil
    end
    AddonMaterial("cache/workshop/" .. addons[wsid]["previewid"] .. ".cache") -- We have to call this to make sure the cached material is cleared. Buggy yay!
    return AddonMaterial("cache/workshop/" .. addons[wsid]["previewid"] .. ".cache")
end

function SetupAddons()
    addonsTable = addonsTable or engine.GetAddons()
    for k, v in pairs(addonsTable) do
        addons[tostring(v.wsid)] = {
            ["downloaded"] = v.downloaded,
            ["title"] = v.title,
            ["file"] = v.file,
            ["mounted"] = v.mounted,
        }
        SetFileInfo(tostring(v.wsid))
        GetMapFiles(v)
    end
end
