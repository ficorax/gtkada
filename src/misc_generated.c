/*****************************************************************************
 *               GtkAda - Ada95 binding for Gtk+/Gnome                       *
 *                                                                           *
 *   Copyright (C) 1998-2000 E. Briot, J. Brobecker and A. Charlet           *
 *                     Copyright (C) 2000-2016, AdaCore                      *
 *                                                                           *
 * This library is free software;  you can redistribute it and/or modify it  *
 * under terms of the  GNU General Public License  as published by the Free  *
 * Software  Foundation;  either version 3,  or (at your  option) any later  *
 * version. This library is distributed in the hope that it will be useful,  *
 * but WITHOUT ANY WARRANTY;  without even the implied warranty of MERCHAN-  *
 * TABILITY or FITNESS FOR A PARTICULAR PURPOSE.                             *
 *                                                                           *
 * As a special exception under Section 7 of GPL version 3, you are granted  *
 * additional permissions described in the GCC Runtime Library Exception,    *
 * version 3.1, as published by the Free Software Foundation.                *
 *                                                                           *
 * You should have received a copy of the GNU General Public License and     *
 * a copy of the GCC Runtime Library Exception along with this program;      *
 * see the files COPYING3 and COPYING.RUNTIME respectively.  If not, see     *
 * <http://www.gnu.org/licenses/>.                                           *
 *
 *****************************************************************************

This file is automatically generated from the .gir files
*/
#include <gtk/gtk.h>

