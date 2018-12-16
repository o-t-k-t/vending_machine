# frozen_string_literal: true

require 'item.rb'

# VendingMachine dispenses beverages
class VendingMachine
  def push_bottun
    Item.new('cola')
  end
end
