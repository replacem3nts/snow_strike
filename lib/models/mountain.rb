class Mountain < ActiveRecord::Base
    has_many :favorites
    has_many :trips
end