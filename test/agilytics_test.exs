defmodule AgilyticsTest do
  use ExUnit.Case
  doctest Agilytics

  test "greets the world" do
    dataset = %{
      columns: ["Backlog", "Dev In", "Dev Out", "Review In", "Review Out", "Test In", "Test Out", "Release In", "Release Out", "Done"],
      issues: Enum.concat(Forge.issue_list(20), Forge.bug_list(5))
    }
    IO.puts("CYCLE TIME")
    Agilytics.cycle_time(dataset)
    |> IO.inspect
    IO.puts("AVG CYCLE TIME")
    Agilytics.avg_cycle_time(dataset)
    |> IO.inspect
    IO.puts("THROUGHPUT")
    Agilytics.throughput(dataset)
    |> IO.inspect
    IO.puts("MONTE CARLO HOW MANY")
    Agilytics.monte_carlo_how_many(dataset, 30, 1000)
    |> IO.inspect
    IO.puts("MONTE CARLO WHEN")
    Agilytics.monte_carlo_when(dataset, 44, 1000)
    |> IO.inspect
    assert true
  end
end
