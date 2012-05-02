require 'csv'

module Export
  module Homegate
    class CsvWriter

      attr_reader :path, :mode, :options

      DEFAULT_OPTIONS ={
          :col_sep => "#",
          :encoding => 'ISO8859-1'
      }


      def initialize(path, mode="wb")
        @path, @mode, @options = path, mode, DEFAULT_OPTIONS
      end

      def write(content)
        CSV.open(path, mode, options) do |f|
          f << filtered(content)
        end
      end

      private

      def filtered(content)
        content.map {|val| val.respond_to?(:gsub) ? val.gsub(@options[:col_sep], "") : val }
      end

    end
  end
end
