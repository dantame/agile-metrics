defmodule Agilytics.Main do

  def main(args) do
    HTTPoison.start
    {opts,_,_} = OptionParser.parse(args, switches: [pull: :boolean, file: :string], aliases: [p: :pull, f: :file])

    case opts[:pull] do
      true ->
        Agilytics.JIRA.pull
      _ ->
    end

    if (opts[:file] != nil) do
        Agilytics.Loader.load(opts[:file])
        |> Agilytics.Metrics.find_end_state
        |> IO.inspect
    end
  end

end
