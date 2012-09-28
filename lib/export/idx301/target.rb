module Export
  module Idx301
    class Target

      # name of the export, for example: homegate
      attr_reader :name

      # account id, is usually equivalent to the ftp user
      attr_reader :agency_id

      # identifier, for example: AlfredMuellerWebsite_HomegateExporter
      # should not be changed once an export is in production
      attr_reader :sender_id

      # ftp credentials
      attr_reader :config

      def initialize(name, agency_id, sender_id, config)
        @name = name
        @agency_id = agency_id
        @sender_id = sender_id
        @config = config
      end

      def self.all
        Settings.idx301.map do |name, data|
          Target.new name, data['agency_id'], data['sender_id'], data['ftp']
        end
      end
    end
  end
end
