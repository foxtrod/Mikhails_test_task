defmodule Rules do

  def calculate(rules, settings) do
    result = Enum.find rules, fn (rules) ->
      Enum.all? rules.rule, fn (rule) ->
        compare_by_operation(rule.operation, settings[String.to_atom(rule.field)], rule.compared_value)
      end
    end
    case result[:output_value] do
      nil -> {:error, :not_successful_rules}
      _ -> {:ok, result[:output_value]}
    end
  end

  def compare_by_operation(operator, setting_value, rule_value) do
    case operator do
      "less_than" -> setting_value < rule_value
      "more_than" -> setting_value > rule_value
      "equal" -> setting_value == rule_value
      "more_or_equal_than" -> setting_value >= rule_value
      "less_or_equal_than" -> setting_value <= rule_value
      "in_set" -> Enum.member? rule_value, setting_value
      "not_in_set" -> !Enum.member? rule_value, setting_value
      _ -> false
    end
  end
end




