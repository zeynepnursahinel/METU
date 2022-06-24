/***********************************************************
Zeynepnur ŞAHİNEL
2305399
EE442 HW1-CHEMICAL REACTION SIMULATION USING PTHREAD LIBRARY
PART1 
References:
queue: (from Geeks for Geeks)
https://www.geeksforgeeks.org/queue-set-1introduction-and-array-implementation/
!IMPORTANT NOTE!
In this code, atom spilling into the tubes is handled
correctly in general. However, sometimes some atoms can not be 
inserted to the Tube2. Probably I miss some conditions inside the SpillAtom
function :)
Moreover, molecule generation print is mostly handled inside the
chemical reaction threads. Information update and printing inside the
main thread do not work properly, yet sometimes it works :)
And lastly, in this part default options for the atom numbers 
is not included. The program works only when you enter numbers with the caracter
through command line :)
To summarize my code:
1-Takes atom numbers input from the user
2-Generates random atoms with RandAtomGem with exponential distributed time
	For the random exponential distribution sleep operation atom_gen_rate is used
3-Create threads for both atoms and chemical reactions
  -Inside atom threads:
		SpillAtom function is used. (not to repeat conditions in each atom thread, to shorten the code)
	-Inside chemical reactions threads:
		Related queue size of each tube is examined inside the proper reaction condition
		And molecule type is updated.
************************************************************/
#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <getopt.h>
#include <unistd.h>
#include <math.h>
#include <stdlib.h>
#include <limits.h>


	
int info_change1;
int info_change2;
int info_change3;
int info_change4;
	
/******************************************************************************/
/**************QUEUE STRUCT AND FUNCTIONS**************************************/
/******************************************************************************/
struct Queue{
    int front, rear, size;
    unsigned capacity;
    int* array;
};
//function to creat a queue/
struct Queue* createQueue(unsigned capacity)
{
    struct Queue* queue = (struct Queue*)malloc(sizeof(struct Queue));
    queue->capacity=capacity;
    queue->front=0;
    queue->size=0;

    //it is done for the InsertQueue
    queue->rear=capacity-1;
    queue->array=(int*)malloc(queue->capacity*sizeof(int));

    return queue;
}

//Queue is full when size == the capacity
int isFull(struct Queue* queue)
{
    return (queue->size==queue->capacity);
}
//Queue is empty when size is 0
int isEmpty(struct Queue* queue)
{
    return (queue->size==0);
}
//Insert Queue
void InsertQueue(struct Queue* queue, int item)
{
    if(isFull(queue)) return;

    queue->rear=(queue->rear+1)%queue->capacity;
    queue->array[queue->rear]=item;
    queue->size=queue->size+1;
    printf("%d inserted to queue\n", item);
}

//Function to Remove am Item from Queue
int Remove(struct Queue* queue)
{
    if(isEmpty(queue))
        return INT_MIN; //what is this??
    int item=queue->array[queue->front];
    queue->front=(queue->front+1)%queue->capacity;
    queue->size=queue->size-1;
    return item;
}

//Function to get front of queue
int front(struct Queue* queue)
{
    if(isEmpty(queue))
        return INT_MIN;
    return queue->array[queue->front];
}

//Function to get rear of the queue
int rear(struct Queue* queue)
{
    if(isEmpty(queue)) return INT_MIN;
    return queue->array[queue->rear];
}
/******************************************************************************/
/**********************Mutex Variables fro Test Tubes**************************/
/******************************************************************************/
pthread_mutex_t mutex_tube1; 
pthread_mutex_t mutex_tube2; 
pthread_mutex_t mutex_tube3; 
pthread_mutex_t mutex_info;

//used inside the Random Atom Generation Fonksiyon
int count_C=0;
int count_H=0;
int count_N=0;
int count_O=0;

/******************************************************************************/
/***************************STRUCTS********************************************/
/******************************************************************************/
struct atom{	
	int atomID;
	char atomTYPE;
}Atom; //create Atom variable


struct tube{
	int tubeID;
	int tubeTS; //time stamp (ID of the first spilled atom)
	int moleculeTYPE; //1:H2O, 2:CO2, 3:NO2, 4:NH3 
	struct Queue* C_Queue;
	struct Queue* H_Queue;
	struct Queue* N_Queue;
	struct Queue* O_Queue;
}Tube1,Tube2, Tube3; //there are 3 test tubes  


struct Information{
	int tubeID;
	struct tube mytube;
}Info;



