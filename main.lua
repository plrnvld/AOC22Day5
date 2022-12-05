function Lines_from(file)
  local lines = {}
  for line in io.lines(file) do
    lines[#lines + 1] = line
  end
  return lines
end

-- tests the functions above
local lines = Lines_from('Input.txt')

-- print all line numbers and their contents
for k,v in pairs(lines) do
  print('line[' .. k .. ']', v)
end