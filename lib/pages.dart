import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import 'core/helper/helper.dart';
import 'core/helper/role/role.dart';
import 'feature/consultation/consultation_model.dart';
import 'feature/history/history_model.dart';
import 'feature/reports/reports_model.dart';
import 'feature/rules/rules_model.dart';
import 'feature/symptoms/symptoms_model.dart';
import 'feature/users/users_model.dart';
import 'firebase_options.dart';

part 'core/services/auth_service.dart';
part 'core/services/symptom_service.dart';
part 'core/services/rule_service.dart';
part 'core/services/pakar_dashboard_service.dart';
part 'core/services/consultation_service.dart';
part 'core/services/user_dashboard_service.dart';
part 'core/services/admin_service.dart';

part 'feature/login/login_controller.dart';

part 'feature/login/login_screen.dart';

part 'feature/signup/signup_controller.dart';

part 'feature/signup/signup_screen.dart';

part 'feature/dashboard/dashboard_controller.dart';

part 'feature/dashboard/dashboard_screen.dart';

part 'feature/consultation/consultation_screen.dart';

part 'feature/consultation/consultation_controller.dart';

part 'feature/history/history_controller.dart';

part 'feature/history/history_screen.dart';

part 'feature/reports/reports_controller.dart';

part 'feature/reports/reports_screen.dart';

part 'feature/rules/rules_controller.dart';

part 'feature/rules/rules_screen.dart';

part 'feature/symptoms/symptoms_controller.dart';

part 'feature/symptoms/symptoms_screen.dart';

part 'feature/users/users_controller.dart';

part 'feature/users/users_screen.dart';

part 'feature/dashboard/widgets/dashboard_activity_tile.dart';

part 'feature/dashboard/widgets/dashboard_card.dart';

part 'feature/dashboard/widgets/dashboard_stat_card.dart';

part 'feature/dashboard/widgets/dashboard_section_title.dart';

part 'feature/dashboard/widgets/dashboard_header_button.dart';

part 'feature/dashboard/widgets/admin_line_chart.dart';

part 'feature/dashboard/widgets/admin_pie_chart.dart';

part 'feature/dashboard/widgets/expert_bar_chart.dart';

part 'feature/dashboard/widgets/expert_pie_chart.dart';

part 'feature/dashboard/widgets/dashboard_create_pakar_dialog.dart';

part 'feature/dashboard/widgets/dashboard_create_pakar_shortcut.dart';

part 'feature/dashboard/models/dashboard_menu_item.dart';

part 'feature/dashboard/models/dashboard_pie_item.dart';

part 'feature/dashboard/models/dashboard_stat_item.dart';

part 'feature/dashboard/models/dashboard_activity_item.dart';

part 'widgets/text_form_field.dart';

part 'widgets/button.dart';

part 'widgets/empty_state.dart';

part 'widgets/circular_indicator.dart';

part 'widgets/pagination.dart';

part 'widgets/dialog.dart';

part 'widgets/table.dart';
