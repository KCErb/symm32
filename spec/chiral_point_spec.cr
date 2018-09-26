require "./spec_helper"

module Symm32
  describe ChiralPoint do
    it "does invert chirality on inversion call" do
      vec = Vector3.new(0, 1, 2)
      point = ChiralPoint.new(vec)
      point.invert(:chirality)
      point.chirality.should eq Chirality::Left
    end
  end
end
