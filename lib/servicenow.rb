require 'rubygems'
require 'mongo'
require 'json'
require 'net/http'
require 'uri'
require 'date'

class ServiceNow

  @@CONNECTION          = Mongo::Connection.new
  @@DB                  = @@CONNECTION.db("hcom-techops")
  @@COLLECTION_RCA      = @@DB.collection("geckoboard-count-rca")
  
  
  # Get total issues
  def get_rca_count()

    uri = URI.parse("https://expedia.service-now.com/problem_task_list.do?JSON&sysparm_query=active%3Dtrue%5Eassignment_groupLIKEH.com&displayvalue=all")

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    request = Net::HTTP::Get.new(uri.request_uri)
    request.basic_auth 'dallison', 'Zxcvbnm3'

    response = http.request(request)
    if response.code == "200"
      result = JSON.parse(response.body)
      rca_count = result['records'].size
      puts result['records'].size
    else
      puts "ERROR!!!"
    end

    doc = { "date" => Date.today.to_time.utc, "count" => rca_count }
    @@COLLECTION_RCA.update( {"date" => Date.today.to_time.utc}, {"$set" => doc}, { upsert: true } )
    return rca_count
  end

  def get_rca_count_previous
    counts = @@COLLECTION_RCA.find(:date => {:$lte => (Date.today - 1).to_time.utc}).sort(:date => :asc)
    count = counts.next
    count.nil? ? 0 : count['count']
  end


end
