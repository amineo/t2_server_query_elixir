defmodule T2ServerQuery.PacketParser do
  @moduledoc """
  This module does the heavy lifting with parsing a Tribes 2 query response packet.

  ## UDP Packet Anatomy

  ### Info Packet
      <<
        _header     :: size(192),
        server_name :: bitstring
      >>

  ### Status Packet
      <<
        _header :: size(48),

        game_type_length    :: little-integer,
        game_type           :: binary-size(game_type_length),
        mission_type_length :: little-integer,
        mission_type        :: binary-size(mission_type_length),
        map_name_length     :: little-integer,
        map_name            :: binary-size(map_name_length),

        _skip_a :: size(8),

        player_count     :: little-integer,
        max_player_count :: little-integer,
        bot_count        :: little-integer,

        _skip_b :: size(16),

        server_description_length :: little-integer,
        server_description        :: binary-size(server_description_length),

        _skip_c :: size(16),

        team_count :: binary-size(1),

        rest :: bitstring
      >>

  Notice the `_skip_(a|b|c)` mappings. I havn't quite figured out what they refer to yet but they don't seem that important. They likely relate to a few server flags like `tournament_mode`, `cpu_speed`, `is_linux`.

  Refer to `T2ServerQuery.QueryResult` for what a typical struct would look like.

  """


  alias T2ServerQuery.QueryResult

  @doc """
    This function expects both an `info` and `status` packet to be passed in that is in a `Base.encode16` format.
    Normally you wouldn't need to run this function manually since it's called in a pipeline from the main `T2ServerQuery.query`

  """
  @spec init({:error, String.t()}, any()) :: {:error, map()}
  def init({:error, host}, _) do
    results = %QueryResult{}

    {:error,
      %{results |
        server_status: :offline,
        server_name: host,
        server_description: "Host unreachable, timed out."
      }
    }
  end

  @spec init(binary(), binary()) :: {:ok, QueryResult.t()}
  def init(info_packet, status_packet) when is_binary(info_packet) and is_binary(status_packet) do

    info_results = info_packet
      |> decode_clean_packet()
      |> handle_info_packet()


    status_results = status_packet
      |> decode_clean_packet()
      |> handle_status_packet()
      |> parse_player_team_scores()


    pack_results({:ok, status_results, info_results})
  end

  @spec pack_results({:ok, map(), map()}) :: {:ok, QueryResult.t()}
  defp pack_results({:ok, status_results, info_results}) do
    results = %QueryResult{}

    {:ok,
      %{results |
        server_status:      :online,
        server_name:        info_results.server_name,
        game_type:          status_results.game_type,
        mission_type:       status_results.mission_type,
        map_name:           status_results.map_name,
        player_count:       status_results.player_count,
        max_player_count:   status_results.max_player_count,
        bot_count:          status_results.bot_count,
        server_description: status_results.server_description,
        team_count:         status_results.team_count,
        teams:              status_results.teams,
        players:            status_results.players
      }
    }
  end

  # Info packet structure
  defp handle_info_packet({:ok, info_packet}) do
    <<
      _header     :: size(192),
      server_name :: bitstring
    >> = info_packet

    %{server_name: server_name}
  end


  # Status packet structure
  defp handle_status_packet({:ok, status_packet}) do
    #IO.inspect status_packet, limit: :infinity
    <<
      _header :: size(48),

      game_type_length    :: little-integer,
      game_type           :: binary-size(game_type_length),
      mission_type_length :: little-integer,
      mission_type        :: binary-size(mission_type_length),
      map_name_length     :: little-integer,
      map_name            :: binary-size(map_name_length),

      _skip_a :: size(8),

      player_count     :: little-integer,
      max_player_count :: little-integer,
      bot_count        :: little-integer,

      _skip_b :: size(16),

      server_description_length :: little-integer,
      server_description        :: binary-size(server_description_length),

      _skip_c :: size(16),

      team_count :: binary-size(1),

      rest :: bitstring
    >> =  status_packet


    %{
      game_type_length:           game_type_length,
      game_type:                  game_type,
      mission_type_length:        mission_type_length,
      mission_type:               mission_type,
      map_name_length:            map_name_length,
      map_name:                   map_name,
      player_count:               player_count,
      max_player_count:           max_player_count,
      bot_count:                  bot_count,
      server_description_length:  server_description_length,
      server_description:         server_description,
      team_count:                 String.to_integer(team_count),
      teams:                      [],
      players:                    [],
      data:                       rest
    }
  end



  # Take the ..rest of the status packet and parse out the team and player scores
  defp parse_player_team_scores(packet) do
    ## Break the status query packet into multiple parts
    ## raw_game_info contains the map, gametype, mod, and description
    ## raw_players_info contains players, assigned team and score
    [raw_team_scores | raw_players_info] = String.split(packet.data, "\n#{packet.player_count}", trim: true)

    pack_teams = raw_team_scores
      |> String.trim_leading
      |> String.split("\n")
      |> Enum.map(&parse_team_scores(&1))
      |> Enum.to_list


    pack_players = raw_players_info
      |> clean_player_info()
      |> Enum.map(&parse_player_scores(&1))
      |> Enum.to_list

    # We're done parsing the data key so we can remove it from our compiled struct
    cleaned_packet = Map.delete(packet, :data)
    %{cleaned_packet | teams: pack_teams, players: pack_players }
  end


  # Convert player array into a map
  # parse_player_scores(["Inferno", "305"])
  # > %{team: "Inferno", score: 305}
  defp parse_team_scores(raw_team_scores) do
    Enum.zip([:name, :score], String.split(raw_team_scores, "\t"))
      |> Map.new
      |> convert_score()
  end


  # Convert player array into a map
  # parse_player_scores(["Anthony", "Storm", "100"])
  # > %{player: "ElKapitan ", score: 100, team: "Inferno"}
  defp parse_player_scores(player) do
    Enum.zip([:player, :team, :score], String.split(player, "\t", trim: true))
      |> Map.new
      |> convert_score()
  end

  # Clean and spaces that might be in the packet for odd reason
  defp decode_clean_packet(packet) do
    packet
      |> String.replace(" ", "")
      |> Base.decode16(case: :mixed)
  end

  # Convert string scores into integers
  defp convert_score(%{score: score} = data) when is_binary(score) and not is_nil(data), do: %{data | score: String.to_integer(score)}
  defp convert_score(%{score: score} = data) when is_integer(score) and not is_nil(data), do: data
  defp convert_score(data), do: data

  # Strip all non-printable UTF chars but preserve spaces, tabs and new-lines
  defp clean_player_info(raw_players_info) do
    Regex.replace(~r/(*UTF)[^\w\ \t\n\/*+-]+/, List.to_string(raw_players_info), "")
      |> String.trim_leading
      |> String.split("\n")
  end

end
