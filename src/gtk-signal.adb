with Unchecked_Conversion;
with Unchecked_Deallocation;

package body Gtk.Signal is

   ---------------
   --  Callback --
   ---------------

   package body Callback is

      type Data_Type_Record is
         record
            Data : aliased Data_Type;
            Func : Callback;
         end record;

      type Data_Type_Access is access all Data_Type_Record;
      function Convert is new Unchecked_Conversion (Data_Type_Access,
                                                    System.Address);

      procedure Free (Data : in out Data_Type_Access);
      --  Free the memory associated with the callback's data

      procedure General_Cb (Widget : System.Address;
                            Data   : access Data_Type_Record);
      --  This is the only real callback function which is called from
      --  C. It dispatches the call to the real callback, after converting
      --  the widget from a C pointer to an Ada Widget type

      ----------------
      -- General_Cb --
      ----------------

      procedure General_Cb (Widget : System.Address;
                            Data   : access Data_Type_Record)
      is
         AWidget : aliased Widget_Type;
      begin
         Set_Object (AWidget, Widget);
         Data.Func (AWidget, Data.Data);
      end General_Cb;

      ----------
      -- Free --
      ----------

      procedure Free (Data : in out Data_Type_Access) is
         procedure Internal is new Unchecked_Deallocation (Data_Type_Record,
                                                           Data_Type_Access);
      begin
         Internal (Data);
      end Free;

      -------------
      -- Connect --
      -------------

      function Connect
        (Obj       : in Widget_Type'Class;
         Name      : in String;
         Func      : in Callback;
         Func_Data : in Data_Type)
         return Guint
      is
         function Internal (Obj       : System.Address;
                            Name      : String;
                            Func      : System.Address;
                            Func_Data : System.Address;
                            Destroy   : System.Address)
                            return Guint;
         pragma Import (C, Internal, "ada_gtk_signal_connect");
         D : Data_Type_Access := new Data_Type_Record'(Data => Func_Data,
                                                       Func => Func);
      begin
         return Internal (Get_Object (Obj), Name & Ascii.NUL,
                          General_Cb'Address, Convert (D), Free'Address);
      end Connect;

      -------------------
      -- Connect_After --
      -------------------

      function Connect_After
        (Obj       : in Widget_Type'Class;
         Name      : in String;
         Func      : in Callback;
         Func_Data : in Data_Type)
         return Guint
      is
         function Internal (Obj       : System.Address;
                            Name      : String;
                            Func      : System.Address;
                            Func_Data : System.Address;
                            Destroy   : System.Address)
                            return Guint;
         pragma Import (C, Internal, "ada_gtk_signal_connect_after");
         D : Data_Type_Access := new Data_Type_Record'(Data => Func_Data,
                                                       Func => Func);
      begin
         return Internal (Get_Object (Obj), Name & Ascii.NUL,
                          General_Cb'Address, Convert (D), Free'Address);
      end Connect_After;

      ----------------
      -- Disconnect --
      ----------------

      procedure Disconnect (Object     : in Widget_Type;
                            Handler_Id : in Guint) is
         procedure Internal (Object : System.Address;
                             Id     : Guint);
         pragma Import (C, Internal, "gtk_signal_disconnect");
      begin
         Internal (Get_Object (Object), Handler_Id);
      end Disconnect;

      -------------------
      -- Handler_Block --
      -------------------

      procedure Handler_Block (Obj        : in Widget_Type'Class;
                               Handler_Id : in Guint)
      is
         procedure Internal (Obj        : in System.Address;
                             Handler_Id : in Guint);
         pragma Import (C, Internal, "gtk_signal_handler_block");
      begin
         Internal (Get_Object (Obj), Handler_Id);
      end Handler_Block;

      ---------------------
      -- Handler_Unblock --
      ---------------------

      procedure Handler_Unblock (Obj        : in Widget_Type'Class;
                                 Handler_Id : in Guint)
      is
         procedure Internal (Obj        : in System.Address;
                             Handler_Id : in Guint);
         pragma Import (C, Internal, "gtk_signal_handler_unblock");
      begin
         Internal (Get_Object (Obj), Handler_Id);
      end Handler_Unblock;


      -------------------------------
      --  Void_Callback_Procedure  --
      -------------------------------

      procedure Void_Callback_Procedure (Widget : in out Widget_Type'Class;
                                         Data   : in     Data_Type) is
      begin
         null;
      end Void_Callback_Procedure;

   end Callback;

   ------------------------------------------------------------
   -- Void_Callback                                          --
   ------------------------------------------------------------

   package body Void_Callback is

      type Data_Type_Record is
         record
            Func : Callback;
         end record;

      type Data_Type_Access is access all Data_Type_Record;
      function Convert is new Unchecked_Conversion (Data_Type_Access,
                                                    System.Address);

      procedure Free (Data : in out Data_Type_Access);

      procedure General_Cb (Widget : System.Address;
                            Data   : access Data_Type_Record);

      ----------
      -- Free --
      ----------

      procedure Free (Data : in out Data_Type_Access) is
         procedure Internal is new Unchecked_Deallocation (Data_Type_Record,
                                                           Data_Type_Access);
      begin
         Internal (Data);
      end Free;

      ----------------
      -- General_Cb --
      ----------------

      procedure General_Cb (Widget : System.Address;
                            Data   : access Data_Type_Record)
      is
         AWidget : aliased Widget_Type;
      begin
         Set_Object (AWidget, Widget);
         Data.Func (AWidget);
      end General_Cb;

      -------------
      -- Connect --
      -------------

      function Connect
        (Obj  : in Widget_Type'Cl   ass;
         Name : in String;
         Func : in Callback)
         return Guint
      is
         function Internal (Obj       : System.Address;
                            Name      : String;
                            Func      : System.Address;
                            Func_Data : System.Address;
                            Destroy   : System.Address)
                            return Guint;
         pragma Import (C, Internal, "ada_gtk_signal_connect");
         D : Data_Type_Access := new Data_Type_Record'(Func => Func);
      begin
         return Internal (Get_Object (Obj), Name & Ascii.NUL,
                          General_Cb'Address, Convert (D), Free'Address);
      end Connect;

      -------------------
      -- Connect_After --
      -------------------

      function Connect_After
        (Obj  : in Widget_Type'Class;
         Name : in String;
         Func : in Callback)
         return Guint
      is
         function Internal (Obj       : System.Address;
                            Name      : String;
                            Func      : System.Address;
                            Func_Data : System.Address;
                            Destroy   : System.Address)
                            return Guint;
         pragma Import (C, Internal, "ada_gtk_signal_connect_after");
         D : Data_Type_Access := new Data_Type_Record'(Func => Func);
      begin
         return Internal (Get_Object (Obj), Name & Ascii.NUL,
                          General_Cb'Address, Convert (D), Free'Address);
      end Connect_After;

      ----------------
      -- Disconnect --
      ----------------

      procedure Disconnect (Object     : in Widget_Type;
                            Handler_Id : in Guint) is
         procedure Internal (Object : System.Address;
                             Id     : Guint);
         pragma Import (C, Internal, "gtk_signal_disconnect");
      begin
         Internal (Get_Object (Object), Handler_Id);
      end Disconnect;

      -------------------
      -- Handler_Block --
      -------------------

      procedure Handler_Block (Obj        : in Widget_Type'Class;
                               Handler_Id : in Guint)
      is
         procedure Internal (Obj        : in System.Address;
                             Handler_Id : in Guint);
         pragma Import (C, Internal, "gtk_signal_handler_block");
      begin
         Internal (Get_Object (Obj), Handler_Id);
      end Handler_Block;

      ---------------------
      -- Handler_Unblock --
      ---------------------

      procedure Handler_Unblock (Obj        : in Widget_Type'Class;
                                 Handler_Id : in Guint)
      is
         procedure Internal (Obj        : in System.Address;
                             Handler_Id : in Guint);
         pragma Import (C, Internal, "gtk_signal_handler_unblock");
      begin
         Internal (Get_Object (Obj), Handler_Id);
      end Handler_Unblock;


      -------------------------------
      --  Void_Callback_Procedure  --
      -------------------------------

      procedure Void_Callback_Procedure (Widget : in out Widget_Type'Class) is
      begin
         null;
      end Void_Callback_Procedure;

   end Void_Callback;


   ---------------------------------------------------------------
   -- Object_Callback                                           --
   ---------------------------------------------------------------

   package body Object_Callback is

      type Data_Type_Record is
         record
            Func : Callback;
            Data : aliased Widget_Type;
         end record;

      type Data_Type_Access is access all Data_Type_Record;
      function Convert is new Unchecked_Conversion (Data_Type_Access,
                                                    System.Address);

      procedure Free (Data : in out Data_Type_Access);
      procedure General_Cb (Widget : System.Address;
                            Data   : access Data_Type_Record);

      ----------
      -- Free --
      ----------

      procedure Free (Data : in out Data_Type_Access) is
         procedure Internal is new Unchecked_Deallocation (Data_Type_Record,
                                                           Data_Type_Access);
      begin
         Internal (Data);
      end Free;

      ----------------
      -- General_Cb --
      ----------------

      procedure General_Cb (Widget : System.Address;
                            Data   : access Data_Type_Record)
      is
      begin
         Data.Func (Data.Data);
      end General_Cb;

      -------------
      -- Connect --
      -------------

      function Connect
        (Obj         : in Object.Gtk_Object'Class;
         Name        : in String;
         Func        : in Callback;
         Slot_Object : in Widget_Type)
         return Guint
      is
         function Internal (Obj       : System.Address;
                            Name      : String;
                            Func      : System.Address;
                            Func_Data : System.Address;
                            Destroy   : System.Address)
                            return Guint;
         pragma Import (C, Internal, "ada_gtk_signal_connect");
         D : Data_Type_Access := new Data_Type_Record'(Data => Slot_Object,
                                                       Func => Func);
      begin
         return Internal (Get_Object (Obj), Name & Ascii.NUL,
                          General_Cb'Address, Convert (D), Free'Address);
      end Connect;

      -------------------
      -- Connect_After --
      -------------------

      function Connect_After
        (Obj         : in Object.Gtk_Object'Class;
         Name        : in String;
         Func        : in Callback;
         Slot_Object : in Widget_Type)
         return Guint
      is
         function Internal (Obj       : System.Address;
                            Name      : String;
                            Func      : System.Address;
                            Func_Data : System.Address;
                            Destroy   : System.Address)
                            return Guint;
         pragma Import (C, Internal, "ada_gtk_signal_connect_after");
         D : Data_Type_Access := new Data_Type_Record'(Data => Slot_Object,
                                                       Func => Func);
      begin
         return Internal (Get_Object (Obj), Name & Ascii.NUL,
                          General_Cb'Address, Convert (D), Free'Address);
      end Connect_After;

      ----------------
      -- Disconnect --
      ----------------

      procedure Disconnect (Object     : in Widget_Type;
                            Handler_Id : in Guint) is
         procedure Internal (Object : System.Address;
                             Id     : Guint);
         pragma Import (C, Internal, "gtk_signal_disconnect");
      begin
         Internal (Get_Object (Object), Handler_Id);
      end Disconnect;

      -------------------
      -- Handler_Block --
      -------------------

      procedure Handler_Block (Obj        : in Object.Gtk_Object'Class;
                               Handler_Id : in Guint)
      is
         procedure Internal (Obj        : in System.Address;
                             Handler_Id : in Guint);
         pragma Import (C, Internal, "gtk_signal_handler_block");
      begin
         Internal (Get_Object (Obj), Handler_Id);
      end Handler_Block;

      ---------------------
      -- Handler_Unblock --
      ---------------------

      procedure Handler_Unblock (Obj        : in Object.Gtk_Object'Class;
                                 Handler_Id : in Guint)
      is
         procedure Internal (Obj        : in System.Address;
                             Handler_Id : in Guint);
         pragma Import (C, Internal, "gtk_signal_hand_unblock");
      begin
         Internal (Get_Object (Obj), Handler_Id);
      end Handler_Unblock;


   end Object_Callback;




   ----------------------
   -- Handlers_Destroy --
   ----------------------

   procedure Handlers_Destroy (Obj : in Object.Gtk_Object'Class)
   is
      procedure Internal (Obj : System.Address);
      pragma Import (C, Internal, "gtk_signal_handlers_destroy");
   begin
      Internal (Get_Object (Obj));
   end Handlers_Destroy;

end Gtk.Signal;
