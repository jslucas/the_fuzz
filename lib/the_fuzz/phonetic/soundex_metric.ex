defmodule TheFuzz.Phonetic.SoundexMetric do
  @moduledoc """
  Compares two strings using the Soundex phonetic algorithm.

  Returns true if the strings have the same Soundex encoding, false otherwise.
  """

  import TheFuzz.Phonetic.SoundexAlgorithm, only: [compute: 1]
  import TheFuzz.Util, only: [len: 1]
  import String, only: [downcase: 1, first: 1]

  @doc """
  Compares two values phonetically using Soundex and returns a boolean
  indicating whether they match.

  Returns nil if either string is empty or doesn't start with an alphabetic
  character.

  ## Examples
      iex> TheFuzz.Phonetic.SoundexMetric.compare("robert", "rupert")
      true

      iex> TheFuzz.Phonetic.SoundexMetric.compare("robert", "rubin")
      false
  """
  def compare(a, b) do
    cond do
      # Return nil if either string is empty or doesn't start with alpha
      len(a) == 0 || !is_alpha?(first(a)) || len(b) == 0 || !is_alpha?(first(b)) ->
        nil

      # Early return false if first letters differ (optimization)
      first(downcase(a)) != first(downcase(b)) ->
        false

      # Otherwise compute and compare soundex codes
      true ->
        soundex_a = compute(a)
        soundex_b = compute(b)

        # Both should produce valid codes at this point
        if soundex_a != nil and soundex_b != nil and
           String.length(soundex_a) > 0 and String.length(soundex_b) > 0 do
          soundex_a == soundex_b
        else
          nil
        end
    end
  end

  ############################################################################
  ## Helper Functions
  ############################################################################

  # Check if a character is alphabetic
  defp is_alpha?(char) do
    char >= "a" and char <= "z" or char >= "A" and char <= "Z"
  end
end
