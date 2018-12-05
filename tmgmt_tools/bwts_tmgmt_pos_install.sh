#!/bin/bash


function tmgmt_c9_pos_install() {
    root_folder=${1}
    if [ -z $root_folder ]; then
      error "Missing root_folder!"
      return 0
    fi

    # base url if its c9
      sites && cd $root_folder &&  baseurl

    # Create Languages and Translator.
    # 1- cp the tools within build folder, using func setTmgmt ROOT_FOLDER
     # eg.:setTmgmt release_4
      setTmgmt $root_folder

     # 2- run the php script
       eval dind $root_folder 'scr tmgmt_tools/init.php -r build/'

    # Create fields using bwts_fields.module
    # Copy module from build to multisite_drupal_std/modules/custom
    sites && cd $root_folder && sudo cp -ap build/tmgmt_tools/bwts_fields ../profiles/multisite_drupal_standard/modules/custom
    # Enable the module.
      eval dind $root_folder 'en -y bwts_fields -r build'

    return 1
}
