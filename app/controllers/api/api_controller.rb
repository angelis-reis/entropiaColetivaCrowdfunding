# coding: utf-8
class Api::ApiController < ActionController::Base
  if Rails.env.production?
    require "new_relic/agent/instrumentation/rails3/action_controller"
    include NewRelic::Agent::Instrumentation::ControllerInstrumentation
    include NewRelic::Agent::Instrumentation::Rails3::ActionController
  end

  respond_to :json

  protect_from_forgery with: :null_session
end
