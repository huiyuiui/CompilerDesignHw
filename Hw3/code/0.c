void codegen();

void codegen() {
  int input_data[17]; // 20~84
  int i;  //88
  for (i = 0; i < 17; i = i + 1) {
    input_data[i] = i;
  }

  int end = 0; // 92
  int data[17]; // 96~160
  for (i = 0; i < 17; i = i + 1) {
    int *id = input_data + i; // 164
    
    int slot = end; // 168
    int cont = slot != 0; // 172
    while (cont) {
      const int parent = (slot - 1) / 2; // 176
      if (data[parent] < *id) {
        *(data + slot) = *(data + parent);
        slot = parent;
      } else {
        cont = 0;
      }
      if (slot == 0) {
        cont = 0;
      }
    }
    data[slot] = *id;
    end = end + 1;
  }

  digitalWrite(26, HIGH);
  delay((data[0] - data[2]) * 1000); /* data[0] - data[2] = 3 */
  digitalWrite(26, LOW);
  delay((end - data[0]) * 1000); /* end - data[0] = 1 */
}
