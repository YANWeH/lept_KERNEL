#ifndef JOS_KERN_E1000_H
#define JOS_KERN_E1000_H

#include <kern/pci.h>

#define E1000REG(offset) (void *)(pci_e1000 + offset)

#define E1000_STATUS 0x00008         /*Device Status - RO */
#define E1000_TCTL 0x00400           /* TX Control - RW */
#define E1000_TIPG 0x00410           /* TX Inter-packet gap -RW */
#define E1000_TDBAL 0x03800          /* TX Descriptor Base Address Low - RW */
#define E1000_TDBAH 0x03804          /* TX Descriptor Base Address High - RW */
#define E1000_TDLEN 0x03808          /* TX Descriptor Length - RW */
#define E1000_TDH 0x03810            /* TX Descriptor Head - RW */
#define E1000_TDT 0x03818            /* TX Descripotr Tail - RW */
#define E1000_TCTL_EN 0x00000002     /* enable tx */
#define E1000_TCTL_BCE 0x00000004    /* busy check enable */
#define E1000_TCTL_PSP 0x00000008    /* pad short packets */
#define E1000_TCTL_CT 0x00000ff0     /* collision threshold */
#define E1000_TCTL_COLD 0x003ff000   /* collision distance */
#define E1000_TXD_CMD_RS 0x08000000  /* Report Status */
#define E1000_TXD_STAT_DD 0x00000001 /* Descriptor Done */
#define TX_MAX 64

struct tx_desc
{
    uint64_t addr;
    uint16_t length;
    uint8_t cso;
    uint8_t cmd;
    uint8_t status;
    uint8_t css;
    uint16_t special;
} __attribute__((packed));

struct packets
{
    char buffer[2048];
} __attribute__((packed));

void e1000_transmit_init();

int pci_e1000_attach(struct pci_func *pcif);

#endif // SOL >= 6
