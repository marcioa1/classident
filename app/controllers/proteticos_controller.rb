class ProteticosController < ApplicationController
  layout "adm"
  # GET /proteticos
  # GET /proteticos.xml
  def index
    @proteticos = Protetico.por_nome

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @proteticos }
    end
  end

  # GET /proteticos/1
  # GET /proteticos/1.xml
  def show
    @protetico = Protetico.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @protetico }
    end
  end

  # GET /proteticos/new
  # GET /proteticos/new.xml
  def new
    @protetico = Protetico.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @protetico }
    end
  end

  # GET /proteticos/1/edit
  def edit
    @protetico = Protetico.find(params[:id])
  end

  # POST /proteticos
  # POST /proteticos.xml
  def create
    @protetico = Protetico.new(params[:protetico])

    respond_to do |format|
      if @protetico.save
        flash[:notice] = 'Protetico was successfully created.'
        format.html { redirect_to(proteticos_path) }
        format.xml  { render :xml => @protetico, :status => :created, :location => @protetico }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @protetico.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /proteticos/1
  # PUT /proteticos/1.xml
  def update
    @protetico = Protetico.find(params[:id])

    respond_to do |format|
      if @protetico.update_attributes(params[:protetico])
        flash[:notice] = 'Protetico was successfully updated.'
        format.html { redirect_to(proteticos_path) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @protetico.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /proteticos/1
  # DELETE /proteticos/1.xml
  def destroy
    @protetico = Protetico.find(params[:id])
    @protetico.destroy

    respond_to do |format|
      format.html { redirect_to(proteticos_url) }
      format.xml  { head :ok }
    end
  end
  
  def abre
    @protetico = Protetico.find(params[:id])  
  end
  
end
