-----------------------------------------------------------------------
--          GtkAda - Ada95 binding for the Gimp Toolkit              --
--                                                                   --
--                     Copyright (C) 1998-1999                       --
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

with Gdk.Color;
with Gdk.GC;
with Gdk.Visual;
with Gdk.Window;
with Gtk.Enums; use Gtk.Enums;
with Gtk.Widget;

package Gtk.Preview is

   type Gtk_Preview_Record is new Gtk.Widget.Gtk_Widget_Record with private;
   type Gtk_Preview is access all Gtk_Preview_Record'Class;

   type Gtk_Preview_Info_Record is new Gtk.Widget.Gtk_Widget_Record
     with private;
   type Gtk_Preview_Info is access all Gtk_Preview_Info_Record'Class;

   procedure Draw_Row
     (Preview : access Gtk_Preview_Record;
      Data    : in Guchar_Array;
      X       : in Gint;
      Y       : in Gint;
      W       : in Gint);
   --  The size required for Data depends of the color depth of the
   --  preview. No verification is done by Ada, everything is left to
   --  gtk. You might get some segmentation fault !
   --  for a color preview, Data'Length = W * 3  (for R, G ,B)
   --  for a grey preview, Data'Length = W;

   function Get_Cmap return Gdk.Color.Gdk_Colormap;

   function Get_Info return Gtk_Preview_Info;

   function Get_Visual return Gdk.Visual.Gdk_Visual;

   procedure Gtk_New
     (Preview  : out Gtk_Preview; The_Type : in Gtk_Preview_Type);

   procedure Initialize
     (Preview  : access Gtk_Preview_Record'Class;
      The_Type : in Gtk_Preview_Type);

   function Get_Type return Gtk.Gtk_Type;
   --  Return the internal value associated with a Gtk_Preview.

   procedure Put
     (Preview : access Gtk_Preview_Record;
      Window  : in Gdk.Window.Gdk_Window;
      Gc      : in Gdk.GC.Gdk_GC;
      Srcx    : in Gint;
      Srcy    : in Gint;
      Destx   : in Gint;
      Desty   : in Gint;
      Width   : in Gint;
      Height  : in Gint);

   procedure Reset;

   procedure Set_Color_Cube
     (Nred_Shades   : in Guint;
      Ngreen_Shades : in Guint;
      Nblue_Shades  : in Guint;
      Ngray_Shades  : in Guint);

   procedure Set_Expand
     (Preview : access Gtk_Preview_Record;
      Expand  : in Boolean);

   procedure Set_Gamma (Gamma : in Gdouble);

   procedure Set_Install_Cmap (Install_Cmap : in Gint);

   procedure Set_Reserved (Nreserved : in Gint);

   procedure Size
     (Preview : access Gtk_Preview_Record;
      Width   : in Gint;
      Height  : in Gint);

   procedure Uninit;

private
   type Gtk_Preview_Record is new Gtk.Widget.Gtk_Widget_Record
     with null record;

   type Gtk_Preview_Info_Record is new Gtk.Widget.Gtk_Widget_Record
     with null record;

   pragma Import (C, Get_Visual, "gtk_preview_get_visual");
   pragma Import (C, Get_Cmap, "gtk_preview_get_cmap");
   pragma Import (C, Get_Type, "gtk_preview_get_type");
end Gtk.Preview;
