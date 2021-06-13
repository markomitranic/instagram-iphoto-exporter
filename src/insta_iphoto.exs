defmodule Insta_Iphoto do
  @moduledoc """
  Parses the json metadata provided by Instagram
  and updates EXIF dates on the files.
  """

  @doc """
  Parses the json metadata provided by Instagram
  and updates EXIF dates to the actual json data
  using the reschedule_image/2 function.
  """
  def start() do
    [posts_json_path] = System.argv()
    {:ok, json} = get_json_data(posts_json_path)
    hydrated_metadata = hydrate_data(json)

    hydrated_metadata
      |> Enum.each(fn {:ok, file_path, date_time} ->
        case reschedule_image(file_path, date_time) do
          {:ok, _message} -> IO.write(".")
          {:error, message} -> IO.inspect(file_path, date_time, message)
        end
      end)
  end

  @doc """
  Changes all the EXIF and FS dates on an image
  using the underlying OS exiftool.

  Outputs the files into /app/output/ folder

  exiftool \
    -AllDates="2000:05:22 06:36:16" \
    -FileModifyDate="2000:05:22 06:36:16" \
    -o /app/output/ \
    /app/fixtures/marko.jpg

  # Examples:
    > reschedule_image("marko.jpg", ~U[2020-03-13 18:59:00Z])
    {:ok, ["1 image files created"]}

    > reschedule_image("1.exe", true)
    {:error, ["Error message"]}
  """
  def reschedule_image(file_path, date) do
    formatted_date_string = exiftool_format_date(date)
    random_dirname = for _ <- 1..20, into: "", do: <<Enum.random('0123456789abcdef')>>

    Exiftool.execute([
      "-AllDates=\"#{formatted_date_string}\"",
      "-FileModifyDate=\"#{formatted_date_string}\"",
      "-o",
      "/app/output/#{random_dirname}/",
      file_path
    ])
  end

  defp get_json_data(posts_json_path) do
    {:ok, body} = File.read(posts_json_path)
    {:ok, Jason.decode!(body)}
  end

  defp hydrate_data(json_data) do
    json_data
      |> Enum.flat_map(fn %{"media" => subitems} -> subitems end)
      |> Enum.map(fn %{"uri" => file_location, "creation_timestamp" => timestamp}
        -> {:ok, "/app/fixtures/#{file_location}", DateTime.from_unix!(timestamp)} end)
  end

  defp exiftool_format_date(date) do
    :io_lib.format(
      "~4..0B:~2..0B:~2..0B ~2..0B:~2..0B:~2..0B",
      [date.year, date.month, date.day, date.hour, date.minute, date.second]
    )
    |> IO.iodata_to_binary()
  end

end

defmodule Exiftool do
  @moduledoc """
  Documentation for Exiftool.
  """

  def execute(args) when is_list(args) do
    case System.cmd(exiftool_path(), args, stderr_to_stdout: true) do
      {data, 0} -> {:ok, parse_result(data)}
      {error, _exit_code} -> {:error, parse_result(error)}
    end
  end

  defp parse_result(raw_output) do
    raw_output
    |> String.split("\n")
    |> Enum.filter(&(&1 != ""))
    |> Enum.map(&String.trim/1)
  end

  defp exiftool_path do
    case Application.get_env(:exiftool, :path, nil) do
      nil -> System.find_executable("exiftool") || exit("Executable not found")
      path -> path
    end
  end
end

IO.inspect(Insta_Iphoto.start())
