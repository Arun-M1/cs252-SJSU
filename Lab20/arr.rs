fn main() {
  let mut a: [i32; 10] = [0;10];
  let mut i = 0;
  while i <= 10 {
    println!("Accessing {}", i);
    a[i] = i as i32;
    i = i + 1;
  }
}

