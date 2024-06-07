import 'package:flutter/material.dart';

const kBaseUrl = '127.0.0.1:8080';
// authentication endpoints
const kRegister = '/api/auth/register'; //DONE //*
const kLogin = '/api/auth/authenticate'; //DONE //*
const kTokenVerification = '/api/auth/token'; //DONE //*
const kRefreshToken = '/api/auth/refresh-token';  // ~
//user endpoints
const kChangePassword = '/api/users/password'; //~
const kChangeRole = '/api/users/role/'; // {userId}  //*
//chapter endpoints
const kVectorSearch = '/api/chapters/similar'; //DONE //*
//course endpoints
const kCreateCourse = '/api/courses';  //DONE //*
const kGetAllInstructorsCourses = '/api/courses'; //DONE //*
const kEditSpecificCourse = '/api/courses/'; // {courseId} //*
const kDeleteSpecificCourse = '/api/courses/'; // {courseId}  //DONE //*
//module endpoints
const kGetModulesForCourse = '/api/modules/courses/'; // {courseId} //DONE //*
const kGetSpecificChapterForSpecificModule = '/api/modules/chapters/'; //{moduleId} // DONE //*
const kGetQuestionsForSpecificModule = '/api/modules/questions/'; //{moduleId} // Request Param // DONE //*
const kAddModuleToCourse = '/api/modules/adm/'; //{courseId} // DONE//*
const kGenerateQuestionsForModule = '/api/modules/adm/questions/'; // {moduleId}/{courseId}/{questionNumber} // DONE//*
const kSaveGeneratedQuestionsForModule = '/api/modules/adm/questions'; // DONE//*
const kEditModuleAndChapterContent = '/api/modules/adm/'; // {moduleId}/{courseId} // DONE //*
const kDeleteSpecificModuleForSpecificCourse = '/api/modules/adm/'; // {moduleId}/{courseId} // DONE//*
//openAI endpoints
const kChat = '/api/openai/chat'; // DONE //*
const kSummarize = '/api/openai/summarize'; // DONE //*
//users-courses endpoints
const kEnrollToCourse = '/api/users-courses/'; //{courseId}  //DONE //*
const kGetUsersCourses = '/api/users-courses'; //DONE //*
const kGetAllCourses = '/api/users-courses/all'; //DONE //*
const kUpdateProgress = '/api/users-courses/progress/'; // {courseId} //*
const kFilterCourses = '/api/users-courses/filter'; // Request Params //~


var kColorScheme =
ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 5, 152, 98));