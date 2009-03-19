class PagesController < ApplicationController
  def show
    pages = ['about']
    render :action => ((pages.include? params[:id]) ? params[:id] : "error")
  end
end
