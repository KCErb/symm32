module Symm32
  module Directions
    class Direction
      getter orientation : Orientation
      getter cartesian : Array(Float64)
      getter spherical : Array(Float64)
      getter orthogonals : Array(Orientation)

      # since data is static, compute once on init
      def initialize
        @cartesian = init_cartesian
        @spherical = init_spherical
        @orthogonals = init_orthogonals
        @orientation = Orientation::Z # compiler needs default in init
      end

      def init_spherical
        compute_angles(cartesian)
      end

      # given vector [x,y,z] return angles [theta, phi]
      # ex: [1,1,1] => [pi/4, pi/4]
      private def compute_angles(vector)
        x,y,z = vector
        r = Math.sqrt(x**2 + y**2 + z**2)
        theta = Math.acos(z/r)
        phi = Math.atan2(y, x)
        [theta, phi]
      end
    end

    class Axial < Direction
      INSTANCE = new

      def initialize
        super
        @orientation = Orientation::Z
      end

      def self.instance
        INSTANCE
      end

      def init_orthogonals
        [
          Orientation::T0,
          Orientation::T30,
          Orientation::T45,
          Orientation::T60,
          Orientation::T90,
          Orientation::T120,
          Orientation::T135,
          Orientation::T150
        ]
      end

      def init_cartesian
        [0.0,0.0,1.0]
      end

      def init_spherical
        [0.0,0.0]
      end
    end

    class Plane < Direction
      INSTANCES = {
        0 => new(0_u8),
        30 => new(30_u8),
        45 => new(45_u8),
        60 => new(60_u8),
        90 => new(60_u8),
        120 => new(120_u8),
        135 => new(135_u8),
        150 => new(150_u8)
      }

      getter angle : UInt8

      def initialize(@angle)
        super()
        @orientation = Orientation.parse("T#{angle}")
      end

      # Singleton getter
      def self.instance(arg : UInt8)
        INSTANCES[arg]
      end

      def init_orthogonals
        res = [Orientation::Z]
        res += case @angle
        when 0
          [Orientation::T90, Orientation::E2, Orientation::E4]
        when 30
          [Orientation::T120]
        when 45
          [Orientation::T135, Orientation::D2, Orientation::D4]
        when 60
          [Orientation::T150]
        when 90
          [Orientation::T0, Orientation::E1, Orientation::E3]
        when 120
          [Orientation::T30]
        when 135
          [Orientation::T90, Orientation::E2, Orientation::E4]
        when 150
          [Orientation::T60]
        else
          raise "Invalid Plane Angle: `#{@angle}`"
        end
      end

      def init_cartesian
        [Math.cos(@angle), Math.sin(@angle), 0.0]
      end

      def init_spherical
        [Math::PI / 2.0, @angle * Math::PI / 180.0]
      end
    end

    class Diagonal < Direction
      INSTANCES = {
        1 => new(1_u8),
        2 => new(2_u8),
        3 => new(3_u8),
        4 => new(4_u8),
      }
      def initialize(@number : UInt8)
        super()
        @orientation = Orientation.parse("D#{number}")
      end

      # Singleton getter
      def self.instance(arg : UInt8)
        INSTANCES[arg]
      end

      def init_orthogonals
        res = [] of Orientation
        res += case @number
        when 1
          [Orientation::T90, Orientation::D2, Orientation::D3, Orientation::E3]
        when 2
          [Orientation::T0, Orientation::D3, Orientation::D4, Orientation::E4]
        when 3
          [Orientation::T90, Orientation::D1, Orientation::D4, Orientation::E1]
        when 4
          [Orientation::T0, Orientation::D1, Orientation::D2, Orientation::E2]
        else
          raise "Invalid Diagonal Number: `#{@number}`"
        end
      end

      def init_cartesian
        case @number
        when 1
          [1.0,1.0,1.0]
        when 2
          [-1.0,1.0,1.0]
        when 3
          [-1.0,-1.0,1.0]
        when 4
          [1.0,-1.0,1.0]
        else
          raise "Invalid Diagonal Number: `#{@number}`"
        end
      end
    end

    class Edge < Direction
      INSTANCES = {
        1 => new(1_u8),
        2 => new(2_u8),
        3 => new(3_u8),
        4 => new(4_u8),
      }

      def initialize(@number : UInt8)
        super()
        @orientation = Orientation.parse("E#{number}")
      end

      # Singleton getter
      def self.instance(arg : UInt8)
        INSTANCES[arg]
      end

      def init_orthogonals
        res = [] of Orientation
        res += case @number
        when 1
          [Orientation::T135, Orientation::E3, Orientation::E4]
        when 2
          [Orientation::T45, Orientation::E1, Orientation::E4]
        when 3
          [Orientation::T135, Orientation::E1, Orientation::E2]
        when 4
          [Orientation::T45, Orientation::E2, Orientation::E3]
        else
          raise "Invalid Edge Number: `#{@number}`"
        end
      end

      def init_cartesian
        case @number
        when 1
          [1.0,0.0,1.0]
        when 2
          [0.0,1.0,1.0]
        when 3
          [-1.0,0.0,1.0]
        when 4
          [0.0,-1.0,1.0]
        else
          raise "Invalid Edge Number: `#{@number}`"
        end
      end
    end
  end
end
