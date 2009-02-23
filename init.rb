$:.unshift "#{File.dirname(__FILE__)}/lib"
require 'acts_as_ordered_list'
ActiveRecord::Base.class_eval { include HowesConsulting::Acts::OrderedList }