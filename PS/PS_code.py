################################################################################################################################
# Class that allows to write bold text to the prints in console
class txt:
    end           = '\033[0m'
    bold          = '\033[01m'
    
    
    
################################################################################################################################
# Add overlay from PL
from pynq import Overlay
ol = Overlay("./bitstream/design1.bit") # import overlay from PL side to PS

################################################################################################################################
# Mapping inputs and outputs from PS to PL
from pynq import GPIO
# Arrange space for every variable/bus being used for data transfers
# INPUT CONFIGURATION
sw           = [GPIO(GPIO.get_gpio_pin(i), 'in') for i in range(58, 56, -1)]
button       = [GPIO(GPIO.get_gpio_pin(i), 'in') for i in range(56, 52, -1)]
# OUTPUT CONFIGURATIONd
led          = [GPIO(GPIO.get_gpio_pin(i), 'out') for i in range(46, 42, -1)]
rgbled1      = [GPIO(GPIO.get_gpio_pin(i), 'out') for i in range(52, 49, -1)]
rgbled2      = [GPIO(GPIO.get_gpio_pin(i), 'out') for i in range(49, 46, -1)]
f_fsk_bus    = [GPIO(GPIO.get_gpio_pin(i), 'out') for i in range(15, -1, -1)]
f_psk_bus    = [GPIO(GPIO.get_gpio_pin(i), 'out') for i in range(31, 15, -1)]
fsk_gain_bus = [GPIO(GPIO.get_gpio_pin(i), 'out') for i in range(34, 31, -1)]
psk_gain_bus = [GPIO(GPIO.get_gpio_pin(i), 'out') for i in range(37, 34, -1)]
mux_sel_bus  = [GPIO(GPIO.get_gpio_pin(i), 'out') for i in range(40, 37, -1)]
mode_fsk_bus = GPIO(GPIO.get_gpio_pin(41), 'out')
mode_psk_bus = GPIO(GPIO.get_gpio_pin(42), 'out')

################################################################################################################################
import time
from IPython.display import clear_output
from threading import Thread
import math

#--- hardcoded config variables ---#
MIN_MOD_LEVEL  = 2
MAX_MOD_LEVEL  = 4
MIN_GAIN_LEVEL = 0
MAX_GAIN_LEVEL = 7
MIN_MUX_POS    = 0
MAX_MUX_POS    = 7
CLK_44K1       = 44.1e3                # clock used for the bitstream generators
CLK_45M158     = CLK_44K1 * pow(2,10)  # clock used for the DAC
CLK_90M317     = CLK_44K1 * pow(2,11)  # clock ...
FSK_F_SET      = 50e3                 # set desired fsk start frequency
PSK_F_SET      = 80e3                 # set desired psk start frequency


#--- initial state variables ---#
fsk_gain       = 1
psk_gain       = 1
fsk_level      = 2
psk_level      = 2
mux_pos        = 0
mod_sel        = 0
gain_level_sel = 0
state_button1  = 0
state_button2  = 0
state_button3  = 0
state_button4  = 0


############## MAIN FUNCTIONS - used once in threads ##############
'''
DESCRIPTION:
Thread to setup initial states.
'''   
def startup():
    global fsk_gain
    global psk_gain
    global f_fsk_bus
    global f_psk_bus
    global fsk_gain_bus
    global psk_gain_bus
    
    # set gains
    int_to_bin_gpio(fsk_gain, 3, fsk_gain_bus) 
    int_to_bin_gpio(psk_gain, 3, psk_gain_bus) 
    
    # send fsk start frequency integer to PL
    fsk_f = freq_to_int(16, FSK_F_SET, CLK_45M158)  
    int_to_bin_gpio(fsk_f, 16, f_fsk_bus)
    # send psk start frequency integer to PL
    psk_f = freq_to_int(16, PSK_F_SET, CLK_45M158)
    int_to_bin_gpio(psk_f, 16, f_psk_bus)

'''
DESCRIPTION:
Thread to switch and button input states.
'''   
def change_input():
    while True:
        global mod_sel
        global gain_level_sel
        global state_button1
        global state_button2
        global state_button3
        global state_button4

        # overwrite switch and button states
        mod_sel = sw[0].read()
        gain_level_sel  = sw[1].read()
        state_button1 = button[0].read()
        state_button2 = button[1].read()
        state_button3 = button[2].read()
        state_button4 = button[3].read()

