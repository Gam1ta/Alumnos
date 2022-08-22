require 'migration_helpers'

class AlumnosSemestres < ActiveRecord::Migration
  extend MigrationHelpers

  def self.up
    create_table :alumnos_semestres, :id => false do |t|
      t.references :alumno, :null => false
      t.references :semestre, :null => false

      t.timestamps
    end

    add_index :alumnos_semestres, [ :alumno_id, :semestre_id ], :unique => true

    foreign_key :alumnos_semestres, :alumno_id, :alumnos
    foreign_key :alumnos_semestres, :semestre_id, :semestres
  end

  def self.down
    remove_index :alumnos_semestres, [ :alumno_id, :semestre_id ]

    drop_foreign_key :alumnos_semestres, :alumno_id, :alumnos
    drop_foreign_key :alumnos_semestres, :semestre_id, :semestres

    drop_table :alumnos_semestres
  end
end
