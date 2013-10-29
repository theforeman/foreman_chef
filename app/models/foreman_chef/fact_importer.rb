module ForemanChef
  class FactImporter < ::FactImporter
    def fact_name_class
      ForemanChef::FactName
    end

    private

    def delete_removed_facts
      to_delete = host.fact_values.joins(:fact_name).where('fact_names.name NOT IN (?)', facts.keys)
      to_delete = to_delete.where(:fact_names => {:compose => false})
      @counters[:deleted] = to_delete.size
      # N+1 DELETE SQL, but this would allow us to use callbacks (e.g. auditing) when deleting.
      to_delete.destroy_all

      @db_facts           = nil
      logger.debug("Merging facts for '#{host}': deleted #{counters[:deleted]} facts")
    end
  end
end
