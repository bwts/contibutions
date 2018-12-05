 # ---------------------------------------
  #      Pos install script local env!!!
  # ---------------------------------------
  function bwts_set_tmgmt_pos_install() {
      eval bwdrush cc all
  
      # base url local env.
        baseurl
  
      eval bwdrush cc all
      # Set Poetry
        setPoetry 
      
      eval bwdrush cc all
      # Create Languages and Translator.
              # 1- cp the tools within build folder, using func setTmgmt ROOT_FOLDER
                eval copyTmgmtTools
 
             # 2- run the php script
                eval drush scr $BASE_PLATFORM/build/tmgmt_tools/init.php -r build
  
      #  Create fields using bwts_fields.module
              info Copy module from build to multisite_drupal_std/modules/custom
              file_tmgmt_tools="$BASE_PLATFORM/build/tmgmt_tools"
              sudo cp -ap $file_tmgmt_tools/bwts_fields $BASE_PLATFORM/profiles/multisite_drupal_standard/modules/custom
      
      # Enable the module.
        eval drush en -y bwts_fields -r build
        eval drush en -y tmgmt_dgt_connector_cart -r build
  
      # Delete tmgmt_tools folder.
      if [ -d "$file_tmgmt_tools" ]; then
         sudo rm -rf $file
         warn "File deleted!"
      fi
  }
