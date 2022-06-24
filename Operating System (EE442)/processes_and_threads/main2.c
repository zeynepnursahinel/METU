/***********************************************************
Zeynepnur ŞAHİNEL
2305399
EE442 HW1-CHEMICAL REACTION SIMULATION USING PTHREAD LIBRARY
PART2
***********************************************************/
#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <getopt.h>
#include <unistd.h>
#include <math.h>
#include <semaphore.h>


/***************************STRUCTS********************************************/
struct atom{	
	int atomID;
	char atomTYPE;
}Atom; //create Atom variable


struct Information{
	int moleculeTYPE;
}Info;

/********************Semaphores  and other Global Variables****************/
int m; //assigned from user command, atom number produced in each atom thread

//used inside the Random Atom Generation Function
int count_C=0;
int count_H=0;
int count_N=0;
int count_O=0;

sem_t sema;

sem_t C;
sem_t H;
sem_t N;
sem_t O;

sem_t H2O;
sem_t CO2;
sem_t NO2;
sem_t NH3;

int count_semC;
int count_semH;
int count_semN;
int count_semO;

double gen_time;
double gen_rate;

int info_update1=0; //for informatin change when molecule is created
int info_update2=0;
int info_update3=0;
int info_update4=0;
/**************RANDOM ATOM GENERATION FUNCTION*********************************/
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

/********To create exponential time distributions*****************************/
double atom_gen_rate(double lambda){
	double u;
	u=rand()/(RAND_MAX+1.0);
	return -log(1-u)/lambda;
}
/***********************ATOM THREADS*******************************************/
void* Produce_C()
{
    printf("%c with ID: %d is created.\n",Atom.atomTYPE, Atom.atomID);
    //printf("C Thread is created\n");
    
    sem_wait(&sema); //entering CS
    
        //sem_post(&C); //increase C semaphores
        count_semC++;
        
        printf ("C counter = %d", count_semC);
        
        gen_time=atom_gen_rate(gen_rate); //EXP DIST. TIME INTERVAL
        printf("atom generation time=%f\n", gen_time);	  
        sleep(gen_time); //Halt the atom creation process for some exp. distributed random time

    
    sem_post(&sema);//exiting CS    
    
}

void* Produce_H()
{
    printf("%c with ID: %d is created.\n",Atom.atomTYPE, Atom.atomID);
    //printf("H Thread is created\n");
    
    sem_wait(&sema); //entering CS
    
        //sem_post(&H); //increase H semaphores
        count_semH++;
        
        printf ("H counter = %d\n", count_semH);
        
        gen_time=atom_gen_rate(gen_rate); //EXP DIST. TIME INTERVAL
        printf("atom generation time=%f\n", gen_time);	  
        sleep(gen_time); //Halt the atom creation process for some exp. distributed random time
    
    sem_post(&sema);//exiting CS 
    
}

void* Produce_N()
{
    printf("%c with ID: %d is created.\n",Atom.atomTYPE, Atom.atomID);
    //printf("N Thread is created\n");
    
   sem_wait(&sema); //entering CS
    
        //sem_post(&N); //increase N semaphores
        count_semN++;
        
        printf ("N counter = %d", count_semN);
        
        gen_time=atom_gen_rate(gen_rate); //EXP DIST. TIME INTERVAL
        printf("atom generation time=%f\n", gen_time);	  
        sleep(gen_time); //Halt the atom creation process for some exp. distributed random time
    
    sem_post(&sema);//exiting CS 
    
}

void* Produce_O()
{
    printf("%c with ID: %d is created.\n",Atom.atomTYPE, Atom.atomID);
    //printf("O Thread is created\n");
    
    sem_wait(&sema); //entering CS
    
        //sem_post(&O); //increase O semaphores
        count_semO++;
        
        printf ("O counter = %d", count_semO);
        
        gen_time=atom_gen_rate(gen_rate); //EXP DIST. TIME INTERVAL
        printf("atom generation time=%f\n", gen_time);	  
        sleep(gen_time); //Halt the atom creation process for some exp. distributed random time
    
    sem_post(&sema);//exiting CS 
}


/*********************REACTION THREADS*****************************************/

void* Composer_H20()
{
    
    
    if(count_semH>=2 && count_semO>=1)
    {
        printf("H2O is created\n");
        
            sem_wait(&sema); //entering CS
                sem_post(&H2O); //increase O semaphores
                //sem_init(&H, 0, 0);
                //sem_init(&O, 0, 0);
                count_semH=count_semH-2;
                count_semO=count_semO-1;
                
                info_update1=1;
                
                Info.moleculeTYPE=1;
                
            sem_post(&sema); //entering CS
    }
    
    else 
    {
        printf("H20 is not yet created\n");
        info_update1=0;
    }
    
   
    
}