void gtkada_Actionable_set_get_action_name(GtkActionableInterface* iface, void* handler) {
    iface->get_action_name = handler;
}
void gtkada_Actionable_set_get_action_target_value(GtkActionableInterface* iface, void* handler) {
    iface->get_action_target_value = handler;
}
void gtkada_Actionable_set_set_action_name(GtkActionableInterface* iface, void* handler) {
    iface->set_action_name = handler;
}
void gtkada_Actionable_set_set_action_target_value(GtkActionableInterface* iface, void* handler) {
    iface->set_action_target_value = handler;
}
void gtkada_Cell_Editable_set_editing_done(GtkCellEditableIface* iface, void* handler) {
    iface->editing_done = handler;
}
void gtkada_Cell_Editable_set_remove_widget(GtkCellEditableIface* iface, void* handler) {
    iface->remove_widget = handler;
}
void gtkada_Cell_Editable_set_start_editing(GtkCellEditableIface* iface, void* handler) {
    iface->start_editing = handler;
}
void gtkada_Color_Chooser_set_add_palette(GtkColorChooserInterface* iface, void* handler) {
    iface->add_palette = handler;
}
void gtkada_Color_Chooser_set_color_activated(GtkColorChooserInterface* iface, void* handler) {
    iface->color_activated = handler;
}
void gtkada_Color_Chooser_set_get_rgba(GtkColorChooserInterface* iface, void* handler) {
    iface->get_rgba = handler;
}
void gtkada_Color_Chooser_set_set_rgba(GtkColorChooserInterface* iface, void* handler) {
    iface->set_rgba = handler;
}
void gtkada_Editable_set_changed(GtkEditableInterface* iface, void* handler) {
    iface->changed = handler;
}
void gtkada_Editable_set_delete_text(GtkEditableInterface* iface, void* handler) {
    iface->delete_text = handler;
}
void gtkada_Editable_set_do_delete_text(GtkEditableInterface* iface, void* handler) {
    iface->do_delete_text = handler;
}
void gtkada_Editable_set_do_insert_text(GtkEditableInterface* iface, void* handler) {
    iface->do_insert_text = handler;
}
void gtkada_Editable_set_get_chars(GtkEditableInterface* iface, void* handler) {
    iface->get_chars = handler;
}
void gtkada_Editable_set_get_position(GtkEditableInterface* iface, void* handler) {
    iface->get_position = handler;
}
void gtkada_Editable_set_get_selection_bounds(GtkEditableInterface* iface, void* handler) {
    iface->get_selection_bounds = handler;
}
void gtkada_Editable_set_insert_text(GtkEditableInterface* iface, void* handler) {
    iface->insert_text = handler;
}
void gtkada_Editable_set_set_position(GtkEditableInterface* iface, void* handler) {
    iface->set_position = handler;
}
void gtkada_Editable_set_set_selection_bounds(GtkEditableInterface* iface, void* handler) {
    iface->set_selection_bounds = handler;
}
void gtkada_Font_Chooser_set_font_activated(GtkFontChooserIface* iface, void* handler) {
    iface->font_activated = handler;
}
void gtkada_Font_Chooser_set_get_font_face(GtkFontChooserIface* iface, void* handler) {
    iface->get_font_face = handler;
}
void gtkada_Font_Chooser_set_get_font_family(GtkFontChooserIface* iface, void* handler) {
    iface->get_font_family = handler;
}
void gtkada_Font_Chooser_set_get_font_size(GtkFontChooserIface* iface, void* handler) {
    iface->get_font_size = handler;
}
void gtkada_Font_Chooser_set_set_filter_func(GtkFontChooserIface* iface, void* handler) {
    iface->set_filter_func = handler;
}
void gtkada_Print_Operation_Preview_set_end_preview(GtkPrintOperationPreviewIface* iface, void* handler) {
    iface->end_preview = handler;
}
void gtkada_Print_Operation_Preview_set_got_page_size(GtkPrintOperationPreviewIface* iface, void* handler) {
    iface->got_page_size = handler;
}
void gtkada_Print_Operation_Preview_set_is_selected(GtkPrintOperationPreviewIface* iface, void* handler) {
    iface->is_selected = handler;
}
void gtkada_Print_Operation_Preview_set_ready(GtkPrintOperationPreviewIface* iface, void* handler) {
    iface->ready = handler;
}
void gtkada_Print_Operation_Preview_set_render_page(GtkPrintOperationPreviewIface* iface, void* handler) {
    iface->render_page = handler;
}
void gtkada_Tool_Shell_set_get_ellipsize_mode(GtkToolShellIface* iface, void* handler) {
    iface->get_ellipsize_mode = handler;
}
void gtkada_Tool_Shell_set_get_icon_size(GtkToolShellIface* iface, void* handler) {
    iface->get_icon_size = handler;
}
void gtkada_Tool_Shell_set_get_orientation(GtkToolShellIface* iface, void* handler) {
    iface->get_orientation = handler;
}
void gtkada_Tool_Shell_set_get_relief_style(GtkToolShellIface* iface, void* handler) {
    iface->get_relief_style = handler;
}
void gtkada_Tool_Shell_set_get_style(GtkToolShellIface* iface, void* handler) {
    iface->get_style = handler;
}
void gtkada_Tool_Shell_set_get_text_alignment(GtkToolShellIface* iface, void* handler) {
    iface->get_text_alignment = handler;
}
void gtkada_Tool_Shell_set_get_text_orientation(GtkToolShellIface* iface, void* handler) {
    iface->get_text_orientation = handler;
}
void gtkada_Tool_Shell_set_get_text_size_group(GtkToolShellIface* iface, void* handler) {
    iface->get_text_size_group = handler;
}
void gtkada_Tool_Shell_set_rebuild_menu(GtkToolShellIface* iface, void* handler) {
    iface->rebuild_menu = handler;
}
void gtkada_Tree_Drag_Dest_set_drag_data_received(GtkTreeDragDestIface* iface, void* handler) {
    iface->drag_data_received = handler;
}
void gtkada_Tree_Drag_Dest_set_row_drop_possible(GtkTreeDragDestIface* iface, void* handler) {
    iface->row_drop_possible = handler;
}
void gtkada_Tree_Drag_Source_set_drag_data_delete(GtkTreeDragSourceIface* iface, void* handler) {
    iface->drag_data_delete = handler;
}
void gtkada_Tree_Drag_Source_set_drag_data_get(GtkTreeDragSourceIface* iface, void* handler) {
    iface->drag_data_get = handler;
}
void gtkada_Tree_Drag_Source_set_row_draggable(GtkTreeDragSourceIface* iface, void* handler) {
    iface->row_draggable = handler;
}
void gtkada_Tree_Sortable_set_get_sort_column_id(GtkTreeSortableIface* iface, void* handler) {
    iface->get_sort_column_id = handler;
}
void gtkada_Tree_Sortable_set_has_default_sort_func(GtkTreeSortableIface* iface, void* handler) {
    iface->has_default_sort_func = handler;
}
void gtkada_Tree_Sortable_set_set_default_sort_func(GtkTreeSortableIface* iface, void* handler) {
    iface->set_default_sort_func = handler;
}
void gtkada_Tree_Sortable_set_set_sort_column_id(GtkTreeSortableIface* iface, void* handler) {
    iface->set_sort_column_id = handler;
}
void gtkada_Tree_Sortable_set_set_sort_func(GtkTreeSortableIface* iface, void* handler) {
    iface->set_sort_func = handler;
}
void gtkada_Tree_Sortable_set_sort_column_changed(GtkTreeSortableIface* iface, void* handler) {
    iface->sort_column_changed = handler;
}
void gtkada_Tree_Model_set_get_column_type(GtkTreeModelIface* iface, void* handler) {
    iface->get_column_type = handler;
}
void gtkada_Tree_Model_set_get_flags(GtkTreeModelIface* iface, void* handler) {
    iface->get_flags = handler;
}
void gtkada_Tree_Model_set_get_iter(GtkTreeModelIface* iface, void* handler) {
    iface->get_iter = handler;
}
void gtkada_Tree_Model_set_get_n_columns(GtkTreeModelIface* iface, void* handler) {
    iface->get_n_columns = handler;
}
void gtkada_Tree_Model_set_get_path(GtkTreeModelIface* iface, void* handler) {
    iface->get_path = handler;
}
void gtkada_Tree_Model_set_get_value(GtkTreeModelIface* iface, void* handler) {
    iface->get_value = handler;
}
void gtkada_Tree_Model_set_iter_children(GtkTreeModelIface* iface, void* handler) {
    iface->iter_children = handler;
}
void gtkada_Tree_Model_set_iter_has_child(GtkTreeModelIface* iface, void* handler) {
    iface->iter_has_child = handler;
}
void gtkada_Tree_Model_set_iter_n_children(GtkTreeModelIface* iface, void* handler) {
    iface->iter_n_children = handler;
}
void gtkada_Tree_Model_set_iter_next(GtkTreeModelIface* iface, void* handler) {
    iface->iter_next = handler;
}
void gtkada_Tree_Model_set_iter_nth_child(GtkTreeModelIface* iface, void* handler) {
    iface->iter_nth_child = handler;
}
void gtkada_Tree_Model_set_iter_parent(GtkTreeModelIface* iface, void* handler) {
    iface->iter_parent = handler;
}
void gtkada_Tree_Model_set_iter_previous(GtkTreeModelIface* iface, void* handler) {
    iface->iter_previous = handler;
}
void gtkada_Tree_Model_set_ref_node(GtkTreeModelIface* iface, void* handler) {
    iface->ref_node = handler;
}
void gtkada_Tree_Model_set_row_changed(GtkTreeModelIface* iface, void* handler) {
    iface->row_changed = handler;
}
void gtkada_Tree_Model_set_row_deleted(GtkTreeModelIface* iface, void* handler) {
    iface->row_deleted = handler;
}
void gtkada_Tree_Model_set_row_has_child_toggled(GtkTreeModelIface* iface, void* handler) {
    iface->row_has_child_toggled = handler;
}
void gtkada_Tree_Model_set_row_inserted(GtkTreeModelIface* iface, void* handler) {
    iface->row_inserted = handler;
}
void gtkada_Tree_Model_set_rows_reordered(GtkTreeModelIface* iface, void* handler) {
    iface->rows_reordered = handler;
}
void gtkada_Tree_Model_set_unref_node(GtkTreeModelIface* iface, void* handler) {
    iface->unref_node = handler;
}
void gtkada_Action_set_activate(GActionInterface* iface, void* handler) {
    iface->activate = handler;
}
void gtkada_Action_set_change_state(GActionInterface* iface, void* handler) {
    iface->change_state = handler;
}
void gtkada_Action_set_get_enabled(GActionInterface* iface, void* handler) {
    iface->get_enabled = handler;
}
void gtkada_Action_set_get_name(GActionInterface* iface, void* handler) {
    iface->get_name = handler;
}
void gtkada_Action_set_get_parameter_type(GActionInterface* iface, void* handler) {
    iface->get_parameter_type = handler;
}
void gtkada_Action_set_get_state(GActionInterface* iface, void* handler) {
    iface->get_state = handler;
}
void gtkada_Action_set_get_state_hint(GActionInterface* iface, void* handler) {
    iface->get_state_hint = handler;
}
void gtkada_Action_set_get_state_type(GActionInterface* iface, void* handler) {
    iface->get_state_type = handler;
}
void gtkada_Action_Group_set_action_added(GActionGroupInterface* iface, void* handler) {
    iface->action_added = handler;
}
void gtkada_Action_Group_set_action_enabled_changed(GActionGroupInterface* iface, void* handler) {
    iface->action_enabled_changed = handler;
}
void gtkada_Action_Group_set_action_removed(GActionGroupInterface* iface, void* handler) {
    iface->action_removed = handler;
}
void gtkada_Action_Group_set_action_state_changed(GActionGroupInterface* iface, void* handler) {
    iface->action_state_changed = handler;
}
void gtkada_Action_Group_set_activate_action(GActionGroupInterface* iface, void* handler) {
    iface->activate_action = handler;
}
void gtkada_Action_Group_set_change_action_state(GActionGroupInterface* iface, void* handler) {
    iface->change_action_state = handler;
}
void gtkada_Action_Group_set_get_action_enabled(GActionGroupInterface* iface, void* handler) {
    iface->get_action_enabled = handler;
}
void gtkada_Action_Group_set_get_action_parameter_type(GActionGroupInterface* iface, void* handler) {
    iface->get_action_parameter_type = handler;
}
void gtkada_Action_Group_set_get_action_state(GActionGroupInterface* iface, void* handler) {
    iface->get_action_state = handler;
}
void gtkada_Action_Group_set_get_action_state_hint(GActionGroupInterface* iface, void* handler) {
    iface->get_action_state_hint = handler;
}
void gtkada_Action_Group_set_get_action_state_type(GActionGroupInterface* iface, void* handler) {
    iface->get_action_state_type = handler;
}
void gtkada_Action_Group_set_has_action(GActionGroupInterface* iface, void* handler) {
    iface->has_action = handler;
}
void gtkada_Action_Group_set_list_actions(GActionGroupInterface* iface, void* handler) {
    iface->list_actions = handler;
}
void gtkada_Action_Group_set_query_action(GActionGroupInterface* iface, void* handler) {
    iface->query_action = handler;
}
void gtkada_Action_Map_set_add_action(GActionMapInterface* iface, void* handler) {
    iface->add_action = handler;
}
void gtkada_Action_Map_set_lookup_action(GActionMapInterface* iface, void* handler) {
    iface->lookup_action = handler;
}
void gtkada_Action_Map_set_remove_action(GActionMapInterface* iface, void* handler) {
    iface->remove_action = handler;
}
void gtkada_Application_set_command_line(GApplicationClass* iface, void* handler) {
    iface->command_line = handler;
}
void gtkada_Application_set_local_command_line(GApplicationClass* iface, void* handler) {
    iface->local_command_line = handler;
}
void gtkada_Text_View_set_draw_layer(GtkTextViewClass* iface, void* handler) {
    iface->draw_layer = handler;
}