'''
DESCRIPTION:
Thread to change modulation level, gain and frequency inputs.
'''    
def select_mod():
    while True:
        global fsk_gain
        global psk_gain
        global fsk_level
        global psk_level
        global mod_sel
        global gain_level_sel
        
        # GPIO variables
        global f_fsk_bus
        global f_psk_bus
        global mode_fsk_bus
        global mode_psk_bus
        global fsk_gain_bus
        global psk_gain_bus

        # fsk selected
        if (mod_sel == 0):
            if (gain_level_sel == 0):                      # gain selected
                fsk_gain = incdec_gain(fsk_gain)           # update gain fsk
                int_to_bin_gpio(fsk_gain, 3, fsk_gain_bus) # send calculated fsk gain to PL
                
            elif (gain_level_sel == 1):                    # level selected
                fsk_level = incdec_level(fsk_level)        # send calculated fsk modulation level to PL
                if fsk_level == MIN_MOD_LEVEL:
                    mode_fsk_bus.write(0)                  # M=2
                elif fsk_level == MAX_MOD_LEVEL:
                    mode_fsk_bus.write(1)
        # psk selected       
        elif(mod_sel == 1):                   
            if (gain_level_sel == 0):                      # gain selected
                psk_gain = incdec_gain(psk_gain)           # update gain psk
                int_to_bin_gpio(psk_gain, 3, psk_gain_bus) # send calculated psk gain to PL
                
            elif (gain_level_sel == 1):                    # level selected
                psk_level = incdec_level(psk_level)        # send calculated psk modulation level to PL
                if psk_level == MIN_MOD_LEVEL:
                    mode_psk_bus.write(0)                  # M=2
                elif psk_level == MAX_MOD_LEVEL:
                    mode_psk_bus.write(1)
       
'''
DESCRIPTION:
Thread to change MUX state.
'''      
def change_mux():
    while True:
        global mux_pos
        
        mux_pos = incdec_mux(mux_pos)
        int_to_bin_gpio(mux_pos, 3, mux_sel_bus)       
        
'''
DESCRIPTION:
Thread to change LED 1 state.
'''                  
def run_led1():
    while True:
        change_led(fsk_gain, led[2])
        
'''
DESCRIPTION:
Thread to change LED2 state.
'''          
def run_led2():
    while True:
        change_led(psk_gain, led[3])       
        
'''
DESCRIPTION:
Thread to change RGB LED 1 state.
'''     
def run_rgbled1():
    while True:
        change_rgbled(fsk_level, rgbled1)
        
'''
DESCRIPTION:
Thread to change RGB LED 2 state.
'''        
def run_rgbled2():
    while True:
        change_rgbled(psk_level, rgbled2)                    
            
            
            
############## SECONDARY FUNCTIONS - used multiple times ##############
'''
DESCRIPTION:
Increment or decrement gain.
'''
def incdec_gain(gain):
    global state_button1
    global state_button2

    temp = gain
    
    # increment or decrement
    if (state_button1 == 1): 
        if (gain >= MIN_GAIN_LEVEL and gain <= MAX_GAIN_LEVEL):
            temp = gain - 1

    elif (state_button2 == 1): 
        if (gain >= MIN_GAIN_LEVEL and gain <= MAX_GAIN_LEVEL):
            temp = gain + 1    

    # coherce if outside boundaries
    if (temp < MIN_GAIN_LEVEL):
        gain = MIN_GAIN_LEVEL
    elif (temp > MAX_GAIN_LEVEL):
        gain = MAX_GAIN_LEVEL
    else:
        gain = temp

    time.sleep(0.3)
        
    return gain
    
'''
DESCRIPTION:
Increment or decrement modulation level.
'''    
def incdec_level(level):
    global state_button1
    global state_button2

    temp = level
    
    # increment or decrement
    if (state_button1 == 1): 
        if (level >= MIN_MOD_LEVEL and level <= MAX_MOD_LEVEL):
            temp = int(level - level/2)

    elif (state_button2 == 1): 
        if (level >= MIN_MOD_LEVEL and level <= MAX_MOD_LEVEL):
            temp = level + level    

    # coherce if outside boundaries
    if (temp < MIN_MOD_LEVEL):
        level = MIN_MOD_LEVEL
    elif (temp > MAX_MOD_LEVEL):
        level = MAX_MOD_LEVEL
    else:
        level = temp

    time.sleep(0.3)
        
    return level
    
    
'''
DESCRIPTION:
Increment or decrement the cyclic multiplexer state.
Valid positions -> [0,7]
'''    
def incdec_mux(mux_pos):
    global state_button3
    global state_button4

    temp = mux_pos

    # increment or decrement
    if (state_button3 == 1): 
        if (mux_pos >= MIN_MUX_POS and mux_pos <= MAX_MUX_POS):
            temp = mux_pos - 1
    elif (state_button4 == 1): 
        if (mux_pos >= MIN_MUX_POS and mux_pos <= MAX_MUX_POS):
            temp = mux_pos + 1    

    # coherce if outside boundaries as cyclic register
    if (temp < MIN_MUX_POS):
        mux_pos = MAX_MUX_POS
    elif (temp > MAX_MUX_POS):
        mux_pos = MIN_MUX_POS
    else:
        mux_pos = temp
        
    time.sleep(0.3)
        
    return mux_pos
    
