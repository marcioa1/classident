class AcompanhamentoCheque < ActiveRecord::Base
  
  before_create :atribui_campos
  
  belongs_to :cheque
  belongs_to :user
  belongs_to :cheque
  
  validates_presence_of :descricao
  validates_length_of :descricao, :within => 1..120
  
  def atribui_campos
    self.origem  = session[:clinica_id]
    self.user_id = current_user
  end
end
