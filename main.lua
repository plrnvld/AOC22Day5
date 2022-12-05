Move = {num = 0, from = 0, to = 0}
function Move:new (o,num,from,to)
   o = o or {}
   setmetatable(o, self)
   self.__index = self
   self.num = num or 0
   self.from = from or 0
   self.to = to or 0
   return o
end

function Move:printMove ()
   print('Move ' .. self.num .. ' from ' .. self.from .. ' to ' .. self.to)
end

Row = {items = {}}
function Row:printRow ()
    print('Row')
    for item in self.items do
        print('  ' .. item)
    end
end

function Read_move(line)
    local tokens = {}
    for token in line:gmatch("%w+") do table.insert(tokens, token) end
    return Move:new(nil, tokens[2],tokens[4],tokens[6])
end

function Read_row(line)
    -- ------------ Continue here
    local tokens = {}
    for token in line:gmatch("%w+") do table.insert(tokens, token) end
    return Move:new(nil, tokens[2],tokens[4],tokens[6])
end

function Lines_from(file)
  local lines = {}
  for line in io.lines(file) do
    lines[#lines + 1] = line
  end
  return lines
end

function string.starts(String,Start)
   return string.sub(String,1,string.len(Start))==Start
end

local lines = Lines_from('Input.txt')

for k,v in pairs(lines) do
  if string.starts(v, 'move')
  then
    local m = Read_move(v)
    m:printMove()
  elseif string.starts(v, '[')
  then
    local r = Read_row(v)
    r:printRow()
  end
end