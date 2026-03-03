local module = {}
if _G.RDILoaded then
    module = _G.RDI
    return module
end
_G.RDILoaded = true
local imageURLLoc = "https://raw.githubusercontent.com/Editnew93/RobloxDataImages/refs/heads/main/RBLX/"
local finished = false
local locked -- Variable to store the latest locked log
local currentState = ""

-- Function to lock the latest print with exact text (including spaces and timestamps)
local function lockPrintWithText(text)
    local devConsole = game.CoreGui:FindFirstChild("DevConsoleMaster")
    local window = devConsole and devConsole:FindFirstChild("DevConsoleWindow")
    local ui = window and window:FindFirstChild("DevConsoleUI")
    local mainView = ui and ui:FindFirstChild("MainView")
    local clientLog = mainView and mainView:FindFirstChild("ClientLog")
    local layout = clientLog and clientLog:FindFirstChild("UIListLayout")

    if clientLog and layout then
        local lastChild
        -- Iterate over children safely
        for _, child in ipairs(clientLog:GetChildren()) do
            if child:FindFirstChild("msg") and child.msg:IsA("TextLabel") then
                local msgText = child.msg.Text
                -- Remove timestamp prefix if present (format: HH:MM:SS -- )
                local cleanText = msgText:match("%d%d:%d%d:%d%d%s*%-%-%s*(.*)") or msgText
                if cleanText == text then
                    lastChild = child
                end
            end
        end

        if lastChild then
            lastChild.LayoutOrder = 99999
            locked = lastChild
            -- Scroll to bottom so the locked log is visible
            clientLog.CanvasPosition = Vector2.new(0, layout.AbsoluteContentSize.Y)
        end
    end
end

function printc(text)
    pcall(function()
        if locked then
            locked.msg.Text = text
            currentState = locked.msg.Text
        end
    end)
end



function clearc()
    pcall(function()
        if locked then
            locked.msg.Text = ""
            currentState = locked.msg.Text
        end
    end)
end



function nlc(text)
    pcall(function()
        if locked then
            locked.msg.Text = locked.msg.Text .. text
            currentState = locked.msg.Text
        end
    end)
end



-- Example usage

print("Please Wait load \n Please wait load \n Please wait load") -- must match exactly
task.wait(1)
task.spawn(function()
    while task.wait(0.05) do
        pcall(function()
            lockPrintWithText("Please Wait load \n Please wait load \n Please wait load") -- locks the log with exact text
            if locked then
                printc(currentState)
            end
        end)

    end
end)
task.wait(0.5)
printc("Services Starting for installation...")
local installing = ""
task.wait(0.05)
function install(id, place)
    installing = id
    clearc()
    local url = imageURLLoc .. id
    local image = game:HttpGet(url)
    writefile(place, image)
end



function animation(ispack, package)
    if ispack then
        task.spawn(function()
            while true do
                if finished then break end
                printc("Package Installation\n " .. package.name .." by " .. package.author .. "\n \| Downloading: "..installing)
                task.wait(0.133)
                printc("Package Installation\n " .. package.name .." by " .. package.author .. "\n \/ Downloading: "..installing)
                task.wait(0.133)
                printc("Package Installation\n " .. package.name .." by " .. package.author .. "\n \- Downloading: "..installing)
                task.wait(0.133)
                printc("Package Installation\n " .. package.name .." by " .. package.author .. "\n \\ Downloading: "..installing)
                task.wait(0.133)
            end
        end)
    else
        task.spawn(function()
            while true do
                if finished then break end
                printc("\| Downloading: "..installing)
                task.wait(0.133)
                printc("\/ Downloading: "..installing)
                task.wait(0.133)
                printc("\- Downloading: "..installing)
                task.wait(0.133)
                printc("\\ Downloading: "..installing)
                task.wait(0.133)
            end
        end)
    end



end

function module:installfromGit(id, to)
    local img = game:HttpGet(imageURLLoc .. "INSTALLATION_" .. id)
    if package == "404: Not Found" then printc("Not found. Please use something from the repo: Editnew93/RobloxDataImages."); wait(3); printc("Waiting for a new instance."); return end
    finished = false
    animation(false, nil)
    install(id, to)
    finished = true
    task.wait()
    clearc()
    printc("Waiting for a new instance.")
end

function module:installPackage(packageid)
    local package = game:HttpGet(imageURLLoc .. "INSTALLATION_" .. packageid)
    if package == "404: Not Found" then return end
    finished = false
    installing = ""
    local data = game.HttpService:JSONDecode(package)

    animation(true, data)
    makefolder(tostring(packageid))
    for _, urls in pairs(data.idlist) do
        print(urls)
        install("Installation_".. packageid .."_Files/" .. urls, tostring(packageid).."/"..urls)
    end
    finished = true
    task.wait()
    clearc()
    printc("Waiting for a new instance.")
end
-- The main function to check if the string contains your protocol
local function checkPackageAsset(obj, property)
    -- Get the current content based on the property name passed
    local content = obj[property]
    
    if content == nil or type(content) ~= "string" then return end
    
    local newLink = nil
    local path = nil

    -- Handle packageasset:// (Requires ID and Filename)
    if content:find("packageasset://") then
        local id, filename = content:match("packageasset://(%d+)/(.+)$")
        if id and filename then
            path = id .. "/" .. filename
            if not isfolder(id) then
                warn("PackageAsset RDI: Package folder not found: " .. id)
                return
            end
        end
    
    -- Handle workspaceasset:// (One argument / Full Path)
    elseif content:find("workspaceasset://") then
        path = content:match("workspaceasset://(.+)$")
    end

    -- Process the path if found
    if path then
        if isfile(path) then
            newLink = getcustomasset(path)
            if content ~= newLink then
                obj[property] = newLink
            end
        else
            warn("RDI Error: File not found at " .. path)
        end
    end
end

-- Function to determine which objects have "image/sound" properties
local function onNewDescendant(descendant)
    -- Determine the property to watch
    local prop = nil
    if descendant:IsA("Decal") or descendant:IsA("Texture") then
        prop = "Texture"
    elseif descendant:IsA("ImageLabel") or descendant:IsA("ImageButton") then
        prop = "Image"
    elseif descendant:IsA("Sound") then
        prop = "SoundId"
    end

    if prop then
        -- Watch for changes
        descendant.Changed:Connect(function(p)
            if p == prop then
                checkPackageAsset(descendant, prop)
            end
        end)
        -- Initial check
        checkPackageAsset(descendant, prop)
    end
end

-- 🔥 FIXED: Listen to the ENTIRE game tree for ANY new item
game.DescendantAdded:Connect(onNewDescendant)

-- Initial scan for everything already in the game
for _, item in ipairs(game:GetDescendants()) do
    pcall(onNewDescendant, item)
end



print("created functions.")
task.wait(0.05)
printc("Confirming...")
task.wait(0.5)
_G.RDI = module
printc("Waiting for a new instance.")
