# frozen_string_literal: true

class HealthController < ActionController::Base
  def show
    head :ok
  end
end
