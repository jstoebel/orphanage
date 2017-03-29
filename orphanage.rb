# following tutorial here: http://www.metabates.com/2011/02/07/building-interfaces-and-abstract-classes-in-ruby/

module Orphanage

  def self.included(klass)
    klass.send(:include, AbstractInterface::Methods)
    klass.send(:extend, AbstractInterface::Methods)
    klass.send(:extend, AbstractInterface::ClassMethods)
  end

  module Methods

    def adopt fk
      # provid a foreign_key 
      puts "hello from adopt!"
    end # adopt

  end

  module ClassMethods

    def orphan_of(klass, options)
      # declare a class to be an orphan record class
      # options (hash)
        # parent: a symbol of the parent class

    end # orphan_of


  end


end
