require 'rubygems'
require 'nokogiri'
require 'planet/instiki_stringsupport'

module Planet
  module XmlParser
    def self.parse(source, encoding='utf-8', uri=nil)
      if source && encoding == 'utf-8'
        s = (source.is_a?(File) ? source.readlines.join : source).purify.to_utf8
      else
        s = source #hope for the best
      end
      Nokogiri::XML.parse(s, uri, encoding)
    end

    def self.fragment source
      Nokogiri::HTML.fragment(source.purify.to_utf8)
    end
  end

  # add a convenience method for computing the xml:base for any given Element
  if not Nokogiri::XML::Node.public_instance_methods.include? "base_uri"
    class Nokogiri::XML::Node
      def base_uri
        base = attribute_with_ns('base','http://www.w3.org/XML/1998/namespace')
        if not base
          parent.base_uri
        elsif parent != document
          Planet::uri_norm(parent.base_uri, base.value)
        else
          base.value
        end
      end

      def text=(text)
        content=text
      end
    end
  end
end
