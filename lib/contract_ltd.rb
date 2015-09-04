require 'bundler/setup'
require 'active_support'
require 'active_support/time'
require 'active_support/core_ext/numeric/conversions'
require 'shrimp'
require 'slim'
require 'contract_ltd/base'
require 'contract_ltd/dividend'
require 'contract_ltd/invoice'
require 'contract_ltd/new'
require "contract_ltd/version"

module ContractLtd
  def self.invoice
    if ARGV.empty?
      puts <<-EOB
        Create a new invoice.slim template:

        invoice new


        Generate a timesheet (CSV) and invoice (PDF) from existing invoice.slim template.

        invoice [-f] [-p] -n [-x|-i [day[am|pm]],[...]]
          -f    - overwrite existing timesheet/invoice
          -n    - generate timesheet/invoice for n months ago (-0 to -12)
          -x    - specify days to exclude (sat/sun excluded anyway)
          -i    - specify days to include
          am|pm - just the morning or afternoon was taken off (half a day)

      EOB
      exit
    end

    # Arguments (other args must be removed before days)
    @days_are_included = ARGV.delete('-i')
    @days_are_excluded = ARGV.delete('-x')
    if @days_are_included && @days_are_excluded
      puts "Days can only be included or excluded. Not both. Specify -i or -x."
      exit 1
    end

    @overwrite = ARGV.delete('-f')
    month = (0..12).detect {|n| ARGV.delete("-#{n}") }
    if ARGV.size > 0
      @days = Hash[*(ARGV.first.split(',').map do |day|
        [day.to_i, day =~ /am|pm/ ? 0.5 : 1.0]
      end.flatten)]
    else
      @days = []
    end

    date = month.month.ago.beginning_of_month.to_date
    if File.exist?(timesheet_filename(date)) || File.exist?(invoice_filename(date))
      if @overwrite
        FileUtils.rm_f(timesheet_filename(date))
        FileUtils.rm_f(invoice_filename(date))
      else
        puts "Existing timesheet and/or invoice detected for #{date}"
        puts "Use -f to overwrite"
        exit 1
      end
    end
    total_days = write_timesheet(date)
    write_pdf(Invoice.new(date, total_days))
  end

  def self.dividend
    if ARGV.size != 5
      puts 'dividend <final|interim> <date_paid> <tax_year_end> <net> <year_end>'
      puts '  date_paid     (yyyymmdd)'
      puts '  tax_year_end  (yyyy)'
      puts '  net           amount dividend actually paid out'
      puts '  year_end      company accounts year end (yyyy)'
    else
      write_pdf(Dividend.new(ARGV))
    end
  end
end

