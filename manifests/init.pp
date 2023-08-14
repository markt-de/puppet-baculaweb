# == Class: baculaweb
#
# @summary Installs bacula-web - A web based reporting and monitoring tool for Bacula.
#
# @see https://www.bacula-web.org/
#
# @param version
#   This version of baculaweb will be installed
# @param archive_name
#   The filename of the archive which will be fetched from the mirror
# @param user
#   The user under which the webserver is running
# @param group
#   The group under which the webserver is running
# @param archive_path
#   The path where the fetched archive from the mirror will be saved
# @param mirror_base_url
#   The base url from where the archive will be downloaded
# @param mirror
#   The complete URL to download the archive
# @param extract_base_dir
#   The base directory for extracting the archive
# @param data_dir
#   The directory wich holds persistent data for baculaweb
# @param data_dir_assets_protected_path
#   Subfolder for assets/protected in data_dir
# @param extract_dir
#   The full path of the directory where to save the archive for the specific version
# @param extract_creates
#   The path of the directory that will be created after extracting the specific version
# @param archive_symlink_to_root_dir
#   Whether the extracted archive should be symlinked to the document root directory
# @param data_dir_symlink
#   Whether the data dir should be symlinked. This ensures data persistence after an upgrade e.g. user database.
# @param root_dir
#   The document root directory for the application
# @param config_path
#   The path of the application config file
# @param cache_path
#   The path of the application cache directory
# @param assets_protected_path
#   The path of the application assets directory
# @param show_inactive_clients
#   Show inactive clients or not
# @param hide_empty_pools
#   Hide empty pools
# @param datetime_format
#   Change default date and time format
# @param enable_users_auth
#   Enable or disable users authentication - This settings is useful if you already authenticate users on Web server side,
#   using .htpasswd or LDAP authentication (mod_auth_ldap or any other).
# @param debug
#   Enable or disable debug mode - Debug mode could be helpful to troubleshoot Bacula-Web setup problem
# @param language
#   Set displayed language - choose from
#   ['en_US', 'be_BY', 'ca_ES', 'pl_PL', 'ru_RU', 'zh_CN', 'no_NO', 'ja_JP', 'sv_SE', 'es_ES', 'de_DE', 'it_IT', 'fr_FR', 'pt_BR', 'nl_NL']
# @param catalog_db
#   Database connection settings for the bacula catalog databases
#
class baculaweb (
  String $version,
  String $user,
  String $group,
  Stdlib::Absolutepath $extract_base_dir,
  Stdlib::Absolutepath $data_dir,
  Variant[Stdlib::HTTPUrl,Stdlib::HTTPSUrl] $mirror_base_url,
  Boolean $archive_symlink_to_root_dir,
  Boolean $data_dir_symlink,
  Stdlib::Absolutepath $root_dir,
  Boolean $show_inactive_clients,
  Boolean $hide_empty_pools,
  String $datetime_format,
  Boolean $enable_users_auth,
  Boolean $debug,
  Enum['en_US', 'be_BY', 'ca_ES', 'pl_PL', 'ru_RU', 'zh_CN', 'no_NO',
  'ja_JP', 'sv_SE', 'es_ES', 'de_DE', 'it_IT', 'fr_FR', 'pt_BR', 'nl_NL'] $language,
  Array[Struct[{
        label     => String,
        host      => Optional[String],
        login     => Optional[String],
        password  => Optional[String],
        db_name   => Optional[String],
        db_type   => Enum['mysql', 'pgsql', 'sqlite'],
        db_port   => Optional[Integer],
  }]] $catalog_db,
  String $archive_name = "bacula-web-${version}.tgz",
  Stdlib::Absolutepath $data_dir_assets_protected_path = "${data_dir}/protected",
  Stdlib::Absolutepath $archive_path = "${extract_base_dir}/${archive_name}",
  Variant[Stdlib::HTTPUrl,Stdlib::HTTPSUrl] $mirror = "${mirror_base_url}/v${version}/${archive_name}",
  Stdlib::Absolutepath $extract_dir = "${extract_base_dir}/v${version}",
  Stdlib::Absolutepath $extract_creates = "${extract_dir}/bacula-web-${version}",
  Stdlib::Absolutepath $config_path = "${root_dir}/application/config/config.php",
  Stdlib::Absolutepath $cache_path = "${root_dir}/application/views/cache",
  Stdlib::Absolutepath $assets_protected_path = "${root_dir}/application/assets/protected",
) {
  contain baculaweb::install
  contain baculaweb::config

  Class['baculaweb::install']
  -> Class['baculaweb::config']
}
