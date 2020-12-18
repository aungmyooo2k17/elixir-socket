defmodule HelloSocketsWeb.PingChannel do
  use Phoenix.Channel

  intercept(["request_ping", "announcement"])

  def join(_topic, _payload, socket) do
    {:ok, socket}
  end

  def handle_in("ping", _payload, socket) do
    {:reply, {:ok, %{ping: "pong"}}, socket}
  end

  def handle_in("pong", _payload, socket) do
    # We only handle ping
    {:noreply, socket}
  end

  def handle_in("pang", _payload, socket) do
    {:stop, :shutdown, {:ok, %{msg: "shutting down"}}, socket}
  end

  def handle_out("request_ping", _payload, socket) do
    push(socket, "send_ping", %{})
    {:noreply, socket}
  end

  def handle_out("announcement", _payload, socket) do
    push(socket, "announcement", %{})
    {:noreply, socket}
  end
end
