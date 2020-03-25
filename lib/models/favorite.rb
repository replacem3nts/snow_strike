class Favorite < ActiveRecord::Base
    belongs_to :user
    belongs_to :mountain

    def self.remove_array_of_favorites(array)
        array.each {|fav| Favorite.find(fav).destroy}
    end
end