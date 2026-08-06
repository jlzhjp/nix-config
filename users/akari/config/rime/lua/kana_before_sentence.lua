local function is_kana_text(text)
  if not text or text == "" then
    return false
  end

  for _, codepoint in utf8.codes(text) do
    local is_kana =
      (codepoint >= 0x3040 and codepoint <= 0x30ff)
      or (codepoint >= 0x31f0 and codepoint <= 0x31ff)
      or (codepoint >= 0xff65 and codepoint <= 0xff9f)
    if not is_kana then
      return false
    end
  end
  return true
end

local function candidate_type(candidate)
  local genuine = candidate:get_genuine()
  return genuine and genuine.type or candidate.type
end

local function filter(input, env)
  local buffered = {}
  local scan_limit = 20
  local flushed = false
  local input_end = #(env.engine.context.input or "")

  local function flush()
    local first_sentence
    for index, candidate in ipairs(buffered) do
      if candidate_type(candidate) == "sentence"
        and not is_kana_text(candidate.text)
      then
        first_sentence = index
        break
      end
    end

    if not first_sentence then
      for _, candidate in ipairs(buffered) do
        yield(candidate)
      end
      return
    end

    local function is_full_match_kana(candidate)
      return is_kana_text(candidate.text)
        and candidate.start == 0
        and candidate._end == input_end
    end

    for index = 1, first_sentence - 1 do
      yield(buffered[index])
    end
    for index = first_sentence, #buffered do
      if is_full_match_kana(buffered[index]) then
        yield(buffered[index])
      end
    end
    for index = first_sentence, #buffered do
      if not is_full_match_kana(buffered[index]) then
        yield(buffered[index])
      end
    end
  end

  for candidate in input:iter() do
    if flushed then
      yield(candidate)
    else
      table.insert(buffered, candidate)
      if #buffered >= scan_limit then
        flush()
        flushed = true
      end
    end
  end

  if not flushed then
    flush()
  end
end

return { func = filter }
