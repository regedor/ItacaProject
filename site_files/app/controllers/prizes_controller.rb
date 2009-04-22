class PrizesController < ApplicationController
  # GET /prizes
  # GET /prizes.xml
  def index
    @prizes = Prize.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @prizes }
    end
  end

  # GET /prizes/1
  # GET /prizes/1.xml
  def show
    @prize = Prize.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @prize }
    end
  end

end
