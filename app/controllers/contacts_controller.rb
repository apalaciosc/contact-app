class ContactsController < ApplicationController
  before_action :authenticate_user!

  def index
    @pagy, @contacts = pagy(current_user.contacts)
  end
end
