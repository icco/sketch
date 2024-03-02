-- study 3
-- code exercise

local s = require 'sequins'

engine.name = "PolyPerc"

function init()
  params:add_control("cutoff","cutoff",controlspec.new(50,5000,'exp',0,555,'hz'))
  params:set_action("cutoff", function(x) engine.cutoff(x) end)
end

notes = s{330,495,660,247.5}

function redraw()
  screen.clear()
  screen.move(64,32)
  screen.font_size(18)
  screen.text_center(params:string("cutoff"))
  screen.update()
end

function enc(n,d)
  if n == 3 then
    params:delta("cutoff",d)
    redraw()
  end
end

function key(n,z)
  if n == 3 then
    if z == 1 then
      engine.hz(notes())
    end
  end
end