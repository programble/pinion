require 'lib/time'

class Pinion::Timer
  attr_accessor :queue
  def initialize
    # @queue is an array in the form of [time, interval, handler]
    @queue = []
    run
  end

  def add(interval, thread = false, &handler)
    handler = proc { Thread.new &handler } if thread
    @queue << [Time.now, interval, handler]
  end

  def run
    Thread.new do
      loop do 
        @queue.each do |q|
          next if q[0] > Time.now
          q[0] += q[1]
          q[2].call
        end
        # This seems to be enough, so I'll leave it like this for now...
        sleep 0.1
      end
    end
  end
end
