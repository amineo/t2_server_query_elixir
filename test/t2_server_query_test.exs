defmodule T2ServerQueryTest do
  use ExUnit.Case, async: true

  # doctest T2ServerQuery


  test "Gracefully handle timeouts and unreachable servers" do
    # We know this query is going to timeout, so lets not wait around :)
    timeout = 250

    port = Enum.random(28_000..28_999)
    {:error, result} = T2ServerQuery.query("127.0.0.1", port, timeout)
      |> T2ServerQuery.log

    assert result.server_status      == :offline
    assert result.server_description == "Host unreachable, timed out."
    assert result.server_name        == "127.0.0.1:#{port}"
  end


  test "Live test a number of Tribes 2 servers" do
    tasks = [
      Task.async(T2ServerQuery, :query, ["35.239.88.241", 28_000]),
      Task.async(T2ServerQuery, :query, ["67.222.138.13"])
    ]

    Task.yield_many(tasks)
      |> Enum.map(fn {_task, result} ->
        test_server_status(result)
      end)

  end

  defp test_server_status({:ok, _}) do
    assert true
  end
  defp test_server_status({:error, _}) do
    assert false
  end
  defp test_server_status(nil) do
    assert false
  end

end



#qry_test = T2ServerQuery.query("127.0.0.1")
#IO.inspect qry_test

#qry_test2 = T2ServerQuery.query("35.239.88.241")
#IO.inspect qry_test2


# tasks = [
#   Task.async(T2ServerQuery, :query, ["127.0.0.1"]),
#   Task.async(T2ServerQuery, :query, ["35.239.88.241"]),
#   Task.async(T2ServerQuery, :query, ["97.99.172.12", 28001]),
#   Task.async(T2ServerQuery, :query, ["67.222.138.13"]),
#   Task.async(T2ServerQuery, :query, ["91.55.51.94"]),
# ]

# IO.inspect Task.yield_many(tasks)

# task0 = Task.async(T2ServerQuery, :query, ["127.0.0.1"])
# task1 = Task.async(T2ServerQuery, :query, ["35.239.88.241"])
# task2 = Task.async(T2ServerQuery, :query, ["97.99.172.12", 28001])
# task3 = Task.async(T2ServerQuery, :query, ["67.222.138.13"])
# task4 = Task.async(T2ServerQuery, :query, ["91.55.51.94"])
# # res4 = Task.await(task4)
# # IO.inspect res4.server_name

# res0 = Task.await(task0)
# res1 = Task.await(task1)
# res2 = Task.await(task2)
# res3 = Task.await(task3)
# res4 = Task.await(task4)


# IO.inspect res1.server_name
# IO.inspect res2.server_name
# IO.inspect res3.server_name
# IO.inspect res4.server_name

# T2ServerQuery.query("35.239.88.241")
# T2ServerQuery.query("97.99.172.12", 28001)
# T2ServerQuery.query("67.222.138.13")
# T2ServerQuery.query("91.55.51.94")
