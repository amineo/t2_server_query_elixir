defmodule T2ServerQuery do
  @moduledoc """

  Querying a Tribes 2 server actually requires sending 2 different packets to the server where the first byte is denoting the type of information we're asking for. The first is called the `info` packet which doesnt contain much more then the server name. The second is called the `status` packet which contains all the meat and potatoes.

  The `T2ServerQuery.query/3` function makes requests for both `info` and `status` and combines them into a single response for easy consumption.


  ## Installation
      def deps do
        [
          {:t2_server_query, "~> 0.1.3"}
        ]
      end

  ## Usage
      # T2ServerQuery.query("35.239.88.241", port // 28_000, timeout // 3_500)
      T2ServerQuery.query("35.239.88.241")

  ---

  """

  require Logger

  alias T2ServerQuery.PacketParser

  @doc """
  Perform a server query.  **Results should be in the form of a tuple with either `:ok` or `:error`**

      {:ok, %T2ServerQuery.QueryResult{...} }

      {:error, %T2ServerQuery.QueryResult{...} }


  ## Examples

      iex> T2ServerQuery.query("35.239.88.241")
      {:ok,
      %T2ServerQuery.QueryResult{
        bot_count: 0,
        game_type: "Classic",
        map_name: "Canker",
        max_player_count: 64,
        mission_type: "LakRabbit",
        player_count: 0,
        players: [%{}],
        server_description: "Celebrating 20 Years of Tribes2! More information in Discord. <a:playt2.com/discord>playt2.com/discord</a>",
        server_name: "Discord PUB",
        server_status: :online,
        team_count: 1,
        teams: [%{name: "Storm", score: 0}]
      }}

      iex> T2ServerQuery.query("127.0.0.1")
      {:error,
      %T2ServerQuery.QueryResult{
        bot_count: 0,
        game_type: "",
        map_name: "",
        max_player_count: 0,
        mission_type: "",
        player_count: 0,
        players: [],
        server_description: "Host unreachable, timed out.",
        server_name: "127.0.0.1:28000",
        server_status: :offline,
        team_count: 0,
        teams: []
      }}

  """
  @spec query(String.t(), integer(), integer()) :: {atom(), T2ServerQuery.QueryResult.t()}
  def query(server_ip, port \\ 28_000, timeout \\ 3_500) do
    Logger.info "query: #{server_ip}"
    case is_valid_ip?(server_ip) do
      true -> handle_query(server_ip, port, timeout)
      false ->  PacketParser.init({:error, "#{server_ip} - Invalid IP" }, nil)
    end
  end

  @spec handle_query(String.t(), integer(), integer()) :: {atom(), T2ServerQuery.QueryResult.t()}
  defp handle_query(server_ip, port, timeout) do
    {:ok, socket} = :gen_udp.open(0, [:binary, {:active, false}])

    # Convert a string ip from "127.0.0.1" into {127, 0, 0, 1}
    {:ok, s_ip} = server_ip
      |> to_charlist()
      |> :inet.parse_address()


    qry_info_packet   = <<14, 2, 1, 2, 3, 4>>
    qry_status_packet = <<18, 2, 1, 2, 3, 4>>

    # Requst info packet
    :gen_udp.send(socket, s_ip, port, qry_info_packet)
    hex_info_packet = :gen_udp.recv(socket, 0, timeout)
      |> handle_udp_response(server_ip, port)

    # Request status packet
    :gen_udp.send(socket, s_ip, port, qry_status_packet)
    hex_status_packet = :gen_udp.recv(socket, 0, timeout)
      |> handle_udp_response(server_ip, port)

    # Combine and parse results
    PacketParser.init(hex_info_packet, hex_status_packet)
  end

  @spec is_valid_ip?(any()) :: boolean()
  defp is_valid_ip?(nil), do: false
  defp is_valid_ip?(server_ip) do
    case Regex.match?(~r/^([1-2]?[0-9]{1,2}\.){3}([1-2]?[0-9]{1,2})$/, server_ip) do
      false -> false
      true -> true
    end
  end


  @spec handle_udp_response(tuple(), String.t(), integer()) :: tuple() | String.t()
  defp handle_udp_response({:ok, {_ip, port, packet}}, _server_ip, port) do
    packet
      |> Base.encode16
  end

  defp handle_udp_response({:error, :timeout}, server_ip, port) do
    Logger.error "TIMEOUT --> #{server_ip}:#{port}"
    {:error, "#{server_ip}:#{port}"}
  end



  @doc false
  def log(thing_to_log) do
    #  Just a simple debug logging util
    Logger.info(inspect thing_to_log)
    IO.puts "\n____________________________________________\n"
    thing_to_log
  end


end
