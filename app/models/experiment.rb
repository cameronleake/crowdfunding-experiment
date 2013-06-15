class Experiment < ActiveRecord::Base
	has_many :rounds, :dependent => :destroy
  has_many :groups, :through => :rounds
	has_many :users, :dependent => :destroy  
	
	after_create :generate_rounds 
  after_create :generate_users
  after_create :generate_preferences
	
	
	def generate_rounds
		1.upto(NUMBER_OF_ROUNDS) do |i|
			self.rounds << Round.create(:number => i)
		end
		self.save!
	end
	
	
	def generate_users     
    @rand_array = (0..(NUMBER_OF_USERS-1)).to_a.sort{ rand() - 0.5 }[0..(NUMBER_OF_CREATORS-1)]
    NUMBER_OF_USERS.times do |i|  
      if @rand_array.include?(i)
        self.users << User.create(:name => "temp", :user_type => "Creator") 
      else
        self.users << User.create(:name => "temp", :user_type => "Donor") 
      end
    end  
		self.save!
	end
	
	                                                            
	def generate_preferences
    @creators = []
    @donors = []
    User.where(:experiment_id => self.id).each_with_index do |user, j|
      if user.user_type == "Creator"
        @creators << user
      elsif user.user_type == "Donor"
        @donors << user             
      end
    end    
    
    self.rounds.each_with_index do |round, i|  
      @round_groups = []
      round.groups.each do |group|
        @round_groups << group
      end        
     
      @random_creator_group = (0..(NUMBER_OF_CREATORS-1)).to_a.sort{ rand() - 0.5 }[0..(NUMBER_OF_CREATORS_PER_GROUP-1)] 
      @creators.each_with_index do |creator, k|
        if @random_creator_group.include?(k)
          creator.creator_preferences << CreatorPreference.create(:group => @round_groups[0], :round => round)            
        else
          creator.creator_preferences << CreatorPreference.create(:group => @round_groups[1], :round => round)           
        end
      end
      
      @random_donor_group = (0..(NUMBER_OF_DONORS-1)).to_a.sort{ rand() - 0.5 }[0..(NUMBER_OF_DONORS_PER_GROUP-1)]   
      @donors.each_with_index do |donor, m|
        if @random_donor_group.include?(m)
          donor.donor_preferences << DonorPreference.create(:group => @round_groups[0], :round => round)            
        else
          donor.donor_preferences << DonorPreference.create(:group => @round_groups[1], :round => round)              
        end        
      end
     
      @random_special_donors = (0..(NUMBER_OF_DONORS_PER_GROUP-1)).to_a.sort{ rand() - 0.5 }[0..(NUMBER_SPECIAL_DONORS_PER_GROUP-1)]  
      @round_groups.each do |group|
        DonorPreference.where(:round_id => round, :group_id => group).each_with_index do |preference, n|
          if @random_special_donors.include?(n) 
            preference.special_donor = true
            preference.save!     
          end
        end
      end
    end
    self.save!                                  
  end                             
	
	
	def set_current_round(round)
    if self.current_round_number != round.number
      self.current_round_number = round.number
      self.save!
    end
  end
	
	
	def start_experiment
    unless self.started?
      self.started = true
      self.start_time = Time.now
      self.current_round_number = 1
      self.save!
    end
	end

	
	def experiment_over         # <TODO CL> Revise logic.
		self.users.each do |user|
			user.payout = 0
			@preferences = Preferences.where(:user_id => user.id)
			@preferences.each do |pref|
				user.payout += pref.round_payout
			end
			user.save!
		end
	
		self.finished_calc = true
		self.save!
	end
  
end
