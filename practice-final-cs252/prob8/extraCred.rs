use std::fmt::Display;

// Function types must be declared
fn print_arr<T: Display>(a: &[T]) -> () {
    for i in a {
        print!("{} ", i);
    }
    println!("");
}

fn main() {
    let mut nums = [9, 4, 22, 13, 11, 44, 8, 12, 1];
    print_arr(&nums[..]);

    let second = find_second_largest(&mut nums[..]); /* Add the appropriate function call to find_second_largest here */
    println!("The second largest elem in the array was {}", second);

    /* Add a function call to zero_out_pos, which should set a[5] to 0. */
    let _zeroed_out = zero_out_pos(&mut nums[..], 5);
    print_arr(&nums[..]);

    let second2 = find_second_largest(&mut nums[..]); /* Add the appropriate function call to find_second_largest here */
    println!("The second largest elem in the array was {}", second2);
}

fn swap(a: &mut[i32], i: usize, j: usize) -> () {
    let tmp = a[i];
    a[i] = a[j];
    a[j] = tmp;
}

fn sort<F>(a: &mut[i32], test: F) -> ()
      where F: Fn(i32, i32) -> bool {
    for i in 0..a.len() {
        for j in i..a.len() {
            if test(a[i], a[j]) {
                swap(&mut a[..], i, j);
            }
        }
    }
}

fn find_second_largest(a: &mut[i32]) -> i32 {
    let dsc = |x: i32, y: i32| {x < y};
    let mut copy = a.to_vec();
    sort(&mut copy[..], dsc);
    //print_arr(&a[..]);
    let second = copy[1];
    return second
}

fn zero_out_pos(a: &mut[i32], i: usize) -> bool {
    if i >= a.len() {
        print!("Index {} is out of bounds for array with length {}", i, a.len());
        return false;
    }
    a[i] = 0;
    return true;
}

