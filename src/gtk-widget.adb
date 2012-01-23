------------------------------------------------------------------------------
--                  GtkAda - Ada95 binding for Gtk+/Gnome                   --
--                                                                          --
--      Copyright (C) 1998-2000 E. Briot, J. Brobecker and A. Charlet       --
--                     Copyright (C) 1998-2012, AdaCore                     --
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

with Ada.Unchecked_Conversion;
with Interfaces.C.Strings;        use Interfaces.C.Strings;
with System;                      use System;

with Cairo;                       use Cairo;
with Glib.Values;                 use Glib.Values;
with Gdk.Color;                   use Gdk.Color;
with Gdk.RGBA;                    use Gdk.RGBA;
with Gdk.Types;                   use Gdk.Types;
with Gdk.Visual;                  use Gdk.Visual;
with Gtk.Enums;                   use Gtk.Enums;
with Gtk.Style;                   use Gtk.Style;
with Gtk.Window;
with Gtkada.Bindings;             use Gtkada.Bindings;
with Gtkada.Types;
with Pango.Context;               use Pango.Context;
with Pango.Layout;                use Pango.Layout;

with Glib.Type_Conversion_Hooks;

package body Gtk.Widget is

   package Type_Conversion is new Glib.Type_Conversion_Hooks.Hook_Registrator
     (Get_Type'Access, Gtk_Widget_Record);
   pragma Warnings (Off, Type_Conversion);

   -------------------------------
   -- Class_Find_Style_Property --
   -------------------------------

   function Class_Find_Style_Property
     (Klass         : GObject_Class;
      Property_Name : String)
      return Param_Spec
   is
      function Internal
        (Klass         : GObject_Class;
         Property_Name : String)
         return Param_Spec;
      pragma Import (C, Internal, "gtk_widget_class_find_style_property");
   begin
      return Internal (Klass, Property_Name & ASCII.NUL);
   end Class_Find_Style_Property;

   ---------------------------------
   -- Class_List_Style_Properties --
   ---------------------------------

   function Class_List_Style_Properties
     (Klass : Glib.Object.GObject_Class) return Glib.Param_Spec_Array
   is
      use Pspec_Arrays;
      function Internal
        (Cclass       : GObject_Class;
         N_Properties : access Guint) return Unbounded_Array_Access;
      pragma Import (C, Internal, "gtk_widget_class_list_style_properties");

      Num     : aliased Guint;
      C_Array : constant Unbounded_Array_Access :=
        Internal (Klass, Num'Access);
      Result  : constant Param_Spec_Array := To_Array (C_Array, Integer (Num));

   begin
      --  Doc says we should free, but that results in double deallocation
--      G_Free (C_Array);
      return Result;
   end Class_List_Style_Properties;

   ----------------
   -- Class_Path --
   ----------------

   function Class_Path (Widget : access Gtk_Widget_Record) return String is
      procedure Internal
        (Widget        : System.Address;
         Path_Length   : out Guint;
         Path          : out chars_ptr;
         Path_Reversed : out chars_ptr);
      pragma Import (C, Internal, "gtk_widget_class_path");
      P, R : chars_ptr;
      Length : Guint;
   begin
      Internal (Get_Object (Widget), Length, P, R);
      declare
         Path : constant String := Value (P);
      begin
         Free (P);
         Free (R);
         return Path;
      end;
   end Class_Path;

   -------------
   -- Convert --
   -------------

   function Convert (W : Gtk_Widget) return System.Address is
   begin
      if W = null then
         return System.Null_Address;
      else
         return Get_Object (W);
      end if;
   end Convert;

   -------------
   -- Convert --
   -------------

   function Convert (W : System.Address) return Gtk_Widget is
      Stub : Gtk_Widget_Record;
   begin
      return Gtk_Widget (Get_User_Data (W, Stub));
   end Convert;

   ----------------
   -- Destroy_Cb --
   ----------------

   procedure Destroy_Cb (Widget : access Gtk_Widget_Record'Class) is
   begin
      Destroy (Widget);
   end Destroy_Cb;

   --------------------
   -- Get_Allocation --
   --------------------

   function Get_Allocation
     (Value : Glib.Values.GValue) return Gtk_Allocation_Access
   is
      pragma Warnings (Off);
      --  This UC is safe aliasing-wise, so kill warning
      function To_Allocation is new
        Ada.Unchecked_Conversion (System.Address, Gtk_Allocation_Access);
      pragma Warnings (On);

   begin
      return To_Allocation (Glib.Values.Get_Address (Value));
   end Get_Allocation;

   ---------------------
   -- Get_Requisition --
   ---------------------

   function Get_Requisition
     (Value : Glib.Values.GValue) return Gtk_Requisition_Access
   is
      pragma Warnings (Off);
      --  This UC is safe aliasing-wise, so kill warning
      function To_Requisition is new
        Ada.Unchecked_Conversion (System.Address, Gtk_Requisition_Access);
      pragma Warnings (On);

   begin
      return To_Requisition (Glib.Values.Get_Address (Value));
   end Get_Requisition;

   ------------------------
   -- Get_Tooltip_Markup --
   ------------------------

   function Get_Tooltip_Markup
     (Widget : access Gtk_Widget_Record) return UTF8_String
   is
      function Internal
        (Widget : System.Address) return Gtkada.Types.Chars_Ptr;
      pragma Import (C, Internal, "gtk_widget_get_tooltip_markup");
   begin
      --  We need to free the returned string.
      declare
         Tmp : constant Gtkada.Types.Chars_Ptr :=
               Internal (Get_Object (Widget));
         Str : constant String := Value (Tmp);
      begin
         Gtkada.Types.g_free (Tmp);
         return Str;
      end;
   end Get_Tooltip_Markup;

   ----------------------
   -- Get_Tooltip_Text --
   ----------------------

   function Get_Tooltip_Text
     (Widget : access Gtk_Widget_Record) return UTF8_String
   is
      function Internal
        (Widget : System.Address) return Gtkada.Types.Chars_Ptr;
      pragma Import (C, Internal, "gtk_widget_get_tooltip_text");
   begin
      --  We need to free the returned string.
      declare
         Tmp : constant Gtkada.Types.Chars_Ptr :=
               Internal (Get_Object (Widget));
         Str : constant String := Value (Tmp);
      begin
         Gtkada.Types.g_free (Tmp);
         return Str;
      end;
   end Get_Tooltip_Text;

   ---------------
   -- Intersect --
   ---------------

   function Intersect
     (Widget       : access Gtk_Widget_Record;
      Area         : Gdk.Rectangle.Gdk_Rectangle;
      Intersection : access Gdk.Rectangle.Gdk_Rectangle) return Boolean
   is
      function Internal
        (Widget : System.Address;
         Area   : Gdk.Rectangle.Gdk_Rectangle;
         Inter  : access Gdk.Rectangle.Gdk_Rectangle) return Gint;
      pragma Import (C, Internal, "gtk_widget_intersect");

      Result : Gint;

   begin
      Result := Internal (Get_Object (Widget), Area, Intersection);
      return Boolean'Val (Result);
   end Intersect;

   ------------------
   -- Is_Sensitive --
   ------------------

   function Is_Sensitive
     (Widget : access Gtk_Widget_Record'Class) return Boolean
   is
      function Internal (Widget : System.Address) return Guint32;
      pragma Import (C, Internal, "gtk_widget_is_sensitive");

   begin
      return Boolean'Val (Internal (Get_Object (Widget)));
   end Is_Sensitive;

   procedure Modify_Base
     (Widget     : access Gtk_Widget_Record;
      State_Type : Enums.Gtk_State_Type;
      Color      : Gdk.Color.Gdk_Color)
   is
      procedure Internal
        (Widget : System.Address;
         State  : Enums.Gtk_State_Type;
         Color  : System.Address);
      pragma Import (C, Internal, "gtk_widget_modify_base");

      Col     : aliased Gdk.Color.Gdk_Color := Color;
      Color_A : System.Address := Col'Address;

   begin
      if Color = Gdk.Color.Null_Color then
         Color_A := System.Null_Address;
      end if;

      Internal (Get_Object (Widget), State_Type, Color_A);
   end Modify_Base;

   -------------------------------
   -- Override_Background_Color --
   -------------------------------

   procedure Override_Background_Color
      (Widget : not null access Gtk_Widget_Record;
       State  : Enums.Gtk_State_Type;
       Color  : Gdk.RGBA.Gdk_RGBA := Gdk.RGBA.Null_RGBA)
   is
      procedure Internal
        (Widget : System.Address;
         State  : Enums.Gtk_State_Type;
         Color  : System.Address);
      pragma Import (C, Internal, "gtk_widget_override_background_color");
   begin
      if Color = Null_RGBA then
         Internal (Get_Object (Widget), State, System.Null_Address);
      else
         Internal (Get_Object (Widget), State, Color'Address);
      end if;
   end Override_Background_Color;

   ---------------
   -- Modify_Bg --
   ---------------

   procedure Modify_Bg
     (Widget     : access Gtk_Widget_Record;
      State_Type : Enums.Gtk_State_Type;
      Color      : Gdk.Color.Gdk_Color)
   is
      procedure Internal
        (Widget : System.Address;
         State  : Enums.Gtk_State_Type;
         Color  : System.Address);
      pragma Import (C, Internal, "gtk_widget_modify_bg");

      Col     : aliased Gdk.Color.Gdk_Color := Color;
      Color_A : System.Address := Col'Address;

   begin
      if Color = Gdk.Color.Null_Color then
         Color_A := System.Null_Address;
      end if;

      Internal (Get_Object (Widget), State_Type, Color_A);
   end Modify_Bg;

   ---------------
   -- Modify_Fg --
   ---------------

   procedure Modify_Fg
     (Widget     : access Gtk_Widget_Record;
      State_Type : Enums.Gtk_State_Type;
      Color      : Gdk.Color.Gdk_Color)
   is
      procedure Internal
        (Widget : System.Address;
         State  : Enums.Gtk_State_Type;
         Color  : System.Address);
      pragma Import (C, Internal, "gtk_widget_modify_fg");

      Col     : aliased Gdk.Color.Gdk_Color := Color;
      Color_A : System.Address := Col'Address;

   begin
      if Color = Gdk.Color.Null_Color then
         Color_A := System.Null_Address;
      end if;

      Internal (Get_Object (Widget), State_Type, Color_A);
   end Modify_Fg;

   -----------------
   -- Modify_Text --
   -----------------

   procedure Modify_Text
     (Widget     : access Gtk_Widget_Record;
      State_Type : Enums.Gtk_State_Type;
      Color      : Gdk.Color.Gdk_Color)
   is
      procedure Internal
        (Widget : System.Address;
         State  : Enums.Gtk_State_Type;
         Color  : System.Address);
      pragma Import (C, Internal, "gtk_widget_modify_text");

      Col     : aliased Gdk.Color.Gdk_Color := Color;
      Color_A : System.Address := Col'Address;

   begin
      if Color = Gdk.Color.Null_Color then
         Color_A := System.Null_Address;
      end if;

      Internal (Get_Object (Widget), State_Type, Color_A);
   end Modify_Text;

   ----------
   -- Path --
   ----------

   function Path
     (Widget : access Gtk_Widget_Record) return String
   is
      procedure Internal
        (Widget        : System.Address;
         Path_Length   : out Guint;
         Path          : out chars_ptr;
         Path_Reversed : out chars_ptr);
      pragma Import (C, Internal, "gtk_widget_path");
      P, R : chars_ptr;
      Length : Guint;
   begin
      Internal (Get_Object (Widget), Length, P, R);
      declare
         Path : constant String := Value (P);
      begin
         Free (P);
         Free (R);
         return Path;
      end;
   end Path;

   ----------------------
   -- Region_Intersect --
   ----------------------

   function Region_Intersect
     (Widget : access Gtk_Widget_Record;
      Region : Cairo.Region.Cairo_Region) return Cairo.Region.Cairo_Region
   is
      function Internal
        (Widget : System.Address;
         Region : Cairo.Region.Cairo_Region) return Cairo.Region.Cairo_Region;
      pragma Import (C, Internal, "gtk_widget_region_intersect");
   begin
      return Internal (Get_Object (Widget), Region);
   end Region_Intersect;

   --------------------
   -- Set_Allocation --
   --------------------

   procedure Set_Allocation
     (Widget : access Gtk_Widget_Record'Class; Alloc : Gtk_Allocation)
   is
      procedure Internal (Widget : System.Address; Alloc : Gtk_Allocation);
      pragma Import (C, Internal, "gtk_widget_set_allocation");
   begin
      Internal (Get_Object (Widget), Alloc);
   end Set_Allocation;

   -----------------
   -- Set_Realize --
   -----------------

   package body Realize_Handling is

      procedure Internal_Realize (Widget : System.Address) is
         Dummy : Widget_Type;
         pragma Warnings (Off, Dummy);
      begin
         Realize_Proc (Widget_Type (Get_User_Data (Widget, Dummy).all)'Access);
      end Internal_Realize;

      procedure Set_Realize (Widget : access Gtk_Widget_Record'Class) is
         procedure Internal
           (Widget : System.Address; Realize : System.Address);
         pragma Import (C, Internal, "ada_widget_set_realize");

      begin
         Internal (Get_Object (Widget), Internal_Realize'Address);
      end Set_Realize;

   end Realize_Handling;

   ---------------------------
   -- Translate_Coordinates --
   ---------------------------

   procedure Translate_Coordinates
     (Src_Widget  : Gtk_Widget;
      Dest_Widget : Gtk_Widget;
      Src_X       : Gint;
      Src_Y       : Gint;
      Dest_X      : out Gint;
      Dest_Y      : out Gint;
      Result      : out Boolean)
   is
      function Internal
        (Src_Widget  : System.Address;
         Dest_Widget : System.Address;
         Src_X       : Gint;
         Src_Y       : Gint;
         Dest_X      : access Gint;
         Dest_Y      : access Gint) return Gboolean;
      pragma Import (C, Internal, "gtk_widget_translate_coordinates");

      X, Y : aliased Gint;

   begin
      Result := Boolean'Val (Internal
        (Get_Object (Src_Widget),
         Get_Object (Dest_Widget),
         Src_X, Src_Y, X'Access, Y'Access));

      if Result then
         Dest_X := X;
         Dest_Y := Y;
      end if;
   end Translate_Coordinates;

   -------------
   -- Destroy --
   -------------

   procedure Destroy (Widget : access Gtk_Widget_Record) is
      procedure Internal (Widget : System.Address);
      pragma Import (C, Internal, "gtk_widget_destroy");

      procedure Unref_Internal (Widget : System.Address);
      pragma Import (C, Unref_Internal, "g_object_unref");
      --  External binding: g_object_unref

      Ptr : constant System.Address := Get_Object (Widget);

      use type System.Address;
   begin
      --  Keep a reference on the object, so that the Ada structure is
      --  never automatically deleted when the C object is.
      --  We can't reset the content of Widget to System.Null_Address before
      --  calling the C function, because we want the user's destroy
      --  callbacks to be called with the appropriate object.
      Ref (Widget);
      Internal (Ptr);

      --  We then can make sure that the object won't be referenced any
      --  more, (The Ada structure won't be free before the ref count goes
      --  down to 0, and we don't want the user to use a deleted object...).
      Set_Object (Widget, System.Null_Address);

      --  Free the reference we had. In most cases, this results in the
      --  object being freed. We can't use directly Unref, since the Ptr
      --  field for Object is Null_Address.
      Unref_Internal (Ptr);
   end Destroy;

end Gtk.Widget;
