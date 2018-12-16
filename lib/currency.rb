# frozen_string_literal: true

# Currency represents coins and bills, and behaves as price value
Currency = Struct.new(:price) do
  TYPES = [1, 5, 10, 50, 100, 500, 1000, 5000, 10_000].freeze

  def initialize(price)
    raise 'Absent currency' unless TYPES.include?(price)

    super(price)
  end
end