/******************************************************************************/
/**************RANDOM ATOM GENERATION FUNCTION*********************************/
/******************************************************************************/
void* RandAtomGen(void* arg)
{
	int *atom_list= (int*) arg;
	int rand_num=rand()%4+1; //to create random numbers from 1 to 4	
	
    if(rand_num==1) //Carbon is coded with 1
	{
	    count_C++;
	    if(count_C<=atom_list[0]) Atom.atomTYPE='C';
	    else RandAtomGen(atom_list);	
    }
	
	else if(rand_num==2) //Hydrogen is coded with 2
	{
	    count_H++;
	    if(count_H<=atom_list[1]) Atom.atomTYPE='H';
	    else RandAtomGen(atom_list);	
    }
	
	else if(rand_num==3) //Nitrogen is coded with 3
	{
	    count_N++;
	    if(count_N<=atom_list[2]) Atom.atomTYPE='N';
	    else RandAtomGen(atom_list);	
    }
		
	else if(rand_num==4) //Oxygen is coded with 4
	{
	    count_O++;
	    if(count_O<=atom_list[3]) Atom.atomTYPE='O';
	    else RandAtomGen(atom_list);
    }
	return NULL;
}
/******************************************************************************/
/********To create exponential time distributions*****************************/
/******************************************************************************/
double atom_gen_rate(double lambda){
	double u;
	u=rand()/(RAND_MAX+1.0);
	return -log(1-u)/lambda;
}
/**************************************************************************/
/********************Conditions for Atom Spilling**************************/
/**************************************************************************/
//Condition for the C atoms fro each tube (when not to put a C in a tube)

int C_Cond_1=0; 
int C_Cond_2=0;
int C_Cond_3=0; 

//Condition for the H atoms (when not to put a H in a tube)
int H_Cond_1=0;
int H_Cond_2=0;
int H_Cond_3=0;

//Condition for the N atoms (when not to put a N in a tube)
int N_Cond_1=0;
int N_Cond_2=0;
int N_Cond_3=0;

//Condition for the O atoms (when not to put a O in a tube)
int O_cond_1=0;
int O_cond_2=0;
int O_cond_3=0;
    
int C_Cond1_fo()
{
    int C_Cond_1=(Tube1.H_Queue->size!=0 || Tube1.N_Queue->size!=0 || Tube1.C_Queue->size!=0);
    return C_Cond_1;
}

int C_Cond2_fo()
{
    int C_Cond_2=(Tube2.H_Queue->size!=0 || Tube2.N_Queue->size!=0 || Tube2.C_Queue->size!=0);
    return C_Cond_2;
}

int C_Cond3_fo()
{
    int C_Cond_3=(Tube3.H_Queue->size!=0 || Tube3.N_Queue->size!=0 || Tube3.C_Queue->size!=0);
    return C_Cond_3;
}

int H_Cond1_fo()
{
    int H_Cond_1=(Tube1.C_Queue->size!=0 || Tube1.H_Queue->size==3 || (Tube1.O_Queue->size!=0 && Tube1.N_Queue->size!=0) || Tube1.O_Queue->size==2);
    return H_Cond_1;
}

int H_Cond2_fo()
{
    int H_Cond_2=(Tube2.C_Queue->size!=0 || Tube2.H_Queue->size==3 || (Tube2.O_Queue->size!=0 && Tube2.N_Queue->size!=0) || Tube2.O_Queue->size==2);
    return H_Cond_2;
}    

int H_Cond3_fo()
{
    int H_Cond_3=(Tube3.C_Queue->size!=0 || Tube3.H_Queue->size==3 || (Tube3.O_Queue->size!=0 && Tube3.N_Queue->size!=0) || Tube3.O_Queue->size==2);
    return H_Cond_3;
}  

int N_Cond1_fo()
{
    int N_Cond_1=(Tube1.C_Queue->size!=0 || Tube1.N_Queue->size!=0 || (Tube1.H_Queue->size!=0 && Tube1.O_Queue->size!=0));
    return N_Cond_1;
}

int N_Cond2_fo()
{
    int N_Cond_2=(Tube2.C_Queue->size!=0 || Tube2.N_Queue->size!=0 || (Tube2.H_Queue->size!=0 && Tube2.O_Queue->size!=0));
    return N_Cond_2;
}

int N_Cond3_fo()
{
    int N_Cond_3=(Tube3.C_Queue->size!=0 || Tube3.N_Queue->size!=0 || (Tube3.H_Queue->size!=0 && Tube3.O_Queue->size!=0));
    return N_Cond_3;
}

int O_Cond1_fo()
{
    int O_Cond_1=(Tube1.O_Queue->size==2 || Tube1.H_Queue->size==3 || 
    (Tube1.N_Queue->size!=0 && Tube1.H_Queue->size!=0) || (Tube1.H_Queue->size!=0 && Tube1.O_Queue->size!=0));
    return O_Cond_1;
}

int O_Cond2_fo()
{
    int O_Cond_2=(Tube2.O_Queue->size==2 || Tube2.H_Queue->size==3 || 
    (Tube2.N_Queue->size!=0 && Tube2.H_Queue->size!=0) || (Tube2.H_Queue->size!=0 && Tube2.O_Queue->size!=0));
    return O_Cond_2;
}

int O_Cond3_fo()
{
    int O_Cond_3=(Tube3.O_Queue->size==2 || Tube3.H_Queue->size==3 || 
    (Tube3.N_Queue->size!=0 && Tube3.H_Queue->size!=0)|| (Tube3.H_Queue->size!=0 && Tube3.O_Queue->size!=0));
    return O_Cond_3;
}

