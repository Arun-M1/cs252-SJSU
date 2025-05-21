fn print_arr(a: &[i32]) -> () {
    for i in a {
      print!("{} ", i);
    }
    println!("");
  }

fn swap(a: &mut[i32], i: usize, j: usize) -> () {
    let tmp = a[i];
    a[i] = a[j];
    a[j] = tmp;
}

fn partition <F> (arr: &mut[i32], start_idx: usize, end_idx:usize, compare: &F) -> usize
    where F: Fn(i32, i32) -> bool {
    let pivot = arr[end_idx];
    let mut left_idx = start_idx;
    let mut right_idx = end_idx - 1;

    while left_idx < right_idx {
        //left idx value < pivot
        while compare(pivot, arr[left_idx]) && left_idx < end_idx - 1 {
            left_idx += 1;
        }
        //pivot < right idx value
        while compare(arr[right_idx], pivot) && right_idx > start_idx {
            right_idx -= 1;
        }
        //swap
        if left_idx < right_idx {
            swap(arr, left_idx, right_idx);
        }
    }
    //swap pivot
    swap(arr, left_idx, end_idx);

    return left_idx;
}

fn sort_subarray <F> (arr: &mut[i32], start_idx: usize, end_idx: usize, test: &F) -> ()
where F: Fn(i32, i32) -> bool  {
    //base case
    if start_idx >= end_idx {
        return;
    }

    let pivot = partition(arr, start_idx, end_idx, test);
    //recursively partition
    if pivot > 0 {
        sort_subarray(arr, start_idx, pivot - 1, test);
    }
    sort_subarray(arr, pivot + 1, end_idx, test);
}

fn sort <F>(arr: &mut[i32], test: F) -> ()
where F: Fn(i32, i32) -> bool {
    if arr.len() > 1 {
        sort_subarray(arr, 0, arr.len() - 1, &test);
    }
}

fn main() {
    let mut nums = [9, 4, 13, 2, 22, 17, 8, 9, 1];
    let asc = |x:i32, y:i32| { x > y };
    print_arr(&nums[..]);
    sort(&mut nums[..], asc);
    print_arr(&nums[..]);
  }