
module BleakHouse
  # The body of the exit handler and <tt>SIGUSR2</tt> trap. It writes a snapshot to a dumpfile named after the current Process.pid.
  def self.hook
    @count ||= 0
    filename = "/tmp/bleak.#{Process.pid}.#{@count}.dump"
    STDERR.puts "** BleakHouse: working..."
    BleakHouse.snapshot(filename)
    STDERR.puts "** BleakHouse: complete\n** Bleakhouse: Run 'bleak #{filename}' to analyze."
    @count += 1
  end
end

unless ENV['NO_EXIT_HANDLER']
  Kernel.at_exit do
    BleakHouse.hook
  end
  STDERR.puts "** Bleakhouse: installed"
end

Kernel.trap("USR2") do
  BleakHouse.hook
end