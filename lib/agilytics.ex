defmodule Agilytics do
  def cycle_time(dataset) do
    Enum.map(dataset.issues, fn issue ->
      first = List.first(issue.timings)
      last = List.last(issue.timings)
      Map.put(issue, :cycle_time, DateTime.diff(last, first))
    end)
  end

  def avg_cycle_time(dataset) do
    issues_with_cycle = cycle_time(dataset)

    total_time = issues_with_cycle
    |> Enum.reduce(0, &(&1.cycle_time + &2))

    total_time / length(issues_with_cycle)
  end

  def throughput_by_issue(dataset) do
    dataset.issues
    |> Enum.group_by(fn issue ->
      List.last(issue.timings)
      |> DateTime.to_date
    end)
  end

  def throughput(dataset) do
    throughput_by_issue(dataset)
    |> Enum.map(fn {k, v} ->
      {k, length(v)}
    end)
    |> Enum.into(%{})
  end

  def monte_carlo_how_many(dataset, num_days, num_trials) do
    daily_throughput = throughput(dataset)
    |> Enum.map(fn {_, v} -> v end)

    monte_carlo_trial(&monte_carlo_how_many_trial/2, [daily_throughput, num_days], num_trials)
  end

  defp monte_carlo_how_many_trial(daily_throughput, num_days) do
    Enum.reduce(1..num_days, fn (_, acc) ->
      Enum.random(daily_throughput) + acc
    end)
  end

  def monte_carlo_when(dataset, num_tickets, num_trials) do
    daily_throughput = throughput(dataset)
    |> Enum.map(fn {_, v} -> v end)

    monte_carlo_trial(&monte_carlo_when_trial/2, [daily_throughput, num_tickets], num_trials)
  end

  defp monte_carlo_when_trial(daily_throughput, num_tickets) do
    Stream.iterate(Enum.random(daily_throughput), fn _ -> Enum.random(daily_throughput) end)
    |> Enum.reduce_while(%{days: 0, tickets: 0}, fn day_throughput, acc ->
      if acc.tickets < num_tickets, do: {:cont, %{acc | days: acc.days + 1, tickets: acc.tickets + day_throughput}}, else: {:halt, acc}
    end)
    |> Map.get(:days)
  end

  defp monte_carlo_trial(trial, trial_args, num_trials) do
    trials = Enum.map(1..num_trials, fn _ ->
      apply(trial, trial_args)
    end)

    Enum.map(1..100, fn p ->
      {p, Statistics.percentile(trials, p)}
    end)
  end
end
