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

with Gdk.Bitmap;
with Gdk.Color;
with Gdk.Pixmap;
with Glib; use Glib;
--  with Glib.Gnodes;
with Gtk.Clist;
with Gtk.Enums; use Gtk.Enums;
with Gtk.Style;
with Gtkada.Types; use Gtkada.Types;
with Interfaces.C.Strings;

package Gtk.Ctree is

   type Gtk_Ctree_Record is new Gtk.Clist.Gtk_Clist_Record with private;
   type Gtk_Ctree is access all Gtk_Ctree_Record'Class;

   type Gtk_Ctree_Row is new Object_Type;
   type Gtk_Ctree_Node is new Object_Type;

   procedure Collapse (Ctree : access Gtk_Ctree_Record;
                       Node  : in     Gtk_Ctree_Node);

   procedure Collapse_Recursive (Ctree : access Gtk_Ctree_Record;
                                 Node  : in     Gtk_Ctree_Node);

   procedure Collapse_To_Depth (Ctree : access Gtk_Ctree_Record;
                                Node  : in     Gtk_Ctree_Node;
                                Depth : in     Gint);

   procedure Expand (Ctree : access Gtk_Ctree_Record;
                     Node  : in     Gtk_Ctree_Node);

   procedure Expand_Recursive (Ctree : access Gtk_Ctree_Record;
                               Node  : in     Gtk_Ctree_Node);

   procedure Expand_To_Depth (Ctree : access Gtk_Ctree_Record;
                              Node  : in     Gtk_Ctree_Node;
                              Depth : in     Gint);

   --  Export_To_Gnode
   --  Find
   --  Find_All_By_Row_Data
   --  Find_All_By_Row_Data_Custom
   --  Find_By_Row_Data
   --  Find_By_Row_Data_Custom
   --  Find_Node_Ptr
   --  Get_Node_Info

   procedure Gtk_New (Widget      :    out Gtk_Ctree;
                      Titles      : in     Chars_Ptr_Array;
                      Tree_Column : in     Gint);
   procedure Initialize (Widget      : access Gtk_Ctree_Record;
                         Titles      : in     Chars_Ptr_Array;
                         Tree_Column : in     Gint);

   procedure Gtk_New (Widget      :    out Gtk_Ctree;
                      Columns     : in     Gint;
                      Tree_Column : in     Gint);
   procedure Initialize (Widget      : access Gtk_Ctree_Record;
                         Columns     : in     Gint;
                         Tree_Column : in     Gint);

   procedure Gtk_Select (Ctree : access  Gtk_Ctree_Record;
                         Node  : in      Gtk_Ctree_Node);

   --  Insert_Gnode

   function Insert_Node (Ctree         : access Gtk_Ctree_Record;
                         Parent        : in     Gtk_Ctree_Node;
                         Sibling       : in     Gtk_Ctree_Node;
                         Spacing       : in     Guint8;
                         Pixmap_Closed : in     Gdk.Pixmap.Gdk_Pixmap;
                         Mask_Closed   : in     Gdk.Bitmap.Gdk_Bitmap;
                         Pixmap_Opened : in     Gdk.Pixmap.Gdk_Pixmap;
                         Mask_Opened   : in     Gdk.Bitmap.Gdk_Bitmap;
                         Is_Leaf       : in     Boolean;
                         Expanded      : in     Boolean)
                         return                 Gtk_Ctree_Node;

   function Is_Ancestor (Ctree  : access Gtk_Ctree_Record;
                         Node   : in     Gtk_Ctree_Node;
                         Child  : in     Gtk_Ctree_Node)
                         return          Boolean;

   function Is_Hot_Spot (Ctree  : access Gtk_Ctree_Record;
                         X      : in     Gint;
                         Y      : in     Gint)
                         return          Boolean;

   function Is_Viewable (Ctree  : access Gtk_Ctree_Record;
                         Node   : in     Gtk_Ctree_Node)
                         return          Boolean;

   function Last (Ctree  : access Gtk_Ctree_Record;
                  Node   : in     Gtk_Ctree_Node)
                  return          Gtk_Ctree_Node;

   procedure Move (Ctree       : access Gtk_Ctree_Record;
                   Node        : in     Gtk_Ctree_Node;
                   New_Parent  : in     Gtk_Ctree_Node;
                   New_Sibling : in     Gtk_Ctree_Node);

   function Node_Get_Cell_Style (Ctree  : access Gtk_Ctree_Record;
                                 Node   : in     Gtk_Ctree_Node;
                                 Column : in     Gint)
                                 return          Gtk.Style.Gtk_Style;

   function Node_Get_Cell_Type (Ctree  : access Gtk_Ctree_Record;
                                Node   : in     Gtk_Ctree_Node;
                                Column : in     Gint)
                                return          Gtk_Cell_Type;

   procedure Node_Get_Pixmap (Ctree   : access Gtk_Ctree_Record;
                              Node    : in     Gtk_Ctree_Node;
                              Column  : in     Gint;
                              Pixmap  :    out Gdk.Pixmap.Gdk_Pixmap;
                              Mask    :    out Gdk.Bitmap.Gdk_Bitmap;
                              Success :    out Boolean);

   procedure Node_Get_Pixtext (Ctree   : access Gtk_Ctree_Record;
                               Node    : in     Gtk_Ctree_Node;
                               Column  : in     Gint;
                               Text    :    out Interfaces.C.Strings.chars_ptr;
                               Spacing :    out Guint8;
                               Pixmap  :    out Gdk.Pixmap.Gdk_Pixmap;
                               Mask    :    out Gdk.Bitmap.Gdk_Bitmap;
                               Success :    out Boolean);

   --  Node_Get_Row_Data

   function Node_Get_Row_Style (Ctree  : access Gtk_Ctree_Record;
                                Node   : in     Gtk_Ctree_Node)
                                return          Gtk.Style.Gtk_Style;

   function Node_Get_Selectable (Ctree  : access Gtk_Ctree_Record;
                                 Node   : in     Gtk_Ctree_Node)
                                 return          Boolean;

   procedure Node_Get_Text (Ctree   : access Gtk_Ctree_Record;
                            Node    : in     Gtk_Ctree_Node;
                            Column  : in     Gint;
                            Text    :    out Interfaces.C.Strings.chars_ptr;
                            Success :    out Boolean);

   function Node_Is_Visible (Ctree  : access Gtk_Ctree_Record;
                             Node   : in     Gtk_Ctree_Node)
                             return          Gtk_Visibility;

   procedure Node_Moveto (Ctree     : access Gtk_Ctree_Record;
                          Node      : in     Gtk_Ctree_Node;
                          Column    : in     Gint;
                          Row_Align : in     Gfloat;
                          Col_Align : in     Gfloat);

   function Node_Nth (Ctree  : access Gtk_Ctree_Record;
                      Row    : in     Guint)
                      return          Gtk_Ctree_Node;

   procedure Node_Set_Background (Ctree : access Gtk_Ctree_Record;
                                  Node  : in     Gtk_Ctree_Node;
                                  Color : in     Gdk.Color.Gdk_Color);

   procedure Node_Set_Cell_Style (Ctree  : access Gtk_Ctree_Record;
                                  Node   : in     Gtk_Ctree_Node;
                                  Column : in     Gint;
                                  Style  : in     Gtk.Style.Gtk_Style);

   procedure Node_Set_Foreground (Ctree : access Gtk_Ctree_Record;
                                  Node  : in     Gtk_Ctree_Node;
                                  Color : in     Gdk.Color.Gdk_Color);

   procedure Node_Set_Pixmap (Ctree  : access Gtk_Ctree_Record;
                              Node   : in     Gtk_Ctree_Node;
                              Column : in     Gint;
                              Pixmap : in     Gdk.Pixmap.Gdk_Pixmap;
                              Mask   : in     Gdk.Bitmap.Gdk_Bitmap);

   procedure Node_Set_Pixtext (Ctree   : access Gtk_Ctree_Record;
                               Node    : in     Gtk_Ctree_Node;
                               Column  : in     Gint;
                               Text    : in     String;
                               Spacing : in     Guint8;
                               Pixmap  : in     Gdk.Pixmap.Gdk_Pixmap;
                               Mask    : in     Gdk.Bitmap.Gdk_Bitmap);

   --  Node_Set_Row_Data
   --  Node_Set_Row_Data_Full

   procedure Node_Set_Row_Style (Ctree : access Gtk_Ctree_Record;
                                 Node  : in     Gtk_Ctree_Node;
                                 Style : in     Gtk.Style.Gtk_Style);

   procedure Node_Set_Selectable (Ctree      : access Gtk_Ctree_Record;
                                  Node       : in     Gtk_Ctree_Node;
                                  Selectable : in     Boolean);

   procedure Node_Set_Shift (Ctree      : access Gtk_Ctree_Record;
                             Node       : in     Gtk_Ctree_Node;
                             Column     : in     Gint;
                             Vertical   : in     Gint;
                             Horizontal : in     Gint);

   procedure Node_Set_Text (Ctree  : access Gtk_Ctree_Record;
                            Node   : in     Gtk_Ctree_Node;
                            Column : in     Gint;
                            Text   : in     String);

   --  Post_Recursive
   --  Post_Recursive_To_Depth
   --  Pre_Recursive
   --  Pre_Recursive_To_Depth

   procedure Real_Select_Recursive (Ctree : access Gtk_Ctree_Record;
                                    Node  : in     Gtk_Ctree_Node;
                                    State : in     Gint);

   procedure Remove_Node (Ctree : access Gtk_Ctree_Record;
                          Node  : in     Gtk_Ctree_Node);

   procedure Select_Recursive (Ctree : access Gtk_Ctree_Record;
                               Node  : in     Gtk_Ctree_Node);

   --  Set_Drag_Compare_Func

   procedure Set_Expander_Style
     (Ctree          : access Gtk_Ctree_Record;
      Expander_Style : in     Gtk_Ctree_Expander_Style);

   procedure Set_Indent (Ctree  : access Gtk_Ctree_Record;
                         Indent : in     Gint);

   procedure Set_Line_Style (Ctree      : access Gtk_Ctree_Record;
                             Line_Style : in     Gtk_Ctree_Line_Style);

   procedure Set_Node_Info (Ctree         : access Gtk_Ctree_Record;
                            Node          : in     Gtk_Ctree_Node;
                            Text          : in     String;
                            Spacing       : in     Guint8;
                            Pixmap_Closed : in     Gdk.Pixmap.Gdk_Pixmap;
                            Mask_Closed   : in     Gdk.Bitmap.Gdk_Bitmap;
                            Pixmap_Opened : in     Gdk.Pixmap.Gdk_Pixmap;
                            Mask_Opened   : in     Gdk.Bitmap.Gdk_Bitmap;
                            Is_Leaf       : in     Boolean;
                            Expanded      : in     Boolean);

   procedure Set_Show_Stub (Ctree     : access Gtk_Ctree_Record;
                            Show_Stub : in     Boolean);

   procedure Set_Spacing (Ctree   : access Gtk_Ctree_Record;
                          Spacing : in     Gint);

   procedure Sort_Node (Ctree : access Gtk_Ctree_Record;
                        Node  : in     Gtk_Ctree_Node);

   procedure Sort_Recursive (Ctree : access Gtk_Ctree_Record;
                             Node  : in     Gtk_Ctree_Node);

   procedure Toggle_Expansion (Ctree : access Gtk_Ctree_Record;
                               Node  : in     Gtk_Ctree_Node);

   procedure Toggle_Expansion_Recursive (Ctree : access Gtk_Ctree_Record;
                                         Node  : in     Gtk_Ctree_Node);

   procedure Unselect (Ctree : access Gtk_Ctree_Record;
                       Node  : in     Gtk_Ctree_Node);

   procedure Unselect_Recursive (Ctree : access Gtk_Ctree_Record;
                                 Node  : in     Gtk_Ctree_Node);

private

   type Gtk_Ctree_Record is new Gtk.Clist.Gtk_Clist_Record with null record;

end Gtk.Ctree;
