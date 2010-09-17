module DateTimeHelper
  def format_datetime(datetime)
    datetime.to_time.strftime("%H:%M, %d %b %Y")
  end
end
