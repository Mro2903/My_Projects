#include <windows.h>
#include <stdio.h>
#define EXE_FILENAME "SinglePhilosopher.exe"
#define NUM_PHILOSOPHERS 5
int main()
{
    PCHAR name = (PCHAR)malloc(7*sizeof(CHAR));
    HANDLE hMutex[NUM_PHILOSOPHERS];
    for (int i = 0; i < NUM_PHILOSOPHERS; i++) {
        sprintf_s(name, 7, "Mutex%d", i);
        hMutex[i] = CreateMutexA(NULL, FALSE, name);
    }
    free(name);
    INT size = strlen(EXE_FILENAME) + 15; // length is increased by 15:
    // space character- 2 byte,
    // 2 mutex names - 12 byte,
    // string NULL terminator- 1 byte
    PCHAR param = (PCHAR)malloc(size*sizeof(CHAR));
    STARTUPINFOA si;
    PROCESS_INFORMATION pi[NUM_PHILOSOPHERS];

    for (int i = 0; i < NUM_PHILOSOPHERS; i++) {
        sprintf_s(param, size, "%s Mutex%d Mutex%d", EXE_FILENAME, i, (i+1)%NUM_PHILOSOPHERS);
        ZeroMemory(&si, sizeof(si));
        si.cb = sizeof(si);
        ZeroMemory(&pi[i], sizeof(pi[i]));
        CreateProcessA(
                NULL,
                param,
                NULL,
                NULL,
                FALSE,
                0,
                NULL,
                NULL,
                &si,
                &pi[i]);
    }
    free(param);
    // Wait for every process to finish, close everything before return
    for (int i = 0; i < NUM_PHILOSOPHERS; i++) {
        WaitForSingleObject(pi[i].hProcess, INFINITE);
    }
    for (int i = 0; i < NUM_PHILOSOPHERS; i++) {
        ReleaseMutex(hMutex[i]);
    }
    for (int i = 0; i < NUM_PHILOSOPHERS; i++) {
        CloseHandle(pi[i].hProcess);
        CloseHandle(pi[i].hThread);
    }
    printf("All processes finished\n");
    return 0;
}
