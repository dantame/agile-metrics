defmodule Agilytics do
  def cycle_time(dataset) do
    Enum.map(dataset.issues, fn issue ->
      first = List.first(issue.timings)
      last = List.last(issue.timings)
      Map.put(issue, :cycle_time, DateTime.diff(last, first))
    end)
    |> IO.inspect
  end

  def avg_cycle_time(dataset) do
    issues_with_cycle = cycle_time(dataset)

    total_time = issues_with_cycle
    |> Enum.reduce(0, &(&1.cycle_time + &2))

    avg_cycle = total_time / length(issues_with_cycle)
    IO.inspect(avg_cycle)
  end

  def throughput_by_issue(dataset) do
    throughput_data = dataset.issues
    |> Enum.group_by(fn issue ->
      List.last(issue.timings)
      |> DateTime.to_date
    end)
    IO.inspect(throughput_data)
  end

  def throughput(dataset) do
    throughput_by_issue(dataset)
    |> Enum.map(fn {k, v} ->
      {k, length(v)}
    end)
    |> Enum.into(%{})
    |> IO.inspect
  end
end