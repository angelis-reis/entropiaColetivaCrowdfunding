class LeadsController < ApplicationController
  def create
    Lead.create!(email: params[:email])
    render nothing: true, status: :created
  end
end
