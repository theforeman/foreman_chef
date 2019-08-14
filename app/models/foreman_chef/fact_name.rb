module ForemanChef
  class FactName < ::FactName
    def origin
      'Chef'
    end

    def icon_path
      'foreman_chef/Chef'
    end
  end
end