void SpillAtom(struct Queue* queue1, struct Queue* queue2, struct Queue* queue3, 
int cond1, int cond2, int cond3)
{
    printf("%c thread is created\n ", Atom.atomTYPE);
    
    //when the first atom is spilled
    if(Atom.atomID==1)
    {
        printf("molecule type %d", Tube1.moleculeTYPE);
        Tube1.tubeTS=1;
        InsertQueue(queue1, Atom.atomID);
        
    }
    //when rather than the first atom is spilled
    else
    {
        //condition of what not to put
        //if tube 1 does not meet the condition
        if(cond1)
        {   
            //if tube2 also does not meet the condition
            if(cond2)
            {
                //none of the tubes meet the condition 
                if(cond3)
                {
                    printf("%c with ID is %d discarded\n", Atom.atomTYPE, Atom.atomID);
                }
                
                //only tube3 meets
                else
                {
                    if(isEmpty(Tube3.C_Queue) && isEmpty(Tube3.H_Queue)
						&& isEmpty(Tube3.N_Queue) && isEmpty(Tube3.O_Queue))
								Tube3.tubeTS=Atom.atomID;
					
					pthread_mutex_lock(&mutex_tube3);//////
					    InsertQueue(queue3, Atom.atomID);
					pthread_mutex_unlock(&mutex_tube3);//////
					
					printf("insert tube 3 ");
                }
            }
            
            //tube2 meets the condition check whether tube 3 meets the condition
            else
            {
                //If both of them meets the condition look at the time stamps of tubes
                if(!cond3)
                    //If time stamp of the tube3 is smaller than tube 2, insert to tube 3
                    
                    //if tube 2 and tube 3 has zero time stamps, then insert to Tube2
                    if(Tube2.tubeTS==0 && Tube3.tubeTS==0)
                    {
                        if(isEmpty(Tube2.C_Queue) && isEmpty(Tube2.H_Queue)
				        && isEmpty(Tube2.N_Queue) && isEmpty(Tube2.O_Queue))
							Tube2.tubeTS=Atom.atomID;
					
    					pthread_mutex_lock(&mutex_tube2);//////
    					    InsertQueue(queue2, Atom.atomID);
    					pthread_mutex_unlock(&mutex_tube2);//////
    					
    					printf("insert tube 2 ");
                    }
                    
                    else if(Tube3.tubeTS<Tube2.tubeTS && Tube3.tubeTS!=0) 
                        {
                            if(isEmpty(Tube3.C_Queue) && isEmpty(Tube3.H_Queue)
						        && isEmpty(Tube3.N_Queue) && isEmpty(Tube3.O_Queue))
								    Tube3.tubeTS=Atom.atomID;
				               
				               pthread_mutex_lock(&mutex_tube3);////// 
				                    InsertQueue(queue3,Atom.atomID);
				               pthread_mutex_unlock(&mutex_tube3);//////
				               printf("insert tube 3 ");
                        }
                    //tube2 time stamp< tube3 time stamp
                    
                    else if(Tube2.tubeTS<Tube3.tubeTS && Tube2.tubeTS!=0)
                    {
                        if(isEmpty(Tube2.C_Queue) && isEmpty(Tube2.H_Queue)
				        && isEmpty(Tube2.N_Queue) && isEmpty(Tube2.O_Queue))
							Tube2.tubeTS=Atom.atomID;
					
					pthread_mutex_lock(&mutex_tube2);//////
					    InsertQueue(queue2, Atom.atomID);
					pthread_mutex_unlock(&mutex_tube2);//////
					
					printf("insert tube 2 ");
                    }
                
                //If only tube2 meets the condition
                else
                {
                    if(isEmpty(Tube2.C_Queue) && isEmpty(Tube2.H_Queue)
				        && isEmpty(Tube2.N_Queue) && isEmpty(Tube2.O_Queue))
							Tube2.tubeTS=Atom.atomID;
					
					pthread_mutex_lock(&mutex_tube2);//////
					    InsertQueue(queue2, Atom.atomID);
					pthread_mutex_unlock(&mutex_tube2);//////
					
					printf("insert tube 2 ");
                }
                
            }
        }
        
        //If Tube1 meets the condition
        else 
        {
            //Check whether chemical reaction occurs in the tubes, if so assign correct
            //time stamps to tubes
            
            if(Tube1.moleculeTYPE!=0)
            {
                if((Tube2.moleculeTYPE!=0) || cond2)
                {
                    if((Tube3.moleculeTYPE!=0) || cond3)
                    {
                        //only tube 1 meets the condition
                        if(isEmpty(Tube1.C_Queue) && isEmpty(Tube1.H_Queue)
						&& isEmpty(Tube1.N_Queue) && isEmpty(Tube1.O_Queue))
								Tube1.tubeTS=Atom.atomID;//
								
                        pthread_mutex_lock(&mutex_tube1);//////
                            InsertQueue(queue1, Atom.atomID);
                            printf("insert tube 1");
                        pthread_mutex_unlock(&mutex_tube1);//////
                    }
                    else
                    {
                        //Tube1 and Tube3 meet the condition
                        //check time stamps 
                        if(Tube3.tubeTS<Tube1.tubeTS && Tube3.tubeTS!=0)
                        {
                            if(isEmpty(Tube3.C_Queue) && isEmpty(Tube3.H_Queue)
						    && isEmpty(Tube3.N_Queue) && isEmpty(Tube3.O_Queue))
								Tube3.tubeTS=Atom.atomID;
                            
                            pthread_mutex_lock(&mutex_tube3);//////
							    InsertQueue(queue3, Atom.atomID);
							pthread_mutex_unlock(&mutex_tube3);//////
							
							printf("insert tube 3 ");
                        }
                        
                        else
                        {
                        //only tube 1 meets the condition
                            if(isEmpty(Tube1.C_Queue) && isEmpty(Tube1.H_Queue)
    						&& isEmpty(Tube1.N_Queue) && isEmpty(Tube1.O_Queue))
    								Tube1.tubeTS=Atom.atomID;//
    								
                            pthread_mutex_lock(&mutex_tube1);//////
                                InsertQueue(queue1, Atom.atomID);
                                printf("insert tube 1");
                            pthread_mutex_unlock(&mutex_tube1);//////
                        }
                        
                    }
                }
                
                //tube1 and tube2 meet the condition, check their time stamps
                else
                {
                    //if tube2<tube1 acc to their time stamps
                    if(Tube2.tubeTS<Tube1.tubeTS && Tube2.tubeTS!=0)
                    {
                        if(isEmpty(Tube2.C_Queue) && isEmpty(Tube2.H_Queue)
				        && isEmpty(Tube2.N_Queue) && isEmpty(Tube2.O_Queue))
							Tube2.tubeTS=Atom.atomID;
					
    					pthread_mutex_lock(&mutex_tube2);//////
    					    InsertQueue(queue2, Atom.atomID);
    					pthread_mutex_unlock(&mutex_tube2);//////
    					
    					printf("insert tube 2 ");
                    }
                    
                    //only tube1 meets the condition
                    else
                    {
                        if(isEmpty(Tube1.C_Queue) && isEmpty(Tube1.H_Queue)
    						&& isEmpty(Tube1.N_Queue) && isEmpty(Tube1.O_Queue))
    								Tube1.tubeTS=Atom.atomID;//
    								
                            pthread_mutex_lock(&mutex_tube1);//////
                                InsertQueue(queue1, Atom.atomID);
                                printf("insert tube 1");
                            pthread_mutex_unlock(&mutex_tube1);//////
                    }
                    
                }
            }
            
            //Tube1 meets the condition and it is not emptied by a chemical reaction
            else
            {   
                //check whether tube 2 also meets the condition
                if(!cond2)
                    //check whether tube 3 also meets the condition
                    if(!cond3)
                        //if all of them meet the Conditions
                        //check time stamps
                        {
                            //if tube2=tube3 time stamp, initially they are zero, 
                            //then insert to tube1
                            if(Tube3.tubeTS==0)
                            {
                                if(Tube1.tubeTS<Tube2.tubeTS || Tube2.tubeTS==0)
                                {
                                    if(isEmpty(Tube1.C_Queue) && isEmpty(Tube1.H_Queue)
            						&& isEmpty(Tube1.N_Queue) && isEmpty(Tube1.O_Queue))
            								Tube1.tubeTS=Atom.atomID;//
            								
                                    pthread_mutex_lock(&mutex_tube1);//////
                                        InsertQueue(queue1, Atom.atomID);
                                        printf("insert tube 1");
                                    pthread_mutex_unlock(&mutex_tube1);//////
                                }
                                
                                else 
                                {
                                    if(isEmpty(Tube2.C_Queue) && isEmpty(Tube2.H_Queue)
                    				&& isEmpty(Tube2.N_Queue) && isEmpty(Tube2.O_Queue))
                    							Tube2.tubeTS=Atom.atomID;
                    					
                    				pthread_mutex_lock(&mutex_tube2);//////
                    					  InsertQueue(queue2, Atom.atomID);
                    				pthread_mutex_unlock(&mutex_tube2);//////
                    					
                    				printf("insert tube 2 ");
                                }
                                
                            }
                            
                            else if(Tube2.tubeTS==0)
                            {
                                if(Tube1.tubeTS<Tube3.tubeTS || Tube3.tubeTS!=0)
                                {
                                    if(isEmpty(Tube1.C_Queue) && isEmpty(Tube1.H_Queue)
            						&& isEmpty(Tube1.N_Queue) && isEmpty(Tube1.O_Queue))
            								Tube1.tubeTS=Atom.atomID;//
            								
                                    pthread_mutex_lock(&mutex_tube1);//////
                                        InsertQueue(queue1, Atom.atomID);
                                        printf("insert tube 1");
                                    pthread_mutex_unlock(&mutex_tube1);//////
                                }
                                
                                else
                                {
                                    if(isEmpty(Tube3.C_Queue) && isEmpty(Tube3.H_Queue)
						            && isEmpty(Tube3.N_Queue) && isEmpty(Tube3.O_Queue))
    								Tube3.tubeTS=Atom.atomID;
                                
                                    pthread_mutex_lock(&mutex_tube3);//////
        							    InsertQueue(queue3, Atom.atomID);
        							pthread_mutex_unlock(&mutex_tube3);//////
    							
    							    printf("insert tube 3 ");
                                }
                            }
                            
                            
                            
                            //when time stamps of tube2 and tube3 are not 0
                          if(Tube2.tubeTS!=0 && Tube3.tubeTS!=0)
                            
                          {
                            //if tube3 time stamp is the smallest, insert to tube 3
                            if(Tube3.tubeTS<Tube2.tubeTS && Tube3.tubeTS<Tube1.tubeTS)
                            {
                                if(isEmpty(Tube3.C_Queue) && isEmpty(Tube3.H_Queue)
						            && isEmpty(Tube3.N_Queue) && isEmpty(Tube3.O_Queue))
								Tube3.tubeTS=Atom.atomID;
                            
                                pthread_mutex_lock(&mutex_tube3);//////
    							    InsertQueue(queue3, Atom.atomID);
    							pthread_mutex_unlock(&mutex_tube3);//////
    							
    							printf("insert tube 3 ");
                            }
                            
                            //if tube2 time stamp is the smalllest, insert to tube 2
                            else if(Tube2.tubeTS<Tube1.tubeTS && Tube2.tubeTS<Tube3.tubeTS) 
                            {
                                if(isEmpty(Tube2.C_Queue) && isEmpty(Tube2.H_Queue)
                				&& isEmpty(Tube2.N_Queue) && isEmpty(Tube2.O_Queue))
                							Tube2.tubeTS=Atom.atomID;
                					
                				pthread_mutex_lock(&mutex_tube2);//////
                					  InsertQueue(queue2, Atom.atomID);
                				pthread_mutex_unlock(&mutex_tube2);//////
                					
                				printf("insert tube 2 ");
                            }
                            
                            //if tube1 time stamp is the smalllest, insert to tube 1
                            else if(Tube1.tubeTS<Tube2.tubeTS && Tube1.tubeTS<Tube3.tubeTS)
                            {
                                if(isEmpty(Tube1.C_Queue) && isEmpty(Tube1.H_Queue)
        						&& isEmpty(Tube1.N_Queue) && isEmpty(Tube1.O_Queue))
        								Tube1.tubeTS=Atom.atomID;//
        								
                                pthread_mutex_lock(&mutex_tube1);//////
                                    InsertQueue(queue1, Atom.atomID);
                                    printf("insert tube 1");
                                pthread_mutex_unlock(&mutex_tube1);//////
                            }
                          }
                        }
                    
                    //if Tube1 and Tube2 meets the condition 
                    else
                    {
                        //check time stamps of tube1 and Tube2
                        //tube2 is smaller insert to Tube2
                        if(Tube2.tubeTS<Tube1.tubeTS && Tube2.tubeTS!=0) 
                        {
                            if(isEmpty(Tube2.C_Queue) && isEmpty(Tube2.H_Queue)
                				&& isEmpty(Tube2.N_Queue) && isEmpty(Tube2.O_Queue))
                							Tube2.tubeTS=Atom.atomID;
                					
                				pthread_mutex_lock(&mutex_tube2);//////
                					  InsertQueue(queue2, Atom.atomID);
                				pthread_mutex_unlock(&mutex_tube2);//////
                					
                				printf("insert tube 2 ");
                        }
                        
                        //else insert insert to tube1
                        else 
                        {
                            if(isEmpty(Tube1.C_Queue) && isEmpty(Tube1.H_Queue)
        						&& isEmpty(Tube1.N_Queue) && isEmpty(Tube1.O_Queue))
        								Tube1.tubeTS=Atom.atomID;//
        								
                                pthread_mutex_lock(&mutex_tube1);//////
                                    InsertQueue(queue1, Atom.atomID);
                                    printf("insert tube 1");
                                pthread_mutex_unlock(&mutex_tube1);//////
                        }
                    }
                //if only tube1 meets the condition insert to tube 1
                else
                {
                    if(isEmpty(Tube1.C_Queue) && isEmpty(Tube1.H_Queue)
        						&& isEmpty(Tube1.N_Queue) && isEmpty(Tube1.O_Queue))
        								Tube1.tubeTS=Atom.atomID;//
        								
                                pthread_mutex_lock(&mutex_tube1);//////
                                    InsertQueue(queue1, Atom.atomID);
                                    printf("insert tube 1");
                                pthread_mutex_unlock(&mutex_tube1);//////
                }
                
            }
        }
    
    printf("Time Stamp of the Tube1 after %c thread=%d \n",Atom.atomTYPE, Tube1.tubeTS);
	printf("Time Stamp of the Tube2 after %c thread=%d \n",Atom.atomTYPE, Tube2.tubeTS);
	printf("Time Stamp of the Tube3 after %c thread=%d \n",Atom.atomTYPE, Tube3.tubeTS);

        
    }
    
    return;
}

