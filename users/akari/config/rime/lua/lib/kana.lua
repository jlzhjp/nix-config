local function contains_only(text, predicate)
  if not text or text == "" then
    return false
  end

  for _, codepoint in utf8.codes(text) do
    if not predicate(codepoint) then
      return false
    end
  end
  return true
end

local function is_hiragana(codepoint)
  return (codepoint >= 0x3040 and codepoint <= 0x309f)
    or codepoint == 0x30fc
end

local function is_kana(codepoint)
  return (codepoint >= 0x3040 and codepoint <= 0x30ff)
    or (codepoint >= 0x31f0 and codepoint <= 0x31ff)
    or (codepoint >= 0xff65 and codepoint <= 0xff9f)
end

return {
  is_hiragana_text = function(text)
    return contains_only(text, is_hiragana)
  end,
  is_kana_text = function(text)
    return contains_only(text, is_kana)
  end,
}
