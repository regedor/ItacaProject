class LocalsController < ApplicationController
  # GET /locals
  # GET /locals.xml
  def index
    @locals = Local.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @locals }
    end
  end

  # GET /locals/1
  # GET /locals/1.xml
  def show
    @local = Local.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @local }
    end
  end
end
