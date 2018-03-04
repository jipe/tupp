class TranslatedString
  attr_reader :value, :language

  def initialize(value, language: :eng)
    @value    = value
    @language = language
  end
end
