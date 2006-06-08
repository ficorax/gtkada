-----------------------------------------------------------------------
--          GtkAda - Ada95 binding for the Gimp Toolkit              --
--                                                                   --
--                     Copyright (C) 2006 AdaCore                    --
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

with Gdk.Color;              use Gdk.Color;
with Gdk.Pixbuf;             use Gdk.Pixbuf;
with Gdk.Rgb;                use Gdk.Rgb;
with Glib;                   use Glib;
with Gtk.Box;                use Gtk.Box;
with Gtk.Frame;              use Gtk.Frame;
with Gtk.Cell_Renderer;      use Gtk.Cell_Renderer;
with Gtk.Cell_Renderer_Pixbuf; use Gtk.Cell_Renderer_Pixbuf;
with Gtk.Cell_Renderer_Text;   use Gtk.Cell_Renderer_Text;
with Gtk.Combo_Box;          use Gtk.Combo_Box;
with Gtk.Cell_Layout;        use Gtk.Cell_Layout;
with Gtk.List_Store;         use Gtk.List_Store;
with Gtk.Tree_Model;         use Gtk.Tree_Model;
with Gtk.Widget;             use Gtk.Widget;

package body Create_Combo_Box is

   Column_0 : constant := 0;
   Column_1 : constant := 1;
   --  The columns in the model

   procedure Append_Color_Pixbuf
     (Model : Gtk_List_Store;
      Color : String);
   --  Append a new pixbuf with Color as its background

   ----------
   -- Help --
   ----------

   function Help return String is
   begin
      return "A @bGtk_Combo_Box@B is a widget that allows the user to choose"
        & " from a list of valid choices.";
   end Help;

   -------------------------
   -- Append_Color_Pixbuf --
   -------------------------

   procedure Append_Color_Pixbuf
     (Model : Gtk_List_Store;
      Color : String)
   is
      Pix     : Gdk_Pixbuf;
      GColor  : Gdk_Color;
      Iter    : Gtk_Tree_Iter;
      Stride  : Gint;
      Num     : Gint;
      Pixels  : Gdk.Rgb.Rgb_Buffer_Access;
   begin
      GColor := Parse (Color);

      Pix := Gdk_New (Bits_Per_Sample => 8, Width => 16, Height => 16);

      --  This code is not clean. It would be better to use cairo, but GtkAda
      --  has no binding for it at the time of this writing. You could also
      --  load the images from XPM data instead.
      Stride := Get_Rowstride (Pix);
      Num    := Get_Width (Pix) * Get_Height (Pix);
      Pixels := Get_Pixels (Pix);

      for N in 0 .. Num - 1 loop
         --  By default, each color occupies 8bits, thus is it easier to
         --  manipulate colors
         Pixels (Integer (N * 3 + 0)) := Guchar (Red   (Gcolor) / 65535 * 255);
         Pixels (Integer (N * 3 + 1)) := Guchar (Green (Gcolor) / 65535 * 255);
         Pixels (Integer (N * 3 + 2)) := Guchar (Blue  (Gcolor) / 65535 * 255);
      end loop;

      Append (Model, Iter);
      Set (Model, Iter, Column_0, Pix);

      Unref (Pix);
   end Append_Color_Pixbuf;

   ---------
   -- Run --
   ---------

   procedure Run (Frame : access Gtk.Frame.Gtk_Frame_Record'Class) is
      Box        : Gtk_Box;
      Model      : Gtk_List_Store;
      Iter       : Gtk_Tree_Iter;
      Combo      : Gtk_Combo_Box;
      Render     : Gtk_Cell_Renderer_Text;
      Pix        : Gtk_Cell_Renderer_Pixbuf;
   begin
      Set_Label (Frame, "Combo box");

      Gtk_New_Vbox (Box, Homogeneous => False);
      Add (Frame, Box);

      --  A simple text combo

      Gtk_New_Text (Combo);
      Pack_Start (Box, Combo, Expand => False);
      Append_Text (Combo, "Simple Text Combo 1");
      Append_Text (Combo, "Simple Text Combo 2");
      Append_Text (Combo, "Simple Text Combo 3");
      Set_Active (Combo, 0);

      --  Create a model. This is a set of rows, each with two columns in this
      --  specific case.
      Gtk_New (Model, (Column_0 => GType_String,
                       Column_1 => GType_Int));
      Append (Model, Iter);
      Set (Model, Iter, Column_0, "Combo From Model");
      Set (Model, Iter, Column_1, 1);

      Append (Model, Iter);
      Set (Model, Iter, Column_0, "Combo From Model");
      Set (Model, Iter, Column_1, 2);

      Append (Model, Iter);
      Set (Model, Iter, Column_0, "Combo From Model");
      Set (Model, Iter, Column_1, 3);

      --  Create the combo. We use both columns of the model to display in the
      --  model, but we could display only one, or even have a display that
      --  doesn't come directly from a column (see create_cell_view for
      --  instance)

      Gtk_New_With_Model (Combo, Model);
      Pack_Start (Box, Combo, Expand => False);

      Gtk_New (Render);
      Pack_Start    (+Combo, Render, Expand => True);
      Add_Attribute (+Combo, Render, "text", Column_0);

      Gtk_New (Render);
      Pack_Start    (+Combo, Render, Expand => True);
      Add_Attribute (+Combo, Render, "text", Column_1);

      Set_Active (Combo, 0);

      --  A matrix combo now
      Gtk_New (Model, (Column_0 => Gdk.Pixbuf.Get_Type));
      Append_Color_Pixbuf (Model, "red");
      Append_Color_Pixbuf (Model, "green");
      Append_Color_Pixbuf (Model, "blue");
      Append_Color_Pixbuf (Model, "yellow");
      Append_Color_Pixbuf (Model, "black");
      Append_Color_Pixbuf (Model, "white");
      Append_Color_Pixbuf (Model, "cyan");
      Append_Color_Pixbuf (Model, "pink");
      Append_Color_Pixbuf (Model, "magenta");

      Gtk_New_With_Model (Combo, Model);
      Pack_Start (Box, Combo, Expand => False);
      Set_Wrap_Width (Combo, 3);  --  Make it a matrix

      Gtk_New (Pix);
      Pack_Start    (+Combo, Pix, Expand => True);
      Add_Attribute (+Combo, Pix, "pixbuf", Column_0);

      Set_Active (Combo, 0);

      Show_All (Frame);
   end Run;

end Create_Combo_Box;