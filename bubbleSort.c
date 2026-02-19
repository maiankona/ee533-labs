int main() {
    // simple bubble sort algorithm
    int arr[] = {64, 34, 25, 12, 22, 11, 90}; // static or via user input?
    int n = sizeof(arr) / sizeof(arr[0]); // will inputs just be 1D or multiple dimensions?
    int i, j, temp;
    for (i = 0; i < n-1; i++) {
        for (j = 0; j < n-i-1; j++) {
            if (arr[j] > arr[j+1]) {
                temp = arr[j];
                arr[j] = arr[j+1];
                arr[j+1] = temp;
            }
        }
    }
        // print the sorted array or return it? how will we confirm it works
        return 0;
}