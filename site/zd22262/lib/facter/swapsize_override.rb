Facter.add(:swapsize) do
  confine :osfamily => "AIX"
  setcode do
    value = 0
    output = Facter::Core::Execution.exec('swap -l 2>/dev/null')
    output.each_line do |line|
      if line =~ /^\/\S+\s.*\s+(\S+)MB\s+(\S+)MB/ 
        value += $1.to_i
    end
    value
  end
end
