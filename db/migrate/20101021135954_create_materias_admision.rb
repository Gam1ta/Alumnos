require 'migration_helpers'
class CreateMateriasAdmision < ActiveRecord::Migration
  extend MigrationHelpers
  
  def self.up
    create_table :materias_admision do |t|
      t.string :nombre , :null => false
      t.string :clave

      t.references :carrera, :null => false

      t.timestamps
    end
    foreign_key(:materias_admision, :carrera_id, :carreras)
  end

  def self.down
    drop_foreign_key(:materias_admisión, :carrera_id, :carreras)
    drop_table :materias_admision
  end
end
