<?php

// db_insert('tmgmt_translator')->fields(array(
//   'tid',
//   'name',
//   'label',
//   'description',
//   'plugin',
//   'settings',
//   'weight',
//   'status',
//   'module',
// ))
// ->values(array(
//   'tid' => '1',
//   'name' => 'test_translator',
//   'label' => 'Test translator (auto created)',
//   'description' => 'Simple translator for testing purposes.',
//   'plugin' => 'test_translator',
//   'settings' => 'a:2:{s:11:"auto_accept";b:0;s:15:"expose_settings";b:1;}',
//   'weight' => '0',
//   'status' => '1',
//   'module' => NULL,
// ))
// ->execute();

function bwts_tmgmt_translator_create($name,  $plugin='file') {
  if ($info = tmgmt_translator_plugin_info($plugin)) {
    if (!tmgmt_translator_exists($name)) {
      $label = $info['label'] . ' (auto created)';
      $translator = tmgmt_translator_create($plugin, $name, $label, $info['description']);
      // Append some default settings from the translator plugin definition.
      $translator->settings = $translator->getController()->defaultSettings();
      $translator->save();
    }
  }
}

bwts_tmgmt_translator_create('Bwts Auto translator');