'''
DESCRIPTION:
Blinks the led based on gain. 1 blink per gain level.
'''
def change_led(gain, led):
    led_cnt = 0
    
    if gain != 0:
        while True:
            led.write(1)
            time.sleep(0.1)
            led.write(0)
            time.sleep(0.1)

            led_cnt = led_cnt+1

            if (led_cnt >= gain):
                time.sleep(1)
                break            

                
'''
DESCRIPTION:
Changes RGB LED color based on modulation level.
'''                
def change_rgbled(level, led):
    if (level == 2):       # blue color  -> M=2
        led[0].write(0)
        led[1].write(0)
        led[2].write(1)
    elif (level == 4):     # green color -> M=4
        led[0].write(0)
        led[1].write(1)
        led[2].write(0)
            
            
'''
DESCRIPTION:
Converts a desired frequency value f_req (in Hz)
into an integer int_to_PL, based on the bit depth n of the frequency input 
and the clock frequency f_clk of the respective DDS Compiler in PL.
'''
def freq_to_int(n, f_req, f_clk):
    res_freq = f_clk / pow(2, n)               # calculated step frequency resolution 
    int_to_PL = math.floor(f_req / res_freq)   # calculate the integer to send to the PL 
    
    return int_to_PL
  
    
'''
DESCRIPTION:
Converts a integer int_var into its binary representation and 
attributes it to the given gpio_bus based on its resolution n.
'''
def int_to_bin_gpio(int_var, n, gpio_bus):
    bin_temp = format(int_var, "0" + str(n) + "b")
    
    for idx, x in enumerate(bin_temp):
        gpio_bus[idx].write(int(x))
        
            
            
            
            
            
            
            
################################################################################################################################            
############## PROGRAM START ##############            
if __name__ == "__main__":
    startup_t = Thread(target = startup)
    t1 = Thread(target = run_led1)
    t2 = Thread(target = run_led2)
    t3 = Thread(target = run_rgbled1)
    t4 = Thread(target = run_rgbled2)
    t5 = Thread(target = change_input)
    t6 = Thread(target = select_mod)
    t7 = Thread(target = change_mux)
    startup_t.setDaemon(True)
    t1.setDaemon(True)
    t2.setDaemon(True)
    t3.setDaemon(True)
    t4.setDaemon(True)
    t5.setDaemon(True)
    t6.setDaemon(True)
    t7.setDaemon(True)
    startup_t.start()
    t1.start()
    t2.start()
    t3.start()
    t4.start()
    t5.start()          
    t6.start()
    t7.start()    
    
    while True:
        print(f"------------------------------------------------------")
        print(f"{txt.bold}| FREQUENCY DIVISION MULTIPLEXING OF FSK/PSK SIGNALS |{txt.end}")
        print(f"------------------------------------------------------")
        print(f"{txt.bold}FSK Settings:{txt.end}")
        print(f"  - Start Frequency (f1):  \t{FSK_F_SET / 1e3} kHz")
        print(f"  - Gain Level (G1):       \t{fsk_gain}")
        print(f"  - Modulation Level (M1): \t{fsk_level}")

        print(f"{txt.bold}PSK Settings:{txt.end}")
        print(f"  - Start Frequency (f2):  \t{PSK_F_SET / 1e3} kHz")
        print(f"  - Gain Level (G2):       \t{psk_gain}")
        print(f"  - Modulation Level (M2): \t{psk_level}")

        print(f"{txt.bold}MUX Settings:{txt.end}")
        print(f"  - Position: \t\t\t{mux_pos} -> ", end="")
        if mux_pos == 0:
            print(f"{fsk_level}-FSK modulator signal")
        elif mux_pos == 1:
            print(f"{psk_level}-PSK modulator signal")
        elif mux_pos == 2:
            print(f"{fsk_level}-FSK gain signal")
        elif mux_pos == 3:
            print(f"{psk_level}-PSK gain signal")
        elif mux_pos == 4:
            print(f"({fsk_level}-FSK gain + {psk_level}-PSK gain) signal")
        elif mux_pos == 5:
            print("Channel emulator output")
        elif mux_pos == 6:
            print(f"{fsk_level}-FSK bitstream")
        elif mux_pos == 7:
            print(f"{psk_level}-PSK bitstream")
        
        print(f"------------------------------------------------------")
        if (mod_sel == 0):
            print(f"\t\u2022{txt.bold}1ST SELECTION = {txt.end}FSK")
        elif (mod_sel == 1):
            print(f"\t\u2022{txt.bold}1ST SELECTION = {txt.end}PSK")
            
        if (gain_level_sel == 0):
            print(f"\t\u2022{txt.bold}2ND SELECTION = {txt.end}GAIN")
        elif (gain_level_sel == 1):
            print(f"\t\u2022{txt.bold}2ND SELECTION = {txt.end}MODULATION LEVEL")
        
        clear_output(wait=True)
        time.sleep(.1)