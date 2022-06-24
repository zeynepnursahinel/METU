# Reference: https://www.youtube.com/watch?v=3QiPPX-KeSc&t=1529s&ab_channel=TechWithTim
"""
Similar to the server, a socket is created and then connected 
to the address the same as the address of the server. 
After connecting, it sends continuously messages in the determined 
format of the related operations. These messages are sent through a 
command window. 
"""
import socket 

HEADER =64
PORT =7077
FORMAT='utf-8'
DISCONNECT_MESSAGE="!DISCONNECT"

SERVER = SERVER=socket.gethostbyname(socket.gethostname())
ADDR=(SERVER,PORT)

client = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
client.connect(ADDR)

def send(msg):
    message=msg.encode(FORMAT)
    msg_length = len(message)
    send_length=str(msg_length).encode(FORMAT)
    send_length += b' '*(HEADER- len(send_length)) #This part is taken from the reference
    #to determine the length of the sent messages
    client.send(send_length)
    client.send(message)
    print(client.recv(2048).decode(FORMAT)) #receiving messages from the server


#continuously send messages from command window
send_sti=True
while send_sti:
    in_msg=input()
    send(in_msg)
    if in_msg==DISCONNECT_MESSAGE:
        send_sti=False
