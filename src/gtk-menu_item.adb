-----------------------------------------------------------------------
--          GtkAda - Ada95 binding for the Gimp Toolkit              --
--                                                                   --
--                     Copyright (C) 1998-2000                       --
--        Emmanuel Briot, Joel Brobecker and Arnaud Charlet          --
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
with Glib.Type_Conversion_Hooks;
pragma Elaborate_All (Glib.Type_Conversion_Hooks);

package body Gtk.Menu_Item is

   -----------------------
   -- Local Subprograms --
   -----------------------

   function Type_Conversion (Type_Name : String) return GObject;
   --  This function is used to implement a minimal automated type conversion
   --  without having to drag the whole Gtk.Type_Conversion package for the
   --  most common widgets.

   --------------
   -- Activate --
   --------------

   procedure Activate (Menu_Item : access Gtk_Menu_Item_Record) is
      procedure Internal (Menu_Item : in System.Address);
      pragma Import (C, Internal, "gtk_menu_item_activate");
   begin
      Internal (Get_Object (Menu_Item));
   end Activate;

   ---------------
   -- Configure --
   ---------------

   procedure Configure (Menu_Item              : access Gtk_Menu_Item_Record;
                        Show_Toggle_Indicator  : in     Boolean;
                        Show_Submenu_Indicator : in     Boolean) is
      procedure Internal (Menu_Item : System.Address;
                          Show_Toggle_Indicator : in Boolean;
                          Show_Submenu_Indicator : in Boolean);
      pragma Import (C, Internal, "gtk_menu_item_configure");
   begin
      Internal (Get_Object (Menu_Item), Show_Toggle_Indicator,
                Show_Submenu_Indicator);
   end Configure;

   --------------
   -- Deselect --
   --------------

   procedure Deselect (Menu_Item : access Gtk_Menu_Item_Record) is
      procedure Internal (Menu_Item : in System.Address);
      pragma Import (C, Internal, "gtk_menu_item_deselect");
   begin
      Internal (Get_Object (Menu_Item));
   end Deselect;

   -------------
   -- Gtk_New --
   -------------

   procedure Gtk_New (Menu_Item : out Gtk_Menu_Item;
                      Label     : in  String := "") is
   begin
      Menu_Item := new Gtk_Menu_Item_Record;
      Initialize (Menu_Item, Label);
   end Gtk_New;

   ----------------
   -- Gtk_Select --
   ----------------

   procedure Gtk_Select (Menu_Item : access Gtk_Menu_Item_Record) is
      procedure Internal (Menu_Item : in System.Address);
      pragma Import (C, Internal, "gtk_menu_item_select");
   begin
      Internal (Get_Object (Menu_Item));
   end Gtk_Select;

   ----------------
   -- Initialize --
   ----------------

   procedure Initialize (Menu_Item : access Gtk_Menu_Item_Record'Class;
                         Label     : in  String) is
      function Internal (Label : in String) return System.Address;
      pragma Import (C, Internal, "gtk_menu_item_new_with_label");
      function Internal2 return System.Address;
      pragma Import (C, Internal2, "gtk_menu_item_new");
   begin
      if Label = "" then
         Set_Object (Menu_Item, Internal2);
      else
         Set_Object (Menu_Item, Internal (Label & ASCII.NUL));
      end if;
      Initialize_User_Data (Menu_Item);
   end Initialize;

   -----------------
   -- Get_Submenu --
   -----------------

   function Get_Submenu (Menu_Item : access Gtk_Menu_Item_Record)
                        return Gtk.Widget.Gtk_Widget
   is
      function Internal (Menu_Item : System.Address) return System.Address;
      pragma Import (C, Internal, "ada_gtk_menu_item_get_submenu");
      Stub : Gtk.Widget.Gtk_Widget_Record;
   begin
      return Gtk.Widget.Gtk_Widget
        (Get_User_Data (Internal (Get_Object (Menu_Item)), Stub));
   end Get_Submenu;

   --------------------
   -- Remove_Submenu --
   --------------------

   procedure Remove_Submenu (Menu_Item : access Gtk_Menu_Item_Record) is
      procedure Internal (Menu_Item : in System.Address);
      pragma Import (C, Internal, "gtk_menu_item_remove_submenu");
   begin
      Internal (Get_Object (Menu_Item));
   end Remove_Submenu;

   -------------------
   -- Right_Justify --
   --------------------

   procedure Right_Justify (Menu_Item : access Gtk_Menu_Item_Record) is
      procedure Internal (Menu_Item : in System.Address);
      pragma Import (C, Internal, "gtk_menu_item_right_justify");
   begin
      Internal (Get_Object (Menu_Item));
   end Right_Justify;

   -------------------
   -- Set_Placement --
   -------------------

   procedure Set_Placement (Menu_Item : access Gtk_Menu_Item_Record;
                            Placement : in     Enums.Gtk_Submenu_Placement) is
      procedure Internal (Menu_Item : in System.Address;
                          Placement : in Enums.Gtk_Submenu_Placement);
      pragma Import (C, Internal, "gtk_menu_item_set_placement");
   begin
      Internal (Get_Object (Menu_Item), Placement);
   end Set_Placement;

   -----------------
   -- Set_Submenu --
   -----------------

   procedure Set_Submenu (Menu_Item : access Gtk_Menu_Item_Record;
                          Submenu   : access Widget.Gtk_Widget_Record'Class) is
      procedure Internal (Menu_Item : in System.Address;
                          Submenu   : in System.Address);
      pragma Import (C, Internal, "gtk_menu_item_set_submenu");
   begin
      Internal (Get_Object (Menu_Item), Get_Object (Submenu));
   end Set_Submenu;

   -----------------------
   -- Set_Right_Justify --
   -----------------------

   procedure Set_Right_Justify
     (Menu_Item : access Gtk_Menu_Item_Record;
      Justify   : Boolean) is
   begin
      if Justify then
         Right_Justify (Menu_Item);
      end if;
   end Set_Right_Justify;

   ---------------------
   -- Type_Conversion --
   ---------------------

   function Type_Conversion (Type_Name : String) return GObject is
   begin
      if Type_Name = "GtkMenuItem" then
         return new Gtk_Menu_Item_Record;
      else
         return null;
      end if;
   end Type_Conversion;

begin
   Glib.Type_Conversion_Hooks.Add_Hook (Type_Conversion'Access);
end Gtk.Menu_Item;
