# acts_as_ordered_list

This plugin was inspired by the `acts_as_list` plug-in, also available here on github.  I needed
something a lot more basic than what it does, and this plug-in is the result.


# Example

Install the plug-in with:

    ruby script/plugin install git://github.com/pahowes/acts_as_ordered_list.git
    
Make sure that your model definition contains a field named "order":

    create_table :my_tables do |t|
      t.integer :order
      ...
      t.timestamps
    end
    
Add ordering capability to your model class:

    class MyTable < ActiveRecord::Base
      acts_as_ordered_list
      ...
    end
    
That's it!
    

Copyright (c) 2009 Howes Consulting, released under the MIT license
