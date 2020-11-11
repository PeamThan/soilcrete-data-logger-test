import serial
import os
import argparse
from enum import Enum

# COMMANDS #####################################
CMD_RD_DEPTH = b'#00RA'
CMD_RD_DRILL = b'#00RB'
CMD_RD_DIGIN = '#02RDI\r'
CMD_RD_ANAIN = '#02RAI12\r'

USB0 = "/dev/ttyUSB0"
USB1 = "/dev/ttyUSB1"

# FUNCTIONS ####################################
def custom_bin2str(binary_val):
    result = ""
    
    # bin2str
    for char in binary_val:
        if char == 13: # '\r'
            break
        result += chr(char)

    return result

def custom_bin2dec(binary_val):
    num_str = ""
    result  = 0
    
    # bin2str
    num_str = custom_bin2str(binary_val)
    
    # str2dec
    result = float(num_str)

    return result

def read_depth(serial_port):
    rd_buff = b''
    num_str = ""
    result  = 0
    
    # get data from serial 
    serial_port.write(CMD_RD_DEPTH)
    rd_buff = serial_port.read(20)
    
    # convert binary to decimal
    try:
        return custom_bin2dec(rd_buff)
    except:
        if len(rd_buff) == 0:
            return '' # UNCONNECTED
        if len(rd_buff) == 5:
            return '%' # PUMP port
        return '$' # Cable swapped
        
def read_drill_rpm(serial_port):
    rd_buff = b''
    num_str = ""
    result  = 0
    
    # get data from serial
    serial_port.write(CMD_RD_DRILL)
    rd_buff = serial_port.read(20)
    
    # convert binary to decimal
    result = custom_bin2dec(rd_buff)
    return result

def read_digital_input(serial_port):
    result = ""

    # get data from serial
    serial_port.write(CMD_RD_DIGIN.encode())
    rd_buff = serial_port.read(20)

    result = custom_bin2str(rd_buff[3:7])
    return result    

def get_wc(digital_val):
    """
    @desription Get state of the switch whether the machine is feeding
                cement or water
    @return <string> "cement" or "water"
    """

    result = "water"

    if (digital_val[1] == "1"):
        result = "cement"

    return result
    
def read_analog_input(serial_port):
    rd_buff = b''
    result = 0

    # get data from serial
    serial_port.write(CMD_RD_ANAIN.encode())
    rd_buff = serial_port.read(20)
    
    result = custom_bin2str(rd_buff[3:])
    return result

def get_pressure(analog_val):
    pressure_hex   = 0
    pressure_dec   = 0
    adc_resolution = 4096 # 12-bit adc
    max_pressure   = 1000
    pressure       = 0

    pressure_hex = analog_val[5:]
    pressure_dec = int(pressure_hex, 16)
    
    # calculate pressure
    pressure = float(pressure_dec/adc_resolution)*max_pressure

    return "{:.3f}".format(pressure)

def get_stroke(analog_val):
    stroke_hex  = 0
    stroke_dec  = 0
    stroke_mult = 0.073
    stroke      = 0
    
    stroke_hex = analog_val[0:4]
    stroke_dec = int(stroke_hex, 16)
    stroke = stroke_dec*stroke_mult
    
    return "{:.3f}".format(stroke)

def get_drll_data(port_location):
    # read depth and drill_rpm sensor from drill port

    depth     = -1
    drill_rpm = -1

    if (port_location[0] != '/'): # Unconnected or swapped
        return (depth, drill_rpm)

    port = get_serial_connection(port_location)

    if (port == None):
        #print("Hello")
        return (depth, dril_rpm)

    try:
        depth = read_depth(port)
        if len(depth) == 0: depth=-1 # catching break connection
    except:
        #print("error! cannot get depth")
        pass

    try:
        drill_rpm = read_drill_rpm(port)
    except:
        pass
        #print("error! cannot get drill_rpm")
    port.close()

    return (depth, drill_rpm)

