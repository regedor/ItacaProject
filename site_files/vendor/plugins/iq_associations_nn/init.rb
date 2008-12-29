require 'iq/associations_nn'

ActiveRecord::Base.send      :include, IQ::AssociationsNn::Extensions::ActiveRecord
ActionController::Base.send  :include, IQ::AssociationsNn::Extensions::ActionController