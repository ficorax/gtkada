package Gtk.Widget is
   function Requisition_Get_Type return Glib.GType;
   pragma Import (C, Requisition_Get_Type, "gtk_requisition_get_type");
   --  Return the internal type for a Gtk_Requisition

   -------------------------
   -- Widgets' life cycle --
   -------------------------

   procedure Destroy (Widget : access Gtk_Widget_Record);
   --  Destroy the widget.
   --  This emits a "destroy" signal, calls all your handlers, and then
   --  unconnects them all. The object is then unref-ed, and if its reference
   --  count goes down to 0, the memory associated with the object and its
   --  user data is freed.
   --  Note that when you destroy handlers are called, the user_data is still
   --  available.
   --
   --  When a widget is destroyed, it will break any references it holds to
   --  other objects. If the widget is inside a container, the widget will be
   --  removed from the container. If the widget is a toplevel (derived from
   --  Gtk_Window), it will be removed from the list of toplevels, and the
   --  reference GTK+ holds to it will be removed. Removing widget from its
   --  container or the list of toplevels results in the widget being
   --  finalized, unless you've added additional references to the widget with
   --  Ref.
   --
   --  In most cases, only toplevel widgets (windows) require explicit
   --  destruction, because when you destroy a toplevel its children will be
   --  destroyed as well.

   procedure Destroy_Cb (Widget : access Gtk_Widget_Record'Class);
   --  This function should be used as a callback to destroy a widget.
   --  All it does is call Destroy on its argument, but its profile is
   --  compatible with the handlers found in Gtk.Handlers.

   generic
      type Widget_Type is new Gtk_Widget_Record with private;
      with procedure Realize_Proc (Widget : access Widget_Type'Class);
   package Realize_Handling is

      procedure Set_Realize (Widget : access Gtk_Widget_Record'Class);
      --  Set the realize handler at the low level.
      --  This is needed to replace the default realize in new widgets.

   private
      --  <doc_ignore>
      procedure Internal_Realize (Widget : System.Address);
      --  The wrapper passed to Gtk+.
      pragma Convention (C, Internal_Realize);
      --  </doc_ignore>
   end Realize_Handling;

   -----------
   -- Styles --
   ------------

   procedure Modify_Fg
     (Widget     : access Gtk_Widget_Record;
      State_Type : Enums.Gtk_State_Type;
      Color      : Gdk.Color.Gdk_Color);
   procedure Modify_Bg
     (Widget     : access Gtk_Widget_Record;
      State_Type : Enums.Gtk_State_Type;
      Color      : Gdk.Color.Gdk_Color);
   pragma Obsolescent (Modify_Bg);

   procedure Override_Background_Color
      (Widget : not null access Gtk_Widget_Record;
       State  : Enums.Gtk_State_Type;
       Color  : Gdk.RGBA.Gdk_RGBA := Gdk.RGBA.Null_RGBA);
   --  Sets the background color to use for a widget.
   --  Set to Null_RGBA to undo the effect of a previous call.

   procedure Modify_Text
     (Widget     : access Gtk_Widget_Record;
      State_Type : Enums.Gtk_State_Type;
      Color      : Gdk.Color.Gdk_Color);

   procedure Modify_Base
     (Widget     : access Gtk_Widget_Record;
      State_Type : Enums.Gtk_State_Type;
      Color      : Gdk.Color.Gdk_Color);

   -------------------
   -- Widgets' tree --
   -------------------

   function Path          (Widget : access Gtk_Widget_Record) return String;

   function Class_Path (Widget : access Gtk_Widget_Record) return String;

   procedure Translate_Coordinates
     (Src_Widget  : Gtk_Widget;
      Dest_Widget : Gtk_Widget;
      Src_X       : Gint;
      Src_Y       : Gint;
      Dest_X      : out Gint;
      Dest_Y      : out Gint;
      Result      : out Boolean);
   --  Translate coordinates relative to Src_Widget's allocation to coordinates
   --  relative to Dest_Widget's allocations. In order to perform this
   --  operation, both widgets must be realized, and must share a common
   --  toplevel.
   --
   --  Result is set to False if either widget was not realized, or there
   --  was no common ancestor. In this case, nothing is stored in Dest_X and
   --  Dest_Y. Otherwise True.

   --------------------
   -- Misc functions --
   --------------------

   function Intersect
     (Widget       : access Gtk_Widget_Record;
      Area         : Gdk.Rectangle.Gdk_Rectangle;
      Intersection : access Gdk.Rectangle.Gdk_Rectangle) return Boolean;
   --  Return True if the widget intersects the screen area Area.
   --  The intersection area is returned in Intersection.

   function Region_Intersect
     (Widget : access Gtk_Widget_Record;
      Region : Cairo.Region.Cairo_Region)
      return Cairo.Region.Cairo_Region;
   --  Region must be in the same coordinate system as the widget's allocation,
   --  ie relative to the widget's window, or to the parent's window for
   --  No_Window widgets.
   --  Returns a newly allocated region. The coordinats are in the same system
   --  as described above.
   --  Computes the intersection of a Widget's area and Region, returning
   --  the intersection. The result may be empty, use gdk.region.empty to
   --  check.

   --------------
   -- Tooltips --
   --------------

   function Get_Tooltip_Text
     (Widget : access Gtk_Widget_Record) return UTF8_String;
   function Get_Tooltip_Markup
     (Widget : access Gtk_Widget_Record) return UTF8_String;

   --------------------------
   -- Creating new widgets --
   --------------------------
   --  Although the core subprogram for creating new widgets is
   --  Glib.Gobjects.Initialize_Class_Record, it is often useful to override
   --  some internal pointers to functions.
   --  The functions below are not needed unless you are writting your own
   --  widgets, and should be reserved for advanced customization of the
   --  standard widgets.

   type Size_Allocate_Handler is access procedure
     (Widget : System.Address; Allocation : Gtk_Allocation);
   pragma Convention (C, Size_Allocate_Handler);
   --  Widget is the gtk+ C widget, that needs to be converted to Ada through
   --  a call to:
   --    declare
   --       Stub : Gtk_Widget_Record; --  or the exact type you expect
   --    begin
   --       My_Widget := Gtk_Widget (Glib.Object.Get_User_Data (Widget, Stub);
   --    end;

   procedure Set_Default_Size_Allocate_Handler
     (Klass   : Glib.Object.GObject_Class;
      Handler : Size_Allocate_Handler);
   pragma Import (C, Set_Default_Size_Allocate_Handler,
                  "ada_gtk_widget_set_default_size_allocate_handler");
   --  Override the default size_allocate handler for this class. This handler
   --  is automatically called in several cases (when a widget is dynamically
   --  resized for instance), not through a signal. Thus, if you need to
   --  override the default behavior provided by one of the standard
   --  containers, you can not simply use Gtk.Handlers.Emit_Stop_By_Name, and
   --  you must override the default handler. Note also that this handler
   --  is automatically inherited by children of this class.

   procedure Set_Allocation
     (Widget : access Gtk_Widget_Record'Class; Alloc : Gtk_Allocation);
   --  Modifies directly the internal field of Widget to register the new
   --  allocation.
   --  Beware that the only use of this method is inside a callback set
   --  by Set_Default_Size_Allocate_Handler. If you simply want to resize
   --  or reposition a widget, use Size_Allocate instead.

   --------------------
   -- GValue support --
   --------------------

   function Get_Requisition
     (Value : Glib.Values.GValue) return Gtk_Requisition_Access;
   --  Convert a value into a Gtk_Requisition_Access.

   function Get_Allocation
     (Value : Glib.Values.GValue) return Gtk_Allocation_Access;
   --  Convert a value into a Gtk_Allocation_Access.

end Gtk.Widget;
