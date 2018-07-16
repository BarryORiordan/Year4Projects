module(..., package.seeall) -- use filename as module name;
                            --    see all other modules, e.g., io

NONE=-1
CAMERA=0
SCENE=1
mode=NONE			 -- no mode initially

sf=string.format		 -- more syntactic sugar!

cameraT = {}
sceneT = {}

boxCount = 1
sphereCount = 1

-- character classes for regexps here:
--  http://www.easyuo.com/openeuo/wiki/index.php/Lua_Patterns_and_Captures_(Regular_Expressions)
function matchTriple(str)	-- match, split a string like "(-1.2,3,4.4)"
  str = string.gsub(str, "%s", "")
  local _, _, x, y, z = string.find(str, "%((-?%d+%.?%d*),(-?%d+%.?%d*),(-?%d+%.?%d*)%)")
  return x, y, z
end

function processBox(params)
  box = {}

  for pair in string.gmatch(params, "[^;]+") do
    local k, v
    _, _, k, v = string.find(pair, "(%w+)%s*=%s*(.*)")
    
    if k == "name" then
      box["name"] = v
      
    elseif k == "blf" then
      local a, b, c = matchTriple(v)
      box["blf"] = {a, b, c}
      
    elseif k == "trb" then
      local d, e, f = matchTriple(v)
      box["trb"] = {d, e, f}
    end
  end
  if box["name"] == nil then
    local boxName = "box#" .. boxCount
    box["name"] = boxName
    boxCount = boxCount + 1
    print("Auto-generated: " .. boxName)
  end
  box["type"] = "box"
  return box
end

function processFace(params)
  face = {}

  for pair in string.gmatch(params, "[^;]+") do
    local k, v
    _, _, k, v = string.find(pair, "(%w+)%s*=%s*(.*)")
    if k == "name" then
      face["name"] = v
      
    elseif k == "col" then
      face["col"] = v
      
    elseif k == "verts" then
      local a, b, c = matchTriple(v)
      --face["verts"] = a, b, c
      
    end
  end
  face["type"] = "face"
  print("constructing face normal from first three vertices of " .. face["name"] .." only...")
  return face
end

function processSphere(params)
  sphere = {}

  for pair in string.gmatch(params, "[^;]+") do
    local k, v
    _, _, k, v = string.find(pair, "(%w+)%s*=%s*(.*)")
    
    if k == "ctr" then
      local a, b, c = matchTriple(v)
      sphere["ctr"] = a, b, c
      
    elseif k == "rad" then
      sphere["rad"] = v
      
    elseif k == "name" then
      sphere["name"] = v
      sphereCount = sphereCount + 1
      
    elseif k == "col" then
      sphere["col"] = v
      
    end
  end
  if sphere["name"] == nil then
    local sphereName = "sphere#" .. sphereCount
    sphere["name"] = sphereName
    sphereCount = sphereCount + 1
    print("Auto-generated: " .. sphereName)
  end
  sphere["type"] = "sphere"
  return sphere
end

function processScene(objdecl) -- declaration of an object
  -- local exact = sf(">%s<", objdecl)
  -- print("Scene declaration:", exact)

  local type, params = string.match(objdecl, "^%s*(%w+)%s*:%s*(.*)")
  
  if type == "face" then
    local f = processFace(params)       -- create face object
    table.insert(sceneT, f)			--   put in table
    
  elseif type == "box" then
    local b = processBox(params)
    table.insert(sceneT, b)
    
  elseif type == "sphere" then
    local s = processSphere(params)
    table.insert(sceneT, s)
    
  else
    print(sf("Cannot handle objects of type %s; ignoring...", type))
    
  end
end

function processCamera(params)
  for pair in string.gmatch(params, "[^;]+") do
    local k, v
    _, _, k, v = string.find(pair, "(%w+)%s*=%s*(.*)")
    
    if k == "loc" then
      local a, b, c = matchTriple(v)
      cameraT["loc"] = {a, b, c}
      
    elseif k == "lookat" then
      local a, b, c = matchTriple(v)
      cameraT["lookat"] = {a, b, c}
      
    elseif k == "upis" then
      local a, b, c = matchTriple(v)
      cameraT["upis"] = {a, b, c}
      
    elseif k == "dfrontplane" then
      cameraT["dfrontplane"] = v
      
    elseif k == "dbackplane" then
      cameraT["dbackplane"] = v
      
    elseif k == "halfangle" then
      cameraT["halfangle"] = v
      
    elseif k == "rho" then
      cameraT["rho"] = v
      
    end
  end
end

function read(scenedef)
 
  file = assert(io.open(scenedef, "r"))
  for line in file:lines() do
    line = string.gsub(line, "%s*#.*", "")  -- delete comments
    line = string.gsub(line, "^%s+", "")    -- leading space
    line = string.gsub(line, "%s*;%s*$", "")    -- trailing spaces, semi
    
    if mode==CAMERA then
      if string.find(line, "^aremac") then
        print "end of camera block"
        mode=NONE
      else
        -- process line as camera part
        processCamera(line)
    end
    
    elseif mode==SCENE then
      if string.find(line, "^enecs") then
        print "end of scene block"
        mode=NONE
      else
        -- process line as scene part
        if line ~= "" then        -- not equal to the null line
          processScene(line)
        end
      end    
    elseif string.find(line, "^camera") then
      print "found camera block"
      mode=CAMERA 
      
    elseif string.find(line, "^scene") then
      print "found scene block"
      mode=SCENE 
      
    end
  end
  print("Camera frontplane specified by halfangle / ratio")
  print()
end
-- end of functions