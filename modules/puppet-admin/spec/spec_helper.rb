require File.expand_path(File.join(File.dirname(__FILE__), '..', '..', '..', 'spec_helper_acceptance', 'spec_helper_acceptance'))

beaker_configuration('puppet-admin') do |c|
  beaker_install_module('akumria/nullmailer') if beaker_is_provisioning?
  beaker_install_module('puppetlabs/apt') if beaker_is_provisioning?
end

module SpecHelper
  module Mail
    module GmailSendOnly
      def send_mail_cmd; "echo 'test mail' | sendmail #{self.admin_address}" end

      def clean_cmd; "echo '' > #{self.mail_log_file} && apt-get -y purge nullmailer" end

      def mail_log_file; "/var/log/mail.log" end

      def admin_address; 'alesouto.tests@gmail.com' end

      def gmail_user; 'alesouto.tests' end

      def gmail_password; 'tests123' end
    end
  end
end
