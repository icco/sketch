-- sketch: eucledia rythems for midi
-- v1.0.0 @icco
-- llllllll.co/u/icco/summary

ER = require("er")
MU = require 'musicutil'

engine.name = 'PolyPerc'
norns.version.required = 221214

current_step = 1
freq = 220
octave = 1
m = midi.connect(1)

function init()
  -- initialization
  engine.release(0.5)
  
  scale = "Major Pentatonic" -- for scale generation
  
  -- setting the number of pulses using params
  params:add{type = "number", id = "pulses", name = "number of pulses", 
    min = 1, max = 16, default = 4, action = function() generate_sequence() end} -- by employing generate_sequence() here we update the sequence
  
  -- setting the number of steps using params
  params:add{type = "number", id = "steps", name = "number of steps", 
    min = 1, max = 16, default = 8, action = function() generate_sequence() end} -- by employing generate_sequence() here we update the sequence
  
  -- setting the shift amount using params
  params:add{type = "number", id = "shift", name = "shift amount",
    default = 0, action = function() generate_sequence() end} -- by employing generate_sequence() here we update the sequence
  
  generate_sequence() -- generate the initial sequence
end

function key(n,z)
  -- key actions: n = number, z = state
  if n == 2 and z == 1 then
    if not playing then
      play = clock.run(play_sequence) -- starts the clock coroutine which plays the euclidean sequence
      playing = true
    elseif playing then
      stop_play()
    end
  elseif n == 3 then
    if z == 1 then
      -- a bit of a fun performative gesture
      octave = math.random(1,4)
      engine.release(2)
    elseif z == 0 then
      octave = 1
      engine.release(0.5)
    end
  end
  redraw()
end

function enc(n,d)
  -- encoder actions: n = number, d = delta
      -- use encoders to change the variables for the euclidean rhythm
  if n == 1 then
    params:delta("pulses", d)
  elseif n == 2 then
    params:delta("steps", d)
  elseif n == 3 then
    params:delta("shift", d)
  end
  redraw()
end

function redraw()
  -- screen redraw
  screen.clear()
  for n = 1,#er_table do -- draws a number of squares equal to the number of steps
    screen.rect(8*(n-1)+1,10,5,5)
    local l = 1
    if n == current_step then l = 15
    elseif er_table[n] then l = 8 -- highlights where there is a pulse
    end
    screen.level(l)
    screen.stroke()
  end
  screen.move(60,50)
  screen.level(15)
  if not playing then
    screen.text_center("press k2 to play")
  elseif playing then
    screen.text_center("press k2 to stop")
  end
  screen.update()
end

function cleanup()
  -- deinitialization
end

function generate_sequence() 
  er_table = ER.gen(params:get("pulses"), params:get("steps"), params:get("shift")) -- storing the returned table in a variable
end

function play_sequence()
  on = false
  note = 40
  while true do
    clock.sync(1)
    
    if on then
      m:note_off(note)
    end
    
    if er_table[current_step] then -- play a note only if there is a pulse in that step
      engine.hz(octave * freq)
      m:note_on(note)
      on = true
    end
    current_step = util.wrap(current_step + 1,1,#er_table) -- uses a built-in helper to wrap the step-counter to the length of the sequence
    random_note = math.random(21,78)
    redraw()
  end
end

function stop_play() -- stops the coroutine playing the sequence
  clock.cancel(play)
  playing = false
end
