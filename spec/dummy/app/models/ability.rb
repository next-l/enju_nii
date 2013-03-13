#module EnjuNii
  class Ability
    include CanCan::Ability

    def initialize(user, ip_address = nil)
      case user.try(:role).try(:name)
      when 'Administrator'
        can [:read, :update], NiiType
      else
        can :read, NiiType
      end
    end
  end
#end
