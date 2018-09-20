module SymmUtil
  # Simple library for working with 3-tuple vectors.
  #
  # Borrowed largely from: [crystaledge/vector3](https://github.com/unn4m3d/crystaledge/blob/master/src/crystaledge/vector3.cr)
  struct Vector3
    property x, y, z

    @x : Float64
    @y : Float64
    @z : Float64

    def initialize(x, y, z : Int32)
      @x = x.to_f64
      @y = y.to_f64
      @z = z.to_f64
    end

    def initialize(@x, @y, @z : Float64)
      @x = 0.0 if @x.abs < Float64::EPSILON
      @y = 0.0 if @y.abs < Float64::EPSILON
      @z = 0.0 if @z.abs < Float64::EPSILON
    end

    def initialize(polar, azimuthal : Int32)
      @x, @y, @z = compute_cartesian(polar.to_f64, azimuthal.to_f64)
    end

    def initialize(polar, azimuthal : Float64)
      @x, @y, @z = compute_cartesian(polar, azimuthal)
    end

    def compute_cartesian(polar, azimuthal)
      x = Math.sin(polar) * Math.cos(azimuthal)
      y = Math.sin(polar) * Math.sin(azimuthal)
      z = Math.cos(polar)
      {x, y, z}
    end

    def values
      {@x, @y, @z}
    end

    # unary negative
    def -
      Vector3.new(-self.x, -self.y, -self.z)
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

    # Rescales vector to magnitude 1.
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

    # Returns new vector with magnitude 1.
    def normalized
      clone.normalize!
    end

    def ==(other : Vector3)
      (x - other.x).abs <= Float64::EPSILON &&
        (y - other.y).abs <= Float64::EPSILON &&
        (z - other.z).abs <= Float64::EPSILON
    end

    # Determines if two vectors are within Float64 tolerance
    # of eachother in all components.
    def close_to?(other : Vector3)
      (x - other.x).abs.round(Float64::DIGITS).zero? &&
        (y - other.y).abs.round(Float64::DIGITS).zero? &&
        (z - other.z).abs.round(Float64::DIGITS).zero?
    end

    # Rounds all components by passing `arg` to `Float64#round`
    # and returns new vector.
    def round(arg)
      x = @x.round(arg)
      y = @y.round(arg)
      z = @z.round(arg)
      self.class.new(x, y, z)
    end

    def zero?
      self == self.class.new(0.0, 0.0, 0.0)
    end

    # Uses close_to to determine if vector is zero.
    def nearly_zero?
      self.close_to? self.class.new(0.0, 0.0, 0.0)
    end

    # Vector dot product
    def dot(other : Vector3)
      x*other.x + y*other.y + z*other.z
    end

    # Vector cross product
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

    # Calculates angle between two vectors.
    def angle_from(other : Vector3)
      cos_theta = dot(other) / magnitude / other.magnitude
      Math.acos(cos_theta)
    end
  end
end
