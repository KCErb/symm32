module Symmetry
  module Crystallographic
    @[Flags]
    enum IsometryKind
      Identity
      Inversion
      Mirror
      Rotation2
      Rotation3
      Rotation3_2
      Rotation4
      Rotation4_3
      Rotation6
      Rotation6_5
      ImproperRotation2
      ImproperRotation3
      ImproperRotation3_2
      ImproperRotation4
      ImproperRotation4_3
      ImproperRotation6
      ImproperRotation6_5

      def self.new_rotation(angle : Int32, improper = false)
        case angle
        when 180
          improper ? ImproperRotation : Rotation2
        when 120
          improper ? ImproperRotation : Rotation3
        when 240
          improper ? ImproperRotation : Rotation3_2
        when 90
          improper ? ImproperRotation : Rotation4
        when 270
          improper ? ImproperRotation : Rotation4_3
        when 60
          improper ? ImproperRotation : Rotation6
        when 300
          improper ? ImproperRotation : Rotation6_5
        else
          raise "invalid rotation angle for IsometryKind enum: #{angle}"
        end
      end
    end
  end
end
