# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Rumbl.Repo.insert!(%SomeModel{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Rumbl.Repo
alias Rumbl.Category
alias Rumbl.Video

for category <- ~w(Action Drama Romance Comedy Sci-fi) do
  if !Repo.get_by(Category, name: category) do
   new_cat = Repo.insert!(%Category{name: category})
   Repo.insert!(%Video{category_id: new_cat.id, url: "foo", title: "bar",
    description: "baz"})
  end
end
