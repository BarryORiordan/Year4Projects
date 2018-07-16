tuples = {}
function readBarriers(filename)
  io.input(filename)
  x = 1
  for line in io.lines() do
    tuples[x] = line
    x = x + 1
  end
  return tuple[1]
end

function myfunction(number)
  for i, input in ipairs(tuples) do
    cppfunction(input)
  end
end
