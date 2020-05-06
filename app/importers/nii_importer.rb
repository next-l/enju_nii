require_dependency EnjuBiblio::Engine.config.root.join('app', 'importers', 'manifestation_importer.rb').to_s

module NiiImporter
  def create_nii_entry(row, **options)
    entry = super
    entry.ncid = row['ncid']
    entry
  end
end

module NiiEntryImporter
  attr_accessor :ncid

  def import
    super
    import_ncid
  end

  def hoge
    puts "aaa"
    super
  end

  def find_by_ncid
    return if ncid.blank?
    NcidRecord.find_by(body: ncid)&.manifestation
  end

  def import_ncid
    return if ncid.blank?

    ncid_record = NcidRecord.find_or_initialize_by(body: ncid)
    ncid_record.update!(manifestation: manifestation_record)
  end
end

ManifestationImporter.singleton_class.send(:prepend, NiiImporter)
ManifestationImporter.send(:prepend, NiiEntryImporter)
