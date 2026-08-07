local kana = require("lib.kana")

local function init(env)
  env.opencc = Opencc("hiragana_to_katakana.json")
end

local function filter(input, env)
  for candidate in input:iter() do
    yield(candidate)

    if kana.is_hiragana_text(candidate.text) then
      local katakana = env.opencc:convert(candidate.text)
      if katakana and katakana ~= candidate.text then
        yield(candidate:to_shadow_candidate(
          "katakana",
          katakana,
          "",
          false
        ))
      end
    end
  end
end

local function fini(env)
  env.opencc = nil
end

return { init = init, func = filter, fini = fini }
