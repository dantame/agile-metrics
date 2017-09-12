defmodule Agilytics.JIRA do
  @auth "Basic REDACTED"
  @endpoint "https://REDACTED.atlassian.net/rest/api/2"
  @project_code "REDACTED"

  def pull do
    headers = ["Authorization": @auth, "Content-Type": "application/json"]
    options = [recv_timeout: 30_000]
    parsed_data = HTTPoison.get!("#{@endpoint}/search?jql=project='#{@project_code}'&expand=changelog&maxResults=1000", headers, options)
    |> parse_response

    File.write!("./issues.json", Poison.encode!(parsed_data))

    IO.puts("We gucci bruv")
  end

  defp parse_response(%{body: body}) do
    decoded_body = body
    |> Poison.Parser.parse!

    parsed_issues = decoded_body["issues"]
    |> Enum.map(fn issue ->
      %{
        id: issue["key"],
        type: issue["fields"]["issuetype"]["name"],
        resolution: issue["fields"]["resolution"]["name"],
        changelog: Enum.filter(issue["changelog"]["histories"], fn history ->
          Enum.any?(history["items"], &(&1["field"] === "status"))
        end)
        |> Enum.map(fn history ->
          {:ok, created, _} = DateTime.from_iso8601(history["created"])
          Enum.map(history["items"], fn item ->
            %{
              created: created,
              fromState: item["fromString"],
              toState: item["toString"]
            }
          end)
        end)
        |> List.flatten
      }
    end)
  end

end
