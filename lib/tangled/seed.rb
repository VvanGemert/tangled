module Tangled
  # Seed
  module Seed
    def self.generate
      calculate(81)
    end

    def self.address
      calculate(90)
    end

    def self.calculate(num)
      Array.new(num) { [*('A'..'Z'), ['9']].sample }.join
    end
  end
end
