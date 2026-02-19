int main() {
    // simple bubble sort algorithm
    int arr[] = {323, 123, -455, 2, 98, 125, 10, 65, -56, 0}; // static or via user input?
    int n = sizeof(arr); 
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
