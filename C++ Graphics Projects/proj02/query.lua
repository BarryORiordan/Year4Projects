
module(..., package.seeall) -- use filename as module name;
                            --    see all other modules, e.g., io
require "lsd"
require "vector"
sf=string.format

function whatObjects()
  count = 0
  for _ in pairs(lsd.sceneT) do count = count + 1 end
  
  print(tostring(count) .. " known objects:")
  for index, data in ipairs(lsd.sceneT) do
    for key, value in pairs(data) do
      if key == "name" then
        print("Name: " .. value .. "; " .. "type: " .. data["type"])
      end
    end
  end
  print()
end

function cameraParams()
  print(sf("Camera location: (%.3f,%.3f,%.3f)", lsd.cameraT["loc"][1], lsd.cameraT["loc"][2], lsd.cameraT["loc"][3]))
  print(sf("Camera looking at: (%.3f,%.3f,%.3f)", lsd.cameraT["lookat"][1], lsd.cameraT["lookat"][2], lsd.cameraT["lookat"][3]))
  print(sf("Camera up direction (approx.): (%.3f,%.3f,%.3f)", lsd.cameraT["upis"][1], lsd.cameraT["upis"][2], lsd.cameraT["upis"][3]))
  print(sf("Camera dist to frontplane: %.3f", lsd.cameraT["dfrontplane"]))
  print(sf("Camera dist to backplane: %.3f", lsd.cameraT["dbackplane"]))
  print(sf("Camera frontplane halfangle: %.3f", lsd.cameraT["halfangle"]))
  print(sf("                  ratio: %.3f", lsd.cameraT["rho"]))
  print()
end

function directions()
  d = vector.substractVector(lsd.cameraT["loc"], lsd.cameraT["lookat"])
  value1 = vector.dotProduct(d, lsd.cameraT["upis"])
  value2 = vector.dotProduct(d, d)
  beta = value1 / value2
  sub = vector.scalarMultiplication(beta, d)
  u = vector.subtraction(lsd.cameraT["upis"], sub)
  r = vector.crossProduct(d, u)
  
  D = vector.normal(d)
  U = vector.normal(u)
  R = vector.normal(r)

  print(sf("Directions: D=(%.3f,%.3f,%.3f)", D[1], D[2], D[3]))
  print(sf("            U=(%.3f,%.3f,%.3f)", U[1], U[2], U[3]))
  print(sf("            R=(%.3f,%.3f,%.3f)", R[1], R[2], R[3]))
  print()
  
end

function frustum()
  
end

function visible()
  --placeholder
  print()
  print("Visible objects:")
  print("Object sphere#1 is partially visible")
  print("Object sphere#2 is fully visible")
end

function collison()
  
end

