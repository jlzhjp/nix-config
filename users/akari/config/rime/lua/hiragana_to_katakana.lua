local function is_hiragana_text(text)
  if not text or text == "" then
    return false
  end

  for _, codepoint in utf8.codes(text) do
    local is_hiragana =
      (codepoint >= 0x3040 and codepoint <= 0x309f)
      or codepoint == 0x30fc
    if not is_hiragana then
      return false
    end
  end
  return true
end

local function init(env)
  env.opencc = Opencc("hiragana_to_katakana.json")
end

local function filter(input, env)
  for candidate in input:iter() do
    yield(candidate)

    if is_hiragana_text(candidate.text) then
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
