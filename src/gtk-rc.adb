-----------------------------------------------------------------------
--               GtkAda - Ada95 binding for Gtk+/Gnome               --
--                                                                   --
--   Copyright (C) 1998-2000 E. Briot, J. Brobecker and A. Charlet   --
--                Copyright (C) 2000-2002 ACT-Europe                 --
--                                                                   --
-- This library is free software; you can redistribute it and/or     --
-- modify it under the terms of the GNU General Public               --
-- License as published by the Free Software Foundation; either      --
-- version 2 of the License, or (at your option) any later version.  --
--                                                                   --
-- This library is distributed in the hope that it will be useful,   --
-- but WITHOUT ANY WARRANTY; without even the implied warranty of    --
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU --
-- General Public License for more details.                          --
--                                                                   --
-- You should have received a copy of the GNU General Public         --
-- License along with this library; if not, write to the             --
-- Free Software Foundation, Inc., 59 Temple Place - Suite 330,      --
-- Boston, MA 02111-1307, USA.                                       --
--                                                                   --
-- As a special exception, if other files instantiate generics from  --
-- this unit, or you link this unit with other files to produce an   --
-- executable, this  unit  does not  by itself cause  the resulting  --
-- executable to be covered by the GNU General Public License. This  --
-- exception does not however invalidate any other reasons why the   --
-- executable file  might be covered by the  GNU Public License.     --
-----------------------------------------------------------------------

with System;
with Interfaces.C; use Interfaces.C;
with Interfaces.C.Strings;
with Gtk.Widget; use Gtk.Widget;

