# -*- encoding: utf-8 -*-
module CiniiBooksHelper
  def link_to_import_from_cinii(ncid)
    if ncid.blank?
      t('enju_nii.not_available')
    else
      identifier_type = IdentifierType.where(:name => 'ncid').first
      if identifier_type
        manifestation = Identifier.where(:body => ncid, :identifier_type_id => identifier_type.id).first.try(:manifestation)
      end
      unless manifestation
        link_to t('enju_nii.add'), cinii_books_path(:book => {:ncid => ncid}), :method => :post
      else
        link_to t('enju_nii.already_exists'), manifestation
      end
    end
  end
end
