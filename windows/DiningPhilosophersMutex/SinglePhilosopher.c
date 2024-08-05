#include <stdio.h>
#include <windows.h>
#define MAX 100
int main(int argc, char *argv[]) {
    if (argc != 3) {
        printf("Usage: %s <mutex name 1 > <mutex name 2>\n", argv[0]);
        return 1;
    }
    HANDLE hMutex1 = CreateMutex(NULL, FALSE, argv[1]);
    HANDLE hMutex2 = CreateMutex(NULL, FALSE, argv[2]);
    INT i = 0;
    while (i < MAX) {
        BOOL ate = FALSE;
        while (!ate) {
            if (WaitForSingleObject(hMutex1, 0) == WAIT_OBJECT_0) {
                if (WaitForSingleObject(hMutex2, 0) == WAIT_OBJECT_0) {
                    printf("PID %lu: %d\n", GetCurrentProcessId(), i++);
                    ReleaseMutex(hMutex2);
                    ate = TRUE;
                } else {
                    ReleaseMutex(hMutex1);
                }
            }
        }
    }
}
