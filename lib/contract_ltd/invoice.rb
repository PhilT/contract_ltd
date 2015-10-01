def file_date(prefix, date, suffix)
  "#{prefix}_#{date.to_s(:file_no_day)}.#{suffix}"
end

def timesheet_filename(date)
  file_date("timesheet", date, "csv")
end

def invoice_filename(date)
  file_date("invoice", date, "pdf")
end

def write_timesheet(date)
  csv = "Timesheet for Ruby Web Development Services\n"
  csv += "by Phil Thompson (Electric Visions Ltd)\n"
  csv += "for #{date.to_s(:month_name_year)}\n\n"
  csv += "Day,Hours\n"
  total = 0
  (date..date.end_of_month.to_date).each do |d|
    day = working_days(d)
    total += day if day.is_a?(Float)
    csv += "#{d.day},#{day * config['hours']}\n"
  end
  csv += "\n"
  csv += "Total (hours),#{total * config['hours']}\n"
  csv += "Total (days),#{total}\n"
  File.open(timesheet_filename(date), 'w') {|f| f.write csv }
  total
end

class Invoice
  def initialize(date, total_days)
    @name = 'invoice'
    @date = date
    @total_days = total_days
  end

  def invoice_num
    previous_invoice_count = Dir['invoice_*'].size
    if previous_invoice_count == 0
      puts "WARNING: NO PREVIOUS INVOICES DETECTED"
      puts "If this is the first invoice you can ignore this warning"
      puts "Otherwise make sure previous invoices are in the correct format:"
      puts "    #{timesheet_filename(@date)}"
      puts "    #{invoice_filename(@date)}"
    end
    '%03d' % (previous_invoice_count + 1)
  end

  def month_year
    @date.to_s(:month_name_year)
  end

  def todays_date
    Date.today.to_s(:long)
  end

  def total_hours
    @total_days * 7.5
  end

  def rate(rate = nil)
    @rate ||= rate
  end

  def days
    @total_days
  end

  def subtotal
    rate * days
  end

  def vat
    subtotal * 0.2
  end

  def total
    subtotal + vat
  end

  def name(ext)
    "#{@name}.#{ext}"
  end

  def filename
    invoice_filename(@date)
  end
end

def working_days(date)
  if @days_are_included
    @days[date.day] || ''
  else
    if date.saturday? || date.sunday?
    ''
    else
      1.0 - @days[date.day].to_f
    end
  end
end

