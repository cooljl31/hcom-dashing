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

  opsPrimary = people.find_person(Date.today, OPS_PRIMARY)
  opsSecondary = people.find_person(Date.today, OPS_SECONDARY)
  send_event('ops', { text: opsPrimary + "<br/>" + opsSecondary })

  triageCount = issues.get_triage_count('Production')
  triagePreviousCount = issues.get_triage_count_previous('Production')
  send_event('triage', { current: triageCount, last: triagePreviousCount })

  readyCount = issues.get_ready_count('Production')
  readyPreviousCount = issues.get_ready_count_previous('Production')
  send_event('ready', { current: readyCount, last: readyPreviousCount })

  points = Array.new
  (0..(30 - issues.get_totals(30, 'Production').length)).each do |i| 
    points[i] = { x: i, y: 0}    
  end
  
  ((30 - issues.get_totals(30, 'Production').length + 1)..30).each do |j|
    points[j] = { x: j, y: issues.get_totals(30, 'Production')[(j - (30 - issues.get_totals(30, 'Production').length + 1))]}  
  end

  send_event('countgraph', points: points)

  
  releasePrimary =  people.find_person(Date.today, RELEASE_PRIMARY)
  releaseSecondary = people.find_person(Date.today, RELEASE_SECONDARY)
  send_event('rel', { text: releasePrimary + "<br/>" + releaseSecondary })

  triageCount = issues.get_triage_count('Release')
  triagePreviousCount = issues.get_triage_count_previous('Release')
  send_event('releasetriage', { current: triageCount, last: triagePreviousCount })

  readyCount = issues.get_ready_count('Release')
  readyPreviousCount = issues.get_ready_count_previous('Release')
  send_event('releaseready', { current: readyCount, last: readyPreviousCount })

  points = Array.new
  (0..(30 - issues.get_totals(30, 'Release').length)).each do |i| 
    points[i] = { x: i, y: 0}    
  end
  
  ((30 - issues.get_totals(30, 'Release').length + 1)..30).each do |j|
    points[j] = { x: j, y: issues.get_totals(30, 'Release')[(j - (30 - issues.get_totals(30, 'Release').length + 1))]}  
  end

  send_event('releasecountgraph', points: points)

end