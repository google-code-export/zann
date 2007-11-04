require File.dirname(__FILE__) + '/../test_helper'

class TaggingTest < Test::Unit::TestCase
  fixtures :taggings, :tags, :photos

  def setup
    setup_fixture_files
  end

  def test_tag_photos
    shanghai_photo = photos(:shanghai_1)
    shanghai_photo.tag_with('shanghai')
    shanghai_photo = Photo.find(shanghai_photo.id)
    assert_equal 'shanghai', shanghai_photo.tag_list
    shanghai_photo.tag_with('tag testing')
    shanghai_photo = Photo.find(shanghai_photo.id)
    assert_equal 'shanghai tag testing', shanghai_photo.tag_list
  end

  def test_tag_chinese
    shanghai_photo = photos(:shanghai_1)
    shanghai_photo.tag_with('上海')
    shanghai_photo = Photo.find(shanghai_photo.id)
    assert_equal '上海', shanghai_photo.tag_list
  end

  def test_tag_update
    shanghai_photo = photos(:shanghai_1)
    shanghai_photo.tag_with('shanghai city')
    shanghai_photo = Photo.find(shanghai_photo.id)
    assert_equal 'shanghai city', shanghai_photo.tag_list
    shanghai_photo.tag_update('new shanghai')
    shanghai_photo = Photo.find(shanghai_photo.id)
    assert_equal 'new shanghai', shanghai_photo.tag_list
  end

  def test_find_by_tag
    shanghai_photo_1 = photos(:shanghai_1)
    shanghai_photo_1.tag_with('shanghai city')
    shanghai_photo_2 = photos(:shanghai_2)
    shanghai_photo_2.tag_with('shanghai subway')
    photos_tagged_shanghai = Photo.find_by_tag('shanghai')
    assert_equal(2, photos_tagged_shanghai.length)
    assert_equal(1, photos_tagged_shanghai[0].id)
    assert_equal(2, photos_tagged_shanghai[1].id)
    photos_tagged_shanghai_and_city = Photo.find_by_tag('shanghai city')
    assert_equal(1, photos_tagged_shanghai_and_city.length)
  end

  def teardown
    teardown_fixture_files
  end
end
