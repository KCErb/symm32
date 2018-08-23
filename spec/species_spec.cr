require "./spec_helper"

module Symm32
  # smoke test
  describe SPECIES do
    it "'s an array constant with 212 members'" do
      SPECIES.size.should eq 212
    end
  end
end
