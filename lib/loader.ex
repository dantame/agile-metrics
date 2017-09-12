defmodule Agilytics.Loader do
  def load do
    loaded_data = File.read!("./issues.json")
    |> Poison.Parser.parse!(keys: :atoms)
    |> convert_to_datetime

    %{ issues: loaded_data }
  end

  defp convert_to_datetime(issues) do
    issues
    |> Enum.map(fn issue ->
      changelog = Enum.map(issue.changelog, fn change ->
        {:ok, created, _} = DateTime.from_iso8601(change.created)
        %{ change | created: created }
      end)
      %{ issue | changelog: changelog }
    end)
  end
end
