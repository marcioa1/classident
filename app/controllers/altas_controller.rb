class AltasController < ApplicationController

  layout "adm"
  # GET /altas
  # GET /altas.xml
  def index
    @altas = Alta.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @altas }
    end
  end

  # GET /altas/1
  # GET /altas/1.xml
  def show
    @alta = Alta.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @alta }
    end
  end

  # GET /altas/new
  # GET /altas/new.xml
  def new
    @alta = Alta.new(:paciente_id => params[:paciente_id])

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @alta }
    end
  end

  # GET /altas/1/edit
  def edit
    @alta = Alta.find(params[:id])
  end

  # POST /altas
  # POST /altas.xml
  def create
    @alta = Alta.new(params[:alta])
    @alta.data_inicio = params[:datepicker].to_date
    @alta.user_id = current_user.id
    respond_to do |format|
      if @alta.save
        flash[:notice] = 'Alta criada com sucesso.'
        format.html { redirect_to(abre_paciente_path(:id=>@alta.paciente_id)) }
        format.xml  { render :xml => @alta, :status => :created, :location => @alta }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @alta.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /altas/1
  # PUT /altas/1.xml
  def update
    @alta = Alta.find(params[:id])

    respond_to do |format|
      if @alta.update_attributes(params[:alta])
        flash[:notice] = 'Alta was successfully updated.'
        format.html { redirect_to(@alta) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @alta.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /altas/1
  # DELETE /altas/1.xml
  def destroy
    @alta = Alta.find(params[:id])
    @alta.destroy

    respond_to do |format|
      format.html { redirect_to(altas_url) }
      format.xml  { head :ok }
    end
  end
end