/***************Atom Thread Functions *************************/
void* C_Thread()
{
    SpillAtom(Tube1.C_Queue, Tube2.C_Queue, Tube3.C_Queue,
C_Cond1_fo(), C_Cond2_fo(), C_Cond3_fo());
    
	return NULL;
}

void* H_Thread()
{

    SpillAtom(Tube1.H_Queue, Tube2.H_Queue, Tube3.H_Queue,
H_Cond1_fo(), H_Cond2_fo(), H_Cond3_fo());

    return NULL;
}

void* N_Thread()
{
   SpillAtom(Tube1.N_Queue, Tube2.N_Queue, Tube3.N_Queue,
N_Cond1_fo(), N_Cond2_fo(), N_Cond3_fo());
   
    return NULL;
}

void* O_Thread()
{
    
    SpillAtom(Tube1.O_Queue, Tube2.O_Queue, Tube3.O_Queue,
O_Cond1_fo(), O_Cond2_fo(), O_Cond3_fo());
    return NULL;
}

/*******************Chemical Reaction Threads*************************/
void* H2O_Thread()
{
	//For Tube1
	if(Tube1.H_Queue->size==2 && Tube1.O_Queue->size==1)	
		{
			printf("H20 is created in the Tube 1\n");
			//remove them from queue
			
			pthread_mutex_lock(&mutex_tube1);//////
    			Remove(Tube1.H_Queue);
    			Remove(Tube1.H_Queue);
    			Remove(Tube1.O_Queue);
    			Tube1.moleculeTYPE=1;
    			Info.tubeID=1;
    		pthread_mutex_lock(&mutex_info);
    			info_change1=1;
    		pthread_mutex_unlock(&mutex_info);
    			Info.mytube.moleculeTYPE=1;
			pthread_mutex_unlock(&mutex_tube1);//////
		}

	//For Tube2
	else if(Tube2.H_Queue->size==2 && Tube2.O_Queue->size==1)	
		{
			printf("H20 is created in the Tube 2\n");
			//remove them from queue
			
			pthread_mutex_lock(&mutex_tube2);//////
    			Remove(Tube2.H_Queue);
    			Remove(Tube2.H_Queue);
    			Remove(Tube2.O_Queue);
    			Tube2.moleculeTYPE=1;
    			Info.tubeID=2;
    		 pthread_mutex_lock(&mutex_info);
    		 	info_change1=1;
    		 pthread_mutex_unlock(&mutex_info);
    			Info.mytube.moleculeTYPE=1;
			pthread_mutex_unlock(&mutex_tube2);//////
			
		}

	//For Tube3
	else if(Tube3.H_Queue->size==2 && Tube3.O_Queue->size==1)
		{
			printf("H20 is created in the Tube 3\n");
			//remove them from queue
			
			pthread_mutex_lock(&mutex_tube3);//////
    			Remove(Tube3.H_Queue);
    			Remove(Tube3.H_Queue);
    			Remove(Tube3.O_Queue);
    			Tube3.moleculeTYPE=1; 
    			Info.tubeID=3;
    			pthread_mutex_lock(&mutex_info);
    				info_change1=1;
    		    pthread_mutex_unlock(&mutex_info);
    			Info.mytube.moleculeTYPE=1;
			pthread_mutex_unlock(&mutex_tube3);//////
		}

	else 
	{
	    printf("H2O is not yet created\n");
	    pthread_mutex_lock(&mutex_info);
    			info_change1=0;
    	pthread_mutex_unlock(&mutex_info);
	    Info.mytube.moleculeTYPE=0;
	}

}

