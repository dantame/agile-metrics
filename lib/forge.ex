defmodule Forge do
  use Blacksmith
  register :issue,
    type: "issue",
    id: Sequence.next(:id),
    changelog: Enum.map(1..10, fn x -> %{ created: Faker.DateTime.backward(30) } end) |> Enum.sort_by(&(&1.created))
    

  register :bug,
    [prototype: :issue],
    type: "bug"
end
