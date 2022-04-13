defmodule T2ServerQuery.QueryResult do
  @moduledoc """
  ## Struct Shape

      %T2ServerQuery.QueryResult{
        server_status:  :online,
        bot_count: 30,
        game_type: "Classic",
        map_name: "Cold as Ice [b]",
        max_player_count: 64,
        mission_type: "Capture the Flag",
        player_count: 29,
        players: [
          %{player: "Rooster128", score: "0", team: "Storm"},
          %{player: "sneakygnome", score: "0", team: "Inferno"},
          %{player: "Waldred ", score: "0", team: "Inferno"},
          %{player: "HDPTetchy ", score: "0", team: "Storm"},
          %{player: "0wnj0o", score: "0", team: "Inferno"},
          %{player: "idjit ", score: "0", team: "Storm"},
          %{player: "JesusChrist ", score: "0", team: "Storm"},
          %{player: "Sofaking--bakeD ", score: "0", team: "Inferno"},
          %{player: "saKe ", score: "0", team: "Inferno"},
          %{player: "ZurkinWood497", score: "0", team: "Storm"},
          %{player: "TerryTC ", score: "0", team: "Inferno"},
          %{player: "WankBullet ", score: "0", team: "Storm"},
          %{player: "CyClones", score: "0", team: "Inferno"},
          %{player: "huntergirl10", score: "0", team: "Storm"},
          %{player: "ChocoTaco", score: "0", team: "Inferno"},
          %{player: "Dirk", score: "0", team: "Storm"},
          %{player: "Krell", score: "0", team: "Storm"},
          %{player: "high5slayer", score: "0", team: "Inferno"},
          %{player: "Red Fraction ", score: "0", team: "Inferno"},
          %{player: "-MaLice--", score: "0", team: "Storm"},
          %{player: "wiltedflower ", score: "0", team: "Inferno"},
          %{player: "Glarm ", score: "0", team: "Storm"},
          %{player: "AlphaSentinel", score: "0", team: "Inferno"},
          %{player: "The-Punisher ", score: "0", team: "Storm"},
          %{player: "2SmOkeD", score: "0", team: "Inferno"},
          %{player: "iPrecision", score: "0", team: "Storm"},
          %{player: "Halo 2 ", score: "0", team: "Storm"},
          %{player: "Sami-FIN ", score: "0", team: "Inferno"},
          %{player: "rileygarbels", score: "0", team: "Storm"}
        ],
        server_description: "This server is using bots that are adapted to playing Classic. http://tribes2bots.byethost4.com/forum/index.php?topic=57.msg234",
        server_name: "Classic Bots Server",
        team_count: 2,
        teams: [%{name: "Storm", score: "0"}, %{name: "Inferno", score: "0"}]
      }
  """

  @type t() :: %__MODULE__{
    server_status:      atom(),
    server_name:        String.t(),
    game_type:          String.t(),
    mission_type:       String.t(),
    map_name:           String.t(),
    player_count:      integer(),
    max_player_count:  integer(),
    bot_count:         integer(),
    server_description: String.t(),
    team_count:        integer(),
    teams:              list(),
    players:            list()
  }

  defstruct [
    server_status:      :offline,
    server_name:        "",
    game_type:          "",
    mission_type:       "",
    map_name:           "",
    player_count:       0,
    max_player_count:   0,
    bot_count:          0,
    server_description: "",
    team_count:         0,
    teams:              [],
    players:            []
  ]
end
