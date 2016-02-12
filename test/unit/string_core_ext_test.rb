# encoding: UTF-8
require_relative "../test_helper"

# tests for String core extension. See lib/noosfero/core_ext/string.rb
class StringCoreExtTest < ActiveSupport::TestCase

  # tests for String#to_slug
  should 'keep only alphanum' do
    assert_equal 'abc', 'abc!)@(*#&@!*#*)'.to_slug
  end

  should 'turn punctuation into dashes' do
    assert_equal 'a-b-c-d-e-f', 'a:b;c+d=e_f'.to_slug
  end

  should 'truncate dashes' do
    assert_equal 'a-b-c', 'a---b: c ;;;'.to_slug
  end

  should 'turn spaces into dashes' do
    assert_equal 'a-b', 'a b'.to_slug
  end

  should 'not remove dots' do
    assert_equal 'a.b', 'a.b'.to_slug
  end

  should 'handle multy-byte UTF-8 characters properly' do
    assert_equal '日本語ローカライズチーム-home', '日本語ローカライズチーム_HOME'.to_slug
  end

  # tests for String#transliterate
  should 'transliterate' do
    assert_equal 'aaaaaaAAAAAeeeeEEOOoocaaaiIIiuuyYnNcC', 'ªáàäâåÁÀÄÂÅéèëêÊËÖÔöôçäàâîÏÎïûüÿŸñÑçÇ'.transliterate
  end

  should 'convert to css class' do
    assert_equal 'spaceship-propulsion_warp-core', "SpaceshipPropulsion::WarpCore".to_css_class
  end

  should 'downcase accented strings' do
    assert_equal 'vatapá com dendê da moça', 'VATAPÁ COM DENDÊ DA MOÇA'.downcase
    assert_equal 'vatapá com dendê da moça', 'VATAPÁ COM dendê da moça'.downcase
  end

  should 'upcase accented strings' do
    assert_equal 'VATAPÁ COM DENDÊ DA MOÇA', 'vatapá com dendê da moça'.upcase
    assert_equal 'VATAPÁ COM DENDÊ DA MOÇA', 'VATAPÁ COM dendê da MOÇA'.upcase
  end

end