void* CO2_Thread()
{
    
    //For Tube1
	if(Tube1.C_Queue->size==1 && Tube1.O_Queue->size==2)	
		{	
			printf("CO2 is created in the Tube 1\n");
			//remove them from queue
			pthread_mutex_lock(&mutex_tube1);//////
    			Remove(Tube1.C_Queue);
    			Remove(Tube1.O_Queue);
    			Remove(Tube1.O_Queue);
    			Tube1.moleculeTYPE=2;
    			Info.tubeID=1;
    			pthread_mutex_lock(&mutex_info);
    			   info_change2=1;
    		    pthread_mutex_unlock(&mutex_info);
    			Info.mytube.moleculeTYPE=2;
			pthread_mutex_unlock(&mutex_tube1);//////
		}


	//For Tube2
	else if(Tube2.C_Queue->size==1 && Tube2.O_Queue->size==2)	
		{
			printf("CO2 is created in the Tube 2\n");
			//remove them from queue
			pthread_mutex_lock(&mutex_tube2);//////
    			Remove(Tube2.C_Queue);
    			Remove(Tube2.O_Queue);
    			Remove(Tube2.O_Queue);
    			Tube2.moleculeTYPE=2;
    			Info.tubeID=2;
    			pthread_mutex_lock(&mutex_info);
    			    info_change2=1;
    		    pthread_mutex_unlock(&mutex_info);
    			Info.mytube.moleculeTYPE=2;
    	    pthread_mutex_unlock(&mutex_tube2);//////
		}

	//For Tube3
	else if(Tube3.C_Queue->size==1 && Tube3.O_Queue->size==2)
		{	
			printf("CO2 is created in the Tube 3\n");
			//remove them from queue
			pthread_mutex_lock(&mutex_tube3);////////
    			Remove(Tube3.C_Queue);
    			Remove(Tube3.O_Queue);
    			Remove(Tube3.O_Queue);
    			Tube3.moleculeTYPE=2;
    			Info.tubeID=3;
    			pthread_mutex_lock(&mutex_info);
    			   info_change2=1;
    		    pthread_mutex_unlock(&mutex_info);
    			Info.mytube.moleculeTYPE=2;
    	    pthread_mutex_unlock(&mutex_tube3);//////
		}

	else 
	{
	    printf("CO2 is not yet created\n");
	    pthread_mutex_lock(&mutex_info);
    			    info_change2=0;
        pthread_mutex_unlock(&mutex_info);
        Info.mytube.moleculeTYPE=0;
	}
}

