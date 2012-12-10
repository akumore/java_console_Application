Fabricator(:account) do
  provider Provider::HOMEGATE
  agency_id "swag"
  sender_id "AlfredMuellerWebsite_SwagExporter"
  video_support false
  username 'test'
  password 'testing'
  host 'localhost'
end
