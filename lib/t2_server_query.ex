defmodule T2ServerQuery do
  @moduledoc """
  Documentation for `T2ServerQuery`.
  """

  require Logger

  # Just a simple debug logging util
  def log(thing_to_log) do
    Logger.info(inspect thing_to_log)
    IO.puts "\n____________________________________________\n"
    thing_to_log
  end


end