void* NO2_Thread()
{
    
     //For Tube1
	if(Tube1.N_Queue->size==1 && Tube1.O_Queue->size==2)	
		{	
			printf("NO2 is created in the Tube 1\n");
			//remove them from queue
			pthread_mutex_lock(&mutex_tube1);
    			Remove(Tube1.N_Queue);
    			Remove(Tube1.O_Queue);
    			Remove(Tube1.O_Queue);
    			Tube1.moleculeTYPE=3;
    			Info.tubeID=1;
    			pthread_mutex_lock(&mutex_info);
    			   info_change3=1;
    		    pthread_mutex_unlock(&mutex_info);
    			Info.mytube.moleculeTYPE=3;
    		pthread_mutex_unlock(&mutex_tube1);
		}

	//For Tube2
	else if(Tube2.N_Queue->size==1 && Tube2.O_Queue->size==2)	
		{
			printf("NO2 is created in the Tube2\n");
			//remove them from queue
			pthread_mutex_lock(&mutex_tube2);
    			Remove(Tube2.N_Queue);
    			Remove(Tube2.O_Queue);
    			Remove(Tube2.O_Queue);
    			Tube2.moleculeTYPE=3;
    			Info.tubeID=2;
    			pthread_mutex_lock(&mutex_info);
    			    info_change3=1;
    		    pthread_mutex_unlock(&mutex_info);
    			Info.mytube.moleculeTYPE=3;
    		pthread_mutex_unlock(&mutex_tube2);
		}

	//For Tube3
	else if(Tube3.N_Queue->size==1 && Tube3.O_Queue->size==2)
		{	
			printf("NO2 is created in the Tube3\n");
			//remove them from queue
			pthread_mutex_lock(&mutex_tube3);
    			Remove(Tube3.N_Queue);
    			Remove(Tube3.O_Queue);
    			Remove(Tube3.O_Queue);
    			Tube3.moleculeTYPE=3;
    			Info.tubeID=3;
    			pthread_mutex_lock(&mutex_info);
    			   info_change3=1;
    		    pthread_mutex_unlock(&mutex_info);
    			Info.mytube.moleculeTYPE=3;
    	    pthread_mutex_unlock(&mutex_tube3);
		}

	else 
	    {
	        printf("NO2 is not yet created\n");
	        pthread_mutex_lock(&mutex_info);
    			    info_change3=0;
    	    pthread_mutex_unlock(&mutex_info);
    	   Info.mytube.moleculeTYPE=0;
	    }

}

