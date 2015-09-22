module ForemanChef
  class ChefServerImporter
    def initialize(args = {})
      @chef_proxy = args[:chef_proxy]
      @environment = args[:env]
      @proxy = args[:proxy]
      @url_arg = args[:url]
    end

    def proxy
      if @proxy
        @proxy
      elsif @url_arg
        @proxy = ProxyAPI::ForemanChef::ChefProxy.new(:url => @url_arg)
      else
        url = SmartProxy.with_features('Chef').first.try(:url)
        raise "Can't find a valid Proxy with a Chef feature" if url.blank?
        @proxy = ProxyAPI::ForemanChef::ChefProxy.new(:url => url)
      end
    end
    attr_writer :proxy

    # return changes hash, currently exists to keep compatibility with importer html
    def changes
      changes = {'new' => {}, 'obsolete' => {}, 'updated' => {}}

      if @environment.nil?
        new_environments.each do |env|
          changes['new'][env] = {}
        end

        old_environments.each do |env|
          changes['obsolete'][env] = {}
        end
      else
        env = @environment
        changes['new'][env] = {} if new_environments.include?(@environment)
        changes['obsolete'][env] = {} if old_environments.include?(@environment)
      end
      changes
    end

    # Update the environments based upon the user's selection
    # +changes+ : Hash with two keys: :new and :obsolete.
    #               changed[:/new|obsolete/] is and Array of Strings
    # Returns   : Array of Strings containing all record errors
    def obsolete_and_new(changes = { })
      return if changes.empty?
      if changes['new'].present?
        changes['new'].each { |name, _| ForemanChef::Environment.create(:name => name, :chef_proxy_id => @chef_proxy.id) }
      end
      if changes['obsolete'].present?
        changes['obsolete'].each { |name, _| ForemanChef::Environment.where(:chef_proxy_id => @chef_proxy.id).find_by_name(name).destroy }
      end
      []
    end

    def db_environments
      @db_environments ||= (ForemanChef::Environment.where(:chef_proxy_id => @chef_proxy.id).pluck('name') - ignored_environments)
    end

    def actual_environments
      @actual_environments ||= (fetch_environments_from_proxy.map { |e| e['name'] } - ignored_environments)
    end

    def new_environments
      actual_environments - db_environments
    end

    def old_environments
      db_environments - actual_environments
    end

    private

    def fetch_environments_from_proxy
      JSON.parse(proxy.list_environments)
    rescue => e
      Foreman::Logging.exception 'Failed to get environments from proxy', e
      return []
    end

    def ignored_environments
      ignored_file[:ignored] || []
    end

    def ignored_file
      return @ignored_file if @ignored_file
      file = File.join(Rails.root.to_s, "config", "ignored_environments.yml")
      @ignored_file = File.exist?(file) ? YAML.load_file(file) : {}
    rescue => e
      logger.warn "Failed to parse environment ignore file: #{e}"
      @ignored_file = {}
    end

    def logger
      @logger ||= Foreman::Logging.logger('foreman_chef')
    end
  end
end
