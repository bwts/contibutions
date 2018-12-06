#!/bin/bash

# VARIABLE to be changed between local env and cloud env.
SITES='/Volumes/UserSpace/Users/aritoadmin/Sites'
BWTS_HOTFIX="$SITES/bwts_hotfix"
BASE_URL='dev.platform'

# Load the logger messages and colours!
. "$SITES/scripts/lib/logger.sh"


# --------------------------------------------------------
# -         FILE PERMISSION
# ---------------------------------------------------------
  function dperm() {
    settings_file={1}
    eval sudo chmod 777 ${settings_file}
  }

  function readExecutedperm() {
    settings_file={1}
    eval sudo chmod 554 ${settings_file}
  }

# ----------------------------------------------------------
#                     TMGMT
# ---------------------------------------------------------

# ---------------------------------------
#      Pos install script local env!!!
# ---------------------------------------
function bwts_set_tmgmt_pos_install() {

  if [ -z ${1} ]; then
    BASE_PLATFORM="$SITES/platform-dev"
  fi  
    # settings folder!
    settings="$BASE_PLATFORM/build/default/settings.php"
    
    MPHR=60    # Minutes per hour.
    echo "Starting"
    start=$(date +%s)

    # base url local env.
      baseUrl $settings
      info "Base url set!"
      echo ''

    # Set Poetry
      setPoetry $settings
      info "Set poetry config.!"
      echo ''

    # Create Languages and Translator.
            # 1- cp the tools within build folder, using func setTmgmt ROOT_FOLDER
              eval copyTmgmtTools $BASE_PLATFORM

            # 2- run the php script
               eval drush scr $BASE_PLATFORM/build/tmgmt_tools/init.php -r build

    #  Create fields using bwts_fields.module
            info "Copy module from build to multisite_drupal_std/modules/custom"
            echo ''
            file_tmgmt_tools="$BASE_PLATFORM/build/tmgmt_tools"
            sudo cp -ap $file_tmgmt_tools/bwts_fields $BASE_PLATFORM/profiles/multisite_drupal_standard/modules/custom

    # Enable the module.
      eval drush en -y bwts_fields -r build
      echo ''

      eval drush en -y tmgmt_dgt_connector_cart -r build
      echo ''

    # Delete tmgmt_tools folder.
    if [ -d "$file_tmgmt_tools" ]; then
       eval sudo rm -rf $file_tmgmt_tools
       warn "File deleted!"
    fi

    bwdrush 'cc all'

    echo ''
    end=$(date +%s)
    printf 'Time spent:  %s minutes, and %s seconds ' "$MINUTES" "$(diff)"
    echo ''
    echo ''
}

# -----------------------------------
#   Calculate time difference (secs)
# -----------------------------------
function diff () {
   printf '%s' $(( $start - $end ))
   # %d = day of month.
}

# ---------------------------------------------------------
#  Copy tmgmt tools for setting Languages and translators.
# ---------------------------------------------------------
function copyTmgmtTools(){
   info "Copy tmgmt tools within build folder!"
   echo ''
   BASE_PLATFORM=${1}
   sudo cp -ap $BWTS_HOTFIX/tmgmt_tools $BASE_PLATFORM/build/
}

# ----------------------
#  SET base url
# ----------------------
function baseUrl() {
  settings_file=${1}

  dperm $settings_file
  cat >> ${settings_file} <<EOL

  # Setting up BASE URL to allow using custom URL
  // ALM testing
  //  \$base_url="http://dev.platform";
     \$base_url="$BASE_URL";

EOL

  # REMOVE Write permission
  readExecutedperm $settings_file
}

# --------------------------------------------------
# Setting up ECAS CONFIG. SETTINGS
# ---------------------------------------------------
function setEcas(){
  # Write permission
  settings_file=${1}

  dperm $settings_file
  cat >> ${settings_file} <<EOL

  # Setting up ECAS
  // ALM testing ECAS
         define('FPFIS_ECAS_URL', 'ecas.ec.europa.eu');
         define('FPFIS_ECAS_PORT', 443);
         define('FPFIS_ECAS_URI', '/cas');

EOL

     # REMOVE Write permission
     readExecutedperm $settings_file
}

# ---------------------------------------------------
#    Setting up POETRY CONFIG. SETTINGS
# ---------------------------------------------------
function setPoetry(){
  settings_file=${1}

  dperm $settings_file
  cat >> ${settings_file} <<EOL

  # Setting up Poetry
  // ALM testing POETRY
      \$conf['poetry_service'] = array(
      'address' => 'http://intragate.test.ec.europa.eu/DGT/poetry_services/components/poetry.cfc?wsdl',
      'method' => 'requestService',
    );

EOL
   readExecutedperm $settings_file
}

# ---------------------------------------------------------------
#  bwts drush
#  drush from root directory where drupal is in build folder.
# ---------------------------------------------------------------
function bwdrush() {
  cmd=${1}
  warn " command is: $cmd"
  echo ''
  if [ ! -z "${cmd}" ]; then
    eval drush $cmd -r build
  else
    error 'Mising the drush command'
    exit
  fi
}

# ---------------------------------------
# Search and replace within bash file.
# --------------------------------------
function bwts_replace() {

   pattern="$1"
   replace="$2"
   file="$3"

   if [ -z ${1} ] || [ -z ${3} ]; then
       info 'USAGE ==> bwts_replace $pattern $replace $destination'
       warn 'The arguments $pattern and $destination cannot be empty!'
       exit
   fi

   if [ ! -s $file ]; then
     error "Destination file does not exist!"
     exit
   fi

   sed -ie s%"$pattern"%"$replace"% ${file}
}

