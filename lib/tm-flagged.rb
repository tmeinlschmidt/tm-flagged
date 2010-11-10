# flagged model
# original idea from xing/flag_shin_tzu
# add fields "flags" as :integer
# add "include FlaggedModel"
# add has_flags 1 => :active, 2 => :common, 3 => :another, :column => 'flags'
module FlaggedModel
  
  TRUE_VALUES = [true, 1, '1', 't', 'T', 'true', 'TRUE']
  
 # def self.included(base)
 #   base.extend ClassMethods
 # end

  module ClassMethods

    def has_flags(*args)
      # process options
      flag_hash, options = parse_options(*args)
      options = {:named_scopes => true, :column => 'flags'}.update(options)
      
      # create class variables
      class_inheritable_reader :flag_column
      write_inheritable_attribute(:flag_column, options[:column])
      flag_column = options[:column]
      # check column
     
      raise ArgumentError, "has_flags: column named '#{flag_column}' doesn't exist" unless check_column_presence

      # mappings
      class_inheritable_hash :flag_mapping
      write_inheritable_attribute(:flag_mapping, {}) unless flag_mapping
      flag_mapping[flag_column] ||= {}
    
      # check & set the mappings values
      flag_hash.each do |key, name|
        # invalid attributes
        raise ArgumentError, "has_flags: invalid key '#{name}'" unless valid_key?(key)
        raise ArgumentError, "has_flags: invalid name '#{name}'" unless valid_name?(name)
        raise ArgumentError, "has_flags: name exists '#{name}'" if method_defined?(name)
        flag_mapping[flag_column][name] = to_bits(key)
        
        class_eval <<-EVAL
          def #{name}
            flag_enabled?(:#{name})
          end

          def #{name}?
            flag_enabled?(:#{name})
          end

          def #{name}=(value)
            FlaggedModel::TRUE_VALUES.include?(value) ? enable_flag(:#{name}) : disable_flag(:#{name})
          end
        EVAL
      end
      # pretty print
      class_eval <<-EVAL
        def pp_#{flag_column.to_s}
          pretty_print_flags
        end
      EVAL
    end

    private
  
    def to_bits(key)
      (1 << (key-1))
    end

    def check_column_presence
      # ActiveRecord
      if respond_to?(:columns) && defined?(ActiveRecord)
        return columns.any?{|col| (col.name == flag_column.to_s && col.type == :integer)}
      end
      if respond_to?(:properties)
        return (properties[flag_column.to_sym] && properties[flag_column.to_sym].class == DataMapper::Property::Integer)
      end
      false
    end

    # is key valid?
    # suppose 64bit bigint ("select ~0;")
    def valid_key?(key)
      (key > 0 && key<=64 && key == key.to_i && !flag_mapping[flag_column].values.include?(to_bits(key)))
    end

    # is name valid?
    def valid_name?(name)
      (name.is_a?(Symbol) && !flag_mapping[flag_column].keys.include?(name))
    end
  
    # parse options
    def parse_options(*args)
      options = args.shift
      if args.size >= 1
        add_options = args.shift
      else
        add_options = options.keys.select {|key| !key.is_a?(Fixnum)}.inject({}) do |hash, key|
          hash[key] = options.delete(key)
          hash
        end
      end
      return options, add_options
    end

  end
  
  # pretty print flags set
  def pretty_print_flags
    get_flags.each do |name, val|
      STDERR.puts "%1d :%s" % [flag_enabled?(name)?1:0, name] 
    end
    nil
  end

  # returns true if specified flag is TRUE
  def flag_enabled?(flag)
    (_flags & get_flag(flag)) == get_flag(flag)
  end

  # !dtto
  def flag_disabled?(flag)
    !flag_enabled?(flag)
  end

  # set flag to 1
  def enable_flag(flag)
    set_flags(_flags | get_flag(flag))
  end

  # reset flag to 0
  def disable_flag(flag)
    set_flags(_flags & ~get_flag(flag))
  end

  # get all the flags
  def get_flags
    self.class.flag_mapping[self.class.flag_column]
  end

  # get specified flag
  def get_flag(flag)
    get_flags[flag]
  end

  # get flag column
  def _flags
    self[self.class.flag_column] || 0
  end
  
  # get flags
  def set_flags(value)
    self[self.class.flag_column] = value
  end
end

Class.class_eval do
  include FlaggedModel::ClassMethods
end

