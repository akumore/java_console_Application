require 'spec_helper'

describe Export::Idx301::FtpUploader, :uploader do
  let :account do
    Account.new(:provider => 'tester')
  end

  let :testdir do
    Rails.root + 'tmp/upload_test/'
  end

  let :packager do
    stub('packager', path: testdir.to_s)
  end

  let :ftp do
    stub('ftp')
  end

  context 'files to upload' do
    before do
      FileUtils.mkpath(testdir)
      FileUtils.touch(testdir + 'foobar.pdf')
    end

    subject do
      Export::Idx301::FtpUploader.new(packager, account)
    end

    describe '#do_upload!' do
      before do
        ftp.should_receive(:pwd).at_least(:once).and_return 'remotedir'
        ftp.should_receive(:passive=).with(true)
        ftp.should_receive(:close)
      end
      it 'should upload files' do
        Net::FTP.should_receive(:open).and_return ftp
        ftp.should_receive(:put).with(testdir.to_s + '/foobar.pdf', 'remotedir/foobar.pdf')
        subject.do_upload!
      end

      it 'should retry upload files on timeout' do
        Net::FTP.should_receive(:open).and_return ftp
        ftp.should_receive(:put).twice.with(testdir.to_s + '/foobar.pdf', 'remotedir/foobar.pdf').and_return do
          raise Errno::ETIMEDOUT
        end
        Airbrake.should_receive(:notify)
        expect { subject.do_upload! }.not_to raise_exception
      end

      it 'should raise exception after 10 errors' do
        Net::FTP.should_receive(:open).and_return ftp
        subject.should_receive(:files).and_return 10.times.map {|i| "file#{i}"}
        FileTest.should_receive(:directory?).at_least(:once).and_return false
        ftp.should_receive(:put).exactly(10).times.and_return do
          raise 'stupid exception'
        end
        Airbrake.should_receive(:notify).exactly(10).times
        expect { subject.do_upload! }.to raise_exception('max error count reached')
      end
    end
  end
end
