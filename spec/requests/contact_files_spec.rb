require 'rails_helper'

RSpec.describe '/contact_files', type: :request do
  let!(:user) { create(:user) }

  describe 'GET /index' do
    before { create_list(:contact_file, 10, user: user) }

    context 'when the user is not authenticated' do
      it 'return 302 status code ' do
        get contact_files_url

        expect(response).to have_http_status(:found)
      end
    end

    context 'with user authenticated' do
      before { login_as(user) }

      it 'renders a successful response' do
        get contact_files_url

        expect(controller.instance_variable_get('@contact_files').count).to eq(10)
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe 'POST /create' do
    context 'success cases' do
      let(:file_path) { File.new("#{Rails.root}/spec/factories/files/example.csv").path }
      let(:params) do
        {
          contact_file: { file: Rack::Test::UploadedFile.new(file_path) }
        }
      end

      before { login_as(user) }

      it 'enqueued ImportContactsJob' do
        expect { post(contact_files_url, params: params) }.to have_enqueued_job(ImportContactsJob)
      end

      it 'save ActiveStorage file' do
        expect { post(contact_files_url, params: params) }.to change(ActiveStorage::Attachment, :count).by(1)
      end

      it 'renders a successful response' do
        post contact_files_url, params: params

        expect(response).to redirect_to(contact_files_url)
      end

      it 'create a ContactFile' do
        post contact_files_url, params: params

        expect(ContactFile.count).to eq(1)
      end
    end
  end
end
