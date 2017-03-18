defmodule WeirdStuff.DateBeautifier do
  def perform(%{year: year, month: month, day: day}) do
    "#{month}/#{day}/#{year}"
  end
end
