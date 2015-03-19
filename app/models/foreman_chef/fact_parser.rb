module ForemanChef
  class FactParser < ::FactParser

    def operatingsystem
      os_name = facts['lsb::id'] || facts['platform']
      release = facts['lsb::release'] || fact['platform_version']
      major, minor = release.split('.')
      description = facts['lsb::description']
      release_name = facts['lsb::codename']

      begin
        klass = os_name.constantize
      rescue NameError => e
        logger.debug "unknown operating system #{os_name}, fallback to generic type"
        klass = Operatingsystem
      end

      args = { :name => os_name, :major => major, :minor => minor }
      klass.where(args).first || klass.new(args.merge(:description => description, :release_name => release_name)).save!
    end

    def environment
      name = facts['environment'] || Setting[:default_puppet_environment]
      Environment.find_or_create_by_name name
    end

    def architecture
      name = facts['kernel::machine']
      name = "x86_64" if name == "amd64"
      Architecture.find_or_create_by_name name unless name.blank?
    end

    def model
      if facts['virtualization'].present?
        name = facts['virtualization']['system']
      else
        name = facts['dmi::system::product_name']
      end
      Model.find_or_create_by_name(name.strip) unless name.blank?
    end

    def domain
      name = facts['domain']
      Domain.find_or_create_by_name name unless name.blank?
    end

    def ipmi_interface
      raise NotImplementedError, not_implemented_error(__method__)
    end

    def certname
      facts['chef_node_name']
    end

    def support_interfaces_parsing?
      false
    end

    def parse_interfaces?
      support_interfaces_parsing? && !Setting['ignore_puppet_facts_for_provisioning']
    end

    private

    # meant to be implemented in inheriting classes
    # should return hash with indifferent access in following format:
    # { 'link': 'true',
    #   'macaddress': '00:00:00:00:00:FF',
    #   'ipaddress': nil,
    #   'any_other_fact': 'value' }
    #
    # note that link and macaddress are mandatory
    def get_facts_for_interface(interface)
      raise NotImplementedError, "parsing interface facts is not supported in #{self.class}"
    end

    # meant to be implemented in inheriting classes
    # should return array of interfaces names, e.g.
    #   ['eth0', 'eth0.0', 'eth1']
    def get_interfaces
      raise NotImplementedError, "parsing interfaces is not supported in #{self.class}"
    end
  end
end
