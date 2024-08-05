#include <stdio.h>
#include <windows.h>
#define NUM_THREADS 5
#define MAX 10000
typedef struct phil {
    PCRITICAL_SECTION cs1;
    PCRITICAL_SECTION cs2;
    INT tid;
} *PPHIL;

DWORD WINAPI thread_func(LPVOID param) {
    PPHIL phil = (PPHIL) param;
    INT i = 0;
    while (i < MAX) {
        int ate = 0;
        while (!ate) {
            if (TryEnterCriticalSection(phil->cs1)) {
                if (TryEnterCriticalSection(phil->cs2)) {
                    printf("%d: %d\n", phil->tid, i++);
                    ate = 1;
                    LeaveCriticalSection(phil->cs2);
                }
                LeaveCriticalSection(phil->cs1);
            }
        }
    }
    free(param);
    return 1;
}
int main()
{
    CRITICAL_SECTION cs[NUM_THREADS];
    for (INT i = 0; i < NUM_THREADS; ++i) {
        InitializeCriticalSection(cs + i);
    }
    HANDLE hThread[NUM_THREADS];
    for (INT i = 0; i < NUM_THREADS; i++) {
        PPHIL phil = (PPHIL) malloc(sizeof (PPHIL));
        phil->tid = i;
        phil->cs1 = cs + i;
        phil->cs2 = cs + (i + 1) % NUM_THREADS;

        hThread[i] = CreateThread(
                NULL, //default security attributes
                0, //default stack size
                thread_func,//thread function
                phil, //thread param
                0, //default creation flags
                NULL //return thread identifier
        );
    }
    WaitForMultipleObjects(NUM_THREADS, hThread, TRUE, INFINITE);
    for (INT i = 0; i < NUM_THREADS; ++i) {
        DeleteCriticalSection(cs + i);
    }
    printf("YEPPE\n");
}
