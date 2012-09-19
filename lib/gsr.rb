require 'mechanize'
require 'open-uri'

#Utility time methods
class Time
	#Converts start_time from time to formatted string
	def format_start_time()
		#Hour logic
		if self.hour < 0
			raise "Invalid self specified: hour can't be negative"
		elsif self.hour == 0
			hour = 12
			half = "AM"
		elsif self.hour == 12
			hour = 12
			half = "PM"
		elsif self.hour > 12
			hour = self.hour - 12
			half = "PM"
		else # 0 < self.hour < 12
			hour = self.hour
			half = "AM"
		end
		
		#Minute logic
		if self.min < 10
			min = "0" + self.min.to_s
		else
			min = self.min.to_s
		end
		
		return hour.to_s + ':' + min + " " + half
	end
	
	#Converts start_date from date to formatted string
	def format_start_date()
		if Date.valid_date?(self.year, self.month, self.day)
			return self.month.to_s + '/' + self.day.to_s
		else
			raise "Invalid start date specified."
		end
	end
end

# GSR class handles making GSR reservations
class GSR
	attr_accessor :username, :password, :spike_root_url
	
	def initialize(username, password, spike_root_url = "http://spike.wharton.upenn.edu/m/gsr.cfm?logout=true")
		@username = username
		@password = password
		@spike_root_url = spike_root_url
	end
	
	# Logs in to spike using mechanize
	def spike_login()
		agent = Mechanize.new
		login = agent.get(self.spike_root_url) #Go to login page
		loginform = agent.page.forms.first #Select login form
		loginform.username = self.username
		loginform.password = self.password
		gsr = agent.submit(loginform, loginform.buttons.first) #Submit form and log in
		return {'agent' => agent, 'gsr' => gsr}
	end
	
	#Reserves the GSR
	#requirements is an optional hash with keys:
		#floor (string [F, G, 2, 3]), start_time (Time), duration (integer, minutes [30,60, or 90])
	def reserve(requirements)		
		#Check if we have a non-kosher floor and revert to default
		requirements['floor'] = "" if !(requirements['floor'].nil?) and 
			!(["", "F", "G", "2", "3"].include? requirements['floor'])
		
		#Default args
		default_options = {'floor' => "", 'start_time' => Time.now, 'duration' => 90}
		args = default_options.merge(requirements)
		
		#Convert start_date and start_time from date and time to correct form format
		start_time = args['start_time'].format_start_time
		start_date = args['start_time'].format_start_date
		
		#Duration logic - round to 30, 60, or 90 (nearest)
		unless requirements['duration'].nil?
			if args['duration'] <= 30
				args['duration'] = 30
			elsif args['duration'] <= 60
				args['duration'] = 60
			else
				args['duration'] = 90
			end
		end
		
		agent = spike_login()['agent'] # Mechanize agent at successful login page
		gsr = spike_login()['gsr'] # Mechanize page = successful login page
		gsrform = gsr.form_with(:action => 'https://spike.wharton.upenn.edu/m/gsr.cfm') #Select GSR form

		#Input GSR info
		gsrform.preferred_floor = args['floor']
		gsrform.start_date = start_date
		gsrform.start_time = start_time
		gsrform.duration = args['duration']
		
		#Submit reservation
		submit = agent.submit(gsrform, gsrform.buttons.first)
		
		#Check if successful
		raise "Error reserving GSR. Check supplied parameters." if submit.link_with(:text => 'Cancel').nil?
		
	end
	
	#Cancels most recent GSR reservation
	def cancel()
		agent = spike_login()['agent'] # Mechanize agent at successful login page
		gsr = spike_login()['gsr'] # Mechanize page = successful login page
		
		cancel = gsr.link_with(:text => 'Cancel')
		if (cancel.nil?)
			raise "Error: You have no GSR reservation to cancel."
		else
			gsr = cancel.click
		end
	end
end