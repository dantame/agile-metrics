defmodule AgilyticsTest do
  use ExUnit.Case
  doctest Agilytics

  test "greets the world" do
    dataset = %{
      columns: ["Backlog", "Dev In", "Dev Out", "Review In", "Review Out", "Test In", "Test Out", "Release In", "Release Out", "Done"],
      issues: Enum.concat(Forge.issue_list(20), Forge.bug_list(5))
    }
    Agilytics.cycle_time(dataset)
    Agilytics.avg_cycle_time(dataset)
    Agilytics.throughput(dataset)
    Agilytics.monte_carlo_how_many(dataset, 30, 1000)
    assert true
  end
end
