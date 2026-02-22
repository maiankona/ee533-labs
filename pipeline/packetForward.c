#define LEN 64

int main() {

    // Source packet buffer
    volatile unsigned char *src = (unsigned char*)0x0600;

    // Destination buffer (simulating output port)
    volatile unsigned char *dst = (unsigned char*)0x0700;

    int i;

    // Simulate packet forwarding:
    // Copy packet from input buffer to output buffer.
    for (i = 0; i < LEN; i++) {

        // Load from source
        unsigned char temp = src[i];

        // Store into destination
        dst[i] = temp;
    }

    while(1);
}
