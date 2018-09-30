module ForemanChef
  # Scans ConfigReports after import for indicators of an Ansible report and
  # sets the origin of the report to 'Ansible'
  class ChefReportScanner
    class << self
      def scan(report, logs)
        if (result = chef_report?(logs))
          report.origin = 'Chef'
        end

        result
      end

      def chef_report?(logs)
        return false if logs.blank?
        logs.last['log']['sources']['source'] == 'Chef'
      end
    end
  end
end
