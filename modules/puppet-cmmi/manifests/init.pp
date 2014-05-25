class cmmi(
$test_cmd           = $cmmi::params::test_cmd,
$tar_cmd            = $cmmi::params::tar_cmd,
$bunzip_cmd         = $cmmi::params::bunzip_cmd,
$gunzip_cmd         = $cmmi::params::gunzip_cmd,
$rm_cmd             = $cmmi::params::rm_cmd,
$wget_cmd           = $cmmi::params::wget_cmd,
$build_dependencies = $cmmi::params::build_dependencies
) inherits cmmi::params {
  package { $build_dependencies: }
}
