require 'rails_helper'

RSpec.describe "PipelineRuns", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/pipeline_runs/index"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /create" do
    it "returns http success" do
      get "/pipeline_runs/create"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /update" do
    it "returns http success" do
      get "/pipeline_runs/update"
      expect(response).to have_http_status(:success)
    end
  end

end
