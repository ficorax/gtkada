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

package body Gtk.Ruler is

   --------------
   -- Draw_Pos --
   --------------

   procedure Draw_Pos (Ruler : access Gtk_Ruler_Record) is
      procedure Internal (Ruler : in System.Address);
      pragma Import (C, Internal, "gtk_ruler_draw_pos");
   begin
      Internal (Get_Object (Ruler));
   end Draw_Pos;

   ----------------
   -- Draw_Ticks --
   ----------------

   procedure Draw_Ticks (Ruler : access Gtk_Ruler_Record) is
      procedure Internal (Ruler : in System.Address);
      pragma Import (C, Internal, "gtk_ruler_draw_ticks");
   begin
      Internal (Get_Object (Ruler));
   end Draw_Ticks;

   ---------------
   -- Get_Lower --
   ---------------

   function Get_Lower (Ruler : access Gtk_Ruler_Record) return Gfloat is
      function Internal (Widget : in System.Address) return Gfloat;
      pragma Import (C, Internal, "ada_ruler_get_lower");
   begin
      return Internal (Get_Object (Ruler));
   end Get_Lower;

   ------------------
   -- Get_Max_Size --
   ------------------

   function Get_Max_Size (Ruler : access Gtk_Ruler_Record) return Gfloat is
      function Internal (Widget : in System.Address) return Gfloat;
      pragma Import (C, Internal, "ada_ruler_get_max_size");
   begin
      return Internal (Get_Object (Ruler));
   end Get_Max_Size;

   ------------------
   -- Get_Position --
   ------------------

   function Get_Position (Ruler : access Gtk_Ruler_Record) return Gfloat is
      function Internal (Widget : in System.Address) return Gfloat;
      pragma Import (C, Internal, "ada_ruler_get_position");
   begin
      return Internal (Get_Object (Ruler));
   end Get_Position;

   ---------------
   -- Get_Upper --
   ---------------

   function Get_Upper (Ruler : access Gtk_Ruler_Record) return Gfloat is
      function Internal (Widget : in System.Address) return Gfloat;
      pragma Import (C, Internal, "ada_ruler_get_upper");
   begin
      return Internal (Get_Object (Ruler));
   end Get_Upper;

   --------------------
   -- Gtk_New_Hruler --
   --------------------

   procedure Gtk_New_Hruler (Ruler : out Gtk_Ruler) is
   begin
      Ruler := new Gtk_Ruler_Record;
      Initialize_Hruler (Ruler);
   end Gtk_New_Hruler;

   --------------------
   -- Gtk_New_Vruler --
   --------------------

   procedure Gtk_New_Vruler (Ruler : out Gtk_Ruler) is
   begin
      Ruler := new Gtk_Ruler_Record;
      Initialize_Vruler (Ruler);
   end Gtk_New_Vruler;

   -----------------------
   -- Initialize_Hruler --
   -----------------------

   procedure Initialize_Hruler (Ruler : access Gtk_Ruler_Record'Class) is
      function Internal return System.Address;
      pragma Import (C, Internal, "gtk_hruler_new");
   begin
      Set_Object (Ruler, Internal);
      Initialize_User_Data (Ruler);
   end Initialize_Hruler;

   -----------------------
   -- Initialize_Vruler --
   -----------------------

   procedure Initialize_Vruler (Ruler : access Gtk_Ruler_Record'Class) is
      function Internal return System.Address;
      pragma Import (C, Internal, "gtk_vruler_new");
   begin
      Set_Object (Ruler, Internal);
      Initialize_User_Data (Ruler);
   end Initialize_Vruler;

   ----------------
   -- Set_Metric --
   ----------------

   procedure Set_Metric
     (Ruler  : access Gtk_Ruler_Record;
      Metric : in Gtk_Metric_Type)
   is
      procedure Internal
        (Ruler  : in System.Address;
         Metric : in Gint);
      pragma Import (C, Internal, "gtk_ruler_set_metric");
   begin
      Internal (Get_Object (Ruler), Gtk_Metric_Type'Pos (Metric));
   end Set_Metric;

   ---------------
   -- Set_Range --
   ---------------

   procedure Set_Range
     (Ruler    : access Gtk_Ruler_Record;
      Lower    : in Gfloat;
      Upper    : in Gfloat;
      Position : in Gfloat;
      Max_Size : in Gfloat)
   is
      procedure Internal
        (Ruler    : in System.Address;
         Lower    : in Gfloat;
         Upper    : in Gfloat;
         Position : in Gfloat;
         Max_Size : in Gfloat);
      pragma Import (C, Internal, "gtk_ruler_set_range");

   begin
      Internal (Get_Object (Ruler), Lower, Upper, Position, Max_Size);
   end Set_Range;

end Gtk.Ruler;
