require 'puppet'
Puppet::Reports.register_report(:myreport) do
  desc "Process reports via the my_cool_cmdb API."

  def process
    Puppet.notice "METRICS: Process Puppet Report"
    Puppet.notice "METRICS: self.logs.last.message: #{self.logs.last.message}"
    self.metrics['time'].values.each { |val|
      Puppet.notice "METRICS: #{val[1]} : #{val[2]}" if val[0] == 'total'
    }
  end
end