def get_pump_data(port_location):
    # read analog and digital inputs from pump port

    pressure = -1
    stroke   = -1
    wc       = -1

    if (port_location[0] != '/'): # Unconnected or swapped
        return (pressure, stroke, wc)

    port = get_serial_connection(port_location)

    if (port == None):
        return (pressure, stroke, wc)

    try:
        analog   = read_analog_input(port)
        pressure = get_pressure(analog)
        stroke   = get_stroke(analog)
    except:
        pass
        #print("error! cannot get analog data from pump port")

    try:
        digital  = read_digital_input(port)
        wc       = get_wc(digital)
    except:
        pass
        #print("error! cannot get digital data from pump port")
    port.close()

    return (pressure, stroke, wc)


def construct_sensor_data(depth=-1, drill_rpm=-1, pressure=-1, stroke=-1, wc=-1):
    # create JSON string
    json_result  = '{'
    json_result += '"depth":"{}",'.format(depth)
    json_result += '"drill":"{}",'.format(drill_rpm)
    json_result += '"pressure":"{}",'.format(pressure)
    json_result += '"stroke":"{}",'.format(stroke)
    json_result += '"wc":"{}"'.format(wc)
    json_result += '}'

    print(json_result)

def get_serial_connection(port_location):
    try:
        return serial.Serial(port_location, 9600, timeout=0.05)
    except:
        #print("Cannot connect to serial port {}. Please check the connection.".format(port_location));
        return

class Status(Enum):
    UNCONNECTED  = 0 # No USB or USB without wiring
    WIRE_SWAPPED = 1
    CONNECTED    = 2

class PortType(Enum):
    UNKNOWN = 0
    DRILL   = 1
    PUMP    = 2

def detect_serial_ports():
    def construct_return_result(port_drll, port_pump):
        json_result  = '{'
        json_result += '"port_drill": "{}",'.format(port_drll)
        json_result += '"port_pump": "{}"'.format(port_pump)
        json_result += '}'
        return json_result
    
    # check if USBs are connected
    def detect_port_status(usb_location):
        port_usb = get_serial_connection(usb_location);
        if port_usb is None:
            return (Status.UNCONNECTED,PortType.UNKNOWN,'') # No USB

        # Check if the port is connected to a drill
        result = read_depth(port_usb)

        port_status = Status.CONNECTED if (type(result) is float) \
                        else Status.UNCONNECTED if (len(result) == 0 or result[0] == '%') \
                        else Status.WIRE_SWAPPED

        if (port_status != Status.UNCONNECTED):
            return (port_status,PortType.DRILL,usb_location)

        # Check if the port is connected to a pump
        result = read_analog_input(port_usb)
        port_usb.close()
        port_status = Status.UNCONNECTED if (len(result) == 0) \
                        else Status.WIRE_SWAPPED if result[0] != '0' \
                        else Status.CONNECTED
        port_type = PortType.UNKNOWN if port_status == Status.UNCONNECTED else PortType.PUMP
        port_usb.close()
        return (port_status,port_type,usb_location)

    port_drill = Status.UNCONNECTED
    port_pump  = Status.UNCONNECTED
    for port in [USB0, USB1]:
        status, ptype, location = detect_port_status(port)
        if (ptype == PortType.DRILL):
            port_drill = location if status == Status.CONNECTED else status
        if (ptype == PortType.PUMP):
            port_pump  = location if status == Status.CONNECTED else status
    
    print(construct_return_result(port_drill, port_pump))

def main():
    # argument parsing
    parser = argparse.ArgumentParser()
    parser.add_argument("-d", "--detect", action="store_true", help="Detect Serial Ports.")
    parser.add_argument("-port_drill", action="store", default='Status.UNCONNECTED', help="USB port location for drill, e.g. /dev/USB0")
    parser.add_argument("-port_pump", action="store", default='Status.UNCONNECTED', help="USB port location for pump, de.g. /dev/USB1")
    args = parser.parse_args()
    
    if args.detect:
        return detect_serial_ports()

    (depth, drill_rpm) = get_drll_data(args.port_drill)
    (pressure, stroke, wc) = get_pump_data(args.port_pump)
    construct_sensor_data(depth, drill_rpm, pressure, stroke, wc)

if __name__ == '__main__':
    main()   

