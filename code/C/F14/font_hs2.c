unsigned char font[] = {
  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
  0x0c, 0x0c, 0x0c, 0x0c, 0x00, 0x0c, 0x00, 0x00,
  0x33, 0x33, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
  0x00, 0x12, 0x3f, 0x12, 0x3f, 0x12, 0x00, 0x00,
  0x7f, 0x7f, 0x7f, 0x7f, 0x7f, 0x7f, 0x00, 0x00,
  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
  0x0c, 0x0c, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
  0x06, 0x0c, 0x18, 0x18, 0x18, 0x0c, 0x06, 0x00,
  0x18, 0x0c, 0x06, 0x06, 0x06, 0x0c, 0x18, 0x00,
  0x00, 0x0c, 0x2d, 0x1e, 0x2d, 0x0c, 0x00, 0x00,
  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
  0x00, 0x00, 0x00, 0x00, 0x00, 0x0c, 0x18, 0x00,
  0x00, 0x00, 0x00, 0x3e, 0x00, 0x00, 0x00, 0x00,
  0x00, 0x00, 0x00, 0x00, 0x00, 0x0c, 0x00, 0x00,
  0x03, 0x06, 0x0c, 0x18, 0x30, 0x60, 0x00, 0x00,
  0x3e, 0x63, 0x63, 0x63, 0x7f, 0x3e, 0x00, 0x00,
  0x1c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x00, 0x00,
  0x7e, 0x07, 0x3e, 0x60, 0x7f, 0x7f, 0x00, 0x00,
  0x7e, 0x03, 0x7f, 0x03, 0x7f, 0x7e, 0x00, 0x00,
  0x63, 0x63, 0x63, 0x3f, 0x03, 0x03, 0x00, 0x00,
  0x7f, 0x70, 0x7e, 0x03, 0x7f, 0x7e, 0x00, 0x00,
  0x3f, 0x70, 0x7e, 0x63, 0x7f, 0x3e, 0x00, 0x00,
  0x7f, 0x03, 0x03, 0x03, 0x03, 0x03, 0x00, 0x00,
  0x3e, 0x63, 0x3e, 0x63, 0x7f, 0x3e, 0x00, 0x00,
  0x3e, 0x63, 0x7f, 0x03, 0x7f, 0x7e, 0x00, 0x00,
  0x00, 0x00, 0x0c, 0x00, 0x00, 0x0c, 0x00, 0x00,
  0x00, 0x00, 0x00, 0x0c, 0x00, 0x0c, 0x18, 0x00,
  0x00, 0x01, 0x07, 0x1f, 0x7e, 0x78, 0x68, 0x08,
  0x00, 0x80, 0x60, 0x98, 0x66, 0x1a, 0x16, 0x10,
  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
  0x7e, 0x07, 0x1e, 0x18, 0x00, 0x18, 0x00, 0x00,
  0x3e, 0x41, 0x4d, 0x5f, 0x40, 0x3e, 0x00, 0x00,
  0x3e, 0x63, 0x63, 0x7f, 0x63, 0x63, 0x00, 0x00,
  0x7e, 0x63, 0x7e, 0x63, 0x7f, 0x7e, 0x00, 0x00,
  0x3e, 0x63, 0x60, 0x63, 0x7f, 0x3e, 0x00, 0x00,
  0x7e, 0x63, 0x63, 0x63, 0x7f, 0x7e, 0x00, 0x00,
  0x3f, 0x60, 0x7f, 0x60, 0x7f, 0x3f, 0x00, 0x00,
  0x3f, 0x60, 0x7f, 0x60, 0x60, 0x60, 0x00, 0x00,
  0x3f, 0x60, 0x63, 0x63, 0x7f, 0x3f, 0x00, 0x00,
  0x63, 0x63, 0x7f, 0x63, 0x63, 0x63, 0x00, 0x00,
  0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x00, 0x00,
  0x07, 0x03, 0x63, 0x63, 0x7f, 0x3e, 0x00, 0x00,
  0x63, 0x63, 0x7e, 0x63, 0x63, 0x63, 0x00, 0x00,
  0x60, 0x60, 0x60, 0x60, 0x7f, 0x3f, 0x00, 0x00,
  0x7e, 0x6b, 0x6b, 0x6b, 0x6b, 0x6b, 0x00, 0x00,
  0x7e, 0x63, 0x63, 0x63, 0x63, 0x63, 0x00, 0x00,
  0x3e, 0x63, 0x63, 0x63, 0x7f, 0x3e, 0x00, 0x00,
  0x7e, 0x63, 0x63, 0x7e, 0x60, 0x60, 0x00, 0x00,
  0x3e, 0x63, 0x63, 0x6b, 0x7f, 0x3e, 0x0c, 0x0c,
  0x7e, 0x63, 0x63, 0x7e, 0x63, 0x63, 0x00, 0x00,
  0x3f, 0x70, 0x3e, 0x03, 0x7f, 0x7e, 0x00, 0x00,
  0x7e, 0x18, 0x18, 0x18, 0x18, 0x18, 0x00, 0x00,
  0x63, 0x63, 0x63, 0x63, 0x7f, 0x3e, 0x00, 0x00,
  0x63, 0x63, 0x63, 0x77, 0x3e, 0x1c, 0x00, 0x00,
  0x6b, 0x6b, 0x6b, 0x6b, 0x7e, 0x7c, 0x00, 0x00,
  0x63, 0x63, 0x3e, 0x63, 0x63, 0x63, 0x00, 0x00,
  0x63, 0x63, 0x3f, 0x03, 0x7f, 0x7e, 0x00, 0x00,
  0x7f, 0x07, 0x1c, 0x70, 0x7f, 0x7f, 0x00, 0x00,
  0x08, 0x68, 0x58, 0x66, 0x19, 0x06, 0x01, 0x00,
  0x60, 0x30, 0x18, 0x0c, 0x06, 0x03, 0x00, 0x00,
  0x10, 0x16, 0x1e, 0x7e, 0xf8, 0xe0, 0x80, 0x00,
  0x00, 0x00, 0x00, 0x00, 0x00, 0x7f, 0x00, 0x00,
  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
  0x00, 0x3f, 0x63, 0x63, 0x7f, 0x3f, 0x00, 0x00,
  0x60, 0x60, 0x7e, 0x63, 0x7f, 0x7e, 0x00, 0x00,
  0x00, 0x3f, 0x60, 0x60, 0x7f, 0x3f, 0x00, 0x00,
  0x03, 0x03, 0x3f, 0x63, 0x7f, 0x3f, 0x00, 0x00,
  0x00, 0x3e, 0x63, 0x7f, 0x70, 0x3e, 0x00, 0x00,
  0x0f, 0x18, 0x3f, 0x18, 0x18, 0x18, 0x00, 0x00,
  0x00, 0x3f, 0x63, 0x63, 0x3f, 0x03, 0x03, 0x3e,
  0x60, 0x60, 0x7e, 0x63, 0x63, 0x63, 0x00, 0x00,
  0x0c, 0x00, 0x0c, 0x0c, 0x0c, 0x0c, 0x00, 0x00,
  0x0c, 0x00, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x38,
  0x60, 0x63, 0x63, 0x7e, 0x63, 0x63, 0x00, 0x00,
  0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x00, 0x00,
  0x00, 0x7e, 0x6b, 0x6b, 0x6b, 0x6b, 0x00, 0x00,
  0x00, 0x7e, 0x63, 0x63, 0x63, 0x63, 0x00, 0x00,
  0x00, 0x3e, 0x63, 0x63, 0x7f, 0x3e, 0x00, 0x00,
  0x00, 0x7e, 0x63, 0x63, 0x7f, 0x7e, 0x60, 0x60,
  0x00, 0x3f, 0x63, 0x63, 0x7f, 0x3f, 0x03, 0x03,
  0x00, 0x3f, 0x60, 0x60, 0x60, 0x60, 0x00, 0x00,
  0x00, 0x3f, 0x70, 0x3e, 0x07, 0x7e, 0x00, 0x00,
  0x30, 0x30, 0x7f, 0x30, 0x30, 0x1f, 0x00, 0x00,
  0x00, 0x63, 0x63, 0x63, 0x7f, 0x3f, 0x00, 0x00,
  0x00, 0x63, 0x63, 0x63, 0x3e, 0x1c, 0x00, 0x00,
  0x00, 0x6b, 0x6b, 0x6b, 0x7e, 0x7c, 0x00, 0x00,
  0x00, 0x63, 0x63, 0x3e, 0x63, 0x63, 0x00, 0x00,
  0x00, 0x63, 0x63, 0x63, 0x3f, 0x03, 0x03, 0x3e,
  0x00, 0x7F, 0x07, 0x1C, 0x70, 0x7F, 0x00, 0x00
};
