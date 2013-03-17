#include <stdint.h>

void init_P();

void init_L();
void draw_L(int frame);

void init_T();
void draw_T(int frame);

void init_G();
void draw_G(int frame);

void init();
void draw(int frame);

extern uint8_t* screen;
void forme(void);
void couleur(void);
