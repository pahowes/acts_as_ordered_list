# ActsAsOrderedList
# Subclass of ActiveRecord::Base that implements ordering.  Each instance of OrderedRecord must
# have a field named "order" that is manipulated by this class.
module HowesConsulting
  module Acts
    module OrderedList

      # Called by ActiveRecord::Base when this module is injected.
      def self.included(base)
        # Adds the acts_as_ordered method by extending the base class.
        base.extend(AddActsAsMethod)
      end

      # This module stores the acts_as method and the two modules that contain the class and
      # instance methods to inject.
      module AddActsAsMethod
        
        def acts_as_ordered_list(options={})
          # Add to this block any includes, associations, (belongs_to), or validations.
          class_eval <<-END
            include HowesConsulting::Acts::OrderedList::InstanceMethods
            
            validates_presence_of(:order, :message => "Must be provided.")
            validates_uniqueness_of(:order, :message => "Must be unique")
          END
        end
      end

      # Add instance methods here.
      module InstanceMethods
        
        # Brings all of the methods defined in the model "ClassMethods" in as class methods.
        def self.included(aClass)
          aClass.extend(ClassMethods)
        end
        
        # Overrides the instance initializer so that the order value always exists.  This method
        # is not always called by ActiveRecord::Base, the most common reason being that the
        # record is read from the data store rather than constructed on-the-fly, which is fine
        # for what we are trying to accomplish.
        def initialize(args = nil)
          super
          self.order = self.class.maximum('"order"').to_i + 1
        end
        
        module ClassMethods

          # Delets a record and reorders the remaining records to fill in the hole.
          def delete(id)
            deletedOrder = self.find(id).order
            super
            records = self.find(:all, :conditions => [ '"order" > ?', deletedOrder ])
            records.collect do |r|
              r.order -= 1
              r.save(false)
            end
          end

          # Changes the ordering of an entity and adjusts the other entrys' orders up or down.
          def change_order(id, newOrder)
            oldOrder = self.find(id).order
            if newOrder > oldOrder
              records = self.find(:all, :conditions => { :order => oldOrder..newOrder })
              records.collect do |r|
                if(r.id == id)
                  r.order = newOrder
                else
                  r.order -= 1
                end
                r.save(false)
              end
            elsif newOrder < oldOrder
              records = self.find(:all, :conditions => { :order => newOrder..oldOrder })
              records.collect do |r|
                if(r.id == id)
                  r.order = newOrder
                else
                  r.order += 1
                end
                r.save(false)
              end
            end
          end
        end
      end
    end
  end
end
