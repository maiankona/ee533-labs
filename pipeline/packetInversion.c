#define LEN 64

int main() {

    // This thread operates on a DIFFERENT packet region.
    volatile unsigned char *packet = (unsigned char*)0x0200;

    int i;

    // Simulate a simple packet transformation,
    // e.g., flipping bits for encryption or flag toggling.
    for (i = 0; i < LEN; i++) {

        // Read byte
        unsigned char temp = packet[i];

        // Invert bits (~ operator)
        temp = ~temp;

        // Write back modified byte
        packet[i] = temp;
    }

    // Infinite loop keeps this thread active.
    while(1);
}
