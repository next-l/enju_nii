class EnjuNii::SetupGenerator < Rails::Generators::Base
  source_root File.expand_path('../templates', __FILE__)

  def copy_setup_files
    directory("db/fixtures", "db/fixtures/enju_nii")
    rake("enju_nii_engine:install:migrations")
    inject_into_class 'app/models/manifestation.rb', Manifestation,
      "  enju_nii_cinii_books\n"
    inject_into_class 'app/models/import_request.rb', ImportRequest,
      "  enju_nii_cinii_books\n"
  end
end
