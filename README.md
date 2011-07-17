EnumeratedField is a library that provides some nice methods when a string column is used like an enumeration, meaning there is a list of allowable values for the string column. Typically you want the display value as seen by the end user to differ from the stored value, allowing you to easily change the display value at anytime without migrating data, and this little gem helps you with that.

## Usage

The default validation uses ActiveModel's inclusion validations. If using on a
class without ActiveModel use `:validate => false` to disable
these.

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

    > hike.trail_values   # useful to provide to options_for_select when constructing forms
    => [['Pacific Crest Trail', 'pct'], ['Continental Divide Trail', 'cdt'], ['Superior Hiking Trail', 'sht']]


These methods are all prefixed with the field name by design, which allows multiple fields on a model to exist which potentially have the same values.

Run tests by:  ruby test/enumerated_field_test.rb

## TODO

* Provide any support needed for defining columns on MySQL databases as enum columns instead of string columns.