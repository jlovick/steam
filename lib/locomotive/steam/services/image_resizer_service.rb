module Locomotive
  module Steam

    class ImageResizerService

      attr_accessor_initialize :resizer, :asset_path

      def resize(source, geometry)
        return nil if disabled? || geometry.blank?

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
        url_or_path = get_url_or_path(source)
        return nil if url_or_path.blank? || url_or_path.nil?

        url_or_path = get_url_or_path(source)

        if url_or_path =~ Steam::IsHTTP
          resizer.fetch_url(url_or_path)
        else
          path = url_or_path.sub(/(\?.*)$/, '')
          resizer.fetch_file(File.join(asset_path || '', path))
        end
      end

      def get_url_or_path(source)
       
       if source.is_a?(Hash)
        filenm =  source['url']
        elsif source.respond_to?(:url)
        filenm =  source.url
        else
        filenm = source
        end
      
       if filenm.nil? 
             return nil
       end

       if filenm.respond_to?(:strip)
             filenm.strip!
       elsif (filenm.has_key? 'filename' && !filenm.filename.nil?)
             filenm = (filenm.base + filenm.filename).strip
       else
             filenm =  nil
       end
      
       return filenm

      end

    end

  end
end
