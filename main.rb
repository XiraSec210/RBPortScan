require 'socket'

ip = ARGV[0]
timeout = 5

if ip.nil?
  puts "Veuillez fournir une adresse IP"
  exit
end

def scan_port(ip, port, timeout)
  begin
    socket = Socket.new(:INET, :STREAM)
    sockaddr = Socket.sockaddr_in(port, ip)
    socket.connect_nonblock(sockaddr)

  rescue Errno::EINPROGRESS
    if IO.select(nil, [socket], nil, timeout)
      begin
        socket.connect_nonblock(sockaddr)
      rescue Errno::EISCONN
        return true
      rescue
        return false
      end
    else
      return false
    end

  rescue
    return false
  end

  return true
end

for port in 1..65535
  if scan_port(ip, port, timeout)
    puts "Port ouvert : #{port}"
  end
end
