#include <kern/e1000.h>
#include <kern/pmap.h>
#include <inc/string.h>

// LAB 6: Your driver code here

volatile void *pci_e1000;

int pci_e1000_attach(struct pci_func *pcif)
{
    pci_func_enable(pcif);
    pci_e1000 = mmio_map_region(pcif->reg_base[0], pcif->reg_size[0]);
    uint32_t *status_reg = (uint32_t *)E1000REG(E1000_STATUS);
    assert(*status_reg == 0x80080783);
    return 0;
}
