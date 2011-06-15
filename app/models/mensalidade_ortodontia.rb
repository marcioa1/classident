class MensalidadeOrtodontia < ActiveRecord::Base
  
  def self.mudou_de_mes(clinica_id)
    ultima = MensalidadeOrtodontia.all(:limit => 1, :order=>'created_at DESC', :conditions=>["clinica_id = ?", clinica_id])
    if ultima.present?
      ultima[0].data.year >= Date.today.year && ultima[0].data.month < Date.today.month
    else
      true  # primeira geração
    end
  end
  
  def self.registra_novo_mes(clinica_id)
    MensalidadeOrtodontia.create(:clinica_id => clinica_id, 
                                 :data       => Date.today)
  end
end
