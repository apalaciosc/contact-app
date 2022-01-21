class ContactsController < ApplicationController
  before_action :authenticate_user!

  def index; end

  def bulk_import; end

  def import
    redirect_to contacts_path
  end
end
