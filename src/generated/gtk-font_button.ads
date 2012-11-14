------------------------------------------------------------------------------
--                                                                          --
--      Copyright (C) 1998-2000 E. Briot, J. Brobecker and A. Charlet       --
--                     Copyright (C) 2000-2012, AdaCore                     --
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
--  The Gtk.Font_Button.Gtk_Font_Button is a button which displays the
--  currently selected font an allows to open a font chooser dialog to change
--  the font. It is suitable widget for selecting a font in a preference
--  dialog.
--
--  </description>

pragma Warnings (Off, "*is already use-visible*");
with Glib;              use Glib;
with Glib.Properties;   use Glib.Properties;
with Glib.Types;        use Glib.Types;
with Gtk.Action;        use Gtk.Action;
with Gtk.Activatable;   use Gtk.Activatable;
with Gtk.Buildable;     use Gtk.Buildable;
with Gtk.Button;        use Gtk.Button;
with Gtk.Font_Chooser;  use Gtk.Font_Chooser;
with Pango.Font;        use Pango.Font;
with Pango.Font_Face;   use Pango.Font_Face;
with Pango.Font_Family; use Pango.Font_Family;

package Gtk.Font_Button is

   type Gtk_Font_Button_Record is new Gtk_Button_Record with null record;
   type Gtk_Font_Button is access all Gtk_Font_Button_Record'Class;

   type Gtk_Font_Filter_Func is access function
     (Family : not null access Pango.Font_Family.Pango_Font_Family_Record'Class;
      Face   : not null access Pango.Font_Face.Pango_Font_Face_Record'Class)
   return Boolean;
   --  The type of function that is used for deciding what fonts get shown in
   --  a Gtk.Font_Chooser.Gtk_Font_Chooser. See
   --  Gtk.Font_Chooser.Set_Filter_Func.
   --  "family": a Pango.Font_Family.Pango_Font_Family
   --  "face": a Pango.Font_Face.Pango_Font_Face belonging to Family

   ------------------
   -- Constructors --
   ------------------

   procedure Gtk_New (Font_Button : out Gtk_Font_Button);
   procedure Initialize
      (Font_Button : not null access Gtk_Font_Button_Record'Class);
   --  Creates a new font picker widget.
   --  Since: gtk+ 2.4

   procedure Gtk_New_With_Font
      (Font_Button : out Gtk_Font_Button;
       Fontname    : UTF8_String);
   procedure Initialize_With_Font
      (Font_Button : not null access Gtk_Font_Button_Record'Class;
       Fontname    : UTF8_String);
   --  Creates a new font picker widget.
   --  Since: gtk+ 2.4
   --  "fontname": Name of font to display in font chooser dialog

   function Get_Type return Glib.GType;
   pragma Import (C, Get_Type, "gtk_font_button_get_type");

   -------------
   -- Methods --
   -------------

   function Get_Font_Name
      (Font_Button : not null access Gtk_Font_Button_Record)
       return UTF8_String;
   --  Retrieves the name of the currently selected font. This name includes
   --  style and size information as well. If you want to render something with
   --  the font, use this string with Pango.Font.From_String . If you're
   --  interested in peeking certain values (family name, style, size, weight)
   --  just query these properties from the Pango.Font.Pango_Font_Description
   --  object.
   --  Since: gtk+ 2.4

   function Set_Font_Name
      (Font_Button : not null access Gtk_Font_Button_Record;
       Fontname    : UTF8_String) return Boolean;
   --  Sets or updates the currently-displayed font in font picker dialog.
   --  Since: gtk+ 2.4
   --  "fontname": Name of font to display in font chooser dialog

   function Get_Show_Size
      (Font_Button : not null access Gtk_Font_Button_Record) return Boolean;
   --  Returns whether the font size will be shown in the label.
   --  Since: gtk+ 2.4

   procedure Set_Show_Size
      (Font_Button : not null access Gtk_Font_Button_Record;
       Show_Size   : Boolean);
   --  If Show_Size is True, the font size will be displayed along with the
   --  name of the selected font.
   --  Since: gtk+ 2.4
   --  "show_size": True if font size should be displayed in dialog.

   function Get_Show_Style
      (Font_Button : not null access Gtk_Font_Button_Record) return Boolean;
   --  Returns whether the name of the font style will be shown in the label.
   --  Since: gtk+ 2.4

   procedure Set_Show_Style
      (Font_Button : not null access Gtk_Font_Button_Record;
       Show_Style  : Boolean);
   --  If Show_Style is True, the font style will be displayed along with name
   --  of the selected font.
   --  Since: gtk+ 2.4
   --  "show_style": True if font style should be displayed in label.

   function Get_Title
      (Font_Button : not null access Gtk_Font_Button_Record)
       return UTF8_String;
   --  Retrieves the title of the font chooser dialog.
   --  Since: gtk+ 2.4

   procedure Set_Title
      (Font_Button : not null access Gtk_Font_Button_Record;
       Title       : UTF8_String);
   --  Sets the title for the font chooser dialog.
   --  Since: gtk+ 2.4
   --  "title": a string containing the font chooser dialog title

   function Get_Use_Font
      (Font_Button : not null access Gtk_Font_Button_Record) return Boolean;
   --  Returns whether the selected font is used in the label.
   --  Since: gtk+ 2.4

   procedure Set_Use_Font
      (Font_Button : not null access Gtk_Font_Button_Record;
       Use_Font    : Boolean);
   --  If Use_Font is True, the font name will be written using the selected
   --  font.
   --  Since: gtk+ 2.4
   --  "use_font": If True, font name will be written using font chosen.

   function Get_Use_Size
      (Font_Button : not null access Gtk_Font_Button_Record) return Boolean;
   --  Returns whether the selected size is used in the label.
   --  Since: gtk+ 2.4

   procedure Set_Use_Size
      (Font_Button : not null access Gtk_Font_Button_Record;
       Use_Size    : Boolean);
   --  If Use_Size is True, the font name will be written using the selected
   --  size.
   --  Since: gtk+ 2.4
   --  "use_size": If True, font name will be written using the selected size.

   procedure Set_Filter_Func
      (Self   : not null access Gtk_Font_Button_Record;
       Filter : Gtk_Font_Filter_Func);
   --  Adds a filter function that decides which fonts to display in the font
   --  chooser.
   --  Since: gtk+ 3.2
   --  "filter": a Gtk_Font_Filter_Func, or null

   generic
      type User_Data_Type (<>) is private;
      with procedure Destroy (Data : in out User_Data_Type) is null;
   package Set_Filter_Func_User_Data is

      type Gtk_Font_Filter_Func is access function
        (Family : not null access Pango.Font_Family.Pango_Font_Family_Record'Class;
         Face   : not null access Pango.Font_Face.Pango_Font_Face_Record'Class;
         Data   : User_Data_Type) return Boolean;
      --  The type of function that is used for deciding what fonts get shown in
      --  a Gtk.Font_Chooser.Gtk_Font_Chooser. See
      --  Gtk.Font_Chooser.Set_Filter_Func.
      --  "family": a Pango.Font_Family.Pango_Font_Family
      --  "face": a Pango.Font_Face.Pango_Font_Face belonging to Family
      --  "data": user data passed to Gtk.Font_Chooser.Set_Filter_Func

      procedure Set_Filter_Func
         (Self      : not null access Gtk.Font_Button.Gtk_Font_Button_Record'Class;
          Filter    : Gtk_Font_Filter_Func;
          User_Data : User_Data_Type);
      --  Adds a filter function that decides which fonts to display in the
      --  font chooser.
      --  Since: gtk+ 3.2
      --  "filter": a Gtk_Font_Filter_Func, or null
      --  "user_data": data to pass to Filter

   end Set_Filter_Func_User_Data;

   ---------------------------------------------
   -- Inherited subprograms (from interfaces) --
   ---------------------------------------------
   --  Methods inherited from the Buildable interface are not duplicated here
   --  since they are meant to be used by tools, mostly. If you need to call
   --  them, use an explicit cast through the "-" operator below.

   procedure Do_Set_Related_Action
      (Self   : not null access Gtk_Font_Button_Record;
       Action : not null access Gtk.Action.Gtk_Action_Record'Class);

   function Get_Related_Action
      (Self : not null access Gtk_Font_Button_Record)
       return Gtk.Action.Gtk_Action;

   procedure Set_Related_Action
      (Self   : not null access Gtk_Font_Button_Record;
       Action : not null access Gtk.Action.Gtk_Action_Record'Class);

   function Get_Use_Action_Appearance
      (Self : not null access Gtk_Font_Button_Record) return Boolean;

   procedure Set_Use_Action_Appearance
      (Self           : not null access Gtk_Font_Button_Record;
       Use_Appearance : Boolean);

   procedure Sync_Action_Properties
      (Self   : not null access Gtk_Font_Button_Record;
       Action : access Gtk.Action.Gtk_Action_Record'Class);

   function Get_Font
      (Self : not null access Gtk_Font_Button_Record) return UTF8_String;

   procedure Set_Font
      (Self     : not null access Gtk_Font_Button_Record;
       Fontname : UTF8_String);

   function Get_Font_Desc
      (Self : not null access Gtk_Font_Button_Record)
       return Pango.Font.Pango_Font_Description;

   procedure Set_Font_Desc
      (Self      : not null access Gtk_Font_Button_Record;
       Font_Desc : Pango.Font.Pango_Font_Description);

   function Get_Font_Face
      (Self : not null access Gtk_Font_Button_Record)
       return Pango.Font_Face.Pango_Font_Face;

   function Get_Font_Family
      (Self : not null access Gtk_Font_Button_Record)
       return Pango.Font_Family.Pango_Font_Family;

   function Get_Font_Size
      (Self : not null access Gtk_Font_Button_Record) return Gint;

   function Get_Preview_Text
      (Self : not null access Gtk_Font_Button_Record) return UTF8_String;

   procedure Set_Preview_Text
      (Self : not null access Gtk_Font_Button_Record;
       Text : UTF8_String);

   function Get_Show_Preview_Entry
      (Self : not null access Gtk_Font_Button_Record) return Boolean;

   procedure Set_Show_Preview_Entry
      (Self               : not null access Gtk_Font_Button_Record;
       Show_Preview_Entry : Boolean);

   ----------------
   -- Interfaces --
   ----------------
   --  This class implements several interfaces. See Glib.Types
   --
   --  - "Activatable"
   --
   --  - "Buildable"
   --
   --  - "FontChooser"

   package Implements_Gtk_Activatable is new Glib.Types.Implements
     (Gtk.Activatable.Gtk_Activatable, Gtk_Font_Button_Record, Gtk_Font_Button);
   function "+"
     (Widget : access Gtk_Font_Button_Record'Class)
   return Gtk.Activatable.Gtk_Activatable
   renames Implements_Gtk_Activatable.To_Interface;
   function "-"
     (Interf : Gtk.Activatable.Gtk_Activatable)
   return Gtk_Font_Button
   renames Implements_Gtk_Activatable.To_Object;

   package Implements_Gtk_Buildable is new Glib.Types.Implements
     (Gtk.Buildable.Gtk_Buildable, Gtk_Font_Button_Record, Gtk_Font_Button);
   function "+"
     (Widget : access Gtk_Font_Button_Record'Class)
   return Gtk.Buildable.Gtk_Buildable
   renames Implements_Gtk_Buildable.To_Interface;
   function "-"
     (Interf : Gtk.Buildable.Gtk_Buildable)
   return Gtk_Font_Button
   renames Implements_Gtk_Buildable.To_Object;

   package Implements_Gtk_Font_Chooser is new Glib.Types.Implements
     (Gtk.Font_Chooser.Gtk_Font_Chooser, Gtk_Font_Button_Record, Gtk_Font_Button);
   function "+"
     (Widget : access Gtk_Font_Button_Record'Class)
   return Gtk.Font_Chooser.Gtk_Font_Chooser
   renames Implements_Gtk_Font_Chooser.To_Interface;
   function "-"
     (Interf : Gtk.Font_Chooser.Gtk_Font_Chooser)
   return Gtk_Font_Button
   renames Implements_Gtk_Font_Chooser.To_Object;

   ----------------
   -- Properties --
   ----------------
   --  The following properties are defined for this widget. See
   --  Glib.Properties for more information on properties)
   --
   --  Name: Font_Name_Property
   --  Type: UTF8_String
   --  Flags: read-write
   --  The name of the currently selected font.
   --
   --  Name: Show_Size_Property
   --  Type: Boolean
   --  Flags: read-write
   --  If this property is set to True, the selected font size will be shown
   --  in the label. For a more WYSIWYG way to show the selected size, see the
   --  ::use-size property.
   --
   --  Name: Show_Style_Property
   --  Type: Boolean
   --  Flags: read-write
   --  If this property is set to True, the name of the selected font style
   --  will be shown in the label. For a more WYSIWYG way to show the selected
   --  style, see the ::use-font property.
   --
   --  Name: Title_Property
   --  Type: UTF8_String
   --  Flags: read-write
   --  The title of the font chooser dialog.
   --
   --  Name: Use_Font_Property
   --  Type: Boolean
   --  Flags: read-write
   --  If this property is set to True, the label will be drawn in the
   --  selected font.
   --
   --  Name: Use_Size_Property
   --  Type: Boolean
   --  Flags: read-write
   --  If this property is set to True, the label will be drawn with the
   --  selected font size.

   Font_Name_Property : constant Glib.Properties.Property_String;
   Show_Size_Property : constant Glib.Properties.Property_Boolean;
   Show_Style_Property : constant Glib.Properties.Property_Boolean;
   Title_Property : constant Glib.Properties.Property_String;
   Use_Font_Property : constant Glib.Properties.Property_Boolean;
   Use_Size_Property : constant Glib.Properties.Property_Boolean;

   -------------
   -- Signals --
   -------------
   --  The following new signals are defined for this widget:
   --
   --  "font-set"
   --     procedure Handler (Self : access Gtk_Font_Button_Record'Class);
   --  The ::font-set signal is emitted when the user selects a font. When
   --  handling this signal, use Gtk.Font_Button.Get_Font_Name to find out
   --  which font was just selected.
   --
   --  Note that this signal is only emitted when the *user* changes the font.
   --  If you need to react to programmatic font changes as well, use the
   --  notify::font-name signal.

   Signal_Font_Set : constant Glib.Signal_Name := "font-set";

private
   Use_Size_Property : constant Glib.Properties.Property_Boolean :=
     Glib.Properties.Build ("use-size");
   Use_Font_Property : constant Glib.Properties.Property_Boolean :=
     Glib.Properties.Build ("use-font");
   Title_Property : constant Glib.Properties.Property_String :=
     Glib.Properties.Build ("title");
   Show_Style_Property : constant Glib.Properties.Property_Boolean :=
     Glib.Properties.Build ("show-style");
   Show_Size_Property : constant Glib.Properties.Property_Boolean :=
     Glib.Properties.Build ("show-size");
   Font_Name_Property : constant Glib.Properties.Property_String :=
     Glib.Properties.Build ("font-name");
end Gtk.Font_Button;
