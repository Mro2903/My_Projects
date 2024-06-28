#include <stdio.h>
#include <stdlib.h>
void merge(int* nums1, int nums1Size, int m, int* nums2, int nums2Size, int n) {
    int *temp = (int *)malloc(sizeof(int) * nums1Size);

    for (int i = 0, j = 0, k = 0; i < nums1Size; i++) {
        if (k == n || j < m && nums1[j] < nums2[k]) {
            temp[i] = nums1[j];
            j++;
        } else {
            temp[i] = nums2[k];
            k++;
        }
    }

    for (int i = 0; i < nums1Size; i++) {
        nums1[i] = temp[i];
    }
    free(temp);
}

int main() {
    int nums1[] = {1};
    int nums2[] = {};
    merge(nums1, 1, 1, nums2, 0, 0);
    return 0;
}