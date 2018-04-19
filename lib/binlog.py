from . import getConfig
from socket import inet_aton

def write_bin_log(src_ip, dst_ip):
    fil = getConfig("event_log","event_log.bin")
    if fil:
        with open(fil, 'ab') as efil:
            efil.write(inet_aton(src_ip))
            efil.write(inet_aton(dst_ip))


if __name__ == '__main__':
    write_bin_log("10.80.100.1","8.8.8.8")
