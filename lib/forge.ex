defmodule Forge do
  use Blacksmith
  register :issue,
    type: "issue",
    id: Sequence.next(:id),
    title: Faker.Lorem.sentence(5),
    timings: Enum.map(1..10, fn x -> Faker.DateTime.backward(30) end) |> Enum.sort

  register :bug,
    [prototype: :issue],
    type: "bug"
end
