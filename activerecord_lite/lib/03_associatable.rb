require_relative '02_searchable'
require 'active_support/inflector'

# Phase IIIa
class AssocOptions
  attr_accessor(
    :foreign_key,
    :class_name,
    :primary_key
  )

  def model_class
    self.class_name.constantize
  end

  def table_name
    self.model_class.table_name
  end
end

class BelongsToOptions < AssocOptions
  def initialize(name, options = {})
      @foreign_key = (options[:foreign_key] || "#{name.to_s.singularize}_id".to_sym)
      @primary_key = (options[:primary_key] || :id)
      @class_name = (options[:class_name] || name.to_s.camelcase.singularize )
  end
end

class HasManyOptions < AssocOptions
  def initialize(name, self_class_name, options = {})
    @foreign_key = (options[:foreign_key] || "#{self_class_name.to_s.underscore.singularize}_id".to_sym)
    @primary_key = (options[:primary_key] || :id)
    @class_name = (options[:class_name] || name.to_s.camelcase.singularize )
  end
end

module Associatable
  # Phase IIIb
  def belongs_to(name, options = {})
    options = BelongsToOptions.new(name, options)
    define_method(name) do
      fval = self.send(options.foreign_key)
      options.model_class.where({id: fval}).first
    end
  end

  def has_many(name, options = {})
    options = HasManyOptions.new(name, options)
    define_method(name) do
      pval = self.send(options.primary_key)
      options.model_class.where()
    end
  end

  def assoc_options
    # Wait to implement this in Phase IVa. Modify `belongs_to`, too.
  end
end

class SQLObject
  # Mixin Associatable here...
  extend Associatable
end
