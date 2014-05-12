package github.giuliolunati.rebol3_sl4a;

import java.io.File;

import android.content.Context;

import com.googlecode.android_scripting.AsyncTaskListener;
import com.googlecode.android_scripting.InterpreterUninstaller;
import com.googlecode.android_scripting.exception.Sl4aException;
import com.googlecode.android_scripting.interpreter.InterpreterDescriptor;
import com.googlecode.android_scripting.FileUtils;

public class Rebol3Uninstaller extends InterpreterUninstaller {
  protected Context mContext;

  public Rebol3Uninstaller(InterpreterDescriptor descriptor, Context context,
      AsyncTaskListener<Boolean> listener) throws Sl4aException {
    super(descriptor, context, listener);
    mContext = context;
  }

  @Override
  protected boolean cleanup() {
    File filesDir = mContext.getFilesDir();
    File dir = new File(filesDir,"bin");
    FileUtils.delete(dir);
    dir = new File(filesDir,"lib");
    FileUtils.delete(dir);
    return true;
  }

}
