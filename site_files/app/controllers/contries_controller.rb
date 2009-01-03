class ContriesController < ApplicationController
  # GET /contries
  # GET /contries.xml
  def index
    @contries = Contry.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @contries }
    end
  end

  # GET /contries/1
  # GET /contries/1.xml
  def show
    @contry = Contry.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @contry }
    end
  end

  # GET /contries/new
  # GET /contries/new.xml
  def new
    @contry = Contry.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @contry }
    end
  end

  # GET /contries/1/edit
  def edit
    @contry = Contry.find(params[:id])
  end

  # POST /contries
  # POST /contries.xml
  def create
    @contry = Contry.new(params[:contry])

    respond_to do |format|
      if @contry.save
        flash[:notice] = 'Contry was successfully created.'
        format.html { redirect_to(@contry) }
        format.xml  { render :xml => @contry, :status => :created, :location => @contry }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @contry.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /contries/1
  # PUT /contries/1.xml
  def update
    @contry = Contry.find(params[:id])

    respond_to do |format|
      if @contry.update_attributes(params[:contry])
        flash[:notice] = 'Contry was successfully updated.'
        format.html { redirect_to(@contry) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @contry.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /contries/1
  # DELETE /contries/1.xml
  def destroy
    @contry = Contry.find(params[:id])
    @contry.destroy

    respond_to do |format|
      format.html { redirect_to(contries_url) }
      format.xml  { head :ok }
    end
  end
end
