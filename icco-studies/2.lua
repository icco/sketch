-- patterning
-- norns study 2

engine.name = "PolyPerc"

function init()
  engine.release(3)
  notes = {} -- create a 'notes' table
  selected = {} -- create a 'selected' table to track playing notes
  
  -- lets create a 5x5 square of notes:
  for m = 1,5 do -- a 'for' loop, where m = 1, then m = 2, etc
    notes[m] = {} -- use m as an vertical index for 'notes'
    selected[m] = {} -- use m as a vertical index for 'selected'
    for n = 1,5 do -- another 'for' loop, where n = 1, then n = 2, etc
      -- n is our horizontal index
      notes[m][n] = 55 * 2^((m*12+n*2)/12) -- this is just fancy math to get some notes
      selected[m][n] = false -- all start unselected
    end
  end
  light = 0
  number = 3 -- our maximum number of notes to play at one time
end

function redraw()
  screen.clear()
  for m = 1,5 do
    for n = 1,5 do
      screen.rect(0.5+m*9,0.5+n*9,6,6) -- (x,y,width,height)
      l = 2
      if selected[m][n] then
        l = l + 3 + light
      end
      screen.level(l)
      screen.stroke()
    end
  end
  screen.move(10,60)
  screen.text(number)
  screen.update()
end

function key(n,z)
  if n == 2 and z == 1 then
    -- clear selected notes
    for x=1,5 do
      for y=1,5 do
        selected[x][y] = false
      end
    end
    -- choose new random notes
    for i=1,number do
      selected[math.random(5)][math.random(5)] = true
    end
  elseif n == 3 then
    -- find notes to play
    if z == 1 then -- key 3 down
      for x=1,5 do
        for y=1,5 do
          if selected[x][y] then
            engine.hz(notes[x][y])
          end
        end
      end
      light = 7 -- adds 7 to the square's screen level
    elseif z == 0 then -- key 3 up
      light = 0 -- adds 0 to the square's screen level
    end
  end
  redraw()
end

function enc(n,d)
  if n==3 then
    -- clamp number of notes from 1 to 4
    number = util.clamp(number + d,1,4)
  end
  redraw()
end