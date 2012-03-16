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
        #TODO Double-check with home gate whether we really need this!
        content.map { |val| val.gsub(@options[:col_sep], "") }
      end

    end
  end
end