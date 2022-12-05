local num_positions = 3

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

function Read_move(line)
    local tokens = {}
    for token in line:gmatch("%w+") do table.insert(tokens, token) end
    return Move:new(nil, tokens[2],tokens[4],tokens[6])
end

Row = {items = {}}
function Row:new (o,items)
   o = o or {}
   setmetatable(o, self)
   self.__index = self
   self.items = items or {}
   return o
end

function Row:printRow ()
    print('Row')
    for i=1,3 do
        print(i .. '  "' .. self.items[i] .. '"')
    end
end

function Read_row(line)
    local row_items = {}
    for i=1,num_positions do
        local index = i*4-2
        row_items[i] = Read_crate(line,index)
    end
    return Row:new(nil, row_items)
end

function Read_crate(line, pos)
    local c = string.sub(line, pos, pos)
    if c == '' then
       return ' '
    else
        return c
    end
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

local rows = {}
local moves = {}

function Read_start()
    local input = Lines_from('Example.txt')
    local stacks_finished = false
    for _,v in pairs(input) do

      if string.starts(v, ' 1') then
         stacks_finished = true
      end

      if stacks_finished and string.starts(v, 'move') then
        local m = Read_move(v)
        m:printMove()
        moves[#moves + 1] = m
      elseif not stacks_finished then
        local r = Read_row(v)
        r:printRow()
        rows[#rows + 1] = r
      end
    end
end

Read_start()