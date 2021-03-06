require 'spec_helper'

module NNCore
  describe "nn_socket" do

    context "given an initialized library and" do

      PROTOCOLS.keys.each do |protocol|

        context "given a supported protocol #{protocol} and address family AF_SP" do

          it "returns a non-zero file descriptor for the socket" do
            @socket = LibNanomsg.nn_socket(AF_SP, PROTOCOLS[protocol])

            @socket.should == 0

            LibNanomsg.nn_close(@socket)
          end
        end

        context "given a supported protocol #{protocol} and address family AF_SP_RAW" do

          if RAW_UNSUPPORTED.include?(protocol)
            it "returns -1 and sets nn_errno to EINVAL" do
              @socket = LibNanomsg.nn_socket(AF_SP_RAW, PROTOCOLS[protocol])

              @socket.should == -1
              LibNanomsg.nn_errno.should == EINVAL
            end
          end
        end

      end

      context "given an unsupported address family" do
        it "nn_socket returns -1 and sets nn_errno to EAFNOSUPPORT" do
          LibNanomsg.nn_socket(0, NN_PUB).should == -1
          LibNanomsg.nn_errno.should == EAFNOSUPPORT
        end
      end

      context "given an unsupported protocol and a supported address family" do

        it "AF_SP returns -1 and sets nn_errno to EINVAL" do
          LibNanomsg.nn_socket(AF_SP, 0).should == -1
          LibNanomsg.nn_errno.should == EINVAL
        end

        it "AF_SP_RAW returns -1 and sets nn_errno to EINVAL" do
          LibNanomsg.nn_socket(AF_SP_RAW, 0).should == -1
          LibNanomsg.nn_errno.should == EINVAL
        end
      end

    end

  end
end
