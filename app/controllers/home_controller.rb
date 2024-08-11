# frozen_string_literal: true

class HomeController < ApplicationController
  def index
    @lead = Lead.new
  end
end
