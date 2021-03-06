defmodule Whisper.PostControllerTest do
  use Whisper.ConnCase

  alias Whisper.{Post, User}

  setup do
    user = Repo.insert!(%User{email: "test@gmail.com", password: "1qazxsw2"})
    post = Repo.insert!(%Post{title: "test title", url: "http://test.com", user_id: user.id})
    conn = assign(build_conn(), :current_user, user)

    {:ok, user: user, post: post, conn: conn}
  end

  @valid_attrs %{title: "Awesome Elixir", url: "https://www.awesome-elixir.com"}
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, post_path(conn, :index)
    assert html_response(conn, 200)
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, post_path(conn, :new)
    assert html_response(conn, 200) =~ "New post"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, post_path(conn, :create), post: @valid_attrs
    assert redirected_to(conn) == post_path(conn, :index)
    assert Repo.get_by(Post, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, post_path(conn, :create), post: @invalid_attrs
    assert html_response(conn, 200) =~ "New post"
  end

  test "shows chosen resource", %{conn: conn, post: post} do
    conn = get conn, post_path(conn, :show, post)
    assert html_response(conn, 200) =~ "test title"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, post_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn, post: post} do
    conn = get conn, post_path(conn, :edit, post)
    assert html_response(conn, 200) =~ "Edit post"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn, post: post} do
    conn = put conn, post_path(conn, :update, post), post: @valid_attrs
    assert redirected_to(conn) == post_path(conn, :show, post)
    assert Repo.get_by(Post, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn, post: post} do
    conn = put conn, post_path(conn, :update, post), post: %{"title" => "", "url" => ""}
    assert html_response(conn, 200) =~ "Edit post"
  end

  test "deletes chosen resource", %{conn: conn, post: post} do
    conn = delete conn, post_path(conn, :delete, post)
    assert redirected_to(conn) == post_path(conn, :index)
    refute Repo.get(Post, post.id)
  end
end
