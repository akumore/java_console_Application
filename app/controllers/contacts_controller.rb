class ContactsController < ApplicationController

  def new
    @contact = Contact.new
  end

  def create
    @contact = Contact.new(params[:contact])
    if @contact.save
      ContactMailer.contact_notification(@contact).deliver
      render 'show'
    else
      render 'new'
    end
  end

end
