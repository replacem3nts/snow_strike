User.destroy_all
Trip.destroy_all
Mountain.destroy_all
Favorite.destroy_all


s1 = User.create(username: "hotdoggin", skier_type: "skier", hometown: "Aspen, CO", age: 39)
s2 = User.create(username: "80s_ski_suit", skier_type: "skier", hometown: "Teluride, CO", age: 43)
s3 = User.create(username: "pow_life", skier_type: "both", hometown: "Jackson, WY", age: 32)
s4 = User.create(username: "board_bunny", skier_type: "snowboarder", hometown: "Waitsfield, VT", age: 27)
s5 = User.create(username: "mr_steep_and_deep", skier_type: "snowboarder", hometown: "New York, NY", age: 24)
s6 = User.create(username: "chicks_rip", skier_type: "snowboarder", hometown: "Boston, MA", age: 42)

m1 = Mountain.create(name: "Jackson Hole", state: "WY", zip_code: 83025, hist_snow_per_year: 430)
m2 = Mountain.create(name: "Snowbird", state: "UT", zip_code: 84092, hist_snow_per_year: 415)
m3 = Mountain.create(name: "Big Sky", state: "MT", zip_code: 59716, hist_snow_per_year: 395)
m4 = Mountain.create(name: "Taos", state: "NM", zip_code: 87525, hist_snow_per_year: 250)
m5 = Mountain.create(name: "Vail", state: "CO", zip_code: 81657, hist_snow_per_year: 315)
m6 = Mountain.create(name: "Sugarbush", state: "VT", zip_code: 05674, hist_snow_per_year: 215)
m7 = Mountain.create(name: "Stowe", state: "VT", zip_code: 05672, hist_snow_per_year: 205)

Favorite.create(user_id: s1.id, mountain_id: m1.id)
Favorite.create(user_id: s1.id, mountain_id: m4.id)
Favorite.create(user_id: s1.id, mountain_id: m5.id)
Favorite.create(user_id: s2.id, mountain_id: m5.id)
Favorite.create(user_id: s2.id, mountain_id: m2.id)
Favorite.create(user_id: s3.id, mountain_id: m1.id)
Favorite.create(user_id: s3.id, mountain_id: m2.id)
Favorite.create(user_id: s3.id, mountain_id: m3.id)
Favorite.create(user_id: s3.id, mountain_id: m6.id)
Favorite.create(user_id: s3.id, mountain_id: m7.id)
Favorite.create(user_id: s4.id, mountain_id: m1.id)
Favorite.create(user_id: s4.id, mountain_id: m6.id)
Favorite.create(user_id: s4.id, mountain_id: m7.id)
Favorite.create(user_id: s5.id, mountain_id: m1.id)
Favorite.create(user_id: s6.id, mountain_id: m2.id)
Favorite.create(user_id: s6.id, mountain_id: m3.id)

Trip.create(name: "Jackson Camp", start_date: "2021-02-15", end_date: "2021-02-23", mountain_id: m1.id, user_id: s3.id)
Trip.create(name: "Family Ski", start_date: "2021-01-13", end_date: "2021-01-26", mountain_id: m5.id, user_id: s3.id)
Trip.create(name: "Desert Strike", start_date: "2021-03-18", end_date: "2021-03-21", mountain_id: m4.id, user_id: s3.id)
Trip.create(name: "Girls Weekend", start_date: "2021-02-20", end_date: "2021-02-23", mountain_id: m3.id, user_id: s4.id)
Trip.create(name: "Girls Weekend", start_date: "2021-02-20", end_date: "2021-02-23", mountain_id: m3.id, user_id: s6.id)
Trip.create(name: "Get me outta here", start_date: "2021-01-13", end_date: "2021-01-26", mountain_id: m6.id, user_id: s5.id)
Trip.create(name: "Maple Sugar Fest", start_date: "2021-02-16", end_date: "2021-02-23", mountain_id: m4.id, user_id: s3.id)