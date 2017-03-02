require 'rubygems'
require 'json'
require 'haml'

require './lib/crontab'
require './lib/cron_job'
require './lib/cron_parser'


EVENT_DATA = {
  :default => {
    "color"       => "#7FFFD4",
    "textColor"   => "#000000",
    "classname"   => "default",
    "durationEvent" => false},

  :every_minute => {
    "title_prefix"  => "Every minute: ",
    "color"         => "#f00",
    "durationEvent" => true},

  :every_five_minutes => {
    "title_prefix"  => "Every five minutes: ",
    "color"         => "#fa0",
    "durationEvent" => true}
}


class Time
  def beginning_of_day
    Time.mktime(year, month, day).send(gmt? ? :gmt : :localtime)
  end
  def end_of_day
    self.beginning_of_day + (60*60*24)
  end
end

def main
  earliest_time = (Time.now.beginning_of_day()+(5*24*60*60)).to_s.gsub(" +0100","")
  latest_time   = (Time.now.end_of_day()+(5*24*60*60)).to_s.gsub(" +0100","")

  json = Cronviz::Crontab.new(:earliest_time=>earliest_time, :latest_time=>latest_time, :event_data=>EVENT_DATA).to_json
  haml = open("assets/container.haml").read
  html = Haml::Engine.new(haml).render(Object.new,
                                       :earliest_time => earliest_time,
                                       :latest_time   => latest_time,
                                       :cron_json     => json)                                       

  open("output.html", "w") do |f|
    f.write html
  end
  print "./output.html successfully created!"

end

main()
