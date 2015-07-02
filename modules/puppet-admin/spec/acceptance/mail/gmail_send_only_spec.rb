require 'spec_helper'

include SpecHelper::Mail::GmailSendOnly

describe 'admin::mail::gmail_send_only type:' do
  context "when include admin::mail::gmail_send_only" do
    it "should run without errors" do
      # CLeanup
      shell clean_cmd

      pp = <<-EOS
        class {'admin::mail::gmail_send_only':
          admin_address   => '#{admin_address}',
          gmail_user      => '#{gmail_user}',
          gmail_password  => '#{gmail_password}',
        }
      EOS

      apply_manifest(pp, :expect_changes => true)
      apply_manifest(pp, :catch_changes => true)

      # Send test mail
      shell send_mail_cmd

      # Wait for sending mail
      sleep 5
    end

    describe file(mail_log_file) do
      it { should contain 'smtp: Succeeded: 250 2.0.0 OK' }
    end
  end
end
