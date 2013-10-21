module ForemanChef
  module FactNameExtensions
    SEPARATOR = '::'

    extend ActiveSupport::Concern

    included do
      belongs_to :root, :class_name => 'FactName'
      belongs_to :parent, :class_name => 'FactName'
      has_many :children, :class_name => 'FactName', :foreign_key => 'parent_id',
               :dependent             => :destroy

      before_save :set_name, :if => Proc.new { |fact| fact.short_name.blank? }
      after_create :set_root

      validates :name, :uniqueness => { :scope => :type }

      scope :roots, where(:parent_id => nil)
    end

    def set_name
      self.short_name ||= self.name.split(SEPARATOR).last
    end

    def root?
      self.name.include?(SEPARATOR)
    end

    def find_root
      self.class.find_by_name(self.name.split(SEPARATOR).first)
    end

    def set_root
      self.root = self.find_root
      save
    end
  end
end
