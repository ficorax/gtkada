with Gdk.Bitmap; use Gdk.Bitmap;
with Gdk.Color;  use Gdk.Color;
with Gdk.Pixmap; use Gdk.Pixmap;
with Gdk.Window; use Gdk.Window;
with Glib; use Glib;
with Gtk.Box; use Gtk.Box;
with Gtk.Button; use Gtk.Button;
with Gtk.Check_Button; use Gtk.Check_Button;
with Gtk.Container; use Gtk.Container;
with Gtk.Enums; use Gtk.Enums;
with Gtk.GEntry; use Gtk.GEntry;
with Gtk.Frame; use Gtk.Frame;
with Gtk.HSeparator; use Gtk.HSeparator;
with Gtk.Hbox; use Gtk.Hbox;
with Gtk.Hseparator; use Gtk.Hseparator;
with Gtk.Label; use Gtk.Label;
with Gtk.Menu; use Gtk.Menu;
with Gtk.Misc; use Gtk.Misc;
with Gtk.Notebook; use Gtk.Notebook;
with Gtk.Object; use Gtk.Object;
with Gtk.Option_Menu; use Gtk.Option_Menu;
with Gtk.Pixmap; use Gtk.Pixmap;
with Gtk.Radio_Menu_Item; use Gtk.Radio_Menu_Item;
with Gtk.Signal; use Gtk.Signal;
with Gtk.Toggle_Button; use Gtk.Toggle_Button;
with Gtk.Vbox; use Gtk.Vbox;
with Gtk.Widget; use Gtk.Widget;
with Gtk.Window; use Gtk.Window;
with Gtk; use Gtk;

with Interfaces.C.Strings;

