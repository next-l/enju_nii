class User < ActiveRecord::Base
  devise :database_authenticatable, #:registerable,
    :recoverable, :rememberable, :trackable, #, :validatable
    :lockable, lock_strategy: :none, unlock_strategy: :none

  include EnjuSeed::EnjuUser
end

Manifestation.include(EnjuNii::EnjuManifestation)
Manifestation.include(EnjuSubject::EnjuManifestation)
