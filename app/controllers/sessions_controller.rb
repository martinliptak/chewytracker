class SessionsController < ApplicationController

  def new
    @session_form = SessionForm.new
  end
  
  def create
    @session_form = SessionForm.new
    if @session_form.submit(params)
      session[:user_id] = @session_form.user.id
      redirect_via_turbolinks_to meals_url
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_via_turbolinks_to welcome_url
  end
end