require 'nokogiri'

module TUPP
  module XML
    class Handler
      attr_reader :document, :character_buffer

      def initialize(document = {})
        @document         = document
        @character_buffer = ''
      end

      # Return handler to delegate digestion to and falsey to keep using this handler
      def start_element(name, attrs = [], uri = nil)
        false
      end

      # Return truthy if this handler has finished and falsey otherwise
      def end_element(name, uri = nil, from_handler = nil)
        false
      end

      def characters(value)
        @character_buffer << value
      end

      protected

      def reset_character_buffer
        @character_buffer = ''
      end

      def delegate_to(handler)
        handler
      end

      def finish
        true
      end
    end

    class Digester < Nokogiri::XML::SAX::Document
      def initialize(handler)
        raise ArgumentError.new('nil handler was provided') if handler.nil?
        @handler_stack = [handler]
      end

      def start_element_namespace(name, attrs = [], prefix = nil, uri = nil, ns = [])
        unless @handler_stack.empty?
          handler = @handler_stack.first
          while handler.respond_to?(:start_element)
            new_handler = handler.start_element(name, attrs, uri)
            @handler_stack.unshift(new_handler) if new_handler.respond_to?(:start_element)
            handler = new_handler
            puts "Delegating element '#{name}' to #{handler&.class}" if handler.respond_to?(:start_element)
          end
        end
      end

      def end_element_namespace(name, prefix = nil, uri = nil)
        unless @handler_stack.empty?
          handler      = @handler_stack.first
          prev_handler = nil
          while handler&.end_element(name, uri, prev_handler)
            prev_handler = @handler_stack.shift
            handler      = @handler_stack.first
            puts "#{prev_handler.class} finished. Notifying #{handler ? handler.class : 'none'}"
          end
        end
      end

      def characters(value)
        @handler_stack.first.characters(value) unless @handler_stack.empty?
      end
    end

    def self.digest(xml, handler)
      digester = Digester.new(handler)
      parser   = Nokogiri::XML::SAX::Parser.new(digester)
      parser.parse(xml)
    end
  end
end
