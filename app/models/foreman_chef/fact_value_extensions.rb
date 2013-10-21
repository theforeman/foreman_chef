module ForemanChef
  module FactValueExtensions
    extend ActiveSupport::Concern

    included do
      before_save :build_parents, :if => Proc.new { |fact| fact.need_parent_tree? }

      delegate :short_name, :compose, :to => :fact_name

      has_one :parent_fact_name, :through => :fact_name, :source => :parent

      scope :with_roots, includes(:fact_name)
      scope :root_only, with_roots.where(:fact_names => {:parent_id => nil})


      # composes can't be deleted during imports
      def undeletable?
        self.compose
      end
    end

    def build_parents
      blocks      = self.name.split(FactName::SEPARATOR)
      name        = blocks.pop
      parent_name = (joined = blocks.join(FactName::SEPARATOR)).empty? ? name : joined
      klass       = self.fact_name.class
      parent      = klass.find_by_name(parent_name)
      if parent.nil?
        parent = klass.new(:name => parent_name, :compose => true, :short_name => blocks.last || name)
      else
        existing = self.class.where(:host_id => self.host_id, :fact_name_id => parent.id).first
      end

      if existing
        existing.save
      else
        self.class.create(:value => nil, :host_id => self.host_id, :fact_name => parent)
      end

      self.fact_name.update_attributes :parent_id => parent.id,
                                       :root_id   => klass.find_by_name(blocks.first || name).id
    end

    def need_parent_tree?
      self.name.include?(FactName::SEPARATOR)
    end
  end
end
