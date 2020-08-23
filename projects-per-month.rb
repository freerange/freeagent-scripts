require 'bundler/setup'
require 'freeagent_api'
require 'csv'

@api = FreeagentAPI.new

number_of_months = Integer(ARGV[0]) rescue 1
reference_date = Date.today << number_of_months

projects = @api.get_resources('projects')
tasks = @api.get_resources('tasks')

results = {}

while reference_date < Date.today do
  month_key = reference_date.strftime('%b %Y')
  year = reference_date.year
  month = reference_date.month
  from_date = Date.new(year, month, 1)
  to_date = Date.new(year, month, -1)

  timeslips = @api.get_resources('timeslips', from_date: from_date, to_date: to_date, reporting_type: 'billable')

  results[month_key] = timeslips.group_by(&:task).map do |task_url, ts|
    task = tasks.find { |t| t.url == task_url }
    next unless task
    project_url = task.project
    project = projects.find { |p| p.url == project_url }
    next unless project
    contact_url = project.contact
    contact = @api.get_resource('contact', contact_url)
    [contact.organisation_name, project.name, task.name].join(' - ')
  end.compact.sort

  reference_date = reference_date >> 1
end

CSV($stdout, col_sep: "\t") do |csv|
  csv << ['Month', 'Project']
  results.each do |month_key, project_names|
    if project_names.empty?
      csv << [month_key]
    else
      project_names.each do |project_name|
        csv << [month_key, project_name]
      end
    end
  end
end
