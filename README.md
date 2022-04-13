# T2ServerQuery

Querying a Tribes 2 server actually requires sending 2 different packets to the server where the first byte is denoting the type of information we're asking for. The first is called the `info` packet which doesnt contain much more then the server name. The second is called the `status` packet which contains all the meat and potatoes.

The `T2ServerQuery.query/3` function makes requests for both `info` and `status` and combines them into a single response for easy consumption.



## Installation

The package can be installed by adding `t2_server_query` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:t2_server_query, "~> 0.1.3"}
  ]
end
```


## Usage

```elixir
# T2ServerQuery.query("35.239.88.241", port // 28_000, timeout // 3_500)
  T2ServerQuery.query("35.239.88.241")
  
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
```

## Docs
The docs can be found at [https://hexdocs.pm/t2_server_query](https://hexdocs.pm/t2_server_query).

Documentation has been generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm).

