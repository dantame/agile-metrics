defmodule Agilytics.Main do

  def main(args) do
    HTTPoison.start
    {opts,_,_} = OptionParser.parse(args, switches: [pull: :boolean], aliases: [p: :pull])

    case opts[:pull] do
      true ->
        Agilytics.JIRA.pull
      _ ->
        IO.puts("NOT PULLING")
        #Agilytics.gather_metrics(File.read!("./issues.json"))
    end
  end

end
