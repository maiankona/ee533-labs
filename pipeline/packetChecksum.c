#define LEN 64

int main() {

    // Pointer to this thread’s packet buffer.
    // Each thread must use a DIFFERENT memory region.
    volatile unsigned char *packet = (unsigned char*)0x0000;

    // Location where the computed checksum will be stored.
    volatile unsigned int *result  = (unsigned int*)0x0100;

    unsigned int sum = 0;
    int i;

    // Simulate computing a simple checksum over packet bytes.
    // This uses:
    // - Load (LDRB)
    // - Addition
    // - Loop and branch
    for (i = 0; i < LEN; i++) {
        sum += packet[i];
    }

    // Store checksum result to memory.
    // This demonstrates correct register writeback + memory store.
    *result = sum;

    // Infinite loop so thread keeps running independently.
    while(1);
}
