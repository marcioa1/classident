class Pagamento < ActiveRecord::Base
  belongs_to :clinica
  belongs_to :tipo_pagamento
end