void* Composer_CO2()
{
    
     
    if(count_semC>=1 && count_semO>=2)
    {
        printf("CO2 is created\n ");
        
        sem_wait(&sema); //entering CS
            //sem_init(&H, 0, 0);
            //sem_init(&O, 0, 0);
            count_semC=count_semC-1;
            count_semO=count_semO-2;
            
            info_update2=1;
            
            Info.moleculeTYPE=2;
            
        sem_post(&sema); //entering CS
    }
    
    else
    {
        printf("CO2 is not yet created\n");
        info_update2=0;
    }
    
     
     
}

void* Composer_NO2()
{
    
    if(count_semN>=1 && count_semO>=2)
    {
        
        printf("NO2 is created\n");
        sem_wait(&sema); //entering CS
    
            sem_post(&NO2); //increase O semaphores
            //sem_init(&H, 0, 0);
            //sem_init(&O, 0, 0);
            count_semN=count_semN-1;
            count_semO=count_semO-2;
            
            info_update3=1;
            
            Info.moleculeTYPE=3;
            
        sem_post(&sema);//exiting CS 
        
    }
    
    else
    {
       printf("NO2 is not yet created\n"); 
       info_update3=0;
    }
}

void* Composer_NH3()
{
    if(count_semN>=1 && count_semH>=3)
    {
        
        printf("NH3 is created\n");
        sem_wait(&sema); //entering CS
    
            sem_post(&NH3); //increase O semaphores
            //sem_init(&H, 0, 0);
            //sem_init(&O, 0, 0);
            count_semH=count_semH-3;
            count_semN=count_semN-1;
            
            info_update4=1;
            
            Info.moleculeTYPE=4;
            
        sem_post(&sema);//exiting CS 
    }
    else
    {
        printf("NH3 is not yet created\n");
        info_update4=0;
    }
    
}

int main(int argc, char **argv) //ARGUMAN KOYMAYI UNUTMA
{
    srand(time(NULL)); //seeding for the rand()
	
	int option, rand_num;
    
    m=4; //LATER DELETE
    gen_rate=100; //LATER DELETE
    
    
	//assigment of the inputs to relevant variables
	while((option=getopt(argc, argv, "m:g:"))!=-1) {
		
	   switch(option){
		case 'm':
			m=atoi(optarg);
			printf("%d pieces of atom for each thread\n",m);
			break;
			
		case 'g':
			gen_rate=atoi(optarg);
			printf("Generation rate =%f\n",gen_rate);
			break;
	   }
	} 
	

	int count_tot=4*m;
	 
	/* thread definitions*/
	pthread_t tids[count_tot]; //thread ids
	pthread_t tid_chems[count_tot]; 
	
	/*initializing the semaphores*/
	sem_init(&sema, 0, 1); //to check before critical section
	
	sem_init(&C, 0, 0);
	sem_init(&H, 0, 0);
	sem_init(&N, 0, 0);
	sem_init(&O, 0, 0);
	
	sem_init(&H2O, 0, 0);
	sem_init(&CO2, 0, 0);
	sem_init(&NO2, 0, 0);
	sem_init(&NH3, 0, 0);
	

	int atom_num_list[4]; //creating argument to be passed into thread function
		
	atom_num_list[0]=m;
	atom_num_list[1]=m;
 	atom_num_list[2]=m;
	atom_num_list[3]=m;
	
	for(int i=0; i<count_tot; i++)
	{

	    RandAtomGen(atom_num_list); //Atom Creation

	    Atom.atomID++;

	    if (Atom.atomTYPE =='C')
        {
            pthread_create(&tids[i],NULL,Produce_C,NULL);
            pthread_join(tids[i],NULL);
        }
	  
        if (Atom.atomTYPE =='H')
        {
            pthread_create(&tids[i],NULL,Produce_H,NULL);
            pthread_join(tids[i],NULL);
        }

        if (Atom.atomTYPE =='N')
        {
            pthread_create(&tids[i],NULL,Produce_N,NULL);
            pthread_join(tids[i],NULL);
        }

        if (Atom.atomTYPE =='O')
        {
            pthread_create(&tids[i],NULL,Produce_O,NULL);
            pthread_join(tids[i],NULL);
        }
        
        //Chemical Reaction Threads Creation
        pthread_create(&tid_chems[i],NULL, Composer_H20, NULL);
        pthread_join(tid_chems[i],NULL);

        pthread_create(&tid_chems[i],NULL, Composer_CO2, NULL);
        pthread_join(tid_chems[i],NULL);

        pthread_create(&tid_chems[i],NULL, Composer_NO2, NULL);
        pthread_join(tid_chems[i],NULL);
        
        pthread_create(&tid_chems[i],NULL, Composer_NH3, NULL);
        pthread_join(tid_chems[i],NULL);
        

       if(info_update1==1 ||  info_update2==1|| info_update3==1 || info_update4==1) //When information is updated
        {
            if(Info.moleculeTYPE==1)
                printf("-H2O is created - with info update\n");
            
            else if(Info.moleculeTYPE==2)
                printf("-CO2 is created - with info update\n");
                
            else if(Info.moleculeTYPE==3)
                printf("-NO2 is created - with info update\n");
                
            else if(Info.moleculeTYPE==4)
                printf("-NH3 is created - with info update\n");
        }
    
    }
    
    
return 0;

}
