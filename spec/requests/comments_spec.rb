# frozen_string_literal: true

require "rails_helper"
require "cgi"

RSpec.describe "Comments", type: :request do
  describe "POST /articles/:article_id/comments" do
    let(:article) { Article.create!(title: "Turbo Article") }

    it "returns turbo stream and replaces the comment form on success" do
      expect do
        post article_comments_path(article),
             params: { comment: { content: "Great post" } },
             as: :turbo_stream
      end.to change(article.comments, :count).by(1)

      expect(response).to have_http_status(:ok)
      expect(response.media_type).to eq(Mime[:turbo_stream].to_s)
      expect(response.body).to include('turbo-stream action="replace" target="new_comment"')
      expect(response.body).not_to include('target="comments"')
    end

    it "returns unprocessable entity and replaces form with errors on failure" do
      expect do
        post article_comments_path(article),
             params: { comment: { content: "" } },
             as: :turbo_stream
      end.not_to change(article.comments, :count)

      expect(response).to have_http_status(:unprocessable_content)
      expect(response.media_type).to eq(Mime[:turbo_stream].to_s)
      expect(response.body).to include('turbo-stream action="replace" target="new_comment"')
      expect(CGI.unescapeHTML(response.body)).to include("Content can't be blank")
    end

    it "redirects with notice on HTML success" do
      expect do
        post article_comments_path(article),
             params: { comment: { content: "Great post" } }
      end.to change(article.comments, :count).by(1)

      expect(response).to redirect_to(article_path(article))
      expect(flash[:notice]).to eq("Comment was successfully created.")
    end

    it "redirects with alert on HTML failure" do
      expect do
        post article_comments_path(article),
             params: { comment: { content: "" } }
      end.not_to change(article.comments, :count)

      expect(response).to redirect_to(article_path(article))
      expect(flash[:alert]).to eq("Comment could not be created.")
    end
  end
end
