class ImportantDateService

  def create(application_date_string)
    application_date = DateTime.parse(application_date_string)
    disclose_by_date = find_disclose_by_date(application_date)
    earliest_closing_date = find_earliest_closing_date(disclose_by_date)

    {
        application_date: application_date,
        disclose_by_date: disclose_by_date,
        earliest_closing_date: earliest_closing_date
    }
  end

  def update(date_hash)
    hash = convert_keys_to_date_time(date_hash)
    hash
  end

  private

  def find_disclose_by_date(application_date)
    date = application_date
    count = 0
    until count == 3 do
      unless is_saturday(date)
        count += 1
      end
      date += 1.day
    end
    date
  end

  def find_earliest_closing_date(disclose_by_date)
    date = disclose_by_date
    count = 0
    until count == 7 do
      unless is_saturday(date)
        count += 1
      end
      date += 1.day
    end
    date
  end

  def is_saturday(date)
    date.strftime("%A") == "Saturday"
  end

end