unit module Wordy;

sub answer ($q is copy) is export { 
  given $q {
    s:s:g/^What is|\?$//;
    s:g/plus/+/;
    s:g/minus/−/;
    loop {
      last unless
        s:s/(.*) multiplied by/($0)×/
        or s:s/(.*) divided by/($0)÷/;
    }
  }
  use MONKEY-SEE-NO-EVAL;
  EVAL $q or fail;
}
