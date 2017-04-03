require 'pry'

module Orphanage
  def self.included(klass)
    klass.send(:include, Orphanage::Methods)
    klass.send(:extend, Orphanage::ClassMethods)

  end # self.included

  module Methods

    def adopt fks, options={}
      # creates a new record in the home table. Returns the created record
      # fks(hash) mapping of foreign keys to values.
      # options(hash): optionally override adoption options set in class

      default_options = self.class.adopt_options
      merged_options = default_options.deep_merge options
      dest = merged_options[:home] # the destination model

      # columns allowed in the destination model
      allowed_cols = dest.column_names
      allowed_cols.delete "id" # obviously this shouldn't carry over

      # timestamps that shouldn't be carried over in the adption
      timestamps_to_remove = merged_options[:update_timestamps]
                              .select{|k, v| v}
                              .map{|k, v| "#{k.to_s}_at" }

      allowed_cols = allowed_cols - timestamps_to_remove

      record = dest.new self
                      .attributes
                      .select {|k, v| allowed_cols.include? k}

      record.update_attributes!(fks)

      self.destroy! if merged_options[:destroy_on_adopt]

      return record

    end # adopt

  end # methods

  module ClassMethods

    def orphan(options = {})
      # declare a class to be an orphan record class
      # home(string or symbol): lower case singular name of table the orphan
        # class will be adopted into. Example :exam or  "exam"

      # fks(array of strings or symbolds) array of foreign key names the orphan will use to attempt
        # to move into the home table.

      # options (hash)
        # destroy_on_adopt (bool): if the orphan record should be destroyed after successful
          # adoption
        # update_timestamps (hash)
          # created: (bool) if created_at timestamp should be updated
            # at adoption
          # updated (bool): if updated_at timestamp should be updated
            # at adoption

      default_options = {
        home: self.name.gsub('Temp', '').constantize,
        destroy_on_adopt: true,
        update_timestamps: {
          created: true,
          updated: true
        }
      }

      merged_options = default_options.deep_merge options

      # self.home_model = home
      self.adopt_options = merged_options

    end # orphan_of

    # def home_model
    #   @@home_model
    # end # parent
    #
    # def home_model= home
    #   @@home_model = home.to_s.titleize.constantize
    # end

    def adopt_options
      @@adopt_options
    end #adopt_options

    def adopt_options= options
      @@adopt_options = options
    end # adopt_options=

  end # class methods

end
