defmodule Insta_Iphoto do

  def start() do
    System.argv()
  end

  def get_json do
    with {:ok, body} <- File.read("/app/fixtures/content/posts_1.json"),
          {:ok, json} <- Jason.decode!(body), do: {:ok, json}
  end

end

IO.inspect(Insta_Iphoto.start())
