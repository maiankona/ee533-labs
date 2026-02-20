#define ARR_BASE ((volatile int*)0x100)
#define N 10

int main() {
    volatile int *arr = ARR_BASE;

    // initialize memory manually
    arr[0] = 323;
    arr[1] = 123;
    arr[2] = -455;
    arr[3] = 2;
    arr[4] = 98;
    arr[5] = 125;
    arr[6] = 10;
    arr[7] = 65;
    arr[8] = -56;
    arr[9] = 0;

    // norm bubble sort
    for (int i = 0; i < N-1; i++) {
        for (int j = 0; j < N-i-1; j++) {
            if (arr[j] > arr[j+1]) {
                int temp = arr[j];
                arr[j] = arr[j+1];
                arr[j+1] = temp;
            }
        }
    }

    while (1);
}
