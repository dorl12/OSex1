#include<stdio.h>
#include<string.h>
#include<stdlib.h>
#include<unistd.h>
#include<sys/types.h>
#include<sys/wait.h>

#define MAXLENGTH 100   // max number of characters to be supported
#define MAXCOM 100      // max number of commands to be supported

typedef struct historyStruct
{
    int pid;
    char command[100];
}historyStruct;

void setArgs(int argc, char *argv[]) {
    char* path = getenv("PATH");
    printf("%s\n", path);
    for(int i = 1; i < argc; i++) {
        strcat(path, ":");
        strcat(path, argv[i]);
    }
    printf("%s\n", path);
    setenv("PATH", path, 1);
//    //    old path + ":" + "/0"
//    int size = strlen(getenv("PATH")) + 2;
//    char* path = (char*) malloc(size);
//    strcpy(path, getenv("PATH"));
//    for(int i = 1; i < argc; i++) {
//        path = (char*) realloc(path, strlen(argv[i]) + 1);
//        strcat(path, ":");
//        strcat(path, argv[i]);
//    }
//    setenv("PATH", path, 1);
//    free(path);
}

char* getInput(char* buffer) {
    printf("$ ");
    fflush(stdout);
    fgets(buffer, MAXLENGTH, stdin);
    buffer[strlen(buffer) - 1] = '\0';
    return buffer;
}

void cdCommand(char* directory) {
    if(chdir(directory) == -1) {
        perror("chdir failed");
    }
}

void historyCommand(struct historyStruct h[MAXCOM], int counter) {
    for(int i = 0; i < counter; i++) {
        printf("%d ", h[i].pid);
        printf("%s\n", h[i].command);
    }
}

void runCommands(char* buffer, historyStruct history[MAXCOM], char** commandArray, int counter) {
    if (strcmp(buffer, "exit")) {
        strcpy(history[counter].command, buffer);
    }
    while(strcmp(buffer, "exit")) {
        int i = 0;
        char* token = strtok(buffer, " ");
        // the name of the command
        commandArray[i] = token;
        i++;
        while(token != NULL) {
            token = strtok(NULL, " ");
            commandArray[i] = token;
            i++;
        }
        commandArray[i-1] = NULL;
        if(!strcmp(commandArray[0], "cd")) {
            history[counter].pid = getegid();
            counter++;
            cdCommand(commandArray[1]);
        }
        else if(!strcmp(commandArray[0], "history")) {
            history[counter].pid = getegid();
            counter++;
            historyCommand(history, counter);
        }
        else {
            pid_t pid = fork();
            if(pid == -1) {
                perror("fork failed");
            }
            else if (pid == 0){
                if(execvp(commandArray[0], commandArray)) {
                    perror("execvp failed");
                }
                exit(0);
            }
            else {
                history[counter].pid = pid;
                counter++;
                if(wait(NULL) < 0) {
                    perror("wait failed");
                }
            }
        }
        getInput(buffer);
        if (strcmp(buffer, "exit")) {
            strcpy(history[counter].command, buffer);
        }
    }
}

int main(int argc, char *argv[]) {
    setArgs(argc, argv);
    char buffer[MAXLENGTH];
    char* commandArray[MAXLENGTH];
    int counter = 0;
    historyStruct history[MAXCOM];
    getInput(buffer);
    runCommands(buffer, history, commandArray, counter);
    return 0;
}






