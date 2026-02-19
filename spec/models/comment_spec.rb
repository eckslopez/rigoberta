# frozen_string_literal: true

require "rails_helper"

RSpec.describe Comment, type: :model, use_transactional_fixtures: false do
  include ActiveJob::TestHelper

  after do
    clear_enqueued_jobs
    clear_performed_jobs
    Comment.delete_all
    Article.delete_all
  end
  
  describe "broadcasts" do
    it "enqueues append broadcast to comments and renders expected comment HTML" do
        article = Article.create!(title: "Turbo Article")
        comment = nil

        expect do
          comment = Comment.create!(article: article, content: "Great post")
        end.to have_enqueued_job(Turbo::Streams::ActionBroadcastJob)

        job = enqueued_jobs.find { |j| j[:job] == Turbo::Streams::ActionBroadcastJob }
        expect(job).to be_present

        options = job[:args][1].with_indifferent_access
        expect(options[:target]).to eq("comments")
        expect(options[:partial]).to eq("comments/comment")
        expect(options[:action]["value"]).to eq("append")

        rendered = ApplicationController.render(
            partial: "comments/comment",
            locals: { comment: comment }
        )
        expect(rendered).to include("Great post")
        expect(rendered).to include(%(id="#{ActionView::RecordIdentifier.dom_id(comment)}"))
    end
  end
end