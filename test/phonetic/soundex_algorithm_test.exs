defmodule SoundexAlgorithmTest do
  use ExUnit.Case

  import TheFuzz.Phonetic.SoundexAlgorithm, only: [compute: 1]

  test "returns nil with empty argument" do
    assert compute("") == nil
  end

  test "returns nil with non-phonetic argument" do
    assert compute("123") == nil
  end

  test "returns expected soundex codes for single letters" do
    # a
    assert compute("a") == "a000"
    assert compute("aa") == "a000"

    # b
    assert compute("b") == "b000"
    assert compute("bb") == "b000"

    # c
    assert compute("c") == "c000"
    assert compute("cc") == "c000"

    # d
    assert compute("d") == "d000"
    assert compute("dd") == "d000"

    # e
    assert compute("e") == "e000"
    assert compute("ee") == "e000"

    # f
    assert compute("f") == "f000"
    assert compute("ff") == "f000"

    # g
    assert compute("g") == "g000"
    assert compute("gg") == "g000"

    # h
    assert compute("h") == "h000"
    assert compute("hh") == "h000"

    # i
    assert compute("i") == "i000"
    assert compute("ii") == "i000"

    # j
    assert compute("j") == "j000"
    assert compute("jj") == "j000"

    # k
    assert compute("k") == "k000"
    assert compute("kk") == "k000"

    # l
    assert compute("l") == "l000"
    assert compute("ll") == "l000"

    # m
    assert compute("m") == "m000"
    assert compute("mm") == "m000"

    # n
    assert compute("n") == "n000"
    assert compute("nn") == "n000"

    # o
    assert compute("o") == "o000"
    assert compute("oo") == "o000"

    # p
    assert compute("p") == "p000"
    assert compute("pp") == "p000"

    # q
    assert compute("q") == "q000"
    assert compute("qq") == "q000"

    # r
    assert compute("r") == "r000"
    assert compute("rr") == "r000"

    # s
    assert compute("s") == "s000"
    assert compute("ss") == "s000"

    # t
    assert compute("t") == "t000"
    assert compute("tt") == "t000"

    # u
    assert compute("u") == "u000"
    assert compute("uu") == "u000"

    # v
    assert compute("v") == "v000"
    assert compute("vv") == "v000"

    # w
    assert compute("w") == "w000"
    assert compute("ww") == "w000"

    # x
    assert compute("x") == "x000"
    assert compute("xx") == "x000"

    # y
    assert compute("y") == "y000"
    assert compute("yy") == "y000"

    # z
    assert compute("z") == "z000"
    assert compute("zz") == "z000"
  end

  test "handles letters followed by numbers" do
    # Starting with letter then numbers
    assert compute("x123456") == "x000"
    assert compute("a123456") == "a000"
    assert compute("f123456") == "f000"
  end

  test "returns expected soundex codes for miscellaneous words" do
    # Simple cases
    assert compute("abc") == "a120"
    assert compute("xyz") == "x200"

    # Common names - robert/rupert/rubin
    assert compute("robert") == "r163"
    assert compute("rupert") == "r163"
    assert compute("rubin") == "r150"

    # Complex names
    assert compute("ashcraft") == "a261"
    assert compute("tymczak") == "t522"
    assert compute("pfister") == "p236"

    # Famous mathematicians/scientists
    assert compute("euler") == "e460"
    assert compute("gauss") == "g200"
    assert compute("hilbert") == "h416"
    assert compute("knuth") == "k530"
    assert compute("lloyd") == "l300"
    assert compute("lukasiewicz") == "l222"

    # Alternative spellings
    assert compute("ashcroft") == "a261"
    assert compute("tymczak") == "t522"
    assert compute("pfister") == "p236"
    assert compute("ellery") == "e460"
    assert compute("ghosh") == "g200"
    assert compute("heilbronn") == "h416"
    assert compute("kant") == "k530"
    assert compute("ladd") == "l300"
    assert compute("lissajous") == "l222"

    # Additional case
    assert compute("fusedale") == "f234"
  end
end
