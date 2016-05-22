require 'tupp/reference'

module TUPP
  class Person < Reference
    attr_accessor :first_name, :last_name, :affiliations

    def initialize(args)
      super
      @first_name   = args[:first_name] if args[:first_name]
      @last_name    = args[:last_name]  if args[:last_name]
      @affiliations = args[:affiliations] || []

      @affiliations << args[:affiliation] if args[:affiliation]
    end
  end
end
