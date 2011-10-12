require 'active_record'
require 'active_record/fixtures'
desc "copy fixtures for enju_nii"
task :enju_nii => :environment do
  ActiveRecord::Fixtures.create_fixtures(File.expand_path(File.dirname(__FILE__)) + '/../../db/fixtures/', File.basename('nii_types', '.yml'))
end
