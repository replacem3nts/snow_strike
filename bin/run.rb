require_relative '../config/environment'

interface = Interface.new()
interface.welcome

user_instance = interface.login_or_reg
interface.user = user_instance
interface.lets_start_msg

interface.main_menu

system 'clear'
Art.goodbye_msg_1
sleep(1.5)
system 'clear'
Art.goodbye_msg_2
sleep(0.75)
system 'clear'
Art.goodbye_msg_3
sleep(0.75)
system 'clear'
Art.goodbye_msg_4
sleep(0.75)
system 'clear'
Art.goodbye_msg_5
sleep(3)
system 'clear'
