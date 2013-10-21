module ForemanChef
  module FactValuesHelper
    def fact_name(value, parent)
      name = h(value.name)
      memo = ''
      name = name.split(FactName::SEPARATOR).map do |current_name|
        memo = memo.empty? ? current_name : memo + FactName::SEPARATOR + current_name
        if parent.present?
          if parent.name == memo
            current_name
          else
            if value.name != memo || (value.name == memo && value.compose)
              link_to(current_name, fact_values_path(:parent_fact => memo),
                      :title => _("Show all %s children fact values") % value.name)
            else
              link_to(current_name, fact_values_path("search" => "name = #{value.name}"),
                      :title => _("Show all %s fact values") % value.name)
            end
          end
        else
          link_to(current_name, fact_values_path(:parent_fact => memo),
                  :title => _("Show all %s children fact values") % value.name)
        end
      end.join(FactName::SEPARATOR).html_safe

      if value.compose
        content_tag(:strong, name)
      else
        name
      end
    end
  end
end
