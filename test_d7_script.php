<?php

// define static var
define('DRUPAL_ROOT', getcwd());

// include bootstrap
include_once('./includes/bootstrap.inc');

// initialize stuff
drupal_bootstrap(DRUPAL_BOOTSTRAP_FULL);

//laod user
global $user;

if($user->uid >0)
{
    // user logged in
    echo 'Welcome '.$user->name.'!';
}
else
{
    // anonym user
    echo 'Welcome guest!';    
}