#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <unistd.h>

int main(int argc, char *argv[]) {
  int status;

  // By calling fork(), a child process will be created as an exact duplicate of
  // the calling process, 'man fork' for more details.
  // if (fork() == 0) {
  // Child process will return 0 from fork()
  // printf("In the forked child process now...\n");
  // printf("Running %s\n", argv[1]);
  
  // system("free -m");

  char buffer[1024];
  strcpy(buffer, argv[1]);
  for (int i = 2; i < argc; ++i) {
    strcat(buffer, " ");
    strcat(buffer, argv[i]);
  }
  printf("Command string: %s\n", buffer);

  // sprintf(command, "%s\0", command);
  status = system(buffer);

  // char* envp[] = {NULL};
  // char*
  // status = execve("/bin/bash", (char *const) argv[1], envp);
  // exit(0);
  //} else {
  // Parent process will return a non-zero value from fork()
  //    printf("Now in the parent process...\n");
  //}

  return 0;
}
