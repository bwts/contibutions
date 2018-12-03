<?php

db_insert('tmgmt_translator')->fields(array(
  'tid',
  'name',
  'label',
  'description',
  'plugin',
  'settings',
  'weight',
  'status',
  'module',
))
->values(array(
  'tid' => '1',
  'name' => 'test_translator',
  'label' => 'Test translator (auto created)',
  'description' => 'Simple translator for testing purposes.',
  'plugin' => 'test_translator',
  'settings' => 'a:2:{s:11:"auto_accept";b:0;s:15:"expose_settings";b:1;}',
  'weight' => '0',
  'status' => '1',
  'module' => NULL,
))
->execute();
