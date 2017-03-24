defmodule Budget do
  alias NimbleCSV.RFC4180, as: CSV

  
  def list_transactions do
    File.read!("lib/transactions.csv")
    |> parse
    |> filter
  end

  defp parse(transactions) do
    CSV.parse_string(transactions)
  end

  defp filter(rows) do
    Enum.map(rows, &(Enum.drop(&1, 1)))
  end
end
