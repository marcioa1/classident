class ChequesController < ApplicationController

  layout "adm"

  # GET /cheques
  # GET /cheques.xml
  def index
    @cheques = Cheque.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @cheques }
    end
  end

  # GET /cheques/1
  # GET /cheques/1.xml
  def show
    @cheque = Cheque.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @cheque }
    end
  end

  # GET /cheques/1/edit
  def edit
    @bancos = Banco.all(:order=>:nome).collect{|obj| [obj.numero + " - " + obj.nome,obj.id]}
    @cheque = Cheque.find(params[:id])
  end

  # PUT /cheques/1
  # PUT /cheques/1.xml
  def update
    @cheque = Cheque.find(params[:id])

    respond_to do |format|
      if @cheque.update_attributes(params[:cheque])
        flash[:notice] = 'Cheque was successfully updated.'
        format.html { redirect_to(@cheque) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @cheque.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /cheques/1
  # DELETE /cheques/1.xml
  def destroy
    @cheque = Cheque.find(params[:id])
    @cheque.destroy

    respond_to do |format|
      format.html { redirect_to(cheques_url) }
      format.xml  { head :ok }
    end
  end
  
  def cheques_recebidos
     @cheques = Cheque.por_bom_para.da_clinica(session[:clinica_id])
  end
  
end
