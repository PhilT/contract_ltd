module ContractLtd
  class Dividend
    attr_reader :type, :tax_year_end, :shares, :net, :tax_credit, :gross, :amount, :company_year_end

    def initialize args
      @name = 'dividend'
      @type = ARGV[0] == 'final' ? 'Final' : 'Interim'
      @date_paid = Date.parse(ARGV[1])
      @tax_year_end = Date.new(ARGV[2].to_i, 4, 5).to_s(:long)
      @shares = 100
      @net = ARGV[3].to_f
      @tax_credit = @net * 0.111111
      @gross = @net + @tax_credit
      @amount = @net / @shares
      @company_year_end = Date.new(ARGV[4].to_i, 2, 28).to_s(:long)
    end

    def date_paid(format = :long)
      @date_paid.to_s(format)
    end

    def name(ext)
      "#{name}.#{ext}"
    end

    def filename
      "#{@name}_#{date_paid(:file)}.pdf"
    end
  end
end

