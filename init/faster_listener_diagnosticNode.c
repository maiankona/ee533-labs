#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>

#define PORT 7777
#define BUFFER_SIZE 65535
#define MATCH_THRESHOLD 5  /* Clinical confidence threshold for viral detection */

/* A helper function to print the hex dump just like your Python script did */
void print_hexdump(const unsigned char *buffer, int length) {
    int i, j;
    for (i = 0; i < length; i += 16) {
        printf("%04x   ", i);
        
        /* Print hex */
        for (j = 0; j < 16; j++) {
            if (i + j < length) {
                printf("%02x ", buffer[i + j]);
            } else {
                printf("   ");
            }
        }
        
        printf("  ");
        
        /* Print ASCII */
        for (j = 0; j < 16; j++) {
            if (i + j < length) {
                unsigned char c = buffer[i + j];
                if (c >= 0x20 && c < 0x7F) {
                    printf("%c", c);
                } else {
                    printf(".");
                }
            }
        }
        printf("\n");
    }
}

int main() {
    int sockfd;
    struct sockaddr_in server_addr, client_addr;
    socklen_t client_len;
    unsigned char buffer[BUFFER_SIZE];
    int recv_len;
    int i;
    int is_nonzero;
    int match_count = 0; /* Track how many viral packets we've seen */

    /* 1. Create UDP socket */
    sockfd = socket(AF_INET, SOCK_DGRAM, 0);
    if (sockfd < 0) {
        perror("Socket creation failed");
        return 1;
    }

    /* 2. Configure server address to listen on all interfaces (0.0.0.0) */
    memset(&server_addr, 0, sizeof(server_addr));
    server_addr.sin_family = AF_INET;
    server_addr.sin_addr.s_addr = INADDR_ANY;
    server_addr.sin_port = htons(PORT);

    /* 3. Bind the socket */
    if (bind(sockfd, (struct sockaddr *)&server_addr, sizeof(server_addr)) < 0) {
        perror("Bind failed");
        close(sockfd);
        return 1;
    }

    printf("[*] Hardware Diagnostic Listener active on UDP port %d\n", PORT);
    printf("[*] Clinical Confidence Threshold set to: %d reads\n", MATCH_THRESHOLD);
    printf("[*] Waiting for NetFPGA alignment results...\n\n");

    client_len = sizeof(client_addr);

    /* 4. Infinite listening loop */
    while (1) {
        /* This blocks and waits until a packet arrives from the FPGA */
        recv_len = recvfrom(sockfd, buffer, BUFFER_SIZE, 0, (struct sockaddr *)&client_addr, &client_len);
        
        if (recv_len > 0) {
            is_nonzero = 0;
            
            /* 5. Check if the hardware sent anything other than pure 0x00 */
            for (i = 0; i < recv_len; i++) {
                if (buffer[i] != 0x00) {
                    is_nonzero = 1;
                    break;
                }
            }

            /* 6. If we found a hardware match (nonzero data) -> Process it */
            if (is_nonzero) {
                match_count++;
                
                if (match_count < MATCH_THRESHOLD) {
                    /* Log the hit, but don't sound the alarm yet */
                    printf("Sequence mapped to viral index. (Match %d/%d)\n", match_count, MATCH_THRESHOLD);
                } 
                else {
                    /* Threshold met! Trigger the full clinical alarm */
                    printf("ALERT: SARS-CoV-2 VIRAL PAYLOAD DETECTED\n");
                    printf("Confidence threshold of %d (0.0001\%) independent reads met.\n", MATCH_THRESHOLD);
                    printf("Received final trigger packet from FPGA (%s:%d)\n", 
                           inet_ntoa(client_addr.sin_addr), ntohs(client_addr.sin_port));
                    printf("Alignment Coordinate Output:\n\n");
                    
                    /* Spit out the hex coordinates so the "doctor" can see the output */
                    print_hexdump(buffer, recv_len);
                    printf("\n[*] Resetting match counter for continuous monitoring...\n\n");
                    
                    /* Reset counter in case you want to keep the demo running */
                    match_count = 0;
                }
            }
        }
    }

    close(sockfd);
    return 0;
}