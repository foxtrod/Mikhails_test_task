defmodule RulesTest do
  use ExUnit.Case
  doctest Rules

  test "in_set operator" do
    assert Rules.calculate(
             [
               %{
                 rule:
                   [%{field: "country", operation: "equal", compared_value: "UK"},
                   %{field: "currency", operation: "equal", compared_value: "GBP"}],
                 output_value: 100
               },
               %{
                 rule:
                   [%{field: "country", operation: "equal", compared_value: "BY"}],
                 output_value: 200
               },
               %{
                 rule:
                   [%{field: "country", operation: "equal", compared_value: "US"},
                   %{field: "currency", operation: "in_set", compared_value: ["GBP", "USD"]}],
                 output_value: 300
               },
             ],
             %{country: "US", currency: "USD"}
           ) == {:ok, 300}
  end


  test "more_than operator" do
    assert Rules.calculate(
             [
               %{
                 rule:
                   [%{field: "amount", operation: "more_than", compared_value: 50},
                   %{field: "currency", operation: "equal", compared_value: "USD"}],
                 output_value: 200
               },
               %{
                 rule:
                   [%{field: "currency", operation: "equal", compared_value: "USD"},
                   %{field: "amount", operation: "equal", compared_value: 100}],
                 output_value: 300
               }
             ],
             %{amount: 100, currency: "USD"}
           ) == {:ok, 200}
  end

  test "not successful rules" do
    assert IO.puts inspect Rules.calculate(
                             [
                               %{
                                 rule:
                                   [%{field: "country", operation: "equal", compared_value: "BY"}],
                                 output_value: 200
                               }
                             ],
                             %{country: "US", currency: "USD"}
                           ) == {:error, :not_successful_rules}
  end
end
