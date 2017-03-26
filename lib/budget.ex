defmodule Budget do
  alias NimbleCSV.RFC4180, as: CSV

  
  def list_transactions do
    File.read!("lib/transactions.csv")
    |> parse
    |> filter
    |> normalize
    |> sort
    |> print
  end

  defp parse(string) do
    CSV.parse_string(string)
  end

  defp filter(rows) do
    Enum.map(rows, &Enum.drop(&1, 1))
  end

  defp normalize(rows) do
    Enum.map(rows, &parse_amount(&1))
  end

  defp parse_amount([date, desc, amount]) do
    [date, desc, parse_to_float(amount)]
  end

  defp parse_to_float(string) do
    String.to_float(string)
    |> abs
  end

  defp sort(rows) do
    Enum.sort(rows, &sort_asc_by_amount(&1, &2))
  end

  defp sort_asc_by_amount([_, _, prev], [_, _, next]) do
    prev < next
  end

  defp print(rows) do
    IO.puts "\nTransactions:"
    Enum.each(rows, &print_to_console(&1))
  end

  defp print_to_console([date, desc, amount]) do
    IO.puts "#{date} #{desc} \t$#{:erlang.float_to_binary(amount, decimals: 2)}"
  end

end
