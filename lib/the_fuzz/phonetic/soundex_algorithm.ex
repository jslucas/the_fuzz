defmodule TheFuzz.Phonetic.SoundexAlgorithm do
  @moduledoc """
  Calculates the [Soundex Phonetic Algorithm](http://en.wikipedia.org/wiki/Soundex)
  of a string.

  The Soundex algorithm encodes names by sound, as pronounced in English. It is
  commonly used to match names that sound similar but are spelled differently.
  """

  import String, only: [downcase: 1, first: 1]
  import TheFuzz.Util, only: [len: 1]

  @doc """
  Returns the Soundex phonetic code of the provided string.

  The result is always a 4-character string consisting of a letter followed by
  three digits (padded with zeros if necessary).

  ## Examples
      iex> TheFuzz.Phonetic.SoundexAlgorithm.compute("robert")
      "r163"

      iex> TheFuzz.Phonetic.SoundexAlgorithm.compute("rupert")
      "r163"

      iex> TheFuzz.Phonetic.SoundexAlgorithm.compute("rubin")
      "r150"
  """
  def compute(value) do
    cond do
      len(value) == 0 ->
        nil

      !is_alpha?(first(value)) ->
        nil

      true ->
        value
        |> downcase()
        |> do_compute()
    end
  end

  ############################################################################
  ## Helper Functions
  ############################################################################

  defp is_alpha?(char) do
    (char >= "a" and char <= "z") or (char >= "A" and char <= "Z")
  end

  # Main computation - keeps first character and transcodes the rest
  defp do_compute(value) do
    first_char = first(value)
    rest = String.slice(value, 1..-1//1)

    encoded = transcode(rest, first_char, [first_char])

    # Pad to 4 characters with '0'
    encoded
    |> Enum.join()
    |> String.pad_trailing(4, "0")
    |> String.slice(0, 4)
  end

  # Transcode the remaining characters after the first
  defp transcode("", _prev_char, output), do: output

  defp transcode(remaining, prev_char, output) do
    current_char = first(remaining)
    rest = String.slice(remaining, 1..-1//1)

    # Get the soundex code for current character
    code =
      if is_vowel?(prev_char) do
        # After vowel, code twice (unconditional mapping)
        map_char(current_char)
      else
        # After consonant, code once (check against last digit)
        last_digit = get_last_digit(output)
        map_char_conditional(current_char, last_digit)
      end

    # Only append if we have a valid code and haven't reached 3 digits yet
    new_output =
      if code != nil and length(output) < 4 do
        output ++ [code]
      else
        output
      end

    # Stop if we've reached 4 characters total (first char + 3 digits)
    if length(new_output) == 4 do
      new_output
    else
      transcode(rest, current_char, new_output)
    end
  end

  # Check if character is a vowel (or y)
  defp is_vowel?(char) do
    char in ~w(a e i o u y)
  end

  # Unconditional mapping (m2 in Scala) - used after vowels
  defp map_char(char) do
    case char do
      c when c in ~w(b f p v) -> "1"
      c when c in ~w(c g j k q s x z) -> "2"
      c when c in ~w(d t) -> "3"
      "l" -> "4"
      c when c in ~w(m n) -> "5"
      "r" -> "6"
      _ -> nil
    end
  end

  # Conditional mapping (m1 in Scala) - used after consonants
  # Only returns a code if it differs from the previous digit
  defp map_char_conditional(char, prev_digit) do
    case char do
      c when c in ~w(b f p v) and prev_digit != "1" -> "1"
      c when c in ~w(c g j k q s x z) and prev_digit != "2" -> "2"
      c when c in ~w(d t) and prev_digit != "3" -> "3"
      "l" when prev_digit != "4" -> "4"
      c when c in ~w(m n) and prev_digit != "5" -> "5"
      "r" when prev_digit != "6" -> "6"
      _ -> nil
    end
  end

  # Get the last digit from the output array
  defp get_last_digit(output) do
    last = List.last(output)

    # If last element is a digit, return it
    # Otherwise, map it to its digit equivalent
    if last in ~w(1 2 3 4 5 6) do
      last
    else
      map_char(last)
    end
  end
end
