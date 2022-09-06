class ISBN13Check
  class << self
    def generate_check_digit(code)
      res1 = generate_check_digit_step1 code
      res2 = generate_check_digit_step2 res1
      res3 = generate_check_digit_step3 res2
      generate_check_digit_step4 res3
    end

    private
    def generate_check_digit_step1(input)
      splitted = input.split("")
      splitted.map.with_index do |char, index|
        char.to_i * (index % 2 == 0 ? 1 : 3)
      end
    end

    def generate_check_digit_step2(input)
      input.inject(&:+)
    end

    def generate_check_digit_step3(input)
      input % 10
    end

    def generate_check_digit_step4(input)
      (10 - input) % 10
    end
  end
end