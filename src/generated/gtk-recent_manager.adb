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
pragma Style_Checks (Off);
pragma Warnings (Off, "*is already use-visible*");
with Glib.Type_Conversion_Hooks; use Glib.Type_Conversion_Hooks;
with Gtkada.Bindings;            use Gtkada.Bindings;

package body Gtk.Recent_Manager is

   function Convert (R : Gtk.Recent_Info.Gtk_Recent_Info) return System.Address is
   begin
      return Get_Object (R);
   end Convert;

   function Convert (R : System.Address) return Gtk.Recent_Info.Gtk_Recent_Info is
   begin
      return From_Object(R);end Convert;

   function Add_Full
     (Manager      : access Gtk_Recent_Manager_Record;
      Uri          : UTF8_String;
      Display_Name : UTF8_String := "";
      Description  : UTF8_String := "";
      Mime_Type    : UTF8_String;
      App_Name     : UTF8_String;
      App_Exec     : UTF8_String;
      Groups       : GNAT.Strings.String_List;
      Is_Private   : Boolean)
   return Boolean
   is
      function Internal
        (Manager     : System.Address;
         Uri         : String;
         Recent_Data : System.Address)
      return Gboolean;
      pragma Import (C, Internal, "gtk_recent_manager_add_full");

      type Gtk_Recent_Data_Record is record
         display_name : chars_ptr;
         description  : chars_ptr;
         mime_type    : chars_ptr;
         app_name     : chars_ptr;
         app_exec     : chars_ptr;
         groups       : System.Address;
         is_private   : Gboolean;
      end record;
      pragma Convention (C, Gtk_Recent_Data_Record);
      --  Internal record that matches struct _GtkRecentData in
      --  gtkrecentmanager.h

      C_Groups : aliased chars_ptr_array := From_String_List (Groups);
      --  Temporary variable to aid translation

      GRD : aliased Gtk_Recent_Data_Record;
      --  Data to feed in to gtk_recent_manager_add_full()

      Result : Gboolean;
   begin
      --  Set up.
      GRD.display_name := String_Or_Null (Display_Name);
      GRD.description  := String_Or_Null (Description);
      GRD.mime_type    := New_String (Mime_Type);
      GRD.app_name     := New_String (App_Name);
      GRD.app_exec     := New_String (App_Exec);
      GRD.is_private   := Boolean'Pos (Is_Private);

      if C_Groups'Length > 0 then
         GRD.groups := C_Groups (C_Groups'First)'Address;
      else
         GRD.groups := System.Null_Address;
      end if;
      --  Invoke function.
      Result := Internal (Get_Object (Manager), Uri & ASCII.NUL, GRD'Address);

      --  Clean up, making sure to avoid double-deallocations where such
      --  may be possible.
      if GRD.display_name /= Null_Ptr then
         Free (GRD.display_name);
      end if;
      if GRD.description /= Null_Ptr then
         Free (GRD.description);
      end if;
      Free (GRD.mime_type);
      Free (GRD.app_name);
      Free (GRD.app_exec);
      for I in C_Groups'Range loop
         if C_Groups (I) /= Null_Ptr then
            Free (C_Groups (I));
         end if;
      end loop;

      --  Return result.
      return Boolean'Val (Result);
   end Add_Full;

   package Type_Conversion_Gtk_Recent_Manager is new Glib.Type_Conversion_Hooks.Hook_Registrator
     (Get_Type'Access, Gtk_Recent_Manager_Record);
   pragma Unreferenced (Type_Conversion_Gtk_Recent_Manager);

   -------------
   -- Gtk_New --
   -------------

   procedure Gtk_New (Self : out Gtk_Recent_Manager) is
   begin
      Self := new Gtk_Recent_Manager_Record;
      Gtk.Recent_Manager.Initialize (Self);
   end Gtk_New;

   ----------------
   -- Initialize --
   ----------------

   procedure Initialize
      (Self : not null access Gtk_Recent_Manager_Record'Class)
   is
      function Internal return System.Address;
      pragma Import (C, Internal, "gtk_recent_manager_new");
   begin
      Set_Object (Self, Internal);
   end Initialize;

   --------------
   -- Add_Item --
   --------------

   function Add_Item
      (Self : not null access Gtk_Recent_Manager_Record;
       URI  : UTF8_String) return Boolean
   is
      function Internal
         (Self : System.Address;
          URI  : Interfaces.C.Strings.chars_ptr) return Integer;
      pragma Import (C, Internal, "gtk_recent_manager_add_item");
      Tmp_URI    : Interfaces.C.Strings.chars_ptr := New_String (URI);
      Tmp_Return : Integer;
   begin
      Tmp_Return := Internal (Get_Object (Self), Tmp_URI);
      Free (Tmp_URI);
      return Boolean'Val (Tmp_Return);
   end Add_Item;

   ---------------
   -- Get_Items --
   ---------------

   function Get_Items
      (Self : not null access Gtk_Recent_Manager_Record)
       return Gtk_Recent_Info_List.Glist
   is
      function Internal (Self : System.Address) return System.Address;
      pragma Import (C, Internal, "gtk_recent_manager_get_items");
      Tmp_Return : Gtk_Recent_Info_List.Glist;
   begin
      Gtk.Recent_Manager.Gtk_Recent_Info_List.Set_Object (Tmp_Return, Internal (Get_Object (Self)));
      return Tmp_Return;
   end Get_Items;

   --------------
   -- Has_Item --
   --------------

   function Has_Item
      (Self : not null access Gtk_Recent_Manager_Record;
       URI  : UTF8_String) return Boolean
   is
      function Internal
         (Self : System.Address;
          URI  : Interfaces.C.Strings.chars_ptr) return Integer;
      pragma Import (C, Internal, "gtk_recent_manager_has_item");
      Tmp_URI    : Interfaces.C.Strings.chars_ptr := New_String (URI);
      Tmp_Return : Integer;
   begin
      Tmp_Return := Internal (Get_Object (Self), Tmp_URI);
      Free (Tmp_URI);
      return Boolean'Val (Tmp_Return);
   end Has_Item;

   -----------------
   -- Lookup_Item --
   -----------------

   function Lookup_Item
      (Self : not null access Gtk_Recent_Manager_Record;
       URI  : UTF8_String) return Gtk.Recent_Info.Gtk_Recent_Info
   is
      function Internal
         (Self : System.Address;
          URI  : Interfaces.C.Strings.chars_ptr) return System.Address;
      pragma Import (C, Internal, "gtk_recent_manager_lookup_item");
      Tmp_URI    : Interfaces.C.Strings.chars_ptr := New_String (URI);
      Tmp_Return : System.Address;
   begin
      Tmp_Return := Internal (Get_Object (Self), Tmp_URI);
      Free (Tmp_URI);
      return From_Object (Tmp_Return);
   end Lookup_Item;

   ---------------
   -- Move_Item --
   ---------------

   function Move_Item
      (Self    : not null access Gtk_Recent_Manager_Record;
       URI     : UTF8_String;
       New_Uri : UTF8_String := "") return Boolean
   is
      function Internal
         (Self    : System.Address;
          URI     : Interfaces.C.Strings.chars_ptr;
          New_Uri : Interfaces.C.Strings.chars_ptr) return Integer;
      pragma Import (C, Internal, "gtk_recent_manager_move_item");
      Tmp_URI     : Interfaces.C.Strings.chars_ptr := New_String (URI);
      Tmp_New_Uri : Interfaces.C.Strings.chars_ptr;
      Tmp_Return  : Integer;
   begin
      if New_Uri = "" then
         Tmp_New_Uri := Interfaces.C.Strings.Null_Ptr;
      else
         Tmp_New_Uri := New_String (New_Uri);
      end if;
      Tmp_Return := Internal (Get_Object (Self), Tmp_URI, Tmp_New_Uri);
      Free (Tmp_URI);
      Free (Tmp_New_Uri);
      return Boolean'Val (Tmp_Return);
   end Move_Item;

   -----------------
   -- Purge_Items --
   -----------------

   function Purge_Items
      (Self : not null access Gtk_Recent_Manager_Record) return Gint
   is
      function Internal (Self : System.Address) return Gint;
      pragma Import (C, Internal, "gtk_recent_manager_purge_items");
   begin
      return Internal (Get_Object (Self));
   end Purge_Items;

   -----------------
   -- Remove_Item --
   -----------------

   function Remove_Item
      (Self : not null access Gtk_Recent_Manager_Record;
       URI  : UTF8_String) return Boolean
   is
      function Internal
         (Self : System.Address;
          URI  : Interfaces.C.Strings.chars_ptr) return Integer;
      pragma Import (C, Internal, "gtk_recent_manager_remove_item");
      Tmp_URI    : Interfaces.C.Strings.chars_ptr := New_String (URI);
      Tmp_Return : Integer;
   begin
      Tmp_Return := Internal (Get_Object (Self), Tmp_URI);
      Free (Tmp_URI);
      return Boolean'Val (Tmp_Return);
   end Remove_Item;

   -----------------
   -- Get_Default --
   -----------------

   function Get_Default return Gtk_Recent_Manager is
      function Internal return System.Address;
      pragma Import (C, Internal, "gtk_recent_manager_get_default");
      Stub_Gtk_Recent_Manager : Gtk_Recent_Manager_Record;
   begin
      return Gtk.Recent_Manager.Gtk_Recent_Manager (Get_User_Data (Internal, Stub_Gtk_Recent_Manager));
   end Get_Default;

end Gtk.Recent_Manager;