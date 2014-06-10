------------------------------------------------------------------------------
--                                                                          --
--      Copyright (C) 1998-2000 E. Briot, J. Brobecker and A. Charlet       --
--                     Copyright (C) 2000-2014, AdaCore                     --
--                                                                          --
-- This library is free software;  you can redistribute it and/or modify it --
-- under terms of the  GNU General Public License  as published by the Free --
-- Software  Foundation;  either version 3,  or (at your  option) any later --
-- version. This library is distributed in the hope that it will be useful, --
-- but WITHOUT ANY WARRANTY;  without even the implied warranty of MERCHAN- --
-- TABILITY or FITNESS FOR A PARTICULAR PURPOSE.                            --
--                                                                          --
-- As a special exception under Section 7 of GPL version 3, you are granted --
-- additional permissions described in the GCC Runtime Library Exception,   --
-- version 3.1, as published by the Free Software Foundation.               --
--                                                                          --
-- You should have received a copy of the GNU General Public License and    --
-- a copy of the GCC Runtime Library Exception along with this program;     --
-- see the files COPYING3 and COPYING.RUNTIME respectively.  If not, see    --
-- <http://www.gnu.org/licenses/>.                                          --
--                                                                          --
------------------------------------------------------------------------------

--  <description>
--  GtkCssProvider is an object implementing the
--  Gtk.Style_Provider.Gtk_Style_Provider interface. It is able to parse
--  [CSS-like](http://www.w3.org/TR/CSS2) input in order to style widgets.
--
--  ## Default files
--
--  An application can cause GTK+ to parse a specific CSS style sheet by
--  calling gtk_css_provider_load_from_file and adding the provider with
--  Gtk.Style_Context.Add_Provider or
--  Gtk.Style_Context.Add_Provider_For_Screen. In addition, certain files will
--  be read when GTK+ is initialized. First, the file
--  `$XDG_CONFIG_HOME/gtk-3.0/gtk.css` is loaded if it exists. Then, GTK+ tries
--  to load `$HOME/.themes/theme-name/gtk-3.0/gtk.css`, falling back to
--  `datadir/share/themes/theme-name/gtk-3.0/gtk.css`, where theme-name is the
--  name of the current theme (see the Gtk.Settings.Gtk_Settings:gtk-theme-name
--  setting) and datadir is the prefix configured when GTK+ was compiled,
--  unless overridden by the `GTK_DATA_PREFIX` environment variable.
--
--  # Style sheets
--
--  The basic structure of the style sheets understood by this provider is a
--  series of statements, which are either rule sets or "@-rules", separated by
--  whitespace.
--
--  A rule set consists of a selector and a declaration block, which is a
--  series of declarations enclosed in curly braces ({ and }). The declarations
--  are separated by semicolons (;). Multiple selectors can share the same
--  declaration block, by putting all the separators in front of the block,
--  separated by commas.
--
--  An example of a rule set with two selectors: |[ GtkButton, GtkEntry {
--  color: ff00ea; font: Comic Sans 12 } ]|
--
--  # Selectors # {gtkcssprovider-selectors}
--
--  Selectors work very similar to the way they do in CSS, with widget class
--  names taking the role of element names, and widget names taking the role of
--  IDs. When used in a selector, widget names must be prefixed with a '#'
--  character. The "*" character represents the so-called universal selector,
--  which matches any widget.
--
--  To express more complicated situations, selectors can be combined in
--  various ways: - To require that a widget satisfies several conditions,
--  combine several selectors into one by concatenating them. E.g.
--  `GtkButtonbutton1` matches a GtkButton widget with the name button1. - To
--  only match a widget when it occurs inside some other widget, write the two
--  selectors after each other, separated by whitespace. E.g. `GtkToolBar
--  GtkButton` matches GtkButton widgets that occur inside a GtkToolBar. - In
--  the previous example, the GtkButton is matched even if it occurs deeply
--  nested inside the toolbar. To restrict the match to direct children of the
--  parent widget, insert a ">" character between the two selectors. E.g.
--  `GtkNotebook > GtkLabel` matches GtkLabel widgets that are direct children
--  of a GtkNotebook.
--
--  ## Examples of widget classes and names in selectors
--
--  Theme labels that are descendants of a window: |[ GtkWindow GtkLabel {
--  background-color: 898989 } ]|
--
--  Theme notebooks, and anything that's within these: |[ GtkNotebook {
--  background-color: a939f0 } ]|
--
--  Theme combo boxes, and entries that are direct children of a notebook: |[
--  GtkComboBox, GtkNotebook > GtkEntry { color: Fg_Color; background-color:
--  1209a2 } ]|
--
--  Theme any widget within a GtkBin: |[ GtkBin * { font: Sans 20 } ]|
--
--  Theme a label named title-label: |[ GtkLabeltitle-label { font: Sans 15 }
--  ]|
--
--  Theme any widget named main-entry: |[ main-entry { background-color:
--  f0a810 } ]|
--
--  Widgets may also define style classes, which can be used for matching.
--  When used in a selector, style classes must be prefixed with a "."
--  character.
--
--  Refer to the documentation of individual widgets to learn which style
--  classes they define and see [Style Classes and
--  Regions][gtkstylecontext-classes] for a list of all style classes used by
--  GTK+ widgets.
--
--  Note that there is some ambiguity in the selector syntax when it comes to
--  differentiation widget class names from regions. GTK+ currently treats a
--  string as a widget class name if it contains any uppercase characters
--  (which should work for more widgets with names like GtkLabel).
--
--  ## Examples for style classes in selectors
--
--  Theme all widgets defining the class entry: |[ .entry { color: 39f1f9; }
--  ]|
--
--  Theme spinbuttons' entry: |[ GtkSpinButton.entry { color: 900185 } ]|
--
--  In complicated widgets like e.g. a GtkNotebook, it may be desirable to
--  style different parts of the widget differently. To make this possible,
--  container widgets may define regions, whose names may be used for matching
--  in selectors.
--
--  Some containers allow to further differentiate between regions by applying
--  so-called pseudo-classes to the region. For example, the tab region in
--  GtkNotebook allows to single out the first or last tab by using the
--  :first-child or :last-child pseudo-class. When used in selectors,
--  pseudo-classes must be prefixed with a ':' character.
--
--  Refer to the documentation of individual widgets to learn which regions
--  and pseudo-classes they define and see [Style Classes and
--  Regions][gtkstylecontext-classes] for a list of all regions used by GTK+
--  widgets.
--
--  ## Examples for regions in selectors
--
--  Theme any label within a notebook: |[ GtkNotebook GtkLabel { color:
--  f90192; } ]|
--
--  Theme labels within notebook tabs: |[ GtkNotebook tab GtkLabel { color:
--  703910; } ]|
--
--  Theme labels in the any first notebook tab, both selectors are equivalent:
--  |[ GtkNotebook tab:nth-child(first) GtkLabel, GtkNotebook tab:first-child
--  GtkLabel { color: 89d012; } ]|
--
--  Another use of pseudo-classes is to match widgets depending on their
--  state. This is conceptually similar to the :hover, :active or :focus
--  pseudo-classes in CSS. The available pseudo-classes for widget states are
--  :active, :prelight (or :hover), :insensitive, :selected, :focused and
--  :inconsistent.
--
--  ## Examples for styling specific widget states
--
--  Theme active (pressed) buttons: |[ GtkButton:active { background-color:
--  0274d9; } ]|
--
--  Theme buttons with the mouse pointer on it, both are equivalent: |[
--  GtkButton:hover, GtkButton:prelight { background-color: 3085a9; } ]|
--
--  Theme insensitive widgets, both are equivalent: |[ :insensitive,
--  *:insensitive { background-color: 320a91; } ]|
--
--  Theme selection colors in entries: |[ GtkEntry:selected {
--  background-color: 56f9a0; } ]|
--
--  Theme focused labels: |[ GtkLabel:focused { background-color: b4940f; } ]|
--
--  Theme inconsistent checkbuttons: |[ GtkCheckButton:inconsistent {
--  background-color: 20395a; } ]|
--
--  Widget state pseudoclasses may only apply to the last element in a
--  selector.
--
--  To determine the effective style for a widget, all the matching rule sets
--  are merged. As in CSS, rules apply by specificity, so the rules whose
--  selectors more closely match a widget path will take precedence over the
--  others.
--
--  # @ Rules
--
--  GTK+'s CSS supports the \Import rule, in order to load another CSS style
--  sheet in addition to the currently parsed one.
--
--  An example for using the \Import rule: |[ Import url
--  ("path/to/common.css"); ]|
--
--  In order to extend key bindings affecting different widgets, GTK+ supports
--  the \Binding-set rule to parse a set of bind/unbind directives, see
--  Gtk.Binding_Set.Gtk_Binding_Set for the supported syntax. Note that the
--  binding sets defined in this way must be associated with rule sets by
--  setting the gtk-key-bindings style property.
--
--  Customized key bindings are typically defined in a separate `gtk-keys.css`
--  CSS file and GTK+ loads this file according to the current key theme, which
--  is defined by the Gtk.Settings.Gtk_Settings:gtk-key-theme-name setting.
--
--  An example for using the \Binding rule: |[ Binding-set binding-set1 { bind
--  "<alt>Left" { "move-cursor" (visual-positions, -3, 0) }; unbind "End"; };
--
--  Binding-set binding-set2 { bind "<alt>Right" { "move-cursor"
--  (visual-positions, 3, 0) }; bind "<alt>KP_space" { "delete-from-cursor"
--  (whitespace, 1) "insert-at-cursor" (" ") }; };
--
--  GtkEntry { gtk-key-bindings: binding-set1, binding-set2; } ]|
--
--  GTK+ also supports an additional \Define-color rule, in order to define a
--  color name which may be used instead of color numeric representations. Also
--  see the Gtk.Settings.Gtk_Settings:gtk-color-scheme setting for a way to
--  override the values of these named colors.
--
--  An example for defining colors: |[ Define-color bg_color f9a039;
--
--  * { background-color: Bg_Color; } ]|
--
--  # Symbolic colors
--
--  Besides being able to define color names, the CSS parser is also able to
--  read different color expressions, which can also be nested, providing a
--  rich language to define colors which are derived from a set of base colors.
--
--  An example for using symbolic colors: |[ Define-color entry-color shade
--  (Bg_Color, 0.7);
--
--  GtkEntry { background-color: Entry-color; }
--
--  GtkEntry:focused { background-color: mix (Entry-color, shade (fff, 0.5),
--  0.8); } ]|
--
--  # Specifying Colors # {specifying-colors} There are various ways to
--  express colors in GTK+ CSS.
--
--  ## rgb(r, g, b)
--
--  An opaque color.
--
--  - `r`, `g`, `b` can be either integers between 0 and 255, or percentages.
--
--  |[ color: rgb(128, 10, 54); background-color: rgb(20%, 30%, 0%); ]|
--
--  ## rgba(r, g, b, a)
--
--  A translucent color.
--
--  - `r`, `g`, `b` can be either integers between 0 and 255, or percentages.
--  - `a` is a floating point number between 0 and 1.
--
--  |[ color: rgb(128, 10, 54, 0.5); ]|
--
--  ## \xxyyzz
--
--  An opaque color.
--
--  - `xx`, `yy`, `zz` are hexadecimal numbers specifying `r`, `g`, `b`
--  variants with between 1 and 4 hexadecimal digits per component.
--
--  |[ color: f0c; background-color: ff00cc; border-color: ffff0000cccc; ]|
--
--  ## \Name
--
--  Reference to a color that has been defined with \Define-color
--
--  |[ color: Bg_Color; ]|
--
--  ## mix(color1, color2, factor)
--
--  A linear combination of `color1` and `color2`.
--
--  - `factor` is a floating point number between 0 and 1.
--
--  |[ color: mix(ff1e0a, Bg_Color, 0.8); ]|
--
--  ## shade(color, factor)
--
--  A lighter or darker variant of `color`.
--
--  - `factor` is a floating point number.
--
--  |[ color: shade(Fg_Color, 0.5); ]|
--
--  ## lighter(color)
--
--  A lighter variant of `color`.
--
--  |[ color: lighter(Fg_Color); ]|
--
--  ## darker(color)
--
--  A darker variant of `color`.
--
--  |[ color: darker(Bg_Color); ]|
--
--  ## alpha(color, factor)
--
--  Modifies passed color's alpha by a factor.
--
--  - `factor` is a floating point number. `factor` < 1.0 results in a more
--  transparent color while `factor` > 1.0 results in a more opaque color.
--
--  |[ color: alpha(Fg_Color, 0.5); ]|
--
--  # Gradients
--
--  Linear or radial gradients can be used as background images.
--
--  ## Linear Gradients
--
--  A linear gradient along the line from (`start_x`, `start_y`) to (`end_x`,
--  `end_y`) is specified using the following syntax:
--
--  > `-gtk-gradient (linear, start_x start_y, end_x end_y, color-stop
--  (position, color), ...)`
--
--  - `start_x` and `end_x` can be either a floating point number between 0
--  and 1, or one of the special values: "left", "right", or "center". -
--  `start_y` and `end_y` can be either a floating point number between 0 and
--  1, or one of the special values: "top", "bottom" or "center". - `position`
--  is a floating point number between 0 and 1. - `color` is a color expression
--  (see above).
--
--  The color-stop can be repeated multiple times to add more than one color
--  stop. "from (color)" and "to (color)" can be used as abbreviations for
--  color stops with position 0 and 1, respectively.
--
--  ## Example: Linear Gradient ![](gradient1.png) |[ -gtk-gradient (linear,
--  left top, right bottom, from(Yellow), to(Blue)); ]|
--
--  ## Example: Linear Gradient 2 ![](gradient2.png) |[ -gtk-gradient (linear,
--  0 0, 0 1, color-stop(0, Yellow), color-stop(0.2, Blue), color-stop(1, 0f0))
--  ]|
--
--  ## Radial Gradients
--
--  A radial gradient along the two circles defined by (`start_x`, `start_y`,
--  `start_radius`) and (`end_x`, `end_y`, `end_radius`) is specified using the
--  following syntax:
--
--  > `-gtk-gradient (radial, start_x start_y, start_radius, end_x end_y,
--  end_radius, color-stop (position, color), ...)`
--
--  where `start_radius` and `end_radius` are floating point numbers and the
--  other parameters are as before.
--
--  ## Example: Radial Gradient ![](gradient3.png) |[ -gtk-gradient (radial,
--  center center, 0, center center, 1, from(Yellow), to(Green)) ]|
--
--  ## Example: Radial Gradient 2 ![](gradient4.png) |[ -gtk-gradient (radial,
--  0.4 0.4, 0.1, 0.6 0.6, 0.7, color-stop (0, f00), color-stop (0.1, a0f),
--  color-stop (0.2, Yellow), color-stop (1, Green)) ]|
--
--  # Border images # {border-images}
--
--  Images and gradients can also be used in slices for the purpose of
--  creating scalable borders. For more information, see the [CSS3
--  documentation for the border-image
--  property](http://www.w3.org/TR/css3-background/border-images).
--
--  ![](slices.png)
--
--  The parameters of the slicing process are controlled by four separate
--  properties.
--
--  - Image Source - Image Slice - Image Width - Image Repeat
--
--  Note that you can use the `border-image` shorthand property to set values
--  for the properties at the same time.
--
--  ## Image Source
--
--  The border image source can be specified either as a URL or a gradient: |[
--  border-image-source: url(path); ]| or |[ border-image-source:
--  -gtk-gradient(...); ]|
--
--  ## Image Slice
--
--  |[ border-image-slice: top right bottom left; ]|
--
--  The sizes specified by the `top`, `right`, `bottom`, and `left` parameters
--  are the offsets (in pixels) from the relevant edge where the image should
--  be "cut off" to build the slices used for the rendering of the border.
--
--  ## Image Width
--
--  |[ border-image-width: top right bottom left; ]|
--
--  The sizes specified by the Top, Right, Bottom and Left parameters are
--  inward distances from the border box edge, used to specify the rendered
--  size of each slice determined by border-image-slice. If this property is
--  not specified, the values of border-width will be used as a fallback.
--
--  ## Image Repeat
--
--  Specifies how the image slices should be rendered in the area outlined by
--  border-width.
--
--  |[ border-image-repeat: [stretch|repeat|round|space]; ]| or |[
--  border-image-repeat: [stretch|repeat|round|space]
--  [stretch|repeat|round|space]; ]|
--
--  - The default (stretch) is to resize the slice to fill in the whole
--  allocated area.
--
--  - If the value of this property is "repeat", the image slice will be tiled
--  to fill the area.
--
--  - If the value of this property is "round", the image slice will be tiled
--  to fill the area, and scaled to fit it exactly a whole number of times.
--
--  - If the value of this property is "space", the image slice will be tiled
--  to fill the area, and if it doesn't fit it exactly a whole number of times,
--  the extra space is distributed as padding around the slices.
--
--  - If two options are specified, the first one affects the horizontal
--  behaviour and the second one the vertical behaviour. If only one option is
--  specified, it affects both.
--
--  ## Example: Border Image ![](border1.png) |[ border-image:
--  url("gradient1.png") 10 10 10 10; ]|
--
--  ## Example: Repeating Border Image ![](border2.png) |[ border-image:
--  url("gradient1.png") 10 10 10 10 repeat; ]|
--
--  ## Example: Stetched Border Image ![](border3.png) |[ border-image:
--  url("gradient1.png") 10 10 10 10 stretch; ]|
--
--  # Supported Properties
--
--  Properties are the part that differ the most to common CSS, not all
--  properties are supported (some are planned to be supported eventually, some
--  others are meaningless or don't map intuitively in a widget based
--  environment).
--
--  The currently supported properties are:
--
--  ## engine: [name|none];
--
--  - `none` means to use the default (ie. builtin engine) |[ engine:
--  clearlooks; ]|
--
--  ## background-color: [color|transparent];
--
--  - `color`: See [Specifying Colors][specifying-colors] |[ background-color:
--  shade (Color1, 0.5); ]|
--
--  ## color: [color|transparent];
--
--  - `color`: See [Specifying Colors][specifying-colors] |[ color: fff; ]|
--
--  ## border-color: [color|transparent]{1,4};
--
--  - `color`: See [Specifying Colors][specifying-colors] - Four values used
--  to specify: top right bottom left - Three values used to specify: top
--  vertical bottom - Two values used to specify: horizontal vertical - One
--  value used to specify: color |[ border-color: red green blue; ]|
--
--  ## border-top-color: [color|transparent];
--
--  - `color`: See [Specifying Colors][specifying-colors] |[ border-top-color:
--  Borders; ]|
--
--  ## border-right-color: [color|transparent];
--
--  - `color`: See [Specifying Colors][specifying-colors] |[
--  border-right-color: Borders; ]|
--
--  ## border-bottom-color: [color|transparent];
--
--  - `color`: See [Specifying Colors][specifying-colors] |[
--  border-bottom-color: Borders; ]|
--
--  ## border-left-color: [color|transparent];
--
--  - `color`: See [Specifying Colors][specifying-colors] |[
--  border-left-color: Borders; ]|
--
--  ## font-family: name;
--
--  The name of the font family or font name to use.
--
--  - Note: unlike the CSS2 Specification this does not support using a
--  prioritized list of font family names and/or generic family names.
--
--  |[ font-family: Sans, Cantarell; ]|
--
--  ## font-style: [normal|oblique|italic];
--
--  Selects between normal, italic and oblique faces within a font family.
--
--  |[ font-style: italic; ]|
--
--  ## font-variant: [normal|small-caps];
--
--  In a small-caps font the lower case letters look similar to the uppercase
--  ones, but in a smaller size and with slightly different proportions.
--
--  |[ font-variant: normal; ]|
--
--  ## font-weight:
--  [normal|bold|bolder|lighter|100|200|300|400|500|600|700|800|900];
--
--  Selects the weight of the font. The values '100' to '900' form an ordered
--  sequence, where each number indicates a weight that is at least as dark as
--  its predecessor. The keyword 'normal' is synonymous with '400', and 'bold'
--  is synonymous with '700'. Keywords other than 'normal' and 'bold' have been
--  shown to be often confused with font names and a numerical scale was
--  therefore chosen for the 9-value list. - Maps to PANGO_TYPE_WEIGHT |[
--  font-weight: bold; ]|
--
--  ## font-size: [absolute-size|relative-size|percentage];
--
--  - `absolute-size`: The size in normal size units like `px`, `pt`, and
--  `em`. Or symbolic sizes like `xx-small`, `x-small`, `small`, `medium`,
--  `large`, `x-large`, `xx-large`. - `relative-size`: `larger` or `smaller`
--  relative to the parent. - `percentage`: A percentage difference from the
--  nominal size. |[ font-size: 12px; ]|
--
--  ## font: [family] [style] [variant] [size];
--
--  A shorthand for setting a few font properties at once. - Supports any
--  format accepted by Pango.Font.From_String - Note: this is somewhat
--  different from the CSS2 Specification for this property. |[ font: Bold 11;
--  ]|
--
--  ## margin: [length|percentage]{1,4};
--
--  A shorthand for setting the margin space required on all sides of an
--  element. - Four values used to specify: top right bottom left - Three
--  values used to specify: top horizontal bottom - Two values used to specify:
--  vertical horizontal - One value used to specify: margin |[ margin: 1em 2em
--  4em; ]|
--
--  ## margin-top: [length|percentage];
--
--  Sets the margin space required on the top of an element. |[ margin-top:
--  10px; ]|
--
--  ## margin-right: [length|percentage];
--
--  Sets the margin space required on the right of an element. |[
--  margin-right: 0px; ]|
--
--  ## margin-bottom: [length|percentage];
--
--  Sets the margin space required on the bottom of an element. |[
--  margin-bottom: 10px; ]|
--
--  ## margin-left: [length|percentage];
--
--  Sets the margin space required on the left of an element. |[ margin-left:
--  1em; ]|
--
--  ## padding: [length|percentage]{1,4};
--
--  A shorthand for setting the padding space required on all sides of an
--  element. The padding area is the space between the content of the element
--  and its border. - Four values used to specify: top right bottom left -
--  Three values used to specify: top horizontal bottom - Two values used to
--  specify: vertical horizontal - One value used to specify: padding |[
--  padding: 1em 2em 4em; ]|
--
--  ## padding-top: [length|percentage];
--
--  Sets the padding space required on the top of an element. |[ padding-top:
--  10px; ]|
--
--  ## padding-right: [length|percentage];
--
--  Sets the padding space required on the right of an element. |[
--  padding-right: 0px; ]|
--
--  ## padding-bottom: [length|percentage];
--
--  Sets the padding space required on the bottom of an element. |[
--  padding-bottom: 10px; ]|
--
--  ## padding-left: [length|percentage];
--
--  Sets the padding space required on the left of an element. |[
--  padding-left: 1em; ]|
--
--  ## border-width: [width]{1,4};
--
--  A shorthand for setting the border width on all sides of an element. -
--  Four values used to specify: top right bottom left - Three values used to
--  specify: top vertical bottom - Two values used to specify: horizontal
--  vertical - One value used to specify: width |[ border-width: 1px 2px 4px;
--  ]|
--
--  ## border-top-width: [width];
--
--  Sets the border width required on the top of an element. |[ border-top:
--  10px; ]|
--
--  ## border-right-width: [width];
--
--  Sets the border width required on the right of an element. |[
--  border-right: 0px; ]|
--
--  ## border-bottom-width: [width];
--
--  Sets the border width required on the bottom of an element. |[
--  border-bottom: 10px; ]|
--
--  ## border-left-width: [width];
--
--  Sets the border width required on the left of an element. |[ border-left:
--  1em; ]|
--
--  ## border-radius: [length|percentage]{1,4};
--
--  Allows setting how rounded all border corners are. - Four values used to
--  specify: top-left top-right bottom-right bottom-left - Three values used to
--  specify: top-left top-right-and-bottom-left bottom-right - Two values used
--  to specify: top-left-and-bottom-right top-right-and-bottom-left - One value
--  used to specify: radius on all sides |[ border-radius: 8px ]|
--
--  ## border-style: [none|solid|inset|outset]{1,4};
--
--  A shorthand property for setting the line style for all four sides of the
--  elements border. - Four values used to specify: top right bottom left; -
--  Three values used to specify: top horizontal bottom - Two values used to
--  specify: vertical horizontal - One value used to specify: style |[
--  border-style: solid; ]|
--
--  ## border-image: [source] [slice] [ / width ] [repeat]; A shorthand for
--  setting an image on the borders of elements. See [Border
--  Images][border-images]. |[ border-image: url("/path/to/image.png") 3 4 4 3
--  repeat stretch; ]|
--
--  ## border-image-source: [none|url|linear-gradient]{1,4};
--
--  Defines the image to use instead of the style of the border. If this
--  property is set to none, the style defined by border-style is used instead.
--  |[ border-image-source: url("/path/to/image.png"); ]|
--
--  ## border-image-slice: [number|percentage]{1,4};
--
--  Divides the image specified by border-image-source in nine regions: the
--  four corners, the four edges and the middle. It does this by specifying 4
--  inwards offsets. - Four values used to specify: top right bottom left; -
--  Three values used to specify: top vertical bottom - Two values used to
--  specify: horizontal vertical - One value used to specify: slice |[
--  border-image-slice: 3 3 4 3; ]|
--
--  ## border-image-width: [length|percentage]{1,4};
--
--  Defines the offset to use for dividing the border image in nine parts, the
--  top-left corner, central top edge, top-right-corner, central right edge,
--  bottom-right corner, central bottom edge, bottom-left corner, and central
--  right edge. They represent inward distance from the top, right, bottom, and
--  left edges. - Four values used to specify: top right bottom left; - Three
--  values used to specify: top horizontal bottom - Two values used to specify:
--  vertical horizontal - One value used to specify: width |[
--  border-image-width: 4px 0 4px 0; ]|
--
--  ## border-image-repeat: [none|url|linear-gradient]{1,4};
--
--  Defines how the middle part of a border image is handled to match the size
--  of the border. It has a one-value syntax which describes the behavior for
--  all sides, and a two-value syntax that sets a different value for the
--  horizontal and vertical behavior. - Two values used to specify: horizontal
--  vertical - One value used to specify: repeat |[ border-image-repeat:
--  stretch; ]|
--
--  ## background-image: [none|url|linear-gradient], ... Sets one or several
--  background images for an element. The images are drawn on successive
--  stacking context layers, with the first specified being drawn as if it is
--  the closest to the user. The borders of the element are then drawn on top
--  of them, and the background-color is drawn beneath them. - There can be
--  several sources listed, separated by commas. |[ background-image:
--  gtk-gradient (linear, left top, right top, from (fff), to (000)); ]|
--
--  ## background-repeat: [repeat|no-repeat|space|round|repeat-x|repeat-y];
--
--  Defines how background images are repeated. A background image can be
--  repeated along the horizontal axis, the vertical axis, both, or not
--  repeated at all. - `repeat`: The image is repeated in the given direction
--  as much as needed to cover the whole background image painting area. The
--  last image may be clipped if the whole thing won't fit in the remaining
--  area. - `space`: The image is repeated in the given direction as much as
--  needed to cover most of the background image painting area, without
--  clipping an image. The remaining non-covered space is spaced out evenly
--  between the images. The first and last images touches the edge of the
--  element. The value of the background-position CSS property is ignored for
--  the concerned direction, except if one single image is greater than the
--  background image painting area, which is the only case where an image can
--  be clipped when the space value is used. - `round`: The image is repeated
--  in the given direction as much as needed to cover most of the background
--  image painting area, without clipping an image. If it doesn't cover exactly
--  the area, the tiles are resized in that direction in order to match it. -
--  `no-repeat`: The image is not repeated (and hence the background image
--  painting area will not necessarily been entirely covered). The position of
--  the non-repeated background image is defined by the background-position CSS
--  property. - Note if not specified, the style doesn't respect the CSS3
--  specification, since the background will be stretched to fill the area. |[
--  background-repeat: no-repeat; ]|
--
--  ## text-shadow: horizontal_offset vertical_offset [ blur_radius ] color;
--
--  A shadow list can be applied to text or symbolic icons, using the CSS3
--  text-shadow syntax, as defined in the [CSS3
--  Specification](http://www.w3.org/TR/css3-text/text-shadow).
--
--  - The offset of the shadow is specified with the `horizontal_offset` and
--  `vertical_offset` parameters. - The optional blur radius is parsed, but it
--  is currently not rendered by the GTK+ theming engine.
--
--  To set a shadow on an icon, use the `icon-shadow` property instead, with
--  the same syntax.
--
--  To set multiple shadows on an element, you can specify a comma-separated
--  list of shadow elements in the `text-shadow` or `icon-shadow` property.
--  Shadows are always rendered front to back (i.e. the first shadow specified
--  is on top of the others). Shadows can thus overlay each other, but they can
--  never overlay the text or icon itself, which is always rendered on top of
--  the shadow layer.
--
--  |[ text-shadow: text-shadow: 1 1 0 blue, -4 -4 red; ]|
--
--  ## box-shadow: [ inset ] horizontal_offset vertical_offset [ blur_radius ]
--  [ spread ] color;
--
--  Themes can apply shadows on framed elements using the CSS3 box-shadow
--  syntax, as defined in the [CSS3
--  Specification](http://www.w3.org/TR/css3-background/the-box-shadow).
--
--  - A positive offset will draw a shadow that is offset to the right (down)
--  of the box, - A negative offset to the left (top). - The optional spread
--  parameter defines an additional distance to expand the shadow shape in all
--  directions, by the specified radius. - The optional blur radius parameter
--  is parsed, but it is currently not rendered by the GTK+ theming engine. -
--  The inset parameter defines whether the drop shadow should be rendered
--  inside or outside the box canvas.
--
--  To set multiple box-shadows on an element, you can specify a
--  comma-separated list of shadow elements in the `box-shadow` property.
--  Shadows are always rendered front to back (i.e. the first shadow specified
--  is on top of the others) so they may overlap other boxes or other shadows.
--
--  |[ box-shadow: inset 0 1px 1px alpha(black, 0.1); ]|
--
--  ## transition: duration [s|ms] [linear|ease|ease-in|ease-out|ease-in-out]
--  [loop];
--
--  Styles can specify transitions that will be used to create a gradual
--  change in the appearance when a widget state changes. - The `duration` is
--  the amount of time that the animation will take for a complete cycle from
--  start to end. - If the loop option is given, the animation will be repated
--  until the state changes again. - The option after the duration determines
--  the transition function from a small set of predefined functions.
--
--  - Linear
--
--  ![](linear.png)
--
--  - Ease transition
--
--  ![](ease.png)
--
--  - Ease-in-out transition
--
--  ![](ease-in-out.png)
--
--  - Ease-in transition
--
--  ![](ease-in.png)
--
--  - Ease-out transition
--
--  ![](ease-out.png)
--
--  |[ transition: 150ms ease-in-out; ]|
--
--  ## gtk-key-bindings: binding1, binding2, ...;
--
--  Key binding set name list.
--
--  ## Other Properties
--
--  GtkThemingEngines can register their own, engine-specific style properties
--  with the function gtk_theming_engine_register_property. These properties
--  can be set in CSS like other properties, using a name of the form
--  `-namespace-name`, where namespace is typically the name of the theming
--  engine, and name is the name of the property. Style properties that have
--  been registered by widgets using Gtk.Widget.Install_Style_Property can also
--  be set in this way, using the widget class name for namespace.
--
--  An example for using engine-specific style properties: |[ * { engine:
--  clearlooks; border-radius: 4; -GtkPaned-handle-size: 6;
--  -clearlooks-colorize-scrollbar: false; } ]|
--
--  </description>
pragma Ada_2005;

pragma Warnings (Off, "*is already use-visible*");
with Glib;               use Glib;
with Glib.Error;         use Glib.Error;
with Glib.Object;        use Glib.Object;
with Glib.Types;         use Glib.Types;
with Glib.Values;        use Glib.Values;
with Gtk.Enums;          use Gtk.Enums;
with Gtk.Style_Provider; use Gtk.Style_Provider;
with Gtk.Widget;         use Gtk.Widget;

package Gtk.Css_Provider is

   type Gtk_Css_Provider_Record is new GObject_Record with null record;
   type Gtk_Css_Provider is access all Gtk_Css_Provider_Record'Class;

   ------------------
   -- Constructors --
   ------------------

   procedure Gtk_New (Self : out Gtk_Css_Provider);
   procedure Initialize
      (Self : not null access Gtk_Css_Provider_Record'Class);
   --  Returns a newly created Gtk.Css_Provider.Gtk_Css_Provider.

   function Gtk_Css_Provider_New return Gtk_Css_Provider;
   --  Returns a newly created Gtk.Css_Provider.Gtk_Css_Provider.

   function Get_Type return Glib.GType;
   pragma Import (C, Get_Type, "gtk_css_provider_get_type");

   -------------
   -- Methods --
   -------------

   function Load_From_Data
      (Self  : not null access Gtk_Css_Provider_Record;
       Data  : UTF8_String;
       Error : access Glib.Error.GError) return Boolean;
   --  Loads Data into Css_Provider, making it clear any previously loaded
   --  information.
   --  "data": CSS data loaded in memory

   function Load_From_Path
      (Self  : not null access Gtk_Css_Provider_Record;
       Path  : UTF8_String;
       Error : access Glib.Error.GError) return Boolean;
   --  Loads the data contained in Path into Css_Provider, making it clear any
   --  previously loaded information.
   --  "path": the path of a filename to load, in the GLib filename encoding

   function To_String
      (Self : not null access Gtk_Css_Provider_Record) return UTF8_String;
   --  Converts the Provider into a string representation in CSS format.
   --  Using Gtk.Css_Provider.Load_From_Data with the return value from this
   --  function on a new provider created with Gtk.Css_Provider.Gtk_New will
   --  basically create a duplicate of this Provider.
   --  Since: gtk+ 3.2

   ---------------------------------------------
   -- Inherited subprograms (from interfaces) --
   ---------------------------------------------

   procedure Get_Style_Property
      (Self  : not null access Gtk_Css_Provider_Record;
       Path  : Gtk.Widget.Gtk_Widget_Path;
       State : Gtk.Enums.Gtk_State_Flags;
       Pspec : in out Glib.Param_Spec;
       Value : out Glib.Values.GValue;
       Found : out Boolean);

   ---------------
   -- Functions --
   ---------------

   function Get_Default return Gtk_Css_Provider;
   --  Returns the provider containing the style settings used as a fallback
   --  for all widgets.

   function Get_Named
      (Name    : UTF8_String;
       Variant : UTF8_String := "") return Gtk_Css_Provider;
   --  Loads a theme from the usual theme paths
   --  "name": A theme name
   --  "variant": variant to load, for example, "dark", or null for the
   --  default

   -------------
   -- Signals --
   -------------

   Signal_Parsing_Error : constant Glib.Signal_Name := "parsing-error";
   --  Signals that a parsing error occured. the Path, Line and Position
   --  describe the actual location of the error as accurately as possible.
   --
   --  Parsing errors are never fatal, so the parsing will resume after the
   --  error. Errors may however cause parts of the given data or even all of
   --  it to not be parsed at all. So it is a useful idea to check that the
   --  parsing succeeds by connecting to this signal.
   --
   --  Note that this signal may be emitted at any time as the css provider
   --  may opt to defer parsing parts or all of the input to a later time than
   --  when a loading function was called.
   --    procedure Handler
   --       (Self    : access Gtk_Css_Provider_Record'Class;
   --        Section : Gtk.Css_Section.Gtk_Css_Section;
   --        Error   : GLib.Error)
   -- 
   --  Callback parameters:
   --    --  "section": section the error happened in
   --    --  "error": The parsing error

   ----------------
   -- Interfaces --
   ----------------
   --  This class implements several interfaces. See Glib.Types
   --
   --  - "StyleProvider"

   package Implements_Gtk_Style_Provider is new Glib.Types.Implements
     (Gtk.Style_Provider.Gtk_Style_Provider, Gtk_Css_Provider_Record, Gtk_Css_Provider);
   function "+"
     (Widget : access Gtk_Css_Provider_Record'Class)
   return Gtk.Style_Provider.Gtk_Style_Provider
   renames Implements_Gtk_Style_Provider.To_Interface;
   function "-"
     (Interf : Gtk.Style_Provider.Gtk_Style_Provider)
   return Gtk_Css_Provider
   renames Implements_Gtk_Style_Provider.To_Object;

end Gtk.Css_Provider;
