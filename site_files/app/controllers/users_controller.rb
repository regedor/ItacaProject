class UsersController < ApplicationController
  # render new.rhtml
  def new
    @user = User.new
  end
 
  def create
    logout_keeping_session!
    @user = User.new(params[:user])
    success = @user && @user.save
    if success && @user.errors.empty?
      redirect_back_or_default('/')
      flash[:notice] = "Obrigado por efectuar o registo. Em breve receberá um email para activar a sua conta."
    else
      flash[:error]  = "Não foi possivel criar a sua conta. Se o problema persistir contacte o administrador."
      render :action => 'new'
    end
  end

  def activate
    logout_keeping_session!
    user = User.find_by_activation_code(params[:activation_code]) unless params[:activation_code].blank?
    case
    when (!params[:activation_code].blank?) && user && !user.active?
      user.activate!
      flash[:notice] = "A sua conta encontra-se agora activa."
      redirect_to '/login'
    when params[:activation_code].blank?
      flash[:error] = "Código de activação inválido."
      redirect_back_or_default('/')
    else 
      flash[:error]  = "Possivelmente esta conta já encontra activa."
      redirect_back_or_default('/')
    end
  end
end
