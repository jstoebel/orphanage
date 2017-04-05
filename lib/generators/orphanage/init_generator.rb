require 'rails/generators/base'

module Orphanage

  class InitGenerator < Rails::Generators::Base
    containing_dir = File.expand_path("..", __FILE__)
    template_dir = File.join(containing_dir, 'templates')
    source_root File.expand_path(template_dir)

    argument :home_model_name, :type => :string

    def ensure_home_model_and_table_exists

      begin
        home_model
      rescue NameError => e
        fail "Home model not found. Plese generate it first."
      end

      table_exists = ActiveRecord::Base.connection.data_source_exists? home_table_name
      fail "table #{home_table_name} does not exist. Stopping." if !table_exists

    end # ensure_home_model_exists

    def generate_model
      generate "model #{home_model_name}Temp --skip-migration"

    end

    def orphanize_model
      # change the model to be an orphan model
      puts "replacing model..."
      template "model.rb.erb", "app/models/#{home_file_name}_temp.rb", force: true
    end

    def create_migration
      puts "creating migration file..."
      migration_file_name = "#{Time.now.utc.strftime("%Y%m%d%H%M%S")}_create_#{home_file_name}_temps.rb"
      template "migration.rb.erb", "db/migrate/#{migration_file_name}"
    end # create_migration

    private

    def home_model
      home_model_name.constantize
    end # home_model

    def home_file_name
      home_model_name.underscore
    end # file_name

    def home_table_name
      home_file_name.pluralize
    end # home_table_name

    def orphan_table_name
      (home_model_name + "Temp").underscore.pluralize
    end # orphan_table_name

    def migration_columns
      # get all column names
      needed_cols = home_model.columns.select { |col| !%w(id created_at updated_at).include? col.name }

      # returns an array of strings each representing a single column to add in the migration.
      migrations = needed_cols.map {|col| "t.#{col.sql_type_metadata.type} :#{col.name}, null: #{col.null}" }

      return migrations

    end # orphan_columns
  end

end
