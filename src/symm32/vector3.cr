# Borrowed largely from: https://github.com/unn4m3d/crystaledge/blob/master/src/crystaledge/vector3.cr
module Symm32
  struct Vector3
    property x, y, z

    @x : Float64
    @y : Float64
    @z : Float64

    def initialize(@x, @y, @z : Float64)
    end

    def values
      {@x, @y, @z}
    end

    def +(other : Vector3)
      Vector3.new(self.x + other.x, self.y + other.y, self.z + other.z)
    end

    def -(other : Vector3)
      Vector3.new(self.x - other.x, self.y - other.y, self.z - other.z)
    end

    def *(other : Float64)
      Vector3.new(self.x * other, self.y * other, self.z * other)
    end

    def clone
      Vector3.new(self.x, self.y, self.z)
    end

    def normalize!
      m = magnitude
      unless m == 0
        inverse = 1.0 / m
        self.x *= inverse
        self.y *= inverse
        self.z *= inverse
      end
      self
    end

    def normalized
      clone.normalize!
    end

    def ==(other : Vector3)
      (x - other.x).abs <= Float64::EPSILON &&
      (y - other.y).abs <= Float64::EPSILON &&
      (z - other.z).abs <= Float64::EPSILON
    end

    def close_to?(other : Vector3)
      (x - other.x).abs.round(Float64::DIGITS).zero? &&
      (y - other.y).abs.round(Float64::DIGITS).zero? &&
      (z - other.z).abs.round(Float64::DIGITS).zero?
    end

    def zero?
      self == self.class.new(0.0,0.0,0.0)
    end

    def nearly_zero?
      self.close_to? self.class.new(0.0,0.0,0.0)
    end

    def dot(other : Vector3)
      x*other.x + y*other.y + z*other.z
    end

    def cross(other : Vector3)
      Vector3.new(
        y*other.z - z*other.y,
        z*other.x - x*other.z,
        x*other.y - y*other.x
      )
    end

    def magnitude
      Math.sqrt(x**2 + y**2 + z**2)
    end
  end
end
