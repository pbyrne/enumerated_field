EnumeratedField is a library that provides some nice methods when a string column is used like an enumeration, meaning there is a list of allowable values for the string column. Typically you want the display value as seen by the end user to differ from the stored value, allowing you to easily change the display value at anytime without migrating data, and this little gem helps you with that.

## Usage

    enum_field(field_name, choices, options = {})

Available options are:

* `:validate`, whether to validate that the value is in the given list
  of choices. Defaults to true.
* `:allow_nil`, whether a nil value passes validation. Defaults to
  false.
* `:allow_blank`, whether a blank (nil, "") value passes validation.
  Defaults to false.

The default validation uses ActiveModel's inclusion validations. If using on a
class without ActiveModel use `:validate => false` to disable
these.

## Example

    class Hike < ActiveRecord::Base
      include EnumeratedField

      # default form
      enum_field :duration, [
        ['Short', 'short'],
        ['Really, really long', 'long']
      ]
      # disable default validation
      enum_field :trail, [
        ['Pacific Crest Trail', 'pct'],
        ['Continental Divide Trail', 'cdt'],
        ['Superior Hiking Trail', 'sht']
      ], :validate => false
    end

    > hike = Hike.create(:trail => 'pct', :duration => 'long')

### Confirm Values

    > hike.trail_sht?
    => false

    > hike.trail_pct?
    => true

    > hike.duration_long?
    => true

    > hike.duration_short?
    => false

### Display Selected Value

    > hike.trail_display
    => "Pacific Crest Trail"

    > hike.duration_display
    => "Really, really long"

### Validation

    > hike.valid?
    => true

    > hike.duration = 'forever'
    > hike.valid?
    => false

### List Available Values

    > hike.trail_values # useful to provide to options_for_select when constructing forms
    => [['Pacific Crest Trail', 'pct'], ['Continental Divide Trail', 'cdt'], ['Superior Hiking Trail', 'sht']]
    > Hike.trail_values # or get it from the class instead of the instance, if you like
    => [['Pacific Crest Trail', 'pct'], ['Continental Divide Trail', 'cdt'], ['Superior Hiking Trail', 'sht']]

### Use Constants for Keys

    > Hike::TRAIL_PCT
    => :pct
    > Hike::TRAIL_SHT
    => :sht

These methods are all prefixed with the field name by design, which allows multiple fields on a model to exist which potentially have the same values.

## TESTS

Run tests with `bundle exec rake test` (or just `rake test` if you're
daring).

## TODO

* Provide any support needed for defining columns on MySQL databases as enum columns instead of string columns.
