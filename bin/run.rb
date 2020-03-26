require_relative '../config/environment'

interface = Interface.new()
interface.welcome

user_instance = interface.login_or_reg
interface.user = user_instance
interface.lets_start_msg

interface.main_menu

system 'clear'
5.times {puts " "}
puts "                MAY THE POW BE WITH YOU!!!!!"
5.times {puts " "}

