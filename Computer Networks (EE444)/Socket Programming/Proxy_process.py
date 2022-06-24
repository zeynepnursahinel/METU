"""
EE444 HW1 SIMPLE PROXY SERVER
ZEYNEPNUR ŞAHİNEL-2305399

References:
https://www.youtube.com/watch?v=3QiPPX-KeSc&t=718s&ab_channel=TechWithTim

!!!IMPORTANT!!!
It is not the simple proxy system, instead this code represents a simple 
client-server system

Initially a socket, later providing communication between the client, 
is created. Here using socket.gethostbyname() function local IPv4 address
is obtained for the server IP and a random port is entered for the address
(IP, Port). After constructing the address, created proxy_server socket
is binded to this address. In the code, two functions are implemented 
being start() and handle_client(). Inside the start(), listening occurs 
continuously. While listening continues it accepts the connection from 
the client with accept(). Through this function, a socket object conn 
and a new address are created. Connection is established after accept. 
Moreover, threads are created to deal handle_client() function simultaneously. 
In the handle_client() coming messages from the client are processed 
according to their operations. This function can be considered as a 
connected state (Fig 1. in the HW1 manual) 

"""
import socket
import threading
import time
from prettytable import PrettyTable
import re
import numpy as np

########################################
#Table Stored in Proxy Server
Tab_Ind_List=['0','1', '2', '3', '4', '5', '6', '7', '8', '9']
Tab_Data_List=['10', '11', '12', '13', '14', '15', '16', '17', '18', '19']
Table=PrettyTable(['Index','Data(Integer)']) #header names
for x in range(0,10):
    Table.add_row([Tab_Ind_List[x], Tab_Data_List[x]])
print(Table)
#########################################
DISCONNECT_MESSAGE="!DISCONNECT"
########################################
PORT=7077
SERVER=socket.gethostbyname(socket.gethostname())
ADDR=(SERVER, PORT)

HEADER=64 #to pick 64 bytes for the received message later
FORMAT= 'utf-8' #used in decode the received message length
#########################################
#Creating a Proxy Server Socket
proxy_server=socket.socket(socket.AF_INET, socket.SOCK_STREAM) #family, type
proxy_server.bind(ADDR)
#########################################
def start():
    proxy_server.listen()
    print(f"[LISTENING] Server is listening on {SERVER}")
    while True:
        conn, addr = proxy_server.accept() #conn is a socket object
        thread=threading.Thread(target=handle_client, args=(conn, addr))
        #When connection occurs go to the handle _client function
        thread.start()
