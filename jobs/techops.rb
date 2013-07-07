require 'rubygems'
require 'mongo'
require 'jira'
require_relative '../lib/issues'
require_relative '../lib/people'
require_relative '../lib/servicenow'

issues = Issues.new
people = People.new
service_now = ServiceNow.new

SCHEDULER.every '1m' do

  points = Array.new
  (0..(30 - issues.get_totals(30).length)).each do |i| 
    points[i] = { x: i, y: 0}    
  end
  
  ((30 - issues.get_totals(30).length + 1)..30).each do |j|
    points[j] = { x: j, y: issues.get_totals(30)[(j - (30 - issues.get_totals(30).length + 1))]}  
  end

  send_event('countgraph', points: points)

  allCount = issues.get_total
  allPreviousCount = issues.get_total_previous
  send_event('count', { current: allCount, last: allPreviousCount })

  triageCount = issues.get_triage_count
  triagePreviousCount = issues.get_triage_count_previous
  send_event('triage', { current: triageCount, last: triagePreviousCount })

  readyCount = issues.get_ready_count
  readyPreviousCount = issues.get_ready_count_previous
  print "Ready"
  puts readyCount
  puts readyPreviousCount
  send_event('ready', { current: readyCount, last: readyPreviousCount })

  oneWeekRaisedCount = issues.get_raised_seven_days
  oneWeekRaisedPreviousCount = issues.get_raised_seven_days_previous
  send_event('raised', { current: oneWeekRaisedCount, last: oneWeekRaisedPreviousCount })

  oneWeekResolvedCount = issues.get_resolved_seven_days
  oneWeekResolvedPreviousCount = issues.get_resolved_seven_days_previous
  send_event('resolved', { current: oneWeekResolvedCount, last: oneWeekResolvedPreviousCount })

  opsPrimary = people.find_person(Date.today, OPS_PRIMARY)
  opsSecondary = people.find_person(Date.today, OPS_SECONDARY)
  send_event('ops', { text: opsPrimary + "<br/>" + opsSecondary })

  releasePrimary =  people.find_person(Date.today, RELEASE_PRIMARY)
  releaseSecondary = people.find_person(Date.today, RELEASE_SECONDARY)
  send_event('rel', { text: releasePrimary + "<br/>" + releaseSecondary })

  rcaCount = service_now.get_rca_count()
  rcaCountPrevious = service_now.get_rca_count_previous()
  send_event('rca', { current: rcaCount, last: rcaCountPrevious })

end
