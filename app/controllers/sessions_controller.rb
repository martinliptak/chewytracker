class SessionsController < ApplicationController
  def new
    @session_form = SessionForm.new(session)
  end
  
  def create
    @session_form = SessionForm.new(session)
    if @session_form.submit(session_params)
      redirect_via_turbolinks_to dashboard_path
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_via_turbolinks_to welcome_url
  end

  private

    def session_params
      params.require(:session_form).permit(:email, :password)
    end
end