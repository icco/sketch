-- study 3
-- code exercise
-- time again: strum

engine.name = "PolyPerc"

function init()
  strum = metro.init(note, 0.05, 8) -- strum will trigger 'note' every 50ms for 8 stages
end

function key(n,z)
  if z == 1 then
    strum:stop() -- stop the strum
    root = 40 + math.random(12) * 2 -- select a random root MIDI note, starting at 40
    engine.hz(midi_to_hz(root)) -- play the root
    strum:start() -- start the strum
  end
end

function note(stage)
  local pitch = midi_to_hz(root + stage * 5) -- stage multiplies by 5 and adds to root
  engine.hz(pitch) -- play the pitch
end

function midi_to_hz(note)
  return (440 / 32) * (2 ^ ((note - 9) / 12))
end