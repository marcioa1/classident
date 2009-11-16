class Paciente < ActiveRecord::Base
  belongs_to :tabela
  has_many :tratamentos
  has_many :debitos
  has_many :recebimentos
  
  def extrato
    result = (recebimentos + debitos).sort { |a,b| a.data<=>b.data }
  end
end
