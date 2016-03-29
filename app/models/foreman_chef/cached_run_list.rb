module ForemanChef
  class CachedRunList < ActiveRecord::Base
    serialize :list

    belongs_to_host

    class Jail < Safemode::Jail
      allow :to_chef_json, :as_chef_json
    end

    def self.parse(run_list_data, run_list_object = nil)
      data = parse_data(run_list_data)

      if run_list_object.nil?
        cached_run_list = new(:list => data)
      else
        cached_run_list = run_list_object.clone
        cached_run_list.list = data
      end

      cached_run_list
    end

    # return data in format ready for serialization
    # which means Hash like this
    # { :run_list => [ 'role[default]', 'recipe[foreman]' ] }
    def self.parse_data(run_list_data)
      case run_list_data
        when Array
          parse_array(run_list_data)
        when Hash
          run_list_data = run_list_data.with_indifferent_access
          if run_list_data.has_key?(:run_list)
            parse_array(run_list_data.with_indifferent_access[:run_list])
          else
            # from form we get {'0' => { 'name' => ...}, '1' => {...}}
            parse_array(run_list_data.values)
          end
        else
          raise ArgumentError, 'unsupported run_list_data format'
      end
    end
    
    def self.parse_array(run_list_array)
      raise ArgumentError, "run_list is #{run_list_array.class}, expected Array" unless run_list_array.is_a?(Array)

      if run_list_array.first.is_a?(Hash)
        run_list_array.map { |item| item_to_chef(item) }
      elsif run_list_array.first.is_a?(String) or run_list_array.empty?
        run_list_array
      else
        raise ArgumentError, "run_list_array Array contains unknown data format of class #{run_list_array.class}"
      end
    end

    # converts 'role[default]' to { :type => 'role', :name => 'default' }
    def self.item_to_form(item)
      type, name = item.split('[')
      { :type => type, :name => name.chop! }
    end

    # converts { :type => 'role', :name => 'default' } to 'role[default]'
    def self.item_to_chef(item)
      item = item.with_indifferent_access
      "#{item[:type]}[#{item[:name]}]"
    end

    def as_chef_json
      { :run_list => self.list }
    end

    def to_chef_json
      as_chef_json.to_json
    end

    def as_form_json
      list.map { |item| self.class.item_to_form(item) }
    end

    def to_form_json
      as_form_json.to_json
    end
  end
end
