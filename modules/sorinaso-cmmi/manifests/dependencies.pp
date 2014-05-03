class cmmi::dependencies {
  include cmmi::params
  package { $cmmi::params::build_dependencies: }
}