//core
export 'package:flutter/material.dart';
export 'dart:convert';
export 'dart:io';

//packages
export 'package:firebase_core/firebase_core.dart';
export 'package:equatable/equatable.dart';
export 'package:provider/provider.dart';
export 'package:another_flushbar/flushbar.dart';
export 'package:another_flushbar/flushbar_route.dart';
export 'package:fluttertoast/fluttertoast.dart';
export 'package:flutter_screenutil/flutter_screenutil.dart';
export 'package:shared_preferences/shared_preferences.dart';
export 'package:cloud_firestore/cloud_firestore.dart';
export 'package:firebase_auth/firebase_auth.dart';

//routes
export 'package:todo/utils/routes/routes.dart';
export 'package:todo/utils/routes/routes_name.dart';

//utils
export 'package:todo/res/color.dart';
export 'package:todo/utils/utils.dart';
export 'package:todo/data/shared_preferences_manager.dart';
export 'package:todo/res/app_urls.dart';
export 'package:todo/data/network/base_api_services.dart';
export 'package:todo/data/network/network_api_services.dart';
export 'package:todo/data/app_exceptions.dart';
export 'package:todo/data/response/status.dart';
export 'package:todo/utils/constants.dart';

//components

//widgets
export 'package:todo/res/widgets/round_button.dart';

//view models

//Providers
export 'package:todo/providers/user_auth_provider.dart';
export 'package:todo/providers/signup_provider.dart';
export 'package:todo/providers/login_provider.dart';
export 'package:todo/providers/todo_list.dart';
export 'package:todo/providers/todo_filter.dart';
export 'package:todo/providers/todo_search.dart';
export 'package:todo/providers/active_todo_count.dart';
export 'package:todo/providers/filtered_todos.dart';

//models
export 'package:todo/model/user_model.dart';

//repositories
export 'package:todo/repository/login_repository.dart';
export 'package:todo/repository/change_password_repository.dart';

//views
export 'package:todo/view/auth_screens/signup_screen.dart';
export 'package:todo/view/auth_screens/login_screen.dart';
export 'package:todo/view/home_screens/todos_page.dart';
