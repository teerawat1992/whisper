# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Whisper.Repo.insert!(%Whisper.SomeModel{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Whisper.{Repo, Post, User}

Repo.delete_all(Post)
Repo.delete_all(User)

changeset = User.registration_changeset(%User{},
  %{"email" => "test@testemail.com", "password" => "1qazxsw2"})
user = Repo.insert!(changeset)

Repo.insert!(%Post{user_id: user.id, title: "Awesome Ruby", url: "https://github.com/markets/awesome-ruby", favorite: true})
Repo.insert!(%Post{user_id: user.id, title: "Awesome Elixir", url: "https://github.com/h4cc/awesome-elixir", favorite: true})
Repo.insert!(%Post{user_id: user.id, title: "Awesome Rust", url: "https://github.com/kud1ing/awesome-rust"})
