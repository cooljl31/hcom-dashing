require 'rubygems'
require 'mongo'
require 'jira'

class Issues

  @@CONNECTION          = Mongo::Connection.new
  @@DB                  = @@CONNECTION.db("hcom-techops")
  @@COLLECTION_ALL      = @@DB.collection("-count-all")
  @@COLLECTION_TRIAGE   = @@DB.collection("-count-triage")
  @@COLLECTION_READY    = @@DB.collection("-count-ready")
  @@COLLECTION_UPDATED  = @@DB.collection("-updated")

  @@username = "readonly123"
  @@password = "readonly123"

  @@options = {
      :username => @@username,
      :password => @@password,
      :site     => 'http://jira.hotels.com',
      :context_path => '',
      # :context_path => '/myjira',
      :auth_type => :basic,
      :use_ssl => false,
      :ssl_verify_mode => false
  }

  @@client = JIRA::Client.new(@@options)

  # Get total issues
  def get_total(label)
    allCount = @@client.Issue.jql('project = "INFRA" AND resolution = "Unresolved" AND labels in "(' +  label + ')"').size
    doc = { "date" => Date.today.to_time.utc, "count" => allCount }
    @@DB.collection(label + "-count-all").update( {"date" => Date.today.to_time.utc}, {"$set" => doc}, { upsert: true } )
    return allCount
  end

  # Get total for each day for last days
  def get_totals(days, label)
    var1 = []
    issues = @@DB.collection(label + "-count-all").find(:date => {:$gte => (Date.today - days).to_time.utc, :$lte => Date.today.to_time.utc}).sort(:date => :asc)
    for a in 0..issues.count() - 1
      var1[a] = issues.next()['count'];
    end
    return var1
  end

  def get_total_previous(label)
    issues = @@DB.collection(label + "-count-all").find(:date => {:$lte => (Date.today - 1).to_time.utc}).sort(:date => :asc)
    issue = issues.next
    issue.nil? ? 0 : issue['count']
  end


  # Get triage count 
  def get_triage_count(label)
    count = @@client.Issue.jql('project = "INFRA" AND Status = "New" AND labels in "(' +  label + ')"').size
    doc = { "date" => Date.today.to_time.utc, "count" => count }
    @@DB.collection(label + "-count-triage").update( {"date" => Date.today.to_time.utc}, {"$set" => doc}, { upsert: true } )
    count
  end

  def get_triage_count_previous(label)
    issues = @@DB.collection(label + "-count-triage").find(:date => {:$lte => (Date.today - 1).to_time.utc}).sort(:date => :asc)
    issue = issues.next
    issue.nil? ? 0 : issue['count']
  end


  # Get ready count 
  def get_ready_count(label)
    count = @@client.Issue.jql('project = "INFRA" AND (Status = "Open" OR Status = "Reopened" OR Status = "More Info Required") AND labels in "(' +  label + ')"').size
    doc = { "date" => Date.today.to_time.utc, "count" => count }
    @@DB.collection(label + "-count-ready").update( {"date" => Date.today.to_time.utc}, {"$set" => doc}, { upsert: true } )
    count
  end

  def get_ready_count_previous(label)
    issues = @@DB.collection(label + "-count-ready").find(:date => {:$lte => (Date.today - 1).to_time.utc}).sort(:date => :asc)
    issue = issues.next
    issue.nil? ? 0 : issue['count']
  end


  # Get issues raised in last 7 days
  def get_raised_seven_days()
    count = @@client.Issue.jql('project = "INFRA" AND created >= "-1w"').size
    doc = { "date" => Date.today.to_time.utc, "count" => count }
    @@COLLECTION_RAISED.update( {"date" => Date.today.to_time.utc}, {"$set" => doc}, { upsert: true } )
    count
  end

  def get_raised_seven_days_previous()
    issues = @@COLLECTION_RAISED.find(:date => {:$lte => (Date.today - 1).to_time.utc}).sort(:date => :asc)
    issue = issues.next
    issue.nil? ? 0 : issue['count']
  end


  # Get issues resolved in last 7 days
  def get_resolved_seven_days()
    count = @@client.Issue.jql('project = "INFRA" AND NOT resolution = "Unresolved" AND resolved >= "-1w"').size
    doc = { "date" => Date.today.to_time.utc, "count" => count }
    @@COLLECTION_RESOLVED.update( {"date" => Date.today.to_time.utc}, {"$set" => doc}, { upsert: true } )
    return count
  end

  def get_resolved_seven_days_previous()
    issues = @@COLLECTION_RESOLVED.find(:date => {:$lte => (Date.today - 1).to_time.utc}).sort(:date => :asc)
    issue = issues.next
    issue.nil? ? 0 : issue['count']
  end

  # Get unresolved issues by user
  def get_unresolved_by_user(user)
    count = @@client.Issue.jql('project = "INFRA" AND resolution = "Unresolved" AND assignee = "' + user + '"').size
    return count
  end


  # Get unresolved issues by user
  def updated()
    doc = {"time" => Time.now.utc }
    @@COLLECTION_UPDATED.insert( doc )
  end

end
