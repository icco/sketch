


engine.name = "PolyPerc"

function init()
  mm = midi.connect()	
  mm.event = function (data)
    print(data[0], data[1], data[2])
    note = data[2]
    engine.hz(midi_to_hz(note))
  end
end

function midi_to_hz(note)
  return (440 / 32) * (2 ^ ((note - 9) / 12))
end