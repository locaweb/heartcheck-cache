module Heartcheck
  module Checks
    # Check for a cache service
    # Base is set in heartcheck gem
    class Cache < Base
      # validate each service
      #
      # @retun [void]
      def validate
        services.each do |service|
          connection = service[:connection]

          append_error(service[:name], :set) unless set?(connection)
          append_error(service[:name], :get) unless get?(connection)
          append_error(service[:name], :delete) unless delete?(connection)
        end
      end

      private

      # test if can write on cache
      #
      # @param con [Cache] an instance of cache
      #
      # @return [Bollean]
      def set?(con)
        con.set('check_test', 'heartcheck')
      rescue
        false
      end

      # test if can read on cache
      #
      # @param con [Cache] an instance of cache
      #
      # @return [Bollean]
      def get?(con)
        con.get('check_test') == 'heartcheck'
      rescue
        false
      end

      # test if can delete on cache
      #
      # @param con [Cache] an instance of cache
      #
      # @return [Bollean]
      def delete?(con)
        con.delete('check_test')
      rescue
        false
      end

      # customize the error message
      # It's called in Heartcheck::Checks::Base#append_error
      #
      # @param name [String] An identifier of service
      # @param key_error [Symbol] name of action
      #
      # @return [void]
      def custom_error(name, key_error)
        @errors << "#{name} fails to #{key_error}"
      end
    end
  end
end
