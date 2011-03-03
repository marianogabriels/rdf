module RDF; class Literal
  ##
  # An integer literal.
  #
  # @example Arithmetic with integer literals
  #   RDF::Literal(40) + 2                    #=> RDF::Literal(42)
  #   RDF::Literal(45) - 3                    #=> RDF::Literal(42)
  #   RDF::Literal(6) * 7                     #=> RDF::Literal(42)
  #   RDF::Literal(84) / 2                    #=> RDF::Literal(42)
  #
  # @see   http://www.w3.org/TR/xmlschema-2/#integer
  # @see   http://www.w3.org/TR/2004/REC-xmlschema-2-20041028/#integer
  # @since 0.2.1
  class Integer < Decimal
    DATATYPE = XSD.integer
    GRAMMAR  = /^[\+\-]?\d+$/.freeze

    ##
    # @param  [Integer, #to_i] value
    # @option options [String] :lexical (nil)
    def initialize(value, options = {})
      @datatype = RDF::URI(options[:datatype] || DATATYPE)
      @string   = options[:lexical] if options.has_key?(:lexical)
      @string   = value if !defined?(@string) && value.is_a?(String)
      @object   = case
        when value.is_a?(::String)    then Integer(value) rescue nil
        when value.is_a?(::Integer)   then value
        when value.respond_to?(:to_i) then value.to_i
        else Integer(value.to_s) rescue nil
      end
    end

    ##
    # Converts this literal into its canonical lexical representation.
    #
    # @return [RDF::Literal] `self`
    # @see    http://www.w3.org/TR/xmlschema-2/#integer
    def canonicalize!
      @string = @object.to_s if @object
      self
    end

    ##
    # Returns the successor value of `self`.
    #
    # @return [RDF::Literal]
    # @since  0.2.3
    def pred
      RDF::Literal(to_i.pred)
    end

    ##
    # Returns the predecessor value of `self`.
    #
    # @return [RDF::Literal]
    # @since  0.2.3
    def succ
      RDF::Literal(to_i.succ)
    end
    alias_method :next, :succ

    ##
    # Returns `true` if the value is even.
    #
    # @return [Boolean]
    # @since  0.2.3
    def even?
      to_i.even?
    end

    ##
    # Returns `true` if the value is odd.
    #
    # @return [Boolean]
    # @since  0.2.3
    def odd?
      to_i.odd?
    end

    ##
    # Returns the absolute value of `self`.
    #
    # @return [RDF::Literal]
    # @since  0.2.3
    def abs
      (n = to_i) && n > 0 ? self : RDF::Literal(n.abs)
    end

    ##
    # Returns `true` if the value is zero.
    #
    # @return [Boolean]
    # @since  0.2.3
    def zero?
      to_i.zero?
    end

    ##
    # Returns `self` if the value is not zero, `nil` otherwise.
    #
    # @return [Boolean]
    # @since  0.2.3
    def nonzero?
      to_i.nonzero? ? self : nil
    end

    ##
    # Returns the value as a string.
    #
    # @return [String]
    def to_s
      @string || @object.to_s
    end

    ##
    # Returns the value as an `OpenSSL::BN` instance.
    #
    # @return [OpenSSL::BN]
    # @see    http://ruby-doc.org/stdlib/libdoc/openssl/rdoc/classes/OpenSSL/BN.html
    # @since  0.2.4
    def to_bn
      require 'openssl' unless defined?(OpenSSL::BN)
      OpenSSL::BN.new(to_s)
    end
  end # Integer
  
  # Derived types
  # @see http://www.w3.org/TR/xpath-functions/#datatypes
  
  # @see http://www.w3.org/TR/2004/REC-xmlschema-2-20041028/#nonPositiveInteger
  class NonPositiveInteger < Integer
    GRAMMAR  = /^(?:[\+\-]?0)|(?:-\d+)$/.freeze

    ##
    # @param  [#to_i] value
    # @option options [String] :lexical (nil)
    def initialize(value, options = {})
      super(value, options.merge(:datatype => XSD.nonPositiveInteger))
    end
  end
  
  # @see http://www.w3.org/TR/2004/REC-xmlschema-2-20041028/#negativeInteger
  class NegativeInteger < NonPositiveInteger
    GRAMMAR  = /^\-\d+$/.freeze

    ##
    # @param  [#to_i] value
    # @option options [String] :lexical (nil)
    def initialize(value, options = {})
      super(value, options.merge(:datatype => XSD.negativeInteger))
    end
  end
  
  # @see http://www.w3.org/TR/2004/REC-xmlschema-2-20041028/#long
  class Long < Integer
    ##
    # @param  [#to_i] value
    # @option options [String] :lexical (nil)
    def initialize(value, options = {})
      super(value, options.merge(:datatype => XSD.long))
    end
  end
  
  # @see http://www.w3.org/TR/2004/REC-xmlschema-2-20041028/#int
  class Int < Long
    ##
    # @param  [#to_i] value
    # @option options [String] :lexical (nil)
    def initialize(value, options = {})
      super(value, options.merge(:datatype => XSD.int))
    end
  end
  
  # @see http://www.w3.org/TR/2004/REC-xmlschema-2-20041028/#short
  class Short < Int
    ##
    # @param  [#to_i] value
    # @option options [String] :lexical (nil)
    def initialize(value, options = {})
      super(value, options.merge(:datatype => XSD.short))
    end
  end
  
  # @see http://www.w3.org/TR/2004/REC-xmlschema-2-20041028/#byte
  class Byte < Short
    ##
    # @param  [#to_i] value
    # @option options [String] :lexical (nil)
    def initialize(value, options = {})
      super(value, options.merge(:datatype => XSD.byte))
    end
  end
  
  # @see http://www.w3.org/TR/2004/REC-xmlschema-2-20041028/#nonNegativeInteger
  class NonNegativeInteger < Integer
    GRAMMAR  = /^(?:[\+\-]?0)|(?:\+?\d+)$/.freeze

    ##
    # @param  [#to_i] value
    # @option options [String] :lexical (nil)
    def initialize(value, options = {})
      super(value, options.merge(:datatype => XSD.nonNegativeInteger))
    end
  end
  
  # @see http://www.w3.org/TR/2004/REC-xmlschema-2-20041028/#unsignedLong
  class UnsignedLong < NonNegativeInteger
    GRAMMAR  = /^\d+$/.freeze

    ##
    # @param  [#to_i] value
    # @option options [String] :lexical (nil)
    def initialize(value, options = {})
      super(value, options.merge(:datatype => XSD.unsignedLong))
    end
  end
  
  # @see http://www.w3.org/TR/2004/REC-xmlschema-2-20041028/#unsignedInt
  class UnsignedInt < UnsignedLong
    ##
    # @param  [#to_i] value
    # @option options [String] :lexical (nil)
    def initialize(value, options = {})
      super(value, options.merge(:datatype => XSD.unsignedInt))
    end
  end
  
  # @see http://www.w3.org/TR/2004/REC-xmlschema-2-20041028/#unsignedShort
  class UnsignedShort < UnsignedInt
    ##
    # @param  [#to_i] value
    # @option options [String] :lexical (nil)
    def initialize(value, options = {})
      super(value, options.merge(:datatype => XSD.unsignedShort))
    end
  end
  
  # @see http://www.w3.org/TR/2004/REC-xmlschema-2-20041028/#unsignedByte
  class UnsignedByte < UnsignedShort
    ##
    # @param  [#to_i] value
    # @option options [String] :lexical (nil)
    def initialize(value, options = {})
      super(value, options.merge(:datatype => XSD.unsignedByte))
    end
  end
  
  # @see http://www.w3.org/TR/2004/REC-xmlschema-2-20041028/#positiveInteger
  class PositiveInteger < NonNegativeInteger
    GRAMMAR  = /^\+?\d+$/.freeze

    ##
    # @param  [#to_i] value
    # @option options [String] :lexical (nil)
    def initialize(value, options = {})
      super(value, options.merge(:datatype => XSD.positiveInteger))
    end
  end
end; end # RDF::Literal
