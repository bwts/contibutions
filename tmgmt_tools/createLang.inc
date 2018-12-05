<?php

#/**
# * Root directory of Drupal installation.
# */
#define('DRUPAL_ROOT', getcwd());
#
#include_once DRUPAL_ROOT . '/includes/bootstrap.inc';
#drupal_bootstrap(DRUPAL_BOOTSTRAP_FULL);
#
require_once 'bootDrupal.php';
// echo variable_get('autologout_timeout') . PHP_EOL;

// locale_add_language('it', $name = 'Italian', $native = 'Italiano', $direction = LANGUAGE_LTR, $domain = '', $prefix = '', $enabled = TRUE, $default = FALSE);
echo 'Starting creating languages >>> ' . PHP_EOL;
$languages = array(
	'br' => array('Portuguese Brasil', 'Portugues BR'),
	'pt' => array('Portuguese PT', 'Portugues PT'),
	'fr' => array('French fr', 'Francais'), 
	'es' => array('Spanish', 'Espanol'),
	'it' => array('Italian', 'Italiano'),
	'pl' => array('Polish', 'Polski')
);

$code_lang = array_keys(language_list());
foreach($languages as $code => $lang) {
	$name = $lang[0];

	if (!in_array($code, $code_lang)) {
		$native = $lang[1];
		locale_add_language($code, $name, $native  , $direction = LANGUAGE_LTR, $domain = '', $prefix = '', $enabled = TRUE, $default = FALSE);
	    echo $name . ' added!' . PHP_EOL; 
	} else {
		echo 'Language "' . $name . '" has been already created! ' . PHP_EOL;

	}
}
echo '>>> END creating languages!!!' . PHP_EOL;
