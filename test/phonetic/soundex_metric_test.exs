defmodule SoundexMetricTest do
  use ExUnit.Case

  import TheFuzz.Phonetic.SoundexMetric, only: [compare: 2]

  test "returns nil with empty arguments" do
    assert compare("", "") == nil
    assert compare("abc", "") == nil
    assert compare("", "xyz") == nil
  end

  test "returns nil with non-phonetic arguments" do
    assert compare("123", "123") == nil
    assert compare("123", "") == nil
    assert compare("", "123") == nil
  end

  test "returns true with phonetically similar arguments" do
    assert compare("robert", "rupert") == true
  end

  test "returns false with phonetically dissimilar arguments" do
    assert compare("robert", "rubin") == false
  end
end
