module ForemanChef
  class ApplicationController < ::ApplicationController
    def resource_class
      "::ForemanChef::#{controller_name.singularize.classify}".constantize
    end
  end
end
