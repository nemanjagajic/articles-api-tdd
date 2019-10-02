RSpec.describe 'articles API', type: :request do
  let!(:articles) { create_list(:article, 10) }
  let(:article_id) { articles.first.id }

  describe 'GET /articles' do
    before { get '/articles' }

    it 'returns articles' do
      expect(json).not_to be_empty
      expect(json.size).to eq(10)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET /articles/:id' do
    before { get "/articles/#{article_id}" }

    context 'when the record exists' do
      it 'returns the article' do
        expect(json).not_to be_empty
        expect(json['id']).to eq(article_id)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the record does not exist' do
      let(:article_id) { 100 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match("\"message\":\"Couldn't find Article with 'id'=100\"")
      end
    end
  end

  describe 'POST /articles' do
    let(:valid_attributes) { { title: 'Learn Elm', content: 'lorem' } }

    context 'when the request is valid' do
      before { post '/articles', params: valid_attributes }

      it 'creates a article' do
        expect(json['title']).to eq('Learn Elm')
        expect(json['content']).to eq('lorem')
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when the request is invalid' do
      before { post '/articles', params: { title: 'Foobar' } }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        expect(response.body)
            .to match("{\"message\":\"Validation failed: Content can't be blank\"}")
      end
    end
  end

  describe 'PUT /articles/:id' do
    let(:valid_attributes) { { title: 'Shopping' } }

    context 'when the record exists' do
      before { put "/articles/#{article_id}", params: valid_attributes }

      it 'updates the record' do
        expect(response.body).to be_empty
      end

      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end
    end
  end

  describe 'DELETE /articles/:id' do
    before { delete "/articles/#{article_id}" }

    it 'returns status code 204' do
      expect(response).to have_http_status(204)
    end
  end
end
