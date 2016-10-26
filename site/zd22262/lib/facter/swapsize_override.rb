Facter.add(:myswapsize) do
  confine :osfamily => "AIX"
  has_weight = 1000
  setcode do
    value = 0
    output = Facter::Core::Execution.exec('swap -l 2>/dev/null')
    output.each_line do |line|
      if line =~ /^\/\S+\s.*\s+(\S+)MB\s+(\S+)MB/ 
        value += $1.to_i
      end
    end
    value
  end
end

Facter.add(:myswapsize_mb) do
  confine :osfamily => "AIX"
  has_weight = 1000
  setcode do
    value = 0
    output = Facter::Core::Execution.exec('swap -l 2>/dev/null')
    output.each_line do |line|
      if line =~ /^\/\S+\s.*\s+(\S+)MB\s+(\S+)MB/ 
        value += $1.to_i
      end
    end
    value
  end
end