void* NH3_Thread()
{
    
     //For Tube1
	if(Tube1.N_Queue->size==1 && Tube1.H_Queue->size==3)	
		{	
			printf("NH3 is created in the Tube 1\n");
			//remove them from queue
			pthread_mutex_lock(&mutex_tube1);
        			Remove(Tube1.N_Queue);
        			Remove(Tube1.H_Queue);
        			Remove(Tube1.H_Queue);
        			Remove(Tube1.H_Queue);
			        Tube1.moleculeTYPE=4;
			        Info.tubeID=1;
			        pthread_mutex_lock(&mutex_info);
    			    	info_change4=1;
    		        pthread_mutex_unlock(&mutex_info);
			        Info.mytube.moleculeTYPE=4;
			pthread_mutex_unlock(&mutex_tube1);
		}


	//For Tube2
	else if(Tube2.N_Queue->size==1 && Tube2.H_Queue->size==3)	
		{
			printf("NH3 is created in the Tube 2\n");
			//remove them from queue
			pthread_mutex_lock(&mutex_tube2);
    			Remove(Tube2.N_Queue);
    			Remove(Tube2.H_Queue);
    			Remove(Tube2.H_Queue);
    			Remove(Tube2.H_Queue);
    			Tube2.moleculeTYPE=4;
    			Info.tubeID=2;
    			pthread_mutex_lock(&mutex_info);
    			    info_change4=1;
    		    pthread_mutex_unlock(&mutex_info);
    			Info.mytube.moleculeTYPE=4;
    		pthread_mutex_unlock(&mutex_tube2);
		}

	//For Tube3
	else if(Tube3.N_Queue->size==1 && Tube3.H_Queue->size==3)
		{	
			printf("NH3 is created in the Tube 3\n");
			//remove them from queue
			pthread_mutex_lock(&mutex_tube3);
    			Remove(Tube3.N_Queue);
    			Remove(Tube3.H_Queue);
    			Remove(Tube3.H_Queue);
    			Remove(Tube3.H_Queue);
    			Tube3.moleculeTYPE=4;
    			Info.tubeID=3;
    			pthread_mutex_lock(&mutex_info);
    			    info_change4=1;
    		    pthread_mutex_unlock(&mutex_info);
    			Info.mytube.moleculeTYPE=4;
    		pthread_mutex_unlock(&mutex_tube3);
		}

	else 
	{
	    printf("NH3 is not yet created\n");
	    pthread_mutex_lock(&mutex_info);
    			    info_change4=0;
        pthread_mutex_unlock(&mutex_info);
        Info.mytube.moleculeTYPE=0;
	}
}
    


   
int main(int argc, char **argv){
    
	srand(time(NULL)); //seeding for the rand()
	


	int option;
     
    int Mc, Mh, Mo, Mn, Mtube; //atom numbers

	double gen_rate, gen_time;
    
    
	//assigment of the inputs to relevant variables
	while((option=getopt(argc, argv, "c:h:o:n:t:g:"))!=-1) {
		
	   switch(option){
		case 'c':
			Mc=atoi(optarg);
			printf("%d pieces of Carbon\n",Mc);
			break;
     	case 'h':
			Mh=atoi(optarg);
			printf("%d pieces of Hydrogen\n",Mh);
			break;
		
		case 'n':
			Mn=atoi(optarg);
			printf("%d pieces of Nitrogen\n",Mn);
			break;

		case 'o':
			Mo=atoi(optarg);
			printf("%d pieces of Oxygen\n",Mo);
			break;
		
        case 't':
			Mtube=atoi(optarg);
			printf("%d pieces of test tubes\n",Mtube);
			break;
		
		case 'g':
			gen_rate=atoi(optarg);
			printf("Generation rate =%f\n",gen_rate);
			break;
	   }
	} 
	

	int count_tot=Mc+Mh+Mo+Mn;

	int atom_num_list[4]; //creating argument to be passed into thread function
		
	atom_num_list[0]=Mc;
	atom_num_list[1]=Mh;
 	atom_num_list[2]=Mn;
	atom_num_list[3]=Mo;

	/*Test Tube Assignments*/
	Tube1.tubeID=1; 
	Tube2.tubeID=2;
	Tube3.tubeID=3;

	/*Create Queue for three tubes*/
	Tube1.C_Queue=createQueue(20);
	Tube1.H_Queue=createQueue(20);
	Tube1.N_Queue=createQueue(20);
	Tube1.O_Queue=createQueue(20);

	Tube2.C_Queue=createQueue(20);
	Tube2.H_Queue=createQueue(20);
	Tube2.N_Queue=createQueue(20);
	Tube2.O_Queue=createQueue(20);

	Tube3.C_Queue=createQueue(20);
	Tube3.H_Queue=createQueue(20);
	Tube3.N_Queue=createQueue(20);
	Tube3.O_Queue=createQueue(20);
	
	/* thread definitions*/
	pthread_t tids[count_tot]; //thread ids
	pthread_t tid_chems[count_tot]; //???????

	for(int i=0; i<count_tot; i++)
	{

	    RandAtomGen(atom_num_list); //Atom Creation

	    Atom.atomID++;
	  
        printf("%c with ID: %d is created.\n",Atom.atomTYPE, Atom.atomID);

	    if (Atom.atomTYPE =='C')
        {
            pthread_create(&tids[i],NULL,C_Thread,NULL);
            pthread_join(tids[i],NULL);
        }
	  
        if (Atom.atomTYPE =='H')
        {
            pthread_create(&tids[i],NULL,H_Thread,NULL);
            pthread_join(tids[i],NULL);
        }

        if (Atom.atomTYPE =='N')
        {
            pthread_create(&tids[i],NULL,N_Thread,NULL);
            pthread_join(tids[i],NULL);
        }

        if (Atom.atomTYPE =='O')
        {
            pthread_create(&tids[i],NULL,O_Thread,NULL);
            pthread_join(tids[i],NULL);
        }
        
        //Chemical Reaction Threads Creation
        pthread_create(&tid_chems[i],NULL, H2O_Thread, NULL);
        pthread_join(tid_chems[i],NULL);

        pthread_create(&tid_chems[i],NULL, CO2_Thread, NULL);
        pthread_join(tid_chems[i],NULL);

        pthread_create(&tid_chems[i],NULL, NO2_Thread, NULL);
        pthread_join(tid_chems[i],NULL);
        
        pthread_create(&tid_chems[i],NULL, NH3_Thread, NULL);
        pthread_join(tid_chems[i],NULL);
        
        pthread_mutex_lock(&mutex_info);
		
    	if(info_change1==1 || info_change2==1 || info_change3==1 || info_change4==1) 
		//When information is updated
        {
            if(Info.mytube.moleculeTYPE==1)
                printf("H2O is created in tube %d with info update\n",Info.tubeID);
            
            else if(Info.mytube.moleculeTYPE==2)
                printf("CO2 is created in tube %d with info update\n",Info.tubeID);
                
            else if(Info.mytube.moleculeTYPE==3)
                printf("NO2 is created in tube %d with info update\n",Info.tubeID);
                
            else if(Info.mytube.moleculeTYPE==4)
                printf("NH3 is created in tube %d with info update\n",Info.tubeID);
        }
        
	    
	    pthread_mutex_unlock(&mutex_info);
	    
        gen_time=atom_gen_rate(gen_rate); //EXP DIST. TIME INTERVAL

        printf("atom generation time=%f\n", gen_time);	  

        sleep(gen_time); //Halt the atom creation process for some exp. distributed random time
        
       
    }
    
    

return 0;

}
