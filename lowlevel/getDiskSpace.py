import shutil
import argparse

# FNS -------------------------------------------------------------------------
def bytes2gb(nbytes):
    return nbytes / (1024*1024*1024)


# Argument Parser
parser = argparse.ArgumentParser(description='Disk Space Utility for Soilcrete Data Logger Project')
parser.add_argument('-disk_path', action='store', default='/media/usb', help='Path of the mounted disk e.g. /media/usb')
args = parser.parse_args()

path = args.disk_path

stat = shutil.disk_usage(path)

def construct_output_json(total_space, used_space, free_space):
    json  = '{'
    json += '"total":"{}",'.format(total_space)
    json += '"used":"{}",'.format(used_space)
    json += '"free":"{}"'.format(free_space)
    json += '}'
    return json 
    

total = round(bytes2gb(stat.total), 2)
used  = round(bytes2gb(stat.used), 2)
free  = round(bytes2gb(stat.free), 2)

print(construct_output_json(total, used, free))


