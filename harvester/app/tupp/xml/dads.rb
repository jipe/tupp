require 'tupp/xml'

module TUPP::XML::DADS
  SUPPORTED_MODS_VERSIONS = %w(3.6 3.5 3.4 3.3 3.2 3.1 3.0)

  module NS
    MODS_V3 = 'http://www.loc.gov/mods/v3'
    XLINK   = 'http://www.w3.org/1999/xlink'
  end 

  class Handler < TUPP::XML::Handler
    def add_document(name, handler)
      if handler&.document
        (document[name] ||= []) << handler.document
      end
    end 
  end

  class DocumentHandler < Handler
    def initialize(document = {})
      super(document)
    end

    def handlers
      @@handlers ||= {
        'name'      => NameHandler,
        'titleInfo' => TitleInfoHandler
      }
    end

    def genre_map
      @@genre_map ||= {
        'bib:article:journal_article' => TUPP::Reference::Publication::JournalArticle
      }
    end

    def start_element(name:, attrs: [], uri: nil)
      case uri 
      when NS::MODS_V3
        return delegate_to(handlers[name].new(document)) if handlers[name]

        case name
        when 'mods'
          version_attr = attrs.find { |attr| attr.localname == 'version' }
          raise 'No MODS version found' unless version_attr
          raise "Unsupported MODS version: #{version_attr.value}" unless SUPPORTED_MODS_VERSIONS.include?(version_attr.value)
        when 'genre'
          return delegate_to(GenreHandler.new(document))
        when 'language'
          return delegate_to(LanguageHandler.new(document))
        end
      end
      super
    end

    def end_element(name:, uri: nil, handler: nil)
      case uri 
      when NS::MODS_V3
        case name
        when 'genre'
          genre_type = handler.document[:type]
          (document[:genres] ||= {})[genre_type] = handler.document[:value] unless genre_type.nil?
        when 'language'
          document[:language] = handler.document
        when 'mods'
          @document = genre_map[document[:genres][:synthesized]].new(@document)
          return finish
        when 'titleInfo'
          document.merge!(handler.document)
        end
      end
      super
    end
  end 

  class GenreHandler < Handler
    def genre_map
      @@genre_map ||= {
        'origin'      => :origin,
        'synthesized' => :synthesized
      }
    end

    def start_element(name:, attrs: [], uri: nil)
      case uri
      when NS::MODS_V3
        case name
        when 'genre'
          type_attr = attrs.find { |attr| attr.localname == 'type' }
          if type_attr
            case type_attr.value
            when /^ds\.dtic\.dk:type:(origin|synthesized)/
              @type = genre_map[$1]
              reset_character_buffer
            end
          end
        end
      end
      super
    end

    def end_element(name:, uri: nil, handler: nil)
      case uri
      when NS::MODS_V3
        case name
        when 'genre'
          if @type
            @document = {type: @type, value: character_buffer}
            @type     = nil
          end
          return finish
        end
      end
      super
    end
  end

  class LanguageHandler < Handler
    def start_element(name:, attrs: [], uri: nil)
      case uri
      when NS::MODS_V3
        case name
        when 'languageTerm'
          type_attr      = attrs.find { |attr| attr.localname == 'type' }
          authority_attr = attrs.find { |attr| attr.localname == 'authority' }
          if type_attr&.value == 'code' && authority_attr&.value == 'iso639-2b'
            @lang_valid = true
            reset_character_buffer
          end
        end
      end
      super
    end

    def end_element(name:, uri: nil, handler: nil)
      case uri
      when NS::MODS_V3
        case name
        when 'languageTerm'
          if @lang_valid
            @document = character_buffer.dup
            @lang_valid = false
          end
        when 'language'
          return finish
        end
      end
      super
    end
  end

  class NameHandler < Handler
    def start_element(name:, attrs: [], uri: nil)
      case uri
      when NS::MODS_V3
        case name
        when 'name'
          type_attr = attrs.find { |attr| attr.localname == 'type' }
          if type_attr
            case type_attr.value
            when 'personal'
              return delegate_to(PersonalNameHandler.new(document))
            when 'corporate'
              return delegate_to(CorporateNameHandler.new(document))
            end
          end
        end
      end
      super
    end

    def end_element(name:, uri: nil, handler: nil)
      case uri 
      when NS::MODS_V3
        case name
        when 'name'
          return finish
        end
      end
      super
    end
  end 

  class PersonalNameHandler < Handler
    def start_element(name:, attrs: [], uri: nil)
      case uri 
      when NS::MODS_V3
        case name
        when 'namePart'
          reset_character_buffer
        end
      end
      super
    end

    def end_element(name:, uri: nil, handler: nil)
      case uri 
      when NS::MODS_V3
        case name
        when 'namePart'
          (document[:name_parts] ||= []) << character_buffer.strip
        when 'name'
          return finish
        end
      end
      super
    end
  end

  class CorporateNameHandler < Handler
    def start_element(name:, attrs: [], uri: nil)
    end

    def end_element(name:, uri: nil, handler: nil)
    end
  end

  class TitleInfoHandler < Handler
    def start_element(name:, attrs: [], uri: nil)
      case uri
      when NS::MODS_V3
        case name
        when 'titleInfo'
          type_attr = attrs.find { |attr| attr.localname == 'type' }
          case type_attr&.value
          when 'uniform'
            @type = :normalized
          when nil
            @type = :main
          end
        when 'title', 'subTitle'
          reset_character_buffer
        end
      end
      super
    end

    def end_element(name:, uri: nil, handler: nil)
      case uri
      when NS::MODS_V3
        case name
        when 'titleInfo'
          case @type
          when :main
            document.merge!(title: @title, subtitle: @subtitle)
          when :normalized
            document.merge!(normalized_title: @title)
          end
          return finish
        when 'title'
          @title = character_buffer.strip
        when 'subTitle'
          @subtitle = character_buffer.strip
        end
      end
      super
    end
  end
end
