defmodule PacketParserTest do
  use ExUnit.Case, async: true

  alias T2ServerQuery.PacketParser

  test "Parse UDP Packet One (Bot Server)" do
    hex_info_packet_one   = "10 02 01 02 03 04 04 56 45 52 35 33 00 00 00 33 00 00 00 CA 61 00 00 13 43 6C 61 73 73 69 63 20 42 6F 74 73 20 53 65 72 76 65 72"
    hex_status_packet_one = "14 02 01 02 03 04 07 43 6C 61 73 73 69 63 10 43 61 70 74 75 72 65 20 74 68 65 20 46 6C 61 67 0F 43 6F 6C 64 20 61 73 20 49 63 65 20 5B 62 5D 21 1D 40 1E B6 09 7F 54 68 69 73 20 73 65 72 76 65 72 20 69 73 20 75 73 69 6E 67 20 62 6F 74 73 20 74 68 61 74 20 61 72 65 20 61 64 61 70 74 65 64 20 74 6F 20 70 6C 61 79 69 6E 67 20 43 6C 61 73 73 69 63 2E 20 68 74 74 70 3A 2F 2F 74 72 69 62 65 73 32 62 6F 74 73 2E 62 79 65 74 68 6F 73 74 34 2E 63 6F 6D 2F 66 6F 72 75 6D 2F 69 6E 64 65 78 2E 70 68 70 3F 74 6F 70 69 63 3D 35 37 2E 6D 73 67 32 33 34 A7 02 32 0A 53 74 6F 72 6D 09 30 0A 49 6E 66 65 72 6E 6F 09 30 0A 32 39 0A 10 0E 52 6F 6F 73 74 65 72 31 32 38 11 09 53 74 6F 72 6D 09 30 0A 10 0E 73 6E 65 61 6B 79 67 6E 6F 6D 65 11 09 49 6E 66 65 72 6E 6F 09 30 0A 10 0E 57 61 6C 64 72 65 64 20 11 09 49 6E 66 65 72 6E 6F 09 30 0A 10 0E 48 44 50 7C 54 65 74 63 68 79 20 11 09 53 74 6F 72 6D 09 30 0A 10 0E 30 77 6E 6A 30 6F 11 09 49 6E 66 65 72 6E 6F 09 30 0A 10 0E 69 64 6A 69 74 20 11 09 53 74 6F 72 6D 09 30 0A 10 0E 4A 65 73 75 73 43 68 72 69 73 74 20 11 09 53 74 6F 72 6D 09 30 0A 10 0E 53 6F 66 61 6B 69 6E 67 2D 7C 2D 62 61 6B 65 44 20 11 09 49 6E 66 65 72 6E 6F 09 30 0A 10 0E 73 61 4B 65 20 11 09 49 6E 66 65 72 6E 6F 09 30 0A 10 0E 5A 75 72 6B 69 6E 57 6F 6F 64 34 39 37 11 09 53 74 6F 72 6D 09 30 0A 10 0E 54 65 72 72 79 54 43 20 11 09 49 6E 66 65 72 6E 6F 09 30 0A 10 0E 57 61 6E 6B 42 75 6C 6C 65 74 20 11 09 53 74 6F 72 6D 09 30 0A 10 0E 43 79 43 6C 6F 6E 65 73 11 09 49 6E 66 65 72 6E 6F 09 30 0A 10 0E 68 75 6E 74 65 72 67 69 72 6C 31 30 11 09 53 74 6F 72 6D 09 30 0A 10 0E 43 68 6F 63 6F 54 61 63 6F 11 09 49 6E 66 65 72 6E 6F 09 30 0A 10 0E 44 69 72 6B 11 09 53 74 6F 72 6D 09 30 0A 10 0E 4B 72 65 6C 6C 11 09 53 74 6F 72 6D 09 30 0A 10 0E 68 69 67 68 35 73 6C 61 79 65 72 11 09 49 6E 66 65 72 6E 6F 09 30 0A 10 0E 52 65 64 20 46 72 61 63 74 69 6F 6E 20 11 09 49 6E 66 65 72 6E 6F 09 30 0A 10 0E 2D 4D 61 4C 69 63 65 2D 2D 11 09 53 74 6F 72 6D 09 30 0A 10 0E 77 69 6C 74 65 64 66 6C 6F 77 65 72 20 11 09 49 6E 66 65 72 6E 6F 09 30 0A 10 0E 47 6C 61 72 6D 20 11 09 53 74 6F 72 6D 09 30 0A 10 0E 41 6C 70 68 61 53 65 6E 74 69 6E 65 6C 11 09 49 6E 66 65 72 6E 6F 09 30 0A 10 0E 5E 54 68 65 2D 50 75 6E 69 73 68 65 72 5E 20 11 09 53 74 6F 72 6D 09 30 0A 10 0E 32 53 6D 4F 6B 65 44 11 09 49 6E 66 65 72 6E 6F 09 30 0A 10 0E 69 50 72 65 63 69 73 69 6F 6E 11 09 53 74 6F 72 6D 09 30 0A 10 0E 48 61 6C 6F 20 32 20 11 09 53 74 6F 72 6D 09 30 0A 10 0E 53 61 6D 69 2D 46 49 4E 20 11 09 49 6E 66 65 72 6E 6F 09 30 0A 10 0E 72 69 6C 65 79 67 61 72 62 65 6C 73 11 09 53 74 6F 72 6D 09 30"

    {:ok, result} = PacketParser.init(hex_info_packet_one, hex_status_packet_one)
      |> T2ServerQuery.log

    assert result.server_status        == :online
    assert result.bot_count            == 30
    assert result.game_type            == "Classic"
    assert result.map_name             == "Cold as Ice [b]"
    assert result.max_player_count     == 64
    assert result.mission_type         == "Capture the Flag"
    assert result.player_count         == 29
    assert length(result.players)      == result.player_count
    assert List.first(result.players)  == %{player: "Rooster128", score: 0, team: "Storm"}
    assert result.server_description   == "This server is using bots that are adapted to playing Classic. http://tribes2bots.byethost4.com/forum/index.php?topic=57.msg234"
    assert result.server_name          == "Classic Bots Server"
    assert result.team_count           == 2
    assert List.first(result.teams)    == %{name: "Storm", score: 0}
  end


  test "Parse UDP Packet Two (DiscordPUB Server)" do
    hex_info_packet_two   = "10 02 01 02 03 04 04 56 45 52 35 33 00 00 00 33 00 00 00 CA 61 00 00 0B 44 69 73 63 6F 72 64 20 50 55 42"
    hex_status_packet_two = "14 02 01 02 03 04 07 43 6C 61 73 73 69 63 09 4C 61 6B 52 61 62 62 69 74 08 53 75 6E 44 61 6E 63 65 A1 00 40 00 E5 08 6A 43 65 6C 65 62 72 61 74 69 6E 67 20 32 30 20 59 65 61 72 73 20 6F 66 20 54 72 69 62 65 73 32 21 20 4D 6F 72 65 20 69 6E 66 6F 72 6D 61 74 69 6F 6E 20 69 6E 20 44 69 73 63 6F 72 64 2E 20 3C 61 3A 70 6C 61 79 74 32 2E 63 6F 6D 2F 64 69 73 63 6F 72 64 3E 70 6C 61 79 74 32 2E 63 6F 6D 2F 64 69 73 63 6F 72 64 3C 2F 61 3E 0B 00 31 0A 53 74 6F 72 6D 09 30 0A 30"

    {:ok, result} = PacketParser.init(hex_info_packet_two, hex_status_packet_two)
      |> T2ServerQuery.log

    assert result.server_status        == :online
    assert result.bot_count            == 0
    assert result.game_type            == "Classic"
    assert result.map_name             == "SunDance"
    assert result.max_player_count     == 64
    assert result.mission_type         == "LakRabbit"
    assert result.player_count         == 0
    assert List.first(result.players)  == %{}
    assert result.server_description   == "Celebrating 20 Years of Tribes2! More information in Discord. <a:playt2.com/discord>playt2.com/discord</a>"
    assert result.server_name          == "Discord PUB"
    assert result.team_count           == 1
    assert List.first(result.teams)    == %{name: "Storm", score: 0}
  end


end
