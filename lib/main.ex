defmodule Agilytics.Main do

  def main(args) do
    HTTPoison.start
    {opts,_,_} = OptionParser.parse(args, switches: [pull: :boolean], aliases: [p: :pull])

    case opts[:pull] do
      true ->
        Agilytics.JIRA.pull
      _ ->
        Agilytics.Loader.load
        |> Agilytics.Metrics.find_end_state
        |> IO.inspect
    end
  end

end
