module Locomotive
  module Steam

    class ImageResizerService

      attr_accessor_initialize :resizer, :asset_path

      def resize(source, geometry)
        return nil if disabled? || geometry.blank? || source.nil?

        if file = fetch_file(source)
          file.thumb(geometry).url
        else
          Locomotive::Common::Logger.error "Unable to resize on the fly: #{source.inspect}"
          nil
        end
      end

      def disabled?
        resizer.nil? || resizer.plugins[:imagemagick].nil?
      end

      protected

      def fetch_file(source)
        return nil if source.blank?

        url_or_path = get_url_or_path(source)
        return nil if url_or_path.nil?

        if url_or_path =~ Steam::IsHTTP
          resizer.fetch_url(url_or_path)
        else
          path = url_or_path.sub(/(\?.*)$/, '')
          resizer.fetch_file(File.join(asset_path || '', path))
        end
      end

      def get_url_or_path(source)
        if source.is_a?(Hash)
          source['url'].strip
        elsif source.respond_to?(:url)
          source.url.strip
        else
          source
        end
      end

    end

  end
end
