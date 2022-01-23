class ContactFilesController < ApplicationController
  before_action :authenticate_user!

  def index
    @pagy, @contact_files = pagy(current_user.contact_files.with_attached_file)
  end

  def new
    @contact_file = ContactFile.new
  end

  def create
    @contact_file = current_user.contact_files.new(contact_file_params)

    respond_to do |format|
      if @contact_file.save
        format.html { redirect_to contact_files_path, notice: 'File saved successfully.' }
      else
        format.html { render :new }
      end
    end
  end

  private

  def contact_file_params
    params.require(:contact_file).permit(:file)
  end
end
