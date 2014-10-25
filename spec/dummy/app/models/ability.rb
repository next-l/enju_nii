#module EnjuNii
  class Ability
    include CanCan::Ability

    def initialize(user, ip_address = '0.0.0.0')
      case user.try(:role).try(:name)
      when 'Administrator'
        can [:read, :update], NiiType
        can [:destroy, :delete], NiiType do |nii_type|
          true unless nii_type.manifestations.exists?
        end if LibraryGroup.site_config.network_access_allowed?(ip_address)
      else
        can :read, NiiType
      end
    end
  end
#end