##########################################       
def handle_client(conn, addr):

    print(f"[NEW CONNECTION] {addr} connected.")
    
    connected =True
    while connected:
        msg_length = conn.recv(HEADER).decode(FORMAT)
        if msg_length: #when some message is sent from the client side (thus length is not zero)
            msg_length =int(msg_length)
            msg = conn.recv(msg_length).decode(FORMAT)
        
        ############Parsing of the messages########### 
        Split_Msg=re.split('=|;|,',msg)
        #print(Split_Msg)
        mess_len=len(Split_Msg)
        #print(mess_len)

        if msg == DISCONNECT_MESSAGE:
            connected = False #can be exited from the while to close a socket later
            print(f"[{addr}] {msg}")

        ####################GET Operation########################
        elif Split_Msg[1]=="GET":
            print(f"[{addr}] {msg}")
            incount=3 #input counter to count the Split_Msg, currently it points to the Ind1 in the message 
            index_count=0  #index counter for the Ind_List
            Ind_List =np.array([]) #Index Number shown in the messages
            Data_List =np.array([]) #Data List: to form data in the related index taken from Tab_Data
            sum_ind_messg="" #to print the index part of the sent message
            sum_data_messg="" #for the conditional expression

            while(incount>2):
                if(incount>=mess_len):
                    break
                else:
                    Ind_List=np.append(Ind_List, Split_Msg[incount])
                    incount=incount+1

                    data_index=int(Ind_List[index_count])
                    Data_List=np.append(Data_List, Tab_Data_List[data_index])

                    index_count=index_count+1

            #print(Ind_List)
            #print(Data_List)

            for x in range (0, index_count):
                ind_messg=str(Ind_List[x])
                sum_ind_messg=sum_ind_messg + ind_messg + ","
            #print(sum_ind_messg)

            for x in range (0, index_count):
                data_messg=str(Data_List[x])
                sum_data_messg=sum_data_messg + data_messg + ","
            #print(sum_data_messg)
            
            op="OP=GET;"
            index_list="IND="
            data_list="DATA="
            
            form_message=op + index_list + sum_ind_messg + data_list + sum_data_messg
            #print(form_message)
            conn.send(form_message.encode()) #encode is used to transform string to utf-8

        ######################PUT Operation#####################
        elif Split_Msg[1]=="PUT":
            print(f"[{addr}] {msg}")
            incount=3 #input counter to count the Split_Msg, currently it points to the Ind1 in the message 
            index_count=0 #index counter for the Ind_List
            Ind_List =np.array([])#Index Number shown in the messages 
            Data_List =np.array([])#Data List: to form data in the related index taken from Tab_Data
            sum_ind_messg=""#to print the index part of the sent message
            sum_data_messg=""#to print the data part of the sent message
            DATAindex=100 #for the conditional expression
            
            while(incount>2):
                if(incount>=mess_len):#end of the array
                    break
                elif(Split_Msg[incount]!='DATA' and DATAindex>incount): #create Ind_List
                    Ind_List=np.append(Ind_List, Split_Msg[incount])
                    incount=incount+1
                    index_count=index_count+1 #to count the index numbers of the Ind_List later
                elif(Split_Msg[incount]=='DATA'):
                    DATAindex=incount #assign the index of the DATA to DATAindex 
                    incount=incount+1    
                elif(DATAindex<incount):
                    if(Split_Msg[incount]==''):#end of the array
                        break
                    else:
                        Data_List=np.append(Data_List, Split_Msg[incount])
                        incount=incount+1

            #print(Ind_List)
            #print(Data_List)  

            
            for x in range (0, index_count):
                listOfGlobals = globals() 
                listOfGlobals['Tab_Data_List[int(Ind_List[x])]']=int(float(Data_List[x]))
                Tab_Data_List[int(Ind_List[x])]=int(float(Data_List[x]))
            
            #print(Tab_Data_List)

            form_message="PUT operation is completed. Server prints the new table"
            conn.send(form_message.encode())

            Table=PrettyTable(['Index','Data(Integer)']) #header names
            for x in range(0,10):
                Table.add_row([Tab_Ind_List[x], Tab_Data_List[x]])
            print(Table)
               

        #############CLR Operation######################
        elif Split_Msg[1]=="CLR":
            
            for x in range (0, 10):
                listOfGlobals = globals() 
                listOfGlobals['Tab_Data_List[x]']=0
                Tab_Data_List[x]=0
            
            #print(Tab_Data_List)

            form_message="CLR operation is completed. Server prints the new table"
            conn.send(form_message.encode())

            Table=PrettyTable(['Index','Data(Integer)']) #header names
            for x in range(0,10):
                Table.add_row([Tab_Ind_List[x], Tab_Data_List[x]])
            print(Table)

            
        #########################ADD Operation##############################
        elif Split_Msg[1]=="ADD":
            print(f"[{addr}] {msg}")
            incount=3
            index_count=0
            Ind_List =np.array([])
            Data_List =np.array([])
            sum_ind_messg=""
            sum_data_messg=""
            sumdata=0

            while(incount>2):
                if(incount>=mess_len):
                    break
                else:
                    Ind_List=np.append(Ind_List, Split_Msg[incount])
                    incount=incount+1

                    data_index=int(Ind_List[index_count])
                    
                    Data_List=np.append(Data_List, Tab_Data_List[data_index])

                    index_count=index_count+1

            #print(Ind_List)
            #print(Data_List)

            for x in range (0, index_count):
                ind_messg=str(Ind_List[x])
                sum_ind_messg=sum_ind_messg + ind_messg + ","
            #print(sum_ind_messg)

            ############different part from GET operation##################3
            for x in range (0, index_count):
                sumdata=sumdata+int(float(Data_List[x]))
                data_messg=str(sumdata)
            #print(sum_data_messg)
            
            sum_data_messg=str(sumdata)
            op="OP=ADD;"
            index_list="IND="
            data_list="DATA="
            
            form_message=op + index_list + sum_ind_messg + data_list + sum_data_messg
            #print(form_message)
            conn.send(form_message.encode()) #encode is used to transform string to utf-8    

    conn.close()   

print("[STARTING] Server is starting...")
start()

