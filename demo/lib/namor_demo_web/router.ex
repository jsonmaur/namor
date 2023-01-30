defmodule NamorDemoWeb.Router do
  use NamorDemoWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :put_root_layout, {NamorDemoWeb.Layouts, :root}
  end

  scope "/", NamorDemoWeb do
    pipe_through [:browser]

    live "/", IndexLive
  end
end
