defmodule HelloSocketsWeb.AuthSocket do
  use Phoenix.Socket
  require Logger

  @one_day 86400

  channel "ping", HelloSocketsWeb.PingChannel
  channel "tracked", HelloSocketsWeb.TrackedChannel

  def connect(%{"token" => token}, socket) do
    case verify(socket, token) do
      {:ok, user_id} ->
        socket = assign(socket, :user_id, user_id)
        {:ok, socket}
      {:error, err} ->
        Logger.error("#{__MODULE__} connect error #{inspect(err)}")
        :error
    end
  end

  def connect(_, socket) do
    Logger.error("#{__MODULE__} connect error missing params")
    :error
  end

  defp verify(socket, token),
    do:
      Phoenix.Token.verify(socket, "salt identifier", token, max_age: @one_day)


  def id(_socket = %{assigns: %{user_id: user_id}}),
    do: "auth_socket:#{user_id}"
end