package body Create_Notebook is

   package Widget_Cb is new Signal.Object_Callback (Gtk_Widget);
   package Note_Cb is new Signal.Object_Callback (Gtk_Notebook);
   package Button_Cb is new Signal.Callback (Gtk_Check_Button, Gtk_Notebook);
   package Two_Cb is new Signal.Two_Callback (Gtk_Notebook, Gtk_Notebook,
                                              Gtk_Notebook_Page);

   Window           : Gtk_Window;
   Book_Open        : Gdk_Pixmap;
   Book_Open_Mask   : Gdk_Bitmap;
   Book_Closed      : Gdk_Pixmap;
   Book_Closed_Mask : Gdk_Bitmap;

   package ICS renames Interfaces.C.Strings;
   Book_Open_Xpm    : ICS.chars_ptr_array :=
     (ICS.New_String ("16 16 4 1"),
      ICS.New_String ("       c None s None"),
      ICS.New_String (".      c black"),
      ICS.New_String ("X      c #808080"),
      ICS.New_String ("o      c white"),
      ICS.New_String ("                "),
      ICS.New_String ("  ..            "),
      ICS.New_String (" .Xo.    ...    "),
      ICS.New_String (" .Xoo. ..oo.    "),
      ICS.New_String (" .Xooo.Xooo...  "),
      ICS.New_String (" .Xooo.oooo.X.  "),
      ICS.New_String (" .Xooo.Xooo.X.  "),
      ICS.New_String (" .Xooo.oooo.X.  "),
      ICS.New_String (" .Xooo.Xooo.X.  "),
      ICS.New_String (" .Xooo.oooo.X.  "),
      ICS.New_String ("  .Xoo.Xoo..X.  "),
      ICS.New_String ("   .Xo.o..ooX.  "),
      ICS.New_String ("    .X..XXXXX.  "),
      ICS.New_String ("    ..X.......  "),
      ICS.New_String ("     ..         "),
      ICS.New_String ("                "));
   Book_Closed_Xpm  : ICS.chars_ptr_array :=
     (ICS.New_String ("16 16 6 1"),
      ICS.New_String ("       c None s None"),
      ICS.New_String (".      c black"),
      ICS.New_String ("X      c red"),
      ICS.New_String ("o      c yellow"),
      ICS.New_String ("O      c #808080"),
      ICS.New_String ("#      c white"),
      ICS.New_String ("                "),
      ICS.New_String ("       ..       "),
      ICS.New_String ("     ..XX.      "),
      ICS.New_String ("   ..XXXXX.     "),
      ICS.New_String (" ..XXXXXXXX.    "),
      ICS.New_String (".ooXXXXXXXXX.   "),
      ICS.New_String ("..ooXXXXXXXXX.  "),
      ICS.New_String (".X.ooXXXXXXXXX. "),
      ICS.New_String (".XX.ooXXXXXX..  "),
      ICS.New_String (" .XX.ooXXX..#O  "),
      ICS.New_String ("  .XX.oo..##OO. "),
      ICS.New_String ("   .XX..##OO..  "),
      ICS.New_String ("    .X.#OO..    "),
      ICS.New_String ("     ..O..      "),
      ICS.New_String ("      ..        "),
      ICS.New_String ("                "));


   procedure Create_Pages (Notebook  : in out Gtk_Notebook'Class;
                           The_Start : Gint;
                           The_End   : Gint) is
      Child     : Gtk_Widget;
      Label_Box : Gtk_Hbox;
      Menu_Box  : Gtk_Hbox;
      Pixmap    : Gtk_Pixmap;
      Label     : Gtk_Label;
   begin
      for I in The_Start .. The_End loop
         case I mod 4 is
            when 3 =>
               declare
                  Tmp : Gtk_Button;
               begin
                  Gtk_New (Tmp, "Page" & Gint'Image (I));
                  Border_Width (Tmp, 10);
                  Child := Gtk_Widget (Tmp);
               end;
            when 2 =>
               declare
                  Tmp : Gtk_Label;
               begin
                  Gtk_New (Tmp, "Page" & Gint'Image (I));
                  Child := Gtk_Widget (Tmp);
               end;
            when 1 =>
               declare
                  Tmp    : Gtk_Frame;
                  Box    : Gtk_Vbox;
                  Label  : Gtk_Label;
                  TEntry : Gtk_Entry;
                  Hbox   : Gtk_Hbox;
                  Button : Gtk_Button;
               begin
                  Gtk_New (Tmp, "Page" & Gint'Image (I));
                  Border_Width (Tmp, 10);
                  Child := Gtk_Widget (Tmp);

                  Gtk_New (Box, True, 0);
                  Border_Width (Box, 10);
                  Add (Tmp, Box);

                  Gtk_New (Label, "Page" & Gint'Image (I));
                  Pack_Start (Box, Label, True, True, 5);

                  Gtk_New (TEntry);
                  Pack_Start (Box, TEntry, True, True, 5);

                  Gtk_New (Hbox, True, 0);
                  Pack_Start (Box, Hbox, True, True, 5);

                  Gtk_New (Button, "Ok");
                  Pack_Start (Hbox, Button, True, True, 5);

                  Gtk_New (Button, "Cancel");
                  Pack_Start (Hbox, Button, True, True, 5);
               end;
            when 0 =>
               declare
                  Tmp   : Gtk_Frame;
                  Label : Gtk_Label;
               begin
                  Gtk_New (Tmp, "Page" & Gint'Image (I));
                  Border_Width (Tmp, 10);
                  Gtk_New (Label, "Page" & Gint'Image (I));
                  Add (Tmp, Label);
                  Child := Gtk_Widget (Tmp);
               end;
            when others => null;
         end case;

         Show_All (Child);

         Gtk_New (Label_Box, False, 0);
         Gtk_New (Pixmap, Book_Closed, Book_Closed_Mask);
         Pack_Start (Label_Box, Pixmap, False, True, 0);
         Set_Padding (Pixmap, 3, 1);

         Gtk_New (Label, "Page" & Gint'Image (I));
         Pack_Start (Label_Box, Label, False, True, 0);
         Show_All (Label_Box);

         Gtk_New (Menu_Box, False, 0);
         Gtk_New (Pixmap, Book_Closed, Book_Closed_Mask);
         Pack_Start (Menu_Box, Pixmap, False, True, 0);
         Set_Padding (Pixmap, 3, 1);

         Gtk_New (Label, "Page" & Gint'Image (I));
         Pack_Start (Menu_Box, Label, False, True, 0);
         Show_All (Menu_Box);

         Append_Page_Menu (Notebook, Child, Label_Box, Menu_Box);
      end loop;
   end Create_Pages;

   procedure Rotate_Notebook (Notebook : in out Gtk_Notebook'Class) is
   begin
      Set_Tab_Pos (Notebook,
                   Gtk_Position_Type'Val
                   ((Gtk_Position_Type'Pos (Get_Tab_Pos (Notebook)) + 1)
                    mod 4));
   end Rotate_Notebook;

   procedure Standard_Notebook (Notebook : in out Gtk_Notebook'Class) is
   begin
      Set_Show_Tabs (Notebook, True);
      Set_Scrollable (Notebook, False);
      if Children_List.Length (Get_Children (Notebook)) = 15 then
         for I in 0 .. 9 loop
            Remove_Page (Notebook, 5);
         end loop;
      end if;
   end Standard_Notebook;

   procedure Notabs_Notebook (Notebook : in out Gtk_Notebook'Class) is
   begin
      Set_Show_Tabs (Notebook, False);
      if Children_List.Length (Get_Children (Notebook)) = 15 then
         for I in 0 .. 9 loop
            Remove_Page (Notebook, 5);
         end loop;
      end if;
   end Notabs_Notebook;

   procedure Scrollable_Notebook (Notebook : in out Gtk_Notebook'Class) is
   begin
      Set_Show_Tabs (Notebook, True);
      Set_Scrollable (Notebook, True);
      if Children_List.Length (Get_Children (Notebook)) = 5 then
         Create_Pages (Notebook, 6, 15);
      end if;
   end Scrollable_Notebook;

   procedure Notebook_Popup (Button : in out Gtk_Check_Button'Class;
                             Notebook : in out Gtk_Notebook) is
   begin
      if Is_Active (Button) then
         Popup_Enable (Notebook);
      else
         Popup_Disable (Notebook);
      end if;
   end Notebook_Popup;

   procedure Page_Switch (Notebook : in out Gtk_Notebook'Class;
                          Page     : in out Gtk_Notebook_Page;
                          Page_Num : in out Gtk_Notebook)
   is
      function Convert is new Gtk.Unchecked_Cast (Gtk_Pixmap);
      Old_Page : Gtk_Notebook_Page := Get_Cur_Page (Notebook);
      Box      : Gtk_Box;
      Pixmap   : Gtk_Pixmap;
   begin
      if Old_Page = Page then
         raise Constraint_Error;
         return;
      end if;

      Pixmap := Convert (Get_Child (Get_Tab_Label (Page), 0));
      Set (Pixmap, Book_Open, Book_Open_Mask);
      Pixmap := Convert (Get_Child (Get_Menu_Label (Page), 0));
      Set (Pixmap, Book_Open, Book_Open_Mask);

      if Is_Created (Old_Page) then
         Pixmap := Convert (Get_Child (Get_Tab_Label (Old_Page), 0));
         Set (Pixmap, Book_Closed, Book_Closed_Mask);
         Pixmap := Convert (Get_Child (Get_Menu_Label (Old_Page), 0));
         Set (Pixmap, Book_Closed, Book_Closed_Mask);
      end if;
   end Page_Switch;

   procedure Run (Widget : in out Gtk.Button.Gtk_Button'Class) is
      Id              : Guint;
      Box1            : Gtk_Vbox;
      Box2            : Gtk_Hbox;
      Notebook        : Gtk_Notebook;
      Transparent     : Gdk_Color;
      Separator       : Gtk_HSeparator;
      Option_Menu     : Gtk_Option_Menu;
      Menu            : Gtk_Menu;
      Menu_Item       : Gtk_Radio_Menu_Item;
      Group           : Gtk.Radio_Menu_Item.Widget_SList.GSlist;
      Button          : Gtk_Check_Button;
      Button2         : Gtk_Button;
   begin
      if not Is_Created (Window) then
         Gtk_New (Window, Window_Toplevel);
         Id := Widget_Cb.Connect (Window, "destroy", Destroy'Access, Window);
         Set_Title (Window, "notebook");
         Border_Width (Window, Border_Width => 0);

         Gtk_New (Box1, False, 0);
         Add (Window, Box1);

         Gtk_New (Notebook);
         Id := Two_Cb.Connect (Notebook, "switch_page", Page_Switch'Access,
                               Notebook);
         Set_Tab_Pos (Notebook, Pos_Top);
         Pack_Start (Box1, Notebook, True, True, 0);
         Border_Width (Notebook, 10);
         Realize (Notebook);

         Create_From_Xpm_D (Book_Open,
                            Get_Window (Notebook),
                            Book_Open_Mask, Transparent,
                            Book_Open_Xpm);
         Create_From_Xpm_D (Book_Closed,
                            Get_Window (Notebook),
                            Book_Closed_Mask, Transparent,
                            Book_Closed_Xpm);

         Create_Pages (Notebook, 1, 5);

         Gtk_New (Separator);
         Pack_Start (Box1, Separator, False, True, 10);

         Gtk_New (Box2, True, 5);
         Pack_Start (Box1, Box2, False, True, 0);

         Gtk_New (Option_Menu);
         Gtk_New (Menu);

         Gtk_New (Menu_Item, Group, "Standard");
         Id := Note_Cb.Connect (Menu_Item, "activate",
                                Standard_Notebook'Access, Notebook);
         Group := Gtk.Radio_Menu_Item.Group (Menu_Item);
         Append (Menu, Menu_Item);
         Show (Menu_Item);

         Gtk_New (Menu_Item, Group, "w/o Tabs");
         Id := Note_Cb.Connect (Menu_Item, "activate",
                                Notabs_Notebook'Access, Notebook);
         Group := Gtk.Radio_Menu_Item.Group (Menu_Item);
         Append (Menu, Menu_Item);
         Show (Menu_Item);

         Gtk_New (Menu_Item, Group, "Scrollable");
         Id := Note_Cb.Connect (Menu_Item, "activate",
                                Scrollable_Notebook'Access, Notebook);
         Group := Gtk.Radio_Menu_Item.Group (Menu_Item);
         Append (Menu, Menu_Item);
         Show (Menu_Item);

         Set_Menu (Option_Menu, Menu);
         Pack_Start (Box2, Option_Menu, False, False, 0);
         Gtk_New (Button, "enable popup menu");
         Pack_Start (Box2, Button, False, False, 0);
         Id := Button_Cb.Connect (Button, "clicked",
                                  Notebook_Popup'Access, Notebook);

         Gtk_New (Box2, False, 10);
         Border_Width (Box2, 10);
         Pack_Start (Box1, Box2, False, True, 0);

         Gtk_New (Button2, "Close");
         Id := Widget_Cb.Connect (Button2, "clicked", Destroy'Access, Window);
         Pack_Start (Box2, Button2, True, True, 0);
         Set_Flags (Button2, Can_Default);
         Grab_Default (Button2);

         Gtk_New (Button2, "next");
         Id := Note_Cb.Connect (Button2, "clicked", Next_Page'Access,
                                Notebook);
         Pack_Start (Box2, Button2, True, True, 0);

         Gtk_New (Button2, "prev");
         Id := Note_Cb.Connect (Button2, "clicked", Prev_Page'Access,
                                Notebook);
         Pack_Start (Box2, Button2, True, True, 0);

         Gtk_New (Button2, "rotate");
         Id := Note_Cb.Connect (Button2, "clicked", Rotate_Notebook'Access,
                                Notebook);
         Pack_Start (Box2, Button2, True, True, 0);

      end if;

      if not Gtk.Widget.Visible_Is_Set (Window) then
         Gtk.Widget.Show_All (Window);
      else
         Gtk.Widget.Destroy (Window);
      end if;

   end Run;

end Create_Notebook;
