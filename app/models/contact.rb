class Contact
	include Mongoid::Document
	include Mongoid::Timestamps

	has_many :real_estates
end