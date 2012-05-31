require 'thread'  
  
class ThreadPool  
  class Worker  
    def initialize  
      @mutex = Mutex.new  
      @thread = Thread.new do  
        while true
	  begin
            sleep 0.001  
            block = get_block  
            if block  
              block.call  
              reset_block  
            end  
	  rescue Exception => ex
		puts ex.message + "\n" +  ex.backtrace.join("\n");
		log( APP_ERROR_LOG_PATH , ex.message + "\n" +  ex.backtrace.join("\n"));
	    reset_block
	  end  
        end  
      end  
    end  
      
    def get_block  
      @mutex.synchronize {@block}  
    end  
      
    def set_block(block)  
      @mutex.synchronize do  
        raise RuntimeError, "Thread already busy." if @block  
        @block = block  
      end  
    end  
      
    def reset_block  
      @mutex.synchronize {@block = nil}  
    end  

    def busy?
      @mutex.synchronize {!@block.nil?}  
    end  
      
  
  end  
    
  attr_accessor :max_size  
  attr_reader :workers  
  
  def initialize(max_size = 10)  
    @max_size = max_size  
    @workers = []  
    @mutex = Mutex.new 
    create_worker 
  end  
    
  def size  
    @mutex.synchronize {@workers.size}  
  end  

  def free_worker_count
     @mutex.synchronize{

	    rtn = 0; 
	    @workers.each { |w| 
	      if w.busy? === false 
		rtn = rtn + 1;
	      end
	    }
            return rtn;
      }
    
  end

  def full?
    @mutex.synchronize{
	@workers.each {|w| 
	   if !w.busy?
		return false;
	   end
	}; 
	return true;
    }
  end
    
  def busy?  
    @mutex.synchronize {@workers.any? {|w| w.busy?}}  
  end  
    
  def join  
    sleep 0.01 while busy?  
  end  
    
  def process(&block) 
    wait_for_worker.set_block(block)  
  end  
    
  def wait_for_worker  
    while true  
      worker = find_available_worker  
      return worker if worker  
      sleep 0.01  
    end  
  end  
    
  def find_available_worker  
    @mutex.synchronize {free_worker}  
  end  
    
  def free_worker  
    @workers.each {|w| return w unless w.busy?}; nil  
  end  
    

  def create_worker  
    @max_size.times do
    	 worker = Worker.new  
    	@workers << worker
    end  
  end  
end  
