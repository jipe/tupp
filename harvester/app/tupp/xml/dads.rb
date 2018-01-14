require 'tupp/xml'

module TUPP
  module XML
    module DADS
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
        def handlers
          @@handlers ||= {
            'genre'     => GenreHandler,
            'name'      => NameHandler,
            'titleInfo' => TitleInfoHandler
          }
        end

        def start_element(name, attrs = [], uri = nil)
          case uri 
          when NS::MODS_V3
            return delegate_to(handlers[name].new) if handlers[name]

            case name
            when 'mods'
              version_attr = attrs.find { |attr| attr.localname == 'version' }
              raise 'No MODS version found' unless version_attr
              raise "Unsupported MODS version: #{version_attr.value}" unless SUPPORTED_MODS_VERSIONS.include?(version_attr.value)
            end
          end
          super
        end

        def end_element(name, uri = nil, handler = nil)
          case uri 
          when NS::MODS_V3
            if handlers.has_key?(name)
              add_document(name, handler)
            end

            case name
            when 'mods'
              map_to_model
              return finish
            end
          end
          super
        end

        def map_to_model
          case document['genre'].first
          when 'bib:article:journal_article'
            @document = TUPP::Reference::Publication::JournalArticle.new
          end
        end
      end 

      class GenreHandler < Handler
        def start_element(name, attrs = [], uri = nil)
          case uri
          when NS::MODS_V3
            case name
            when 'genre'
              type_attr = attrs.find { |attr| attr.localname == 'type' }
              if type_attr
                case type_attr.value
                when 'ds.dtic.dk:type:synthesized'
                  reset_character_buffer
                when 'ds.dtic.dk:type:origin'
                  reset_character_buffer
                end
              end
            end
          end
          super
        end

        def end_element(name, uri = nil, handler = nil)
          case uri
          when NS::MODS_V3
            case name
            when 'genre'
              @document = character_buffer
              return finish
            end
          end
          super
        end
      end

      class NameHandler < Handler
        def start_element(name, attrs = [], uri = nil)
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

        def end_element(name, uri = nil, handler = nil)
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
        def start_element(name, attrs = [], uri = nil)
          case uri 
          when NS::MODS_V3
            case name
            when 'namePart'
              reset_character_buffer
            end
          end
          super
        end

        def end_element(name, uri = nil, handler = nil)
          case uri 
          when NS::MODS_V3
            case name
            when 'namePart'
              (document['nameParts'] ||= []) << character_buffer.strip
            when 'name'
              return finish
            end
          end
          super
        end
      end

      class CorporateNameHandler < Handler
        def start_element(name, attrs = [], uri = nil)
        end

        def end_element(name, uri = nil, handler = nil)
        end
      end

      class TitleInfoHandler < Handler
        def start_element(name, attrs = [], uri = nil)
          case uri
          when NS::MODS_V3
            case name
            when 'title', 'subTitle'
              reset_character_buffer
            end
          end
          super
        end

        def end_element(name, uri = nil, handler = nil)
          case uri
          when NS::MODS_V3
            case name
            when 'titleInfo'
              document.merge!('title' => @title, 'subtitle' => @subtitle)
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
  end
end

