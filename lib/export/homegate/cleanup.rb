module Export
  module Homegate
    class Cleanup

      attr_reader :directory

      def initialize export_dir
        @export_dir = export_dir
        @entries = Dir.entries(export_dir)
      end

      def removable_exports
        entries.select do |dir|
          if dir.to_i == 0
            false
          elsif Date.parse(dir.to_i.to_s) < (Date.today - 5.days)
            true
          else
            false
          end
        end
      end

      def run
        removable_exports.each do |dir|
          Dir.rmdir(File.join(@export_dir, dir))
        end
      end
    end
  end
end