package body Gtk.Rc is

   -------------
   -- Gtk_New --
   -------------

   procedure Gtk_New (Rc_Style : out Gtk_Rc_Style) is
   begin
      Rc_Style := new Gtk_Rc_Style_Record;
      Gtk.Rc.Initialize (Rc_Style);
   end Gtk_New;

   ----------------
   -- Initialize --
   ----------------

   procedure Initialize (Rc_Style : access Gtk_Rc_Style_Record'Class) is
      function Internal return System.Address;
      pragma Import (C, Internal, "gtk_rc_style_new");

   begin
      Set_Object (Rc_Style, Internal);
   end Initialize;

   ----------
   -- Copy --
   ----------

   function Copy (Orig : access Gtk_Rc_Style_Record) return Gtk_Rc_Style is
      function Internal (Orig : System.Address) return System.Address;
      pragma Import (C, Internal, "gtk_rc_style_copy");

      Stub : Gtk_Rc_Style_Record;
   begin
      return Gtk_Rc_Style (Get_User_Data (Internal (Get_Object (Orig)), Stub));
   end Copy;

   ----------------------
   -- Add_Default_File --
   ----------------------

   procedure Add_Default_File (Filename : String) is
      procedure Internal (Filename : String);
      pragma Import (C, Internal, "gtk_rc_add_default_file");

   begin
      Internal (Filename & ASCII.NUL);
   end Add_Default_File;

   -----------------------
   -- Set_Default_Files --
   -----------------------

   procedure Set_Default_Files (Filenames : Chars_Ptr_Array) is
      procedure Internal (Filenames : Chars_Ptr_Array);
      pragma Import (C, Internal, "gtk_rc_set_default_files");

   begin
      Internal (Filenames + Null_Ptr);
   end Set_Default_Files;

   -----------------------
   -- Get_Default_Files --
   -----------------------

   function Get_Default_Files return Chars_Ptr_Array is
      type Flat_Chars_Ptr_Array is array (Positive) of Chars_Ptr;
      type Flat_Access is access all Flat_Chars_Ptr_Array;

      function Internal return Flat_Access;
      pragma Import (C, Internal, "gtk_rc_get_default_files");

      Addr : constant Flat_Access := Internal;
      Len  : Positive;

      use type Strings.chars_ptr;

   begin
      Len := 1;

      loop
         exit when Addr (Len) = Null_Ptr;
         Len := Len + 1;
      end loop;

      declare
         Result : Chars_Ptr_Array (1 .. size_t (Len) - 1);
      begin
         for J in Result'Range loop
            Result (J) := Addr (Positive (J));
         end loop;

         return Result;
      end;
   end Get_Default_Files;

   ---------------
   -- Get_Style --
   ---------------

   function Get_Style
     (Widget : access Gtk.Widget.Gtk_Widget_Record'Class) return Gtk_Style
   is
      function Internal (Widget : System.Address) return Gtk_Style;
      pragma Import (C, Internal, "gtk_rc_get_style");

   begin
      return Internal (Get_Object (Widget));
   end Get_Style;

   ------------------------
   -- Get_Style_By_Paths --
   ------------------------

   --  function Get_Style_By_Paths
   --    (Settings    : access Gtk_Settings_Record'Class;
   --     Widget_Path : String := "";
   --     Class_Path  : String := "";
   --     The_Type    : Glib.GType := Glib.GType_None) return Gtk_Style
   --  is
   --     function Internal
   --       (Settings    : System.Address;
   --        Widget_Path : System.Address;
   --        Class_Path  : System.Address;
   --        The_Type    : Glib.GType) return Gtk_Style;
   --     pragma Import (C, Internal, "gtk_rc_get_style_by_paths");

   --     W, C : System.Address := System.Null_Address;

   --  begin
   --     if Widget_Path /= "" then
   --        W := Widget_Path'Address;
   --     end if;

   --     if Clast_Path /= "" then
   --        C := Class_Path'Address;
   --     end if;

   --     return Internal (Get_Object (Settings, W, C, The_Type));
   --  end Get_Style_By_Paths;

   ------------------------------
   -- Reparse_All_For_Settings --
   ------------------------------

   --  function Reparse_All_For_Settings
   --    (Settings   : access Gtk_Settings_Record'Class;
   --     Force_Load : Boolean) return Boolean
   --  is
   --     function Internal
   --       (Settings   : System.Address;
   --        Force_Load : Gboolean) return Gboolean;
   --     pragma Import (C, Internal, "gtk_rc_reparse_all_for_settings");

   --  begin
   --     return To_Boolean (Internal
   --       (Get_Object (Settings), To_Gboolean (Force_Load));
   --  end Reparse_All_For_Settings;

   -------------------------
   -- Find_Pixmap_In_Path --
   -------------------------

   --  function Find_Pixmap_In_Path
   --    (Settings    : access Gtk_Settings_Record'Class;
   --     Pixmap_File : String) return String
   --  is
   --     function Internal
   --       (Settings    : System.Address;
   --        Scanner     : System.Address := System.Null_Address;
   --        Pixmap_File : String) return Chars_Ptr;
   --     pragma Import (C, Internal, "gtk_rc_find_pixmap_in_path");

   --     S : Chars_Ptr := Internal
   --       (Get_Object (Settings), Pixmap_File => Pixmap_File & ASCII.NUL);

   --  begin
   --     declare
   --        Str : constant String := Strings.Value (S);
   --     begin
   --        g_free (S);
   --        return Str;
   --     end;
   --  end Find_Pixmap_In_Path;

   -----------
   -- Parse --
   -----------

   procedure Parse (Filename : String) is
      procedure Internal (Filename : String);
      pragma Import (C, Internal, "gtk_rc_parse");

   begin
      Internal (Filename & ASCII.NUL);
   end Parse;

   ------------------
   -- Parse_String --
   ------------------

   procedure Parse_String (Rc_String : String) is
      procedure Internal (Rc_String : String);
      pragma Import (C, Internal, "gtk_rc_parse_string");

   begin
      Internal (Rc_String & ASCII.NUL);
   end Parse_String;

   -----------------
   -- Reparse_All --
   -----------------

   function Reparse_All return Boolean is
      function Internal return Gboolean;
      pragma Import (C, Internal, "gtk_rc_reparse_all");

   begin
      return Internal /= 0;
   end Reparse_All;

   -------------------------
   -- Find_Module_In_Path --
   -------------------------

   function Find_Module_In_Path (Module_File : String) return String is
      function Internal (Module_File : String) return Chars_Ptr;
      pragma Import (C, Internal, "gtk_rc_find_module_in_path");

      S   : constant Chars_Ptr := Internal (Module_File & ASCII.NUL);
      Str : constant String := Strings.Value (S);

   begin
      g_free (S);
      return Str;
   end Find_Module_In_Path;

   -------------------
   -- Get_Theme_Dir --
   -------------------

   function Get_Theme_Dir return String is
      function Internal return Chars_Ptr;
      pragma Import (C, Internal, "gtk_rc_get_theme_dir");

      S   : constant Chars_Ptr := Internal;
      Str : constant String := Strings.Value (S);

   begin
      g_free (S);
      return Str;
   end Get_Theme_Dir;

   --------------------
   -- Get_Module_Dir --
   --------------------

   function Get_Module_Dir return String is
      function Internal return Chars_Ptr;
      pragma Import (C, Internal, "gtk_rc_get_module_dir");

      S   : constant Chars_Ptr := Internal;
      Str : constant String := Strings.Value (S);

   begin
      g_free (S);
      return Str;
   end Get_Module_Dir;

   ------------------------
   -- Get_Im_Module_Path --
   ------------------------

   function Get_Im_Module_Path return String is
      function Internal return Chars_Ptr;
      pragma Import (C, Internal, "gtk_rc_get_im_module_path");

      S   : constant Chars_Ptr := Internal;
      Str : constant String := Strings.Value (S);

   begin
      g_free (S);
      return Str;
   end Get_Im_Module_Path;

   ------------------------
   -- Get_Im_Module_File --
   ------------------------

   function Get_Im_Module_File return String is
      function Internal return Chars_Ptr;
      pragma Import (C, Internal, "gtk_rc_get_im_module_file");

      S   : constant Chars_Ptr := Internal;
      Str : constant String := Strings.Value (S);

   begin
      g_free (S);
      return Str;
   end Get_Im_Module_File;

   ------------------------
   -- Get_Modifier_Style --
   ------------------------

   function Get_Modifier_Style
     (Widget : access Gtk_Widget_Record'Class) return Gtk_Rc_Style
   is
      function Internal (Widget : System.Address) return System.Address;
      pragma Import (C, Internal, "gtk_widget_get_modifier_style");

      Stub : Gtk_Rc_Style_Record;

   begin
      return Gtk_Rc_Style
        (Get_User_Data (Internal (Get_Object (Widget)), Stub));
   end Get_Modifier_Style;

   ------------------
   -- Modify_Style --
   ------------------

   procedure Modify_Style
     (Widget : access Gtk_Widget_Record'Class;
      Style  : access Gtk_Rc_Style_Record'Class)
   is
      procedure Internal (Widget : System.Address; Style : System.Address);
      pragma Import (C, Internal, "gtk_widget_modify_style");

   begin
      Internal (Get_Object (Widget), Get_Object (Style));
   end Modify_Style;

end Gtk.Rc;
