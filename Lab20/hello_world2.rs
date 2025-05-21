fn foo(x: i32) -> i32 {
  x + 3
}

fn main() {
  println!("Hello world!");
  println!("{}", foo(4));
  let a = 1;
  let b = 2;
  let c = 3;
  // Placeholders for arguments are indicated with {}
  println!("a:{} b:{} c:{}", a, b, c);
  // Numbers can specify which argument is to be used
  println!("<{0}>{1}</{0}>", "h1", "Hello world!");
  // Named arguments can also be useful
  println!("<{tagname} {attrname}='{attrval}'>{body}</{tagname}>",
    tagname="a",
    attrname="href",
    attrval="https://www.rust-lang.org/",
    body="Rust website");
}

