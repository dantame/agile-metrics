defmodule Agilytics.JIRA do
  @auth "Basic REDACTED=="
  @endpoint "https://issues.apache.org/jira/rest/api/2"
  @project_code "ZOOKEEPER"

  def pull do
    data = Stream.resource(&start/0, &next/1, &stop/1)
    |> Enum.concat([])

    File.write!("./#{@project_code}.json", Poison.encode!(data))

    IO.puts("We gucci bruv")
  end

  defp start do
    IO.puts("PAGE 1")
    get_api()
  end

  defp next({nil, _}) do
    {:halt, nil}
  end

  defp next({[], _}) do
    {:halt, nil}
  end

  defp next({prev_items, start_at}) do
    IO.puts("PAGE #{div((start_at + 2000), 1000)}")
    { items, start_at_new } = get_api(start_at + 1000)

    { prev_items, { items, start_at_new } }
  end

  defp stop(_) do
  end

  defp get_api(start_at \\ 0) do
    headers = ["Authorization": @auth, "Content-Type": "application/json"]
    options = [recv_timeout: 600_000]
    data = HTTPoison.get!("#{@endpoint}/search?jql=project='#{@project_code}'&expand=changelog&maxResults=1000&startAt=#{start_at}", headers, options)
           |> parse_response
    {data, start_at}
  end


  defp parse_response(%{body: body}) do
    decoded_body = body
    |> Poison.Parser.parse!

    decoded_body["issues"]
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
