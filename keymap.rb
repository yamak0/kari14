# Keyboard: kari14 macropad
# Initialize a Keyboard
kbd = Keyboard.new

# If your right hand the "anchor"
# kbd.set_anchor(:right)

# Initialize GPIO assign
# Assuming you'er using a Sparkfun Pro Micro RP2040
kbd.init_pins(
    [ 26, 13, 12, 11 ],    # row0, row1,... respectively
    [ 27, 28, 29, 14 ]     # col0, col1,... respectively
)
# Physical Layout
# ,-------------------.
# | 00 | 01 | 02 | na |
# |----+----+----+----|
# | 10 | 11 | 12 | na |
# |----+----+----+----|
# | 20 | 21 | 22 |23/E|
# |----+----+----+----|
# | 30 | 31 | 32 |33/E|
# `-------------------'

# default layer should be added at first

kbd.add_layer :default, %i[
  RAISE_ENT LOWER_DOT KC_0    KC_NO
  KC_3      KC_2      KC_1    KC_NO
  KC_6      KC_5      KC_4    KC_A
  KC_9      KC_8      KC_7    KC_B
]

kbd.add_layer :raise, %i[
  KC_C      KC_D      KC_E    KC_NO
  KC_F3     KC_F2     KC_F1   KC_NO
  KC_F6     KC_F5     KC_F4   KC_F
  KC_F9     KC_F8     KC_F7   KC_G
]
kbd.add_layer :lower, %i[
  KC_H      KC_I      KC_J    KC_NO
  KC_F12    KC_F11    KC_F10  KC_NO
  KC_F15    KC_F14    KC_F13  KC_K
  KC_F18    KC_F17    KC_F16  KC_L
]

#                   Your custom     Keycode or             Keycode (only modifiers)      Release time      Re-push time
#                   key name        Array of Keycode       or Layer Symbol to be held    threshold(ms)     threshold(ms)
#                                   or Proc                or Proc which will run        to consider as    to consider as
#                                   when you click         while you keep press          `click the key`   `hold the key`
kbd.define_mode_key :RAISE_ENT,   [ :KC_ENTER,             :raise,                       300,              300 ]
kbd.define_mode_key :LOWER_DOT,   [ :KC_DOT,               :lower,                       300,              300 ]

# `before_report` will work just right before reporting what keys are pushed to USB host.
# You can use it to hack data by adding an instance method to Keyboard class by yourself.
# ex) Use Keyboard#before_report filter if you want to input `":" w/o shift` and `";" w/ shift`
#kbd.before_report do
#  kbd.invert_sft if kbd.keys_include?(:KC_SCOLON)
#  # You'll be also able to write `invert_ctl`, `invert_alt` and `invert_gui`
#end

# # Initialize RGB class with pin, underglow_size, backlight_size and is_rgbw.
# rgb = RGB.new(
#   0,    # pin number
#   0,    # size of underglow pixel
#   32,   # size of backlight pixel
#   false # 32bit data will be sent to a pixel if true while 24bit if false
# )
# sleep 1
# # Set an effect
# #  `nil` or `:off` for turning off
# rgb.effect = :swirl
# # Set an action when you input
# #  `nil` or `:off` for turning off
# #rgb.action = :thunder
# # Append the feature. Will possibly be able to write `Keyboard#append(OLED.new)` in the future
# kbd.append rgb

# Initialize RotaryEncoder with pin_a and pin_b
encoder0 = RotaryEncoder.new(9, 10)
encoder0.configure :left
# These implementations are still ad-hoc
encoder0.clockwise do
  kbd.send_key :KC_PGDOWN
end
encoder0.counterclockwise do
  kbd.send_key :KC_PGUP
end
kbd.append encoder0

encoder1 = RotaryEncoder.new(7, 8)
encoder1.configure :right
# These implementations are still ad-hoc
encoder1.clockwise do
  kbd.send_key :KC_DOWN
end
encoder1.counterclockwise do
  kbd.send_key :KC_UP
end
kbd.append encoder1

kbd.start!