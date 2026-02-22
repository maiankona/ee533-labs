#define LEN 64

int main() {

    // Independent packet region
    volatile unsigned char *packet = (unsigned char*)0x0400;

    // Store classification result here
    volatile unsigned int *count_addr = (unsigned int*)0x0500;

    unsigned int count = 0;
    int i;

    // Simulate simple packet classification:
    // Count number of non-zero bytes.
    for (i = 0; i < LEN; i++) {

        // Load byte
        if (packet[i] != 0) {
            count++;
        }
    }

    // Write classification result to memory.
    *count_addr = count;

    while(1);
}
