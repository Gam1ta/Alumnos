class RestrictsController < ApplicationController
  def access_denied
    @usuario = User.where("id=?", current_user.id.to_i).first
    @require = params[:required]
    @section = params[:section]
    flash[:info] = ['¡Error!', 'No tienes permisos para esta página']
  end
end
