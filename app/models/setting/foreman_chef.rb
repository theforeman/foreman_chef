class Setting::ForemanChef < Setting

  def self.load_defaults
    # Check the table exists
    return unless super

    self.transaction do
      [
          self.set('auto_deletion', N_("Enable the auto deletion of mapped objects in chef-server through foreman-proxy (currently node and client upon host deletion)"), true),
      ].each { |s| self.create! s.update(:category => "Setting::ForemanChef")}
    end

    true

  end

end
