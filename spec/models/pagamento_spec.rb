require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Pagamento do
  fixtures :pagamentos, :clinicas

  before(:each) do
     @adm = pagamentos(:ao_dentista)
     @centro = pagamentos(:do_centro)
     @sc = pagamentos(:de_sc)
  end
   
  it "deve ter dois custos" do
    @adm.custos.size.should be == 2
  end
  
  it "o total dos custos deve ser igual ao pagamento original" do
    valor_centro = @centro.valor
    valor_sc = @sc.valor 
    @adm.valor.should be == (valor_centro + valor_sc)
  end
  
  it "deve ser identificado por id 1" do
    @centro.pagamento.id.should be == 1
    @sc.pagamento.id.should be == 1
  end
  
  it "deve ser um pagamento_pai" do
    @adm.pagamento_das_clinicas?.should be == true
  end
  
  
end
