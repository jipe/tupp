class Error < StandardError; end

class UnknownProviderError < Error 
  def initialize(provider)
    super("Unknown provider '#{provider}'")
  end
end
