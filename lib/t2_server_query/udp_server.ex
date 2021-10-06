defmodule T2ServerQuery.UdpServer do
  @moduledoc """
  Documentation for `UdpServer`.
  """
  require Logger

  alias T2ServerQuery.PacketParser

  @doc """
  Perform a server query.
  Results should be in the form of a tuple
    - {:ok, %T2ServerQuery.QueryResult{}}
    - {:error, %T2ServerQuery.QueryResult{}}

  Querying a Tribes 2 server actually requires sending 2 different packets to the server where the first byte is denoting what we're asking for in response. The first is called the 'info' packet which doesnt contain much more then the server name. The second is called the 'status' packet which contains all the meat and potatoes.


  ## Examples

      iex> T2ServerQuery.UdpServer.query("35.239.88.241")
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

      iex> T2ServerQuery.UdpServer.query("127.0.0.1")
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
  def query(server_ip, port \\ 28_000, timeout \\ 3_500) do
    Logger.info "query: #{server_ip}"

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


  defp handle_udp_response({:ok, {_ip, _port, packet}}, _server_ip, _port) do
    packet
      |> Base.encode16
  end

  defp handle_udp_response({:error, :timeout}, server_ip, port) do
    Logger.error "TIMEOUT --> #{server_ip}:#{port}"
    {:error, "#{server_ip}:#{port}"}
  end

end
