require 'rails_helper'

RSpec.describe '/contacts', type: :request do
  let!(:user) { create(:user) }

  describe 'GET /index' do
    before { create_list(:contact, 3, user: user) }

    context 'when the user is not authenticated' do
      it 'return 302 status code ' do
        get contacts_url

        expect(response).to have_http_status(:found)
      end
    end

    context 'with user authenticated' do
      before { login_as(user) }

      it 'renders a successful response' do
        get contacts_url

        expect(controller.instance_variable_get('@contacts').count).to eq(3)
        expect(response).to have_http_status(:ok)
      end
    end
  end
end
