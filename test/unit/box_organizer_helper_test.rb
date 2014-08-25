# encoding: UTF-8
require File.dirname(__FILE__) + '/../test_helper'

class BoxOrganizerHelperTest < ActionView::TestCase


  def setup
    @environment = Environment.default
  end

  attr_reader :environment

  should 'max number of blocks be 7' do
    assert_equal 7, max_number_of_blocks_per_line
  end

  should 'display the default icon for block without icon' do
    class SomeBlock < Block; end
    block = SomeBlock
    @plugins = mock
    @plugins.stubs(:fetch_first_plugin).with(:has_block?, block).returns(nil)
    assert_match '/images/icon_block.png', display_icon(block)
  end

  should 'display the icon block' do
    class SomeBlock < Block; end
    block = SomeBlock
    @plugins = mock
    @plugins.stubs(:fetch_first_plugin).with(:has_block?, block).returns(nil)

    File.stubs(:exists?).returns(false)
    File.stubs(:exists?).with(File.join(Rails.root, 'public', 'images', '/blocks/some_block/icon.png')).returns(true)
    assert_match 'blocks/some_block/icon.png', display_icon(block)
  end

  should 'display the plugin icon block' do
    class SomeBlock < Block; end
    block = SomeBlock
    class SomePlugin < Noosfero::Plugin; end
    SomePlugin.stubs(:name).returns('SomePlugin')
    @plugins = mock
    @plugins.stubs(:fetch_first_plugin).with(:has_block?, block).returns(SomePlugin)

    File.stubs(:exists?).returns(false)
    File.stubs(:exists?).with(File.join(Rails.root, 'public', 'plugins/some/images/blocks/some_block/icon.png')).returns(true)
    assert_match 'plugins/some/images/blocks/some_block/icon.png', display_icon(block)
  end

  should 'display the theme icon block' do
    class SomeBlock < Block; end
    block = SomeBlock

    @plugins = mock
    @plugins.stubs(:fetch_first_plugin).with(:has_block?, block).returns(nil)

    @environment = mock
    @environment.stubs(:theme).returns('some_theme')

    File.stubs(:exists?).returns(false)
    File.stubs(:exists?).with(File.join(Rails.root, 'public', 'designs/themes/some_theme/images/blocks/some_block/icon.png')).returns(true)
    assert_match 'designs/themes/some_theme/images/blocks/some_block/icon.png', display_icon(block)
  end

  should 'display the theme icon block instead of block icon' do
    class SomeBlock < Block; end
    block = SomeBlock

    @plugins = mock
    @plugins.stubs(:fetch_first_plugin).with(:has_block?, block).returns(nil)

    @environment = mock
    @environment.stubs(:theme).returns('some_theme')

    File.stubs(:exists?).returns(false)
    File.stubs(:exists?).with(File.join(Rails.root, 'public', 'designs/themes/some_theme/images/blocks/some_block/icon.png')).returns(true)
    File.stubs(:exists?).with(File.join(Rails.root, 'public', 'images', '/blocks/some_block/icon.png')).returns(true)
    assert_match 'designs/themes/some_theme/images/blocks/some_block/icon.png', display_icon(block)
  end

  should 'display the theme icon block instead of plugin block icon' do
    class SomeBlock < Block; end
    block = SomeBlock

    class SomePlugin < Noosfero::Plugin; end
    SomePlugin.stubs(:name).returns('SomePlugin')
    @plugins = mock
    @plugins.stubs(:fetch_first_plugin).with(:has_block?, block).returns(SomePlugin)

    @environment = mock
    @environment.stubs(:theme).returns('some_theme')

    File.stubs(:exists?).returns(false)
    File.stubs(:exists?).with(File.join(Rails.root, 'public', 'designs/themes/some_theme/images/blocks/some_block/icon.png')).returns(true)
    File.stubs(:exists?).with(File.join(Rails.root, 'public', 'plugins/some/images/blocks/some_block/icon.png')).returns(true)
    assert_match 'designs/themes/some_theme/images/blocks/some_block/icon.png', display_icon(block)
  end

  should 'display the theme icon block instead of block icon and plugin icon' do
    class SomeBlock < Block; end
    block = SomeBlock

    class SomePlugin < Noosfero::Plugin; end
    SomePlugin.stubs(:name).returns('SomePlugin')
    @plugins = mock
    @plugins.stubs(:fetch_first_plugin).with(:has_block?, block).returns(SomePlugin)


    @environment = mock
    @environment.stubs(:theme).returns('some_theme')

    File.stubs(:exists?).returns(false)
    File.stubs(:exists?).with(File.join(Rails.root, 'public', 'designs/themes/some_theme/images/blocks/some_block/icon.png')).returns(true)
    File.stubs(:exists?).with(File.join(Rails.root, 'public', 'plugins/some/images/blocks/some_block/icon.png')).returns(true)
    File.stubs(:exists?).with(File.join(Rails.root, 'public', 'images', '/blocks/some_block/icon.png')).returns(true)
    assert_match 'designs/themes/some_theme/images/blocks/some_block/icon.png', display_icon(block)
  end

  should 'display the plugin icon block instead of block icon' do
    class SomeBlock < Block; end
    block = SomeBlock

    class SomePlugin < Noosfero::Plugin; end
    SomePlugin.stubs(:name).returns('SomePlugin')
    @plugins = mock
    @plugins.stubs(:fetch_first_plugin).with(:has_block?, block).returns(SomePlugin)


    File.stubs(:exists?).returns(false)
    File.stubs(:exists?).with(File.join(Rails.root, 'public', 'plugins/some/images/blocks/some_block/icon.png')).returns(true)
    File.stubs(:exists?).with(File.join(Rails.root, 'public', 'images', '/blocks/some_block/icon.png')).returns(true)
    assert_match 'plugins/some/images/blocks/some_block/icon.png', display_icon(block)
  end

end
