module ForemanChef

  module FactValuesControllerExtensions
    extend ActiveSupport::Concern

    included do
      helper 'foreman_chef/fact_values'

      def index
        begin
          values = FactValue.my_facts.search_for(params[:search], :order => params[:order])
        rescue => e
          error e.to_s
          values = FactValue.search_for ""
        end

        conds = values.where_values.map { |c| c.split(/AND|OR/) }.flatten.reject { |c| c.include?('"hosts"."name"') }

        if (parent = params[:parent_fact]).present? && (@parent = ::FactName.find_all_by_name(parent)).present?
          values = values.where(:fact_names => { :parent_id => @parent.map(&:id) })
          @parent = @parent.first
        elsif conds.present?
          values
        else
          values = values.root_only
        end

        @fact_values = values.no_timestamp_facts.required_fields.paginate :page => params[:page]

        render 'foreman_chef/fact_values/index'
      end
    end
  end
end
