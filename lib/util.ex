defmodule Util do
  def integers(strings), do: Enum.map(strings, &String.to_integer/1)
end
