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

pragma Ada_05;
--  <description>
--  The Gtk.File_Chooser_Button.Gtk_File_Chooser_Button is a widget that lets
--  the user select a file. It implements the Gtk.File_Chooser.Gtk_File_Chooser
--  interface. Visually, it is a file name with a button to bring up a
--  Gtk.File_Chooser_Dialog.Gtk_File_Chooser_Dialog. The user can then use that
--  dialog to change the file associated with that button. This widget does not
--  support setting the Gtk.File_Chooser.Gtk_File_Chooser:select-multiple
--  property to True.
--
--  == Create a button to let the user select a file in /etc ==
--
--    {
--       GtkWidget *button;
--       button = gtk_file_chooser_button_new (_("Select a file"),
--          GTK_FILE_CHOOSER_ACTION_OPEN);
--       gtk_file_chooser_set_current_folder (GTK_FILE_CHOOSER (button),
--          "/etc");
--    }
--
--  The Gtk.File_Chooser_Button.Gtk_File_Chooser_Button supports the
--  Gtk.File_Chooser.Gtk_File_Chooser_Action<!-- -->s
--  Gtk.File_Chooser.Action_Open and Gtk.File_Chooser.Action_Select_Folder.
--
--  <important> The Gtk.File_Chooser_Button.Gtk_File_Chooser_Button will
--  ellipsize the label, and thus will thus request little horizontal space. To
--  give the button more space, you should call gtk_widget_get_preferred_size,
--  Gtk.File_Chooser_Button.Set_Width_Chars, or pack the button in such a way
--  that other interface elements give space to the widget. </important>
--  </description>
--  <group>Buttons and Toggles</group>

pragma Warnings (Off, "*is already use-visible*");
with Glib;             use Glib;
with Glib.Object;      use Glib.Object;
with Glib.Properties;  use Glib.Properties;
with Glib.Types;       use Glib.Types;
with Gtk.Box;          use Gtk.Box;
with Gtk.Buildable;    use Gtk.Buildable;
with Gtk.Enums;        use Gtk.Enums;
with Gtk.File_Chooser; use Gtk.File_Chooser;
with Gtk.File_Filter;  use Gtk.File_Filter;
with Gtk.Orientable;   use Gtk.Orientable;
with Gtk.Widget;       use Gtk.Widget;

