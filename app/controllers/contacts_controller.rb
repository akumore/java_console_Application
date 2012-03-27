class ContactsController < ApplicationController

  def new
    @contact = Contact.new
  end

  def create
    @contact = Contact.new(params[:contact])
    if @contact.save
      #TODO: send contact mail to mail@alfred-mueller.ch
      render 'show'
    else
      render 'new'
    end
  end

end
