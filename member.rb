class BaseClassMember
  # @Override
  def self.attr_accessor(*vars)
    @attributes ||= []
    @attributes.concat vars
    super(*vars)
  end

  def self.attributes
    @attributes
  end

  def attributes
    self.class.attributes
  end
end

class Member < BaseClassMember
  @@members = Array.new
  attr_accessor(:name, :location, :age)

  def initialize(attr=nil)
    unless attr.nil?
      @name = attr['name']
      @location = attr['location']
      @age = attr['age']
    end
    @@members << self
  end

  def self.all
    @@members
  end

  # Member.filter(attribute: value, ...)
  def self.filter(options)
    return [] unless responds_to_attr(options)

    @@members.select{ |member|
      result = Array.new
      options.each do |option|
        result.push(
          is_equal(member.send(option[0]), option[1])
        )
      end
      result.inject{ |res, x| (res && x) }
    }
  end

  # Note: Removed to test dynamic methods
  # def self.filter_by_name(query)
    # @@members.select{ |member| member.name == query }
    # self.filter(name: query)
  # end

  def self.filter_by_location(query)
    # @@members.select{ |member| member.location == query }
    self.filter(location: query)
  end

  def self.filter_by_age(to, from)
    # @@members.select{ |member| ((to.to_i)..(from.to_i)).include?(member.age) }
    self.filter(age: [to, from])
  end

  class << self
    private
      # responds_to_attr({:attribute => value, ...})
      def responds_to_attr(options)
        options.each do |option|
          return false unless  self.attributes.include?(option[0])
        end
        true
      end

      def is_equal(attribute_value, search_value)
        if attribute_value.is_a?(Numeric) && is_range(search_value)
          search_range = (search_value.min)..(search_value.max)
          search_range.include?(attribute_value)
        else
          set_type_of(attribute_value) == set_type_of(search_value)
        end
      end

      def set_type_of(param)
        if param.is_a?(Numeric)
          number(param)
        elsif param.is_a?(Array)
          param.compact.flatten.sort
        else
          downcase(param)
        end
      end

      def is_range(param)
        param.is_a?(Array) && param.length == 2 && param[0].is_a?(Numeric) && param[1].is_a?(Numeric)
      end

      def downcase(param)
        param.strip.downcase
      end

      def number(param)
        param.to_i
      end

      # @Override
      def method_missing(name, *arguments, &block)
        return "No method '#{name}' for class #{self}" unless name.to_s.start_with?('filter_by')

        # defines the method parameter
        # assignment: (_param, ...)
        _name = name.to_s.split('filter_by_')[1].split('_').compact.flatten
        attributes = _name.select{ |attr| Member.attributes.include?(attr.to_sym) }
        puts "#{attributes} #{arguments}"

        return "Invalid method '#{name}' with arguments #{arguments}" if attributes.length != arguments[0].length

        params_names = attributes.map { |param| '_'+param }
        assignment = params_names.join(', ')

        # defines the method call parameter
        # options (attr: _param, ...)
        attribute_map = Hash.new
        attributes.zip(params_names){ |attr, val| attribute_map[attr.to_sym] = val }
        options = (attribute_map.map do |attr, var| "#{attr}: #{var}" end).join(', ')

        # dynamically define a new filter_by method
        # def.filter_by_[attr](_param, ...)
        #    self.filter(attr: _param, ...)
        # end
        Member.class_eval <<-CODE, __FILE__, __LINE__ + 1
          def self.#{name}(#{assignment})
            self.filter(#{options})
          end
        CODE

        # call to the new method created
        send(name, *arguments)
      end
  end
end

