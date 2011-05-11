class AdicionaHoraAUser < ActiveRecord::Migration
  def self.up
    add_column :users, :hora_de_inicio_0,  :datetime, :default => Time.zone.parse('08:00')
    add_column :users, :hora_de_termino_0, :datetime, :default => Time.zone.parse('18:00')
    add_column :users, :hora_de_inicio_1,  :datetime, :default => Time.zone.parse('08:00')
    add_column :users, :hora_de_termino_1, :datetime, :default => Time.zone.parse('18:00')
    add_column :users, :hora_de_inicio_2,  :datetime, :default => Time.zone.parse('08:00')
    add_column :users, :hora_de_termino_2, :datetime, :default => Time.zone.parse('18:00')
    add_column :users, :hora_de_inicio_3,  :datetime, :default => Time.zone.parse('08:00')
    add_column :users, :hora_de_termino_3, :datetime, :default => Time.zone.parse('18:00')
    add_column :users, :hora_de_inicio_4,  :datetime, :default => Time.zone.parse('08:00')
    add_column :users, :hora_de_termino_4, :datetime, :default => Time.zone.parse('18:00')
    add_column :users, :hora_de_inicio_5,  :datetime, :default => Time.zone.parse('08:00')
    add_column :users, :hora_de_termino_5, :datetime, :default => Time.zone.parse('18:00')
    add_column :users, :hora_de_inicio_6,  :datetime, :default => Time.zone.parse('08:00')
    add_column :users, :hora_de_termino_6, :datetime, :default => Time.zone.parse('18:00')
    add_column :users, :hora_de_inicio_7,  :datetime, :default => Time.zone.parse('08:00')
    add_column :users, :hora_de_termino_7, :datetime, :default => Time.zone.parse('18:00')
    add_column :users, :dia_da_semana_0, :boolean, :default => false
    add_column :users, :dia_da_semana_1, :boolean, :default => true
    add_column :users, :dia_da_semana_2, :boolean, :default => true
    add_column :users, :dia_da_semana_3, :boolean, :default => true
    add_column :users, :dia_da_semana_4, :boolean, :default => true
    add_column :users, :dia_da_semana_5, :boolean, :default => true
    add_column :users, :dia_da_semana_6, :boolean, :default => true
  end

  def self.down
    remove_column :users, :dia_da_semana_6
    remove_column :users, :dia_da_semana_5
    remove_column :users, :dia_da_semana_4
    remove_column :users, :dia_da_semana_3
    remove_column :users, :dia_da_semana_2
    remove_column :users, :dia_da_semana_1
    remove_column :users, :dia_da_semana_0
    remove_column :users, :hora_de_termino_7
    remove_column :users, :hora_de_inicio_7
    remove_column :users, :hora_de_termino_6
    remove_column :users, :hora_de_inicio_6
    remove_column :users, :hora_de_termino_5
    remove_column :users, :hora_de_inicio_5
    remove_column :users, :hora_de_termino_4
    remove_column :users, :hora_de_inicio_4
    remove_column :users, :hora_de_termino_3
    remove_column :users, :hora_de_inicio_3
    remove_column :users, :hora_de_termino_2
    remove_column :users, :hora_de_inicio_2
    remove_column :users, :hora_de_termino_1
    remove_column :users, :hora_de_inicio_1
    remove_column :users, :hora_de_termino_0
    remove_column :users, :hora_de_inicio_0
  end
end