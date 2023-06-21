defmodule ChannelServerWeb.DeviceChannel do
  use ChannelServerWeb, :channel
  require Logger

  @impl true
  def join("device:general", payload, socket) do
    if authorized?(payload) do
      Logger.info "Device joined lobby"
      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  @impl true
  def handle_in("ping", payload, socket) do
    {:reply, {:ok, payload}, socket}
  end

  @impl true
  def handle_in("hello", _payload, socket) do
    Logger.info "Received HELLO"
    # an asynchronous push with no reply:

    {:noreply, socket}
  end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (device:lobby).
  @impl true
  def handle_in("shout", payload, socket) do
    broadcast(socket, "shout", payload)
    {:noreply, socket}
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end