package Gtk.File_Chooser_Button is

   type Gtk_File_Chooser_Button_Record is new Gtk_Box_Record with null record;
   type Gtk_File_Chooser_Button is access all Gtk_File_Chooser_Button_Record'Class;

   ------------------
   -- Constructors --
   ------------------

   procedure Gtk_New
      (Button : out Gtk_File_Chooser_Button;
       Title  : UTF8_String;
       Action : Gtk.File_Chooser.Gtk_File_Chooser_Action);
   procedure Initialize
      (Button : access Gtk_File_Chooser_Button_Record'Class;
       Title  : UTF8_String;
       Action : Gtk.File_Chooser.Gtk_File_Chooser_Action);
   --  Creates a new file-selecting button widget.
   --  Since: gtk+ 2.6
   --  "title": the title of the browse dialog.
   --  "action": the open mode for the widget.

   procedure Gtk_New_With_Dialog
      (Button : out Gtk_File_Chooser_Button;
       Dialog : access Gtk.Widget.Gtk_Widget_Record'Class);
   procedure Initialize_With_Dialog
      (Button : access Gtk_File_Chooser_Button_Record'Class;
       Dialog : access Gtk.Widget.Gtk_Widget_Record'Class);
   --  Creates a Gtk.File_Chooser_Button.Gtk_File_Chooser_Button widget which
   --  uses Dialog as its file-picking window.
   --  Note that Dialog must be a Gtk.Dialog.Gtk_Dialog (or subclass) which
   --  implements the Gtk.File_Chooser.Gtk_File_Chooser interface and must not
   --  have GTK_DIALOG_DESTROY_WITH_PARENT set.
   --  Also note that the dialog needs to have its confirmative button added
   --  with response GTK_RESPONSE_ACCEPT or GTK_RESPONSE_OK in order for the
   --  button to take over the file selected in the dialog.
   --  Since: gtk+ 2.6
   --  "dialog": the widget to use as dialog

   function Get_Type return Glib.GType;
   pragma Import (C, Get_Type, "gtk_file_chooser_button_get_type");

   -------------
   -- Methods --
   -------------

   function Get_Focus_On_Click
      (Button : access Gtk_File_Chooser_Button_Record) return Boolean;
   procedure Set_Focus_On_Click
      (Button         : access Gtk_File_Chooser_Button_Record;
       Focus_On_Click : Boolean);
   --  Sets whether the button will grab focus when it is clicked with the
   --  mouse. Making mouse clicks not grab focus is useful in places like
   --  toolbars where you don't want the keyboard focus removed from the main
   --  area of the application.
   --  Since: gtk+ 2.10
   --  "focus_on_click": whether the button grabs focus when clicked with the
   --  mouse

   function Get_Title
      (Button : access Gtk_File_Chooser_Button_Record) return UTF8_String;
   procedure Set_Title
      (Button : access Gtk_File_Chooser_Button_Record;
       Title  : UTF8_String);
   --  Modifies the Title of the browse dialog used by Button.
   --  Since: gtk+ 2.6
   --  "title": the new browse dialog title.

   function Get_Width_Chars
      (Button : access Gtk_File_Chooser_Button_Record) return Gint;
   procedure Set_Width_Chars
      (Button  : access Gtk_File_Chooser_Button_Record;
       N_Chars : Gint);
   --  Sets the width (in characters) that Button will use to N_Chars.
   --  Since: gtk+ 2.6
   --  "n_chars": the new width, in characters.

   ---------------------------------------------
   -- Inherited subprograms (from interfaces) --
   ---------------------------------------------

   procedure Add_Filter
      (Chooser : access Gtk_File_Chooser_Button_Record;
       Filter  : access Gtk.File_Filter.Gtk_File_Filter_Record'Class);

   function Add_Shortcut_Folder
      (Chooser : access Gtk_File_Chooser_Button_Record;
       Folder  : UTF8_String) return Boolean;

   function Add_Shortcut_Folder_Uri
      (Chooser : access Gtk_File_Chooser_Button_Record;
       Uri     : UTF8_String) return Boolean;

   function Get_Action
      (Chooser : access Gtk_File_Chooser_Button_Record)
       return Gtk.File_Chooser.Gtk_File_Chooser_Action;
   procedure Set_Action
      (Chooser : access Gtk_File_Chooser_Button_Record;
       Action  : Gtk.File_Chooser.Gtk_File_Chooser_Action);

   function Get_Create_Folders
      (Chooser : access Gtk_File_Chooser_Button_Record) return Boolean;
   procedure Set_Create_Folders
      (Chooser        : access Gtk_File_Chooser_Button_Record;
       Create_Folders : Boolean);

   function Get_Current_Folder
      (Chooser : access Gtk_File_Chooser_Button_Record) return UTF8_String;
   function Set_Current_Folder
      (Chooser  : access Gtk_File_Chooser_Button_Record;
       Filename : UTF8_String) return Boolean;

   function Get_Current_Folder_Uri
      (Chooser : access Gtk_File_Chooser_Button_Record) return UTF8_String;
   function Set_Current_Folder_Uri
      (Chooser : access Gtk_File_Chooser_Button_Record;
       Uri     : UTF8_String) return Boolean;

   function Get_Do_Overwrite_Confirmation
      (Chooser : access Gtk_File_Chooser_Button_Record) return Boolean;
   procedure Set_Do_Overwrite_Confirmation
      (Chooser                   : access Gtk_File_Chooser_Button_Record;
       Do_Overwrite_Confirmation : Boolean);

   function Get_Extra_Widget
      (Chooser : access Gtk_File_Chooser_Button_Record)
       return Gtk.Widget.Gtk_Widget;
   procedure Set_Extra_Widget
      (Chooser      : access Gtk_File_Chooser_Button_Record;
       Extra_Widget : access Gtk.Widget.Gtk_Widget_Record'Class);

   function Get_Filename
      (Chooser : access Gtk_File_Chooser_Button_Record) return UTF8_String;
   function Set_Filename
      (Chooser  : access Gtk_File_Chooser_Button_Record;
       Filename : UTF8_String) return Boolean;

   function Get_Filenames
      (Chooser : access Gtk_File_Chooser_Button_Record)
       return Gtk.Enums.String_SList.GSlist;

   function Get_Filter
      (Chooser : access Gtk_File_Chooser_Button_Record)
       return Gtk.File_Filter.Gtk_File_Filter;
   procedure Set_Filter
      (Chooser : access Gtk_File_Chooser_Button_Record;
       Filter  : access Gtk.File_Filter.Gtk_File_Filter_Record'Class);

   function Get_Local_Only
      (Chooser : access Gtk_File_Chooser_Button_Record) return Boolean;
   procedure Set_Local_Only
      (Chooser    : access Gtk_File_Chooser_Button_Record;
       Local_Only : Boolean);

   function Get_Preview_Filename
      (Chooser : access Gtk_File_Chooser_Button_Record) return UTF8_String;

   function Get_Preview_Uri
      (Chooser : access Gtk_File_Chooser_Button_Record) return UTF8_String;

   function Get_Preview_Widget
      (Chooser : access Gtk_File_Chooser_Button_Record)
       return Gtk.Widget.Gtk_Widget;
   procedure Set_Preview_Widget
      (Chooser        : access Gtk_File_Chooser_Button_Record;
       Preview_Widget : access Gtk.Widget.Gtk_Widget_Record'Class);

   function Get_Preview_Widget_Active
      (Chooser : access Gtk_File_Chooser_Button_Record) return Boolean;
   procedure Set_Preview_Widget_Active
      (Chooser : access Gtk_File_Chooser_Button_Record;
       Active  : Boolean);

   function Get_Select_Multiple
      (Chooser : access Gtk_File_Chooser_Button_Record) return Boolean;
   procedure Set_Select_Multiple
      (Chooser         : access Gtk_File_Chooser_Button_Record;
       Select_Multiple : Boolean);

   function Get_Show_Hidden
      (Chooser : access Gtk_File_Chooser_Button_Record) return Boolean;
   procedure Set_Show_Hidden
      (Chooser     : access Gtk_File_Chooser_Button_Record;
       Show_Hidden : Boolean);

   function Get_Uri
      (Chooser : access Gtk_File_Chooser_Button_Record) return UTF8_String;
   function Set_Uri
      (Chooser : access Gtk_File_Chooser_Button_Record;
       Uri     : UTF8_String) return Boolean;

   function Get_Uris
      (Chooser : access Gtk_File_Chooser_Button_Record)
       return Gtk.Enums.String_SList.GSlist;

   function Get_Use_Preview_Label
      (Chooser : access Gtk_File_Chooser_Button_Record) return Boolean;
   procedure Set_Use_Preview_Label
      (Chooser   : access Gtk_File_Chooser_Button_Record;
       Use_Label : Boolean);

   function List_Filters
      (Chooser : access Gtk_File_Chooser_Button_Record)
       return Glib.Object.Object_List.GSList;

   function List_Shortcut_Folder_Uris
      (Chooser : access Gtk_File_Chooser_Button_Record)
       return Gtk.Enums.String_SList.GSlist;

   function List_Shortcut_Folders
      (Chooser : access Gtk_File_Chooser_Button_Record)
       return Gtk.Enums.String_SList.GSlist;

   procedure Remove_Filter
      (Chooser : access Gtk_File_Chooser_Button_Record;
       Filter  : access Gtk.File_Filter.Gtk_File_Filter_Record'Class);

   function Remove_Shortcut_Folder
      (Chooser : access Gtk_File_Chooser_Button_Record;
       Folder  : UTF8_String) return Boolean;

   function Remove_Shortcut_Folder_Uri
      (Chooser : access Gtk_File_Chooser_Button_Record;
       Uri     : UTF8_String) return Boolean;

   procedure Select_All (Chooser : access Gtk_File_Chooser_Button_Record);

   function Select_Filename
      (Chooser  : access Gtk_File_Chooser_Button_Record;
       Filename : UTF8_String) return Boolean;

   function Select_Uri
      (Chooser : access Gtk_File_Chooser_Button_Record;
       Uri     : UTF8_String) return Boolean;

   procedure Set_Current_Name
      (Chooser : access Gtk_File_Chooser_Button_Record;
       Name    : UTF8_String);

   procedure Unselect_All (Chooser : access Gtk_File_Chooser_Button_Record);

   procedure Unselect_Filename
      (Chooser  : access Gtk_File_Chooser_Button_Record;
       Filename : UTF8_String);

   procedure Unselect_Uri
      (Chooser : access Gtk_File_Chooser_Button_Record;
       Uri     : UTF8_String);

   function Get_Orientation
      (Self : access Gtk_File_Chooser_Button_Record)
       return Gtk.Enums.Gtk_Orientation;
   procedure Set_Orientation
      (Self        : access Gtk_File_Chooser_Button_Record;
       Orientation : Gtk.Enums.Gtk_Orientation);

   ----------------
   -- Interfaces --
   ----------------
   --  This class implements several interfaces. See Glib.Types
   --
   --  - "Buildable"
   --
   --  - "FileChooser"
   --
   --  - "Orientable"

   package Implements_Buildable is new Glib.Types.Implements
     (Gtk.Buildable.Gtk_Buildable, Gtk_File_Chooser_Button_Record, Gtk_File_Chooser_Button);
   function "+"
     (Widget : access Gtk_File_Chooser_Button_Record'Class)
   return Gtk.Buildable.Gtk_Buildable
   renames Implements_Buildable.To_Interface;
   function "-"
     (Interf : Gtk.Buildable.Gtk_Buildable)
   return Gtk_File_Chooser_Button
   renames Implements_Buildable.To_Object;

   package Implements_FileChooser is new Glib.Types.Implements
     (Gtk.File_Chooser.Gtk_File_Chooser, Gtk_File_Chooser_Button_Record, Gtk_File_Chooser_Button);
   function "+"
     (Widget : access Gtk_File_Chooser_Button_Record'Class)
   return Gtk.File_Chooser.Gtk_File_Chooser
   renames Implements_FileChooser.To_Interface;
   function "-"
     (Interf : Gtk.File_Chooser.Gtk_File_Chooser)
   return Gtk_File_Chooser_Button
   renames Implements_FileChooser.To_Object;

   package Implements_Orientable is new Glib.Types.Implements
     (Gtk.Orientable.Gtk_Orientable, Gtk_File_Chooser_Button_Record, Gtk_File_Chooser_Button);
   function "+"
     (Widget : access Gtk_File_Chooser_Button_Record'Class)
   return Gtk.Orientable.Gtk_Orientable
   renames Implements_Orientable.To_Interface;
   function "-"
     (Interf : Gtk.Orientable.Gtk_Orientable)
   return Gtk_File_Chooser_Button
   renames Implements_Orientable.To_Object;

   ----------------
   -- Properties --
   ----------------
   --  The following properties are defined for this widget. See
   --  Glib.Properties for more information on properties)
   --
   --  Name: Focus_On_Click_Property
   --  Type: Boolean
   --  Flags: read-write
   --  Whether the Gtk.File_Chooser_Button.Gtk_File_Chooser_Button button
   --  grabs focus when it is clicked with the mouse.
   --
   --  Name: Title_Property
   --  Type: UTF8_String
   --  Flags: read-write
   --  Title to put on the Gtk.File_Chooser_Dialog.Gtk_File_Chooser_Dialog
   --  associated with the button.
   --
   --  Name: Width_Chars_Property
   --  Type: Gint
   --  Flags: read-write
   --  The width of the entry and label inside the button, in characters.

   Focus_On_Click_Property : constant Glib.Properties.Property_Boolean;
   Title_Property : constant Glib.Properties.Property_String;
   Width_Chars_Property : constant Glib.Properties.Property_Int;

   -------------
   -- Signals --
   -------------
   --  The following new signals are defined for this widget:
   --
   --  "file-set"
   --     procedure Handler
   --       (Self : access Gtk_File_Chooser_Button_Record'Class);
   --  The ::file-set signal is emitted when the user selects a file.
   --  Note that this signal is only emitted when the <emphasis>user</emphasis>
   --  changes the file.

   Signal_File_Set : constant Glib.Signal_Name := "file-set";

private
   Focus_On_Click_Property : constant Glib.Properties.Property_Boolean :=
     Glib.Properties.Build ("focus-on-click");
   Title_Property : constant Glib.Properties.Property_String :=
     Glib.Properties.Build ("title");
   Width_Chars_Property : constant Glib.Properties.Property_Int :=
     Glib.Properties.Build ("width-chars");
end Gtk.File_Chooser_Button;