defmodule GlimeshWeb.UserSettings.Components.ChannelStatisticsLive do
  use GlimeshWeb, :live_view

  alias Glimesh.Accounts
  alias Glimesh.ChannelLookups

  def mount(_params, session, socket) do
    streamer = Accounts.get_user_by_session_token(session["user_token"])

    case ChannelLookups.get_channel_for_user(streamer) do
      %Glimesh.Streams.Channel{} = channel ->
        {:ok,
         socket
         |> assign(:streams, Glimesh.Streams.list_streams(channel))
         |> assign(:channel, channel)}

      nil ->
        {:ok, redirect(socket, to: "/")}
    end
  end
end
