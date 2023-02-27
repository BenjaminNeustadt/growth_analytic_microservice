class Event < ActiveRecord::Base
  include WebHookMessageHelper

  self.table_name = 'events'
  
  def self.memory
    all.tap { |a| a.empty? and return MESSAGE[:absent_data] }
  end

  def self.trials_count
     where(name: 'trial').count
  end

  def self.signups_count
     where(name: 'signup').count
  end

  def self.unsubscribe_count
     where(name: 'unsubscribe').count
  end

  def self.trial_users
    where(name: 'trial')
  end

  def self.signup_users
    where(name: 'signup', user_id: trial_users.pluck(:user_id))
  end

  def self.actions_and_records
    {
      actions: {
        trials: trials_count,
        signups: signups_count,
        'trial-to-signup-conversion': signup_users.count,
        unsubscribe: unsubscribe_count
      },
      records: memory
    }.to_json
  end

end
