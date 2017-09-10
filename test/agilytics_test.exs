defmodule AgilyticsTest do
  use ExUnit.Case
  doctest Agilytics

  test "greets the world" do
    dataset = %{
      columns: ["Backlog", "Dev In", "Dev Out", "Review In", "Review Out", "Test In", "Test Out", "Release In", "Release Out", "Done"],
      issues: Enum.concat(Forge.issue_list(90), Forge.bug_list(10))
    }
    IO.puts("CYCLE TIME")
    Agilytics.cycle_time(dataset)
    |> IO.inspect
    IO.puts("AVG CYCLE TIME")
    Agilytics.avg_cycle_time(dataset)
    |> IO.inspect
    IO.puts("THROUGHPUT")
    throughput = Agilytics.throughput(dataset)
    |> IO.inspect
    IO.puts("MONTE CARLO HOW MANY")
    monte_how = Agilytics.monte_carlo_how_many(dataset, 30, 100000)
                |> IO.inspect

    IO.puts("MONTE CARLO WHEN")
    monte_when = Agilytics.monte_carlo_when(dataset, 44, 100000)
                 |> IO.inspect

    File.write!('./monte_when.json', Poison.encode!(monte_when), [:binary])
    File.write!('./monte_how.json', Poison.encode!(monte_how), [:binary])
    File.write!('./throughput.json', Poison.encode!(throughput), [:binary])

    assert true
  end
end
