class MensalidadeOrtodontia < ActiveRecord::Base
  
  def self.mudou_de_mes(clinica_id)
    ultima = MensalidadeOrtodontia.all(:limit => 1, :order=>'created_at DESC', :conditions=>["clinica_id = ?", clinica_id])
    if ultima.present?
      if ultima[0].data.month == Date.today.month && ultima[0].data.year == Date.today.year
        return false
      else
        return true
      end
    else
      true  # primeira geração
    end
  end
  
  def self.registra_novo_mes(clinica_id)
    MensalidadeOrtodontia.create(:clinica_id => clinica_id, 
                                 :data       => Date.today)
  end
end
