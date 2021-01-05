defmodule DurationParser do
  @moduledoc """
  Documentation for DurationParser.
  """

  @doc """
  Duration Parser

  ## Examples

      iex> DurationParser.parse_minutes("2:15")
      {:ok, 135}

      iex> DurationParser.parse_minutes("02:15")
      {:ok, 135}

      iex> DurationParser.parse_minutes("2h 35m")
      {:ok, 155}

      iex> DurationParser.parse_minutes("10")
      {:ok, 10}

      iex> DurationParser.parse_minutes("0.5h")
      {:ok, 30}

      iex> DurationParser.parse_minutes("0.5")
      {:ok, 30}

      iex> DurationParser.parse_minutes("10.0")
      {:ok, 600}

      iex> DurationParser.parse_minutes("7.5")
      {:ok, 450}

      iex> DurationParser.parse_minutes("24.5")
      {:ok, 1470}

      iex> DurationParser.parse_minutes("a24.5")
      {:error, "expected 2 digits"}
  """

  # Regex matches 10:35 | 9:20
  @time_regex ~r/^([0-1]?\d|2[0-3]):([0-5]\d)$/

  # Regex matches 2h35m | 1h10m
  @hour_minute_regex ~r/^([0-1]?[0-9]|2[0-3])h[0-5][0-9]m$/

  # Regex matches 10 | 1 | 2
  @number_regex ~r/^\d+$/

  def parse_minutes(duration) when is_integer(duration) do
    {:ok, duration}
  end

  def parse_minutes(duration) do
    duration = String.replace(duration, " ", "", global: true)

    cond do
      String.match?(duration, @hour_minute_regex) ->
        [hours, minutes, _] = String.split(duration, ["h", "m"])
        {hours, _} = Integer.parse(hours) 
        {minutes, _} = Integer.parse(minutes)
        {:ok, hours * 60 + minutes}

      String.match?(duration, @time_regex) ->
        [hours, minutes] = String.split(duration, ":")
        {hours, _} = Integer.parse(hours) 
        {minutes, _} = Integer.parse(minutes)
        {:ok, hours * 60 + minutes}

      String.match?(duration, @number_regex) ->
        {duration, _} = Integer.parse(duration)
        {:ok, duration}

      :error == Float.parse(duration) ->
        {:error, "expected 2 digits"}

      {duration, _} = Float.parse(duration) ->
        {:ok, floor(duration * 60)}        

      true ->
        {:error, "expected 2 digits"}
    end
  end

end
