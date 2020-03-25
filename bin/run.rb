require_relative '../config/environment'

interface = Interface.new()
interface.welcome

user_instance = interface.choose_login_or_register
interface.user = user_instance

go_to = interface.main_menu

case go_to
when 1
    interface.find_mtns
when 2
    interface.my_trips
when 3
    interface.my_favorites
when 4
    interface.account_settings
else
    return
end

puts "hello world"

