require "./isbn13_check"

describe ISBN13Check do
  describe "#generate_check_digit" do
    subject { ISBN13Check.generate_check_digit code }
    let(:code) { "978014300723" }

    context "algorithm sequence" do
      let(:step1_result) { double() }
      let(:step2_result) { double() }
      let(:step3_result) { double() }
      let(:step4_result) { double() }

      before do
        expect(ISBN13Check).to receive(:generate_check_digit_step1).with(code).and_return step1_result
        expect(ISBN13Check).to receive(:generate_check_digit_step2).with(step1_result).and_return step2_result
        expect(ISBN13Check).to receive(:generate_check_digit_step3).with(step2_result).and_return step3_result
        expect(ISBN13Check).to receive(:generate_check_digit_step4).with(step3_result).and_return step4_result
      end

      it { should eq step4_result }
    end

    context "#generate_check_digit_step1" do
      subject { ISBN13Check.send(:generate_check_digit_step1, code) }

      it { should be_an_instance_of Array }
      it { should eq [9, 21, 8, 0, 1, 12, 3, 0, 0, 21, 2, 9] }

      context "other inputs" do
        context "111111111111" do
          let(:code) { "111111111111" }

          it { should eq [1, 3, 1, 3, 1, 3, 1, 3, 1, 3, 1, 3] }
        end

        context "222222222222" do
          let(:code) { "222222222222" }

          it { should eq [2, 6, 2, 6, 2, 6, 2, 6, 2, 6, 2, 6] }
        end

        context "849576213211" do
          let(:code) { "849576213211" }

          it { should eq [8, 12, 9, 15, 7, 18, 2, 3, 3, 6, 1, 3] }
        end
      end 
    end

    context "#generate_check_digit_step2" do
      subject { ISBN13Check.send(:generate_check_digit_step2, step1_result) }
      let(:step1_result) { ISBN13Check.send(:generate_check_digit_step1, code) }

      it { should be_an_instance_of Fixnum }
      it { should eq 86 }

      context "other inputs" do
        context "[1, 3, 1, 3, 1, 3, 1, 3, 1, 3, 1, 3]" do
          let(:step1_result) { [1, 3, 1, 3, 1, 3, 1, 3, 1, 3, 1, 3] }

          it { should eq 24 }
        end

        context "[2, 6, 2, 6, 2, 6, 2, 6, 2, 6, 2, 6]" do
          let(:step1_result) { [2, 6, 2, 6, 2, 6, 2, 6, 2, 6, 2, 6] }

          it { should eq 48 }
        end

        context "[8, 12, 9, 15, 7, 18, 2, 3, 3, 6, 1, 3]" do
          let(:step1_result) { [8, 12, 9, 15, 7, 18, 2, 3, 3, 6, 1, 3] }

          it { should eq 87 }
        end
      end 
    end

    context "#generate_check_digit_step3" do
      subject { ISBN13Check.send(:generate_check_digit_step3, step2_result) }
      let(:step2_result) { 86 }

      it { should eq 6 }

      context "other inputs" do
        context "71" do
          let (:step2_result) { 71 }

          it { should eq 1 }
        end

        context "2" do
          let (:step2_result) { 2 }

          it { should eq 2 }
        end

        context "10579" do
          let (:step2_result) { 10579 }

          it { should eq 9 }
        end
      end
    end

    context "#generate_check_digit_step4" do
      subject { ISBN13Check.send(:generate_check_digit_step4, step3_result) }
      let(:step3_result) { 6 }

      it { should eq 4 }

      context "other inputs" do
        context "9" do
          let(:step3_result) { 9 }

          it { should eq 1 }
        end

        context "3" do
          let(:step3_result) { 3 }

          it { should eq 7 }
        end

        context "10" do
          let(:step3_result) { 10 }

          it { should eq 0 }
        end

        context "0" do
          let(:step3_result) { 0 }

          it { should eq 0 }
        end
      end
    end

    context "main check" do
      context "111111111111" do
        let(:code) { "111111111111" }

        it { should eq 6 }
      end

      context "222222222222" do
        let(:code) { "222222222222" }

        it { should eq 2 }
      end

      context "849576213211" do
        let(:code) { "849576213211" }

        it { should eq 3 }
      end
    end

  end
end
