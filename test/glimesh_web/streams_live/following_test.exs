defmodule GlimeshWeb.StreamsLive.FollowingTest do
  use GlimeshWeb.ConnCase

  import Glimesh.AccountsFixtures
  import Phoenix.LiveViewTest

  defp create_channel(_) do
    streamer = streamer_fixture(%{}, %{})
    Glimesh.Streams.start_stream(streamer.channel)

    %{
      channel: streamer.channel,
      streamer: streamer
    }
  end

  describe "Following List" do
    setup [:register_and_log_in_user, :create_channel]

    test "lists no followed streams", %{
      conn: conn
    } do
      {:ok, _, html} = live(conn, Routes.streams_list_path(conn, :index, "following"))

      assert html =~ "Followed Streams"
      assert html =~ "None of the streams you follow are live"
      assert html =~ "All Followed Streamers"
      assert html =~ "You do not follow anyone who is offline"
    end

    test "lists some followed streams", %{
      conn: conn,
      streamer: streamer,
      channel: channel,
      user: user
    } do
      Glimesh.AccountFollows.follow(streamer, user)

      {:ok, _, html} = live(conn, Routes.streams_list_path(conn, :index, "following"))

      assert html =~ "Followed Streams"
      assert html =~ streamer.displayname
      assert html =~ channel.title
    end

    test "lists users that are offline", %{
      conn: conn,
      user: user
    } do
      streamer = streamer_fixture()
      Glimesh.AccountFollows.follow(streamer, user)

      {:ok, _, html} = live(conn, Routes.streams_list_path(conn, :index, "following"))

      assert html =~ "All Followed Streamers"
      assert html =~ streamer.displayname
    end
  end
end
