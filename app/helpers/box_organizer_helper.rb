module BoxOrganizerHelper

  def max_number_of_blocks_per_line
    7
  end

  def display_icon(block)
    image_path = nil
    plugin = @plugins.fetch_first_plugin(:has_block?, block)

    theme = Theme.new(environment.theme) # remove this
    if File.exists?(File.join(theme.filesystem_path, 'images', block.icon_path))
      image_path = File.join(theme.public_path, 'images', block.icon_path)
    elsif plugin && File.exists?(File.join(Rails.root, 'public', plugin.public_path, 'images', block.icon_path))
      image_path = File.join('/', plugin.public_path, 'images', block.icon_path)
    elsif File.exists?(File.join(Rails.root, 'public', 'images', block.icon_path))
      image_path = block.icon_path
    else
      image_path = block.default_icon_path
    end

    image_tag(image_path, height: '48', width: '48', class: 'block-type-icon', alt: '' )
  end

  def display_previews(block)
#  def self.previews_path
#    previews = Dir.glob(File.join(images_filesystem_path, 'previews/*')).map do |path|
#      File.join(images_base_url_path, 'previews', File.basename(path))
#    end
    ''
  end

  def icon_selector(icon = 'no-ico')
    render :partial => 'icon_selector', :locals => { :icon => icon }
  end

  def extra_option_checkbox(option)
    if [:human_name, :name, :value, :checked, :options].all? {|k| option.key? k}
      labelled_check_box(option[:human_name], option[:name], option[:value], option[:checked], option[:options])
    end
  end

end
