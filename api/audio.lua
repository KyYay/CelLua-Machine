audiocache = {}

function playSound(sound)
  if not audiocache[sound] then
    audiocache[sound] = love.audio.newSource(sound, "static")
  end
  love.audio.play(audiocache[sound])
end