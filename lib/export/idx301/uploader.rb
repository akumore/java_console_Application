module Export
  module Idx301
    class Uploader
      def initialize(source, target)
        @source = source
        @target = target
      end

      def upload
        # do stuff
        #`rsync #{@source} #{@target}`
      end
    end
  end
end
