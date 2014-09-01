#
# Added for Ruby-GetText-Package
#

makemo_stamp = 'tmp/makemo.stamp'
desc "Create mo-files for L10n"
task :makemo => makemo_stamp
file makemo_stamp => Dir.glob('po/*/noosfero.po') do
  Rake::Task['symlinkmo'].invoke
  Rake::Task['gettext:pack'].invoke
  FileUtils.mkdir_p 'tmp'
  FileUtils.touch makemo_stamp
end

task :cleanmo do
  rm_f makemo_stamp
end
task :clean => 'cleanmo'

task :symlinkmo do
  langmap = {
    'pt' => 'pt_BR',
  }
  mkdir_p(Rails.root.join('locale'))
  Dir.glob(Rails.root.join('po/*/')).each do |dir|
    lang = File.basename(dir)
    orig_lang = langmap[lang] || lang
    mkdir_p(Rails.root.join('locale', "#{lang}", 'LC_MESSAGES'))
    ln_sf "../../po/#{lang}/noosfero.po", "locale/#{lang}/noosfero.po"
    ln_sf "../../po/#{lang}/noosfero-doc.po", "locale/#{lang}/noosfero-doc.po"
    ['iso_3166'].each do |domain|
      origin = "/usr/share/locale/#{orig_lang}/LC_MESSAGES/#{domain}.mo"
      target = Rails.root.join('locale', "#{lang}", 'LC_MESSAGES', "#{domain}.mo")
      if !File.symlink?(target)
        ln_s origin, target
      end
    end
  end
end

namespace :gettext do
  def files_to_translate
    sources =
      Dir.glob("{app,lib}/**/*.{rb,rhtml,erb}") +
      Dir.glob('config/initializers/*.rb') +
      Dir.glob('public/*.html.erb') +
      Dir.glob('public/designs/themes/{base,noosfero,profile-base}/*.{rhtml,html.erb}') +
      Dir.glob('plugins/**/{controllers,models,lib,views}/**/*.{rhtml,html.erb,rb}')
  end
end

desc "Update pot/po files to match new version."
task :updatepo => :symlinkmo do
  puts 'Extracting strings from source. This may take a while ...'
  Rake::Task['gettext:find'].invoke
end

task :checkpo do
  sh 'for po in po/*/noosfero.po; do echo -n "$po: "; msgfmt --statistics --output /dev/null $po; done'
end

# vim: ft=ruby
