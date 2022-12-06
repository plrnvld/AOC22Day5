local num_positions = 9

local rows = {}
local moves = {}
local columns = {}

-- Move
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
    return Move:new{num=tonumber(tokens[2]),from=tonumber(tokens[4]),to=tonumber(tokens[6])}
end

-- Row
Row = {items = {}}
function Row:new (o,items)
   o = o or {}
   setmetatable(o, self)
   self.__index = self
   self.items = items or {}
   return o
end

function Row:printRow ()
    io.write('Row ')
    for i=1,3 do
        io.write('(' .. i .. ':"' .. self.items[i] .. '") ')
    end
    print()
end

-- Column
Column = {num=0, items = {}}
function Column:new (o,items)
   o = o or {}
   setmetatable(o, self)
   self.__index = self
   self.num = num
   self.items = items or {}
   return o
end

function Column:addCrate (crate)
    self.items[#self.items + 1] = crate
end

function Column:removeCrate ()
    local crate = self.items[#self.items]
    table.remove(self.items,#self.items)
    return crate
end

function Column:removeMulti(n)
    local toMove = {}
    for i=1,n do
        toMove[i] = self:removeCrate()
    end
    return toMove
end

function Column:addMulti(crates)
    for i=1,#crates do
        self:addCrate(crates[i])
    end
end

function Column:printColumn ()
    io.write('Column ' .. self.num .. ':')
    for i,v in ipairs(self.items) do
        io.write(v)
    end
    print()
end

function Read_row(line)
    local row_items = {}
    for i=1,num_positions do
        local index = i*4-2
        row_items[i] = Read_crate(line,index)
    end
    return Row:new{items=row_items}
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

function MoveCrates(move)
    local toMove = columns[move.from]:removeMulti(move.num)
    columns[move.to]:addMulti(toMove)
end

function Read_start()
    local input = Lines_from('Input.txt')
    local stacks_finished = false
    for _,v in pairs(input) do

      if string.starts(v, ' 1') then
         stacks_finished = true
      end

      if stacks_finished and string.starts(v, 'move') then
        local m = Read_move(v)
        moves[#moves + 1] = m
      elseif not stacks_finished then
        local r = Read_row(v)
        rows[#rows + 1] = r
      end
    end

    local num_columns = #rows[1].items
    for i=1,num_columns do
        columns[i] = Column:new{num=i,items={}}
    end

    for i=(#rows),1,-1 do
        for l,crate in ipairs(rows[i].items) do
            if crate ~= ' ' then
                columns[l]:addCrate(crate)
            end
        end
    end
end

Read_start()

print('Columns')
for k,column in pairs(columns) do
    print(k)
    columns[k]:printColumn()
end

print()
print('Moves')
for i,move in ipairs(moves) do
    move:printMove()
    MoveCrates(move)
end

for i,column in ipairs(columns) do
    print(i)
    column:printColumn()
end

