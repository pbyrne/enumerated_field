require File.dirname(__FILE__) + '/test_helper'

class Apple
  include EnumeratedField

  attr_accessor :color, :kind
  
  enum_field :color, [['Red', :red], ['Green', :green]], :validate => false
  enum_field :kind, [['Fuji Apple', :fuji], ['Delicious Red Apple', :delicious]], :validate => false

  def initialize(color, kind)
    self.color = color
    self.kind = kind
  end

end

class Banana
  include EnumeratedField
  include ActiveModel::Validations

  attr_accessor :brand

  enum_field :brand, [["Chiquita", :chiquita], ["Del Monte", :delmonte]]

  def initialize(brand)
    self.brand = brand
  end
end

class EnumeratedFieldTest < Test::Unit::TestCase

  context 'EnumeratedField class' do

    should 'have the color_values method' do
      assert_equal Apple.color_values.length, 2
    end

    should 'have 2 values without first option' do
      assert_equal Apple.color_values.length, 2
    end

    should 'have 3 values with first option' do
      assert_equal Apple.color_values(:first_option => "Select Color").length, 3
    end

  end

  context 'EnumeratedField instance' do

    setup do
      @red_apple = Apple.new(:red, :fuji)
      @green_apple = Apple.new(:green, :delicious)
    end

    should 'have color_display method' do
      assert_equal @red_apple.color_display, 'Red'
    end

    should 'show Green for color_display of green' do
      assert_equal @red_apple.color_display_for(:green), 'Green'
    end

    should 'have two enum fields in one class' do
      assert_equal @green_apple.color_display, 'Green'
      assert_equal @green_apple.kind_display, 'Delicious Red Apple'
    end

    should 'have valid question methods' do
      assert @green_apple.color_green?
      assert !@green_apple.color_red?
      assert @green_apple.kind_delicious?
      assert !@green_apple.kind_fuji?
    end

    should 'have 2 values without first option' do
      assert_equal @red_apple.color_values.length, 2
    end

    should 'have 3 values with first option' do
      assert_equal @red_apple.color_values(:first_option => "Select Color").length, 3
    end

  end

  def test_validation
    # valid choice
    banana = Banana.new(:chiquita)
    assert banana.valid?

    # invalid choice
    bad_banana = Banana.new(:penzoil)
    assert !bad_banana.valid?
    assert_equal ["is not included in the list"], bad_banana.errors[:brand]

    # no validations, accepts any choice
    apple = Apple.new(:orange, :macintosh)
    assert !apple.respond_to?(:valid)
  end
end
