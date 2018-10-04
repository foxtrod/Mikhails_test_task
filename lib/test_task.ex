defmodule Rules do

  def calculate(rules, settings) do

    result = Enum.find rules, fn (rules) ->
      Enum.all? rules.rule, fn (rule) ->
        compare_by_operation(rule.operation, settings, String.to_atom(rule.field), rule.compared_value)
      end
    end
    case result[:output_value] do
      nil -> {:error, :not_successful_rules}
      _ -> {:ok, result[:output_value]}
    end
  end

  def compare_by_operation(operator, settings, rule_field, rule_value) do
    if settings[rule_field] do
      case operator do
        "less_than" -> settings[rule_field] < rule_value
        "more_than" -> settings[rule_field] > rule_value
        "equal" -> settings[rule_field] == rule_value
        "more_or_equal_than" -> settings[rule_field] >= rule_value
        "less_or_equal_than" -> settings[rule_field] <= rule_value
        "in_set" -> Enum.member? rule_value, settings[rule_field]
        "not_in_set" -> !Enum.member? rule_value, settings[rule_field]
        _ -> false
      end
    end
  end
end




