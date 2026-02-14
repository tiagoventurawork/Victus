<?php
header('Content-Type: application/json; charset=utf-8');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type, Authorization');

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit;
}

require_once __DIR__ . '/config/Database.php';
require_once __DIR__ . '/helpers/JwtHelper.php';
require_once __DIR__ . '/middleware/AuthMiddleware.php';
require_once __DIR__ . '/routes/Router.php';

// Load all models
foreach (glob(__DIR__ . '/models/*.php') as $model) {
    require_once $model;
}
// Load all controllers
foreach (glob(__DIR__ . '/controllers/*.php') as $controller) {
    require_once $controller;
}

$router = new Router();

// ---- AUTH ----
$router->add('POST', '/auth/register',       'AuthController@register');
$router->add('POST', '/auth/login',           'AuthController@login');
$router->add('POST', '/auth/recover',         'AuthController@recover');
$router->add('POST', '/auth/reset-password',  'AuthController@resetPassword');

// ---- DASHBOARD ----
$router->add('GET', '/dashboard',             'DashboardController@index');

// ---- EVENTS ----
$router->add('GET', '/events',                'EventController@index');
$router->add('GET', '/events/{id}',           'EventController@show');

// ---- LIBRARY ----
$router->add('GET', '/library',               'LibraryController@index');
$router->add('GET', '/library/{id}',          'LibraryController@show');

// ---- VIDEOS ----
$router->add('GET', '/videos/{id}',           'VideoController@show');

// ---- PROGRESS ----
$router->add('POST', '/progress',             'ProgressController@save');
$router->add('GET',  '/progress/{videoId}',   'ProgressController@get');

// ---- FAVORITES ----
$router->add('POST',   '/favorites',          'FavoriteController@toggle');
$router->add('GET',    '/favorites',           'FavoriteController@index');

// ---- COMPLETED ----
$router->add('POST',   '/completed',           'CompletedController@toggle');
$router->add('GET',    '/completed',            'CompletedController@index');

// ---- NOTES ----
$router->add('GET',    '/notes/{videoId}',     'NoteController@index');
$router->add('POST',   '/notes',               'NoteController@store');
$router->add('PUT',    '/notes/{id}',          'NoteController@update');
$router->add('DELETE', '/notes/{id}',          'NoteController@destroy');

// ---- COMMENTS ----
$router->add('GET',    '/comments/{videoId}',  'CommentController@index');
$router->add('POST',   '/comments',            'CommentController@store');

// ---- MATERIALS ----
$router->add('GET',    '/materials/{videoId}',  'MaterialController@index');

// ---- PROFILE ----
$router->add('GET',    '/profile',             'ProfileController@show');
$router->add('PUT',    '/profile',             'ProfileController@update');
$router->add('POST',   '/profile/avatar',      'ProfileController@uploadAvatar');

$router->dispatch();