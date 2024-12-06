defmodule Input do
  @doc """
  Fetch the puzzle input for a given `day`.
  """
  def get_input(day) do
    year = Application.get_env(:advent_of_code, :year)
    session = Application.get_env(:advent_of_code, :session)

    request =
      Req.new(
        base_url: "https://adventofcode.com",
        url: "/#{year}/day/#{day}/input",
        headers: %{"cookie" => "session=#{session}"}
      )

    case Req.get(request) do
      {:ok, %{status: 400}} -> {:error, :not_logged_in}
      {:ok, %{status: 404}} -> {:error, :not_yet_available}
      {:ok, %{body: body}} -> {:ok, body}
      result -> result
    end
  end

  @doc """
  Get the file path of the puzzle input for a given `day`
  """
  def path(day), do: "inputs/day_#{day}.txt"

  @doc """
  Read the puzzle input for a given `day`.
  """
  def read(day), do: day |> path() |> File.read!()
end
