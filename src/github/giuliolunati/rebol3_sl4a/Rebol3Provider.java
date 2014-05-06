package github.giuliolunati.rebol3_sl4a;

import com.googlecode.android_scripting.interpreter.InterpreterDescriptor;
import com.googlecode.android_scripting.interpreter.InterpreterProvider;

public class Rebol3Provider extends InterpreterProvider {
  @Override
  protected InterpreterDescriptor getDescriptor() {
    return new Rebol3Descriptor();
  }
}